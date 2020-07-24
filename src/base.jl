import Libdl

const OCAML_LIB = "libocaml"

const OCAML_LIB_DIR = get(ENV, "OCAML_LIB_DIR", "")

if OCAML_LIB_DIR == ""
  error("You must specify the OCAML_LIB_DIR environment variable to use OCaml.")
end

function __init__()
  push!(Libdl.DL_LOAD_PATH, OCAML_LIB_DIR)
  Libdl.dlopen("$OCAML_LIB.so")
  ccall((:caml_startup, OCAML_LIB), Cvoid, (Ptr{Ptr{Int8}},), [])
end

# Mutable to ensure there is a finalizer
mutable struct Caml{Type}
  ptr :: Ptr{Cvoid} # Pointer to an OCaml value
  function Caml{T}(ptr::Ptr{Cvoid}) where T
    v = new{T}(ptr)
    Base.finalizer(v) do v
      ccall((:caml_release, OCAML_LIB), Cvoid, (Ptr{Cvoid},), v.ptr)
    end
    return v
  end
end

# unit
#const unit = Caml{:unit}(ccall((:__caml_make_unit__, OCAML_LIB), Ptr{Cvoid}, ()))
