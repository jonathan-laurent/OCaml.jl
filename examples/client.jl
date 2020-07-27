# The path of the directory in which one can find libocaml.so
ENV["OCAML_LIB_DIR"] = "_build/default/ocaml"

using OCaml

# Testing the API

include("../_build/default/ocaml/lib/lib.jl")

expr = add(constant(1), constant(2))

@show evaluate(expr)

@show evaluate(array_get(sum_terms(expr), 2))