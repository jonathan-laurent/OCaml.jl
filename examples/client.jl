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
  values = [convert(Caml{A}, x) for x in arr]
  GC.@preserve values begin
    ptrs = Ptr{Cchar}[v.ptr for v in values]
    push!(ptrs, C_NULL)
    @assert isa(ptrs, Vector{Ptr{Cchar}})
    ptr = ccall((:caml_base_make_array, OCaml.OCAML_LIB), Ptr{Cvoid}, (Ptr{Ptr{Cchar}},), ptrs)
    return Caml{Tuple{:array, A}}(ptr)
  end
end

expr = add(constant(1), constant(2))

@show evaluate(expr)

array_range(5)

x = convert(Caml{Tuple{:array, :int}}, [1, 2, 3])
convert(Vector{Int}, x)

function main()
  t = @elapsed begin
    x = 0
    for i in 1:1000
      x += sum(array_sum([1, 2, 3]))
      caml_run_gc(nothing)
    end
  end
  @show t
end

# main()

using BenchmarkTools
@btime array_sum([1, 2, 3])

# @btime evaluate(add(constant(1), constant(2)))
# @btime evaluate(add(constant(1), constant(2)))