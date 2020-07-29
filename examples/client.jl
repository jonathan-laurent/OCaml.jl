# The path of the directory in which one can find libocaml.so
ENV["OCAML_LIB_DIR"] = "_build/default/examples/libocaml"

using OCaml

include("../_build/default/examples/libocaml/ocamljl_examples.jl")

expr = add(constant(1), constant(2))

@show evaluate(expr)

using BenchmarkTools

@btime array_sum([1, 2, 3])