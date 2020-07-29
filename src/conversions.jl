# Integer conversions

function Base.convert(::Type{Clong}, v::Caml{:int})
  return ccall((:caml_to_long, OCAML_LIB), Clong, (Ptr{Cvoid},), v.ptr)
end

function Base.convert(::Type{Caml{:int}}, n::Clong)
  ptr = ccall((:caml_of_long, OCAML_LIB), Ptr{Cvoid}, (Clong,), n)
  return Caml{:int}(ptr)
end

function Base.convert(::Type{T}, n::Caml{:int}) where {T <: Integer}
  return convert(T, convert(Clong, n))
end

function Base.convert(::Type{Caml{:int}}, n::Integer)
  return convert(Caml{:int}, convert(Clong, n))
end

# Bool conversions

function Base.convert(::Type{Bool}, v::Caml{:bool})
  return ccall((:caml_to_bool, OCAML_LIB), Bool, (Ptr{Cvoid},), v.ptr)
end

function Base.convert(::Type{Caml{:bool}}, b::Bool)
  ptr = ccall((:caml_of_bool, OCAML_LIB), Ptr{Cvoid}, (Bool,), b)
  return Caml{:bool}(ptr)
end

# Float conversions

function Base.convert(::Type{Cdouble}, v::Caml{:float})
  return ccall((:caml_to_double, OCAML_LIB), Cdouble, (Ptr{Cvoid},), v.ptr)
end

function Base.convert(::Type{Caml{:float}}, x::Cdouble)
  ptr = ccall((:caml_of_double, OCAML_LIB), Ptr{Cvoid}, (Cdouble,), x)
  return Caml{:float}(ptr)
end

function Base.convert(::Type{T}, x::Caml{:float}) where {T <: AbstractFloat}
  return convert(T, convert(Cdouble, x))
end

function Base.convert(::Type{Caml{:float}}, x::AbstractFloat)
  return convert(Caml{:float}, convert(Cdouble, x))
end

# String conversions

function Base.convert(::Type{String}, v::Caml{:string})
  str = ccall((:caml_to_string, OCAML_LIB), Cstring, (Ptr{Cvoid},), v.ptr)
  return unsafe_string(str)
end

function Base.convert(::Type{Caml{:string}}, str::String)
  ptr = ccall((:caml_of_string, OCAML_LIB), Ptr{Cvoid}, (Cstring,), str)
  return Caml{:string}(ptr)
end

# Unit conversions

function Base.convert(::Type{Nothing}, ::Caml{:unit})
  return nothing
end

function Base.convert(::Type{Caml{:unit}}, ::Nothing)
  return Caml{:unit}(ccall((:caml_make_unit, OCAML_LIB), Ptr{Cvoid}, ()))
end

# Array conversions

function Base.convert(::Type{<:Vector}, arr::CamlArray{A}) where A
  n = array_length(arr)
  Eltype = tojulia(Caml{A})
  return Eltype[convert(Eltype, array_get(arr, i)) for i in 0:(n-1)]
end

function Base.convert(::Type{CamlArray{A}}, arr::Vector) where A
  values = [convert(Caml{A}, x) for x in arr]
  GC.@preserve values begin
    ptrs = Ptr{Cchar}[v.ptr for v in values]
    push!(ptrs, C_NULL)
    @assert isa(ptrs, Vector{Ptr{Cchar}})
    ptr = ccall((:caml_base_make_array, OCAML_LIB), Ptr{Cvoid}, (Ptr{Ptr{Cchar}},), ptrs)
    return CamlArray{A}(ptr)
  end
end

# List conversions

function Base.convert(T::Type{<:Vector}, l::CamlList{A}) where {A}
  ptr = ccall((:array_of_list, OCAML_LIB), Ptr{Cvoid}, (Ptr{Cvoid},), l.ptr)
  return convert(T, CamlArray{A}(ptr))
end

function Base.convert(::Type{CamlList{A}}, x::Vector) where {A}
  arr = convert(CamlArray{A}, x)
  ptr = ccall((:list_of_array, OCAML_LIB), Ptr{Cvoid}, (Ptr{Cvoid},), arr.ptr)
  return CamlList{A}(ptr)
end

# Canonical conversions

tojulia(t::Type) = t
tojulia(::Type{Caml{:unit}}) = Nothing
tojulia(::Type{Caml{:int}}) = Int
tojulia(::Type{Caml{:bool}}) = Bool
tojulia(::Type{Caml{:float}}) = Float64
tojulia(::Type{Caml{:string}}) = String

tojulia(x) = convert(tojulia(typeof(x)), x)

# More advanced conversions that you may want to disable

tojulia(::Type{CamlArray{A}}) where A = Vector{tojulia(Caml{A})}
tojulia(::Type{CamlList{A}})  where A = Vector{tojulia(Caml{A})}