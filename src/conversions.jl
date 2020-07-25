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


# Canonical conversions

tojulia(t::Type) = t
tojulia(::Type{Caml{:unit}}) = Nothing
tojulia(::Type{Caml{:int}}) = Int
tojulia(::Type{Caml{:bool}}) = Bool
tojulia(::Type{Caml{:string}}) = String

tojulia(x) = convert(tojulia(typeof(x)), x)