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

struct CamlException <: Exception
  msg :: String
end

function Base.showerror(io::IO, e::CamlException)
  print(io, "OCaml Exception: ")
  print(io, e.msg)
end

# Mutable to ensure there is a finalizer
mutable struct Caml{Type}
  ptr :: Ptr{Cvoid} # Pointer to an OCaml value
  function Caml{T}(ptr::Ptr{Cvoid}) where T
    if ptr == C_NULL
      # An exception must have occured, which is why the user ended up
      # with a NULL value pointer.
      err = ccall((:caml_last_exception_message, OCAML_LIB), Cstring, ())
      throw(CamlException(unsafe_string(err)))
    else
      v = new{T}(ptr)
      Base.finalizer(v) do v
        ccall((:caml_release, OCAML_LIB), Cvoid, (Ptr{Cvoid},), v.ptr)
      end
      return v
    end
  end
end