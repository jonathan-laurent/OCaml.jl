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

# Returns `args` if the given AST matches `Header{args...}` and `nothing` otherwise.
function match_curly(header, ast)
  if isa(ast, Expr) && ast.head == :curly && ast.args[1] == header
    return ast.args[2:end]
  else
    return nothing
  end
end

# Returns `arg` if the givenAST matches `Caml{arg}` and `nothing` otherwise.
function match_caml(t)
  args = match_curly(:Caml, t)
  isnothing(args) && return nothing
  length(args) != 1 && return nothing
  return args[1]
end

# To call when a malformed type is passed to @caml
invalid_type_error(t) = error("Invalid type passed to @caml: $t")

# Check if an AST is an OCaml simple type such as :int or :string
is_type_symbol(t) = isa(t, QuoteNode)

# Also checks type well-formedness.
function typexpr_variables(t)
  if isa(t, Symbol)
    return Set([t])
  elseif is_type_symbol(t)
    return Set()
  else
    args = match_curly(:Tuple, t)
    isnothing(args) && invalid_type_error(t)
    length(args) < 2 && invalid_type_error(t)
    is_type_symbol(args[1]) || invalid_type_error(t)
    return union([typexpr_variables(a) for a in args]...)    
  end
end

# Takes an AST expression of the form `:(arg :: type)` and returns
# the set of 
function typed_arg_variables(a)
  @assert a.head == :(::)
  typ = a.args[2]
  t = match_caml(typ)
  isnothing(t) && invalid_type_error(typ)
  return typexpr_variables(t)
end

# Filter the type annotations of a function's arguments such that:
# - No type annotation is used for types that do not contain type typexpr_variables
# - If a type variable A is used, the first type annotation mentioning A is kept
function filter_type_annots(args)
  seen = Set()
  map(args) do a
    vars = typed_arg_variables(a)
    keep = !(vars ⊆ seen)
    seen = seen ∪ vars
    return keep ? a : a.args[1]
  end
end

# Escape all the symbols that belong to `symbs` in `e`
function escape_symbols(symbs, e)
  if e ∈ symbs
    return esc(e)
  elseif isa(e, Expr)
    return Expr(e.head, [escape_symbols(symbs, a) for a in e.args]...)
  else
    return e
  end
end

function generate_function_wrapper(lib, name, args, ret, whereargs)
  # We escape the generic type parameters to get nicer documentation
  esctp(x) = escape_symbols(whereargs, x)
  args = add_missing_names(args)
  argsdecl = esctp.(filter_type_annots(args))
  argnames = [a.args[1] for a in args]
  argconvs = [:(convert($(esctp(a.args[2])), $(a.args[1]))) for a in args]
  ptrtypes = [:(Ptr{Cvoid}) for _ in argnames]
  ptrs = [:($x.ptr) for x in argnames]
  cfun = :(($(QuoteNode(name)), $lib))
  return quote
    function $(esc(name))($(argsdecl...)) where {$(esc.(whereargs)...)}
      ($(argnames...),) = ($(argconvs...),)
      GC.@preserve $(argnames...) begin
        ptr = ccall($cfun, Ptr{Cvoid}, ($(ptrtypes...),), $(ptrs...))
        return tojulia($(esctp(ret))(ptr))
      end
    end
  end
end

function generate_constant_wrapper(lib, name, typ)
  ptr = :(ccall(($(QuoteNode(name)), $lib), Ptr{Cvoid}, ()))
  return quote
    const $(esc(name)) = tojulia($typ($ptr))
  end
end

function generate_wrapper(lib, e)
  @assert e.head == :(::)
  typ = e.args[2]
  if !isa(typ, Symbol) && typ.head == :where
    whereargs = typ.args[2:end]
    typ = typ.args[1]
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

# We escape the AST returned by the macro
# Therefore, these macros should be used in a place where Caml is accessible.
macro caml(lib, e)
  return generate_wrapper(lib, e)
end

const CURRENT_LIB = Ref{String}(OCAML_LIB)

macro caml(e)
  lib = CURRENT_LIB[]
  @assert !isempty(lib) "No current lib was set"
  return generate_wrapper(lib, e)
end