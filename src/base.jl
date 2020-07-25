import Libdl

const OCAML_LIB = "libocaml"

function __init__()
  libdir = get(ENV, "OCAML_LIB_DIR", "")
  if isempty(libdir)
    error("You must specify the OCAML_LIB_DIR environment variable to use OCaml.")
  end
  push!(Libdl.DL_LOAD_PATH, libdir)
  Libdl.dlopen("$OCAML_LIB")
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