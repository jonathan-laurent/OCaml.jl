# The path of the directory in which one can find libocaml.so
ENV["OCAML_LIB_DIR"] = "_build/default/ocaml"

using OCaml

# Testing the API

include("../_build/default/ocaml/lib/lib.jl")

OCaml.tojulia(::Type{Caml{Tuple{:array, A}}}) where A = Vector{OCaml.tojulia(Caml{A})}

function Base.convert(::Type{<:Vector}, arr::Caml{Tuple{:array, A}}) where A
  n = array_length(arr)
  Eltype = OCaml.tojulia(Caml{A})
  return Eltype[convert(Eltype, array_get(arr, i)) for i in 0:(n-1)]
end

function Base.convert(::Type{Caml{Tuple{:array, A}}}, arr::Vector) where A
  ptrs = Ptr{Cchar}[convert(Caml{A}, x).ptr for x in arr]
  push!(ptrs, C_NULL)
  @assert isa(ptrs, Vector{Ptr{Cchar}})
  ptr = ccall((:caml_base_make_array, OCaml.OCAML_LIB), Ptr{Cvoid}, (Ptr{Ptr{Cchar}},), ptrs)
  return Caml{Tuple{:array, A}}(ptr)
end

expr = add(constant(1), constant(2))

@show evaluate(expr)

array_range(5)

x = convert(Caml{Tuple{:array, :int}}, [1, 2, 3])
convert(Vector{Int}, x)