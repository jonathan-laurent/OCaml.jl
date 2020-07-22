module CamlLib

export OCAML_LIB
export CamlType, CamlType0, CamlType1, CamlType2
export CamlInt, CamlBool, CamlString, CamlArray
export CamlValue

# Mutable to ensure there is a finalizer
mutable struct CamlValue{Type}
  ptr :: Ptr{Cvoid} # Pointer to an OCaml value
end

# Setup the runtime

import Libdl

const OCAML_LIB_DIR = "_build/install/default/lib/binding-julia"
const OCAML_LIB = "libbinding-julia"

push!(Libdl.DL_LOAD_PATH, OCAML_LIB_DIR)

const OCAML_LIB_HANDLE = Libdl.dlopen("$OCAML_LIB.so")

function __init__()
  ccall((:__caml_initialize__, OCAML_LIB), Cvoid, (Ptr{Ptr{Int8}},), [])
end

# Basic functions to deal with types

abstract type CamlType end
struct CamlType0{name} <: CamlType end
struct CamlType1{name, arg} <: CamlType end
struct CamlType2{name, arg1, arg2} <: CamlType end

const CamlUnit = CamlType0{:unit}
const CamlInt = CamlType0{:int}
const CamlBool = CamlType0{:bool}
const CamlString = CamlType0{:string}
const CamlArray{T} = CamlType1{:array, T}

# Mutable to ensure there is a finalizer
mutable struct CamlValue{Type}
  ptr :: Ptr{Cvoid} # Pointer to an OCaml value
  function CamlValue{T}(ptr::Ptr{Cvoid}) where {T <: CamlType}
    v = new{T}(ptr)
    Base.finalizer(v) do v
      ccall((:__release__, OCAML_LIB), Cvoid, (Ptr{Cvoid},), v.ptr)
    end
    return v
  end
end

# Integer conversions

function Base.convert(::Type{Clong}, v::CamlValue{CamlInt})
  return ccall((:__long_of_caml__, OCAML_LIB), Clong, (Ptr{Cvoid},), v.ptr)
end

function Base.convert(::Type{CamlValue{CamlInt}}, n::Clong)
  ptr = ccall((:__caml_of_long__, OCAML_LIB), Ptr{Cvoid}, (Clong,), n)
  return CamlValue{CamlInt}(ptr)
end

function Base.convert(::Type{T}, n::CamlValue{CamlInt}) where {T <: Integer}
  return convert(T, convert(Clong, n))
end

function Base.convert(::Type{CamlValue{CamlInt}}, n::Integer)
  return convert(CamlValue{CamlInt}, convert(Clong, n))
end

# Bool conversions

function Base.convert(::Type{Bool}, v::CamlValue{CamlBool})
  return ccall((:__bool_of_caml__, OCAML_LIB), Bool, (Ptr{Cvoid},), v.ptr)
end

function Base.convert(::Type{CamlValue{CamlBool}}, b::Bool)
  ptr = ccall((:__caml_of_bool__, OCAML_LIB), Ptr{Cvoid}, (Bool,), b)
  return CamlValue{CamlBool}(ptr)
end

# String conversions

function Base.convert(::Type{String}, v::CamlValue{CamlString})
  str = ccall((:__string_of_caml__, OCAML_LIB), Cstring, (Ptr{Cvoid},), v.ptr)
  return unsafe_string(str)
end

function Base.convert(::Type{CamlValue{CamlString}}, str::String)
  ptr = ccall((:__caml_of_string__, OCAML_LIB), Ptr{Cvoid}, (Cstring,), str)
  return CamlValue{CamlString}(ptr)
end

# unit

const unit = CamlValue{CamlUnit}(ccall((:__caml_make_unit__, OCAML_LIB), Ptr{Cvoid}, ()))

end

using .CamlLib

# Testing the base conversions

function identity_integer(x::T) :: T where {T <: Integer}
  return convert(CamlValue{CamlInt}, x)
end

function identity_bool(x::Bool) :: Bool
  return convert(CamlValue{CamlBool}, x)
end

function identity_string(x::String) :: String
  return convert(CamlValue{CamlString}, x)
end

@assert identity_integer(42) == 42
@assert identity_bool(false) == false
@assert identity_string("hello") == "hello"

# Testing the Expr API

const Expr = CamlValue{CamlType0{:expr}}

function constant(x::CamlValue{CamlInt}) :: Expr
  ptr = ccall((:constant, OCAML_LIB), Ptr{Cvoid}, (Ptr{Cvoid},), x.ptr)
  return Expr(ptr)
end

constant(x::Integer) = constant(convert(CamlValue{CamlInt}, x))

function add(x::Expr, y::Expr) :: Expr
  ptr = ccall((:add, OCAML_LIB), Ptr{Cvoid}, (Ptr{Cvoid}, Ptr{Cvoid}), x.ptr, y.ptr)
  return Expr(ptr)
end

function evaluate(x::Expr) :: Int
  ptr = ccall((:evaluate, OCAML_LIB), Ptr{Cvoid}, (Ptr{Cvoid},), x.ptr)
  return CamlValue{CamlInt}(ptr)
end

const zero = Expr(ccall((:zero, OCAML_LIB), Ptr{Cvoid}, ()))

@show evaluate(zero)
@show evaluate(add(constant(1), constant(2)))