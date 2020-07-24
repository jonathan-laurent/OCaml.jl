# Generation

# Take a list of arguments and generate missing names
function add_missing_names(args)
  used = Set{Symbol}()
  return map(enumerate(args)) do (i, a)
    @assert a.head == :(::)
    if length(a.args) == 1 # No name is provided
      typ = a.args[1]
      candidates = (Symbol("x$i") for i in Iterators.countfrom(i))
      name = first(Iterators.dropwhile(c -> c ∈ used,  candidates))
      push!(used, name)
      return :($name :: $typ)
    else # A name is provided
      name = a.args[1]
      @assert name ∉ used "Argument names must be unique"
      push!(used, name)
      return a
    end
  end
end

@assert add_missing_names([:(::Int), :(::String)]) == [:(x1::Int), :(x2::String)]

caml_type(t) = !isa(t, Symbol) && t.head == :curly && t.args[1] == :Caml

function caml_of_julia(t)
  dict = Dict(:Int => :int, :Bool => :bool, :String => :string)
  if haskey(dict, t)
    return :(Caml{$(QuoteNode(dict[t]))})
  else
    return nothing
  end
end

julia_type(t) = !isnothing(caml_of_julia(t))

function from_caml(t, ptr)
  if caml_type(t)
    t = esc(t)
    return :($t($ptr))
  else
    mlt = caml_of_julia(t)
    @assert !isnothing(mlt) "No Caml type registered for $t."
    t = esc(t)
    mlt = esc(mlt)
    return :(convert($t, $mlt($ptr)))
  end
end

function to_caml(t, caml)
  if caml_type(t)
    return esc(:($caml.ptr))
  else
    mlt = caml_of_julia(t)
    @assert !isnothing(mlt) "Cannot build a caml value from type $t."
    return esc(:(convert($mlt, $caml).ptr))
  end
end

function generate_function_wrapper(lib, name, args, ret, whereargs)
  args = add_missing_names(args)
  return quote
    function $(esc(name))($(esc.(args)...)) :: $(esc(ret)) where {$(esc.(whereargs)...)}
      ptr = ccall(
        ($(QuoteNode(name)), $(esc(lib))),
        Ptr{Cvoid},
        ($([:(Ptr{Cvoid}) for _ in args]...),),
        $([to_caml(a.args[2], a.args[1]) for a in args]...))
      return $(from_caml(ret, :ptr))
    end
  end
end

function generate_constant_wrapper(lib, name, typ)
  val = :(ccall(($(QuoteNode(name)), $(esc(lib))), Ptr{Cvoid}, ()))
  return quote
    const $(esc(name)) = $(from_caml(typ, val))
  end
end

function generate_wrapper(lib, e)
  @assert e.head == :(::)
  typ = e.args[2]
  if !isa(typ, Symbol) && typ.head == :where
    typ = typ.args[1]
    whereargs = typ.args[2:end]
  else
    whereargs = []
  end
  if isa(e.args[1], Symbol)
    # Constant definition
    name = e.args[1]
    return generate_constant_wrapper(lib, name, typ)
  elseif e.args[1].head == :call
    # Function definition
    name = e.args[1].args[1]
    args = e.args[1].args[2:end]
    return generate_function_wrapper(lib, name, args, typ, whereargs)
  else
    error("Invalid use of @caml.")
  end
end

macro caml(lib, e)
  generate_wrapper(lib, e)
end

const CURRENT_LIB = Ref{String}(OCAML_LIB)

macro caml(e)
  lib = CURRENT_LIB[]
  @assert !isempty(lib) "No current lib was set"
  return generate_wrapper(lib, e)
end