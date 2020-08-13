# The path of the directory in which one can find libocaml.so
ENV["OCAML_LIB_DIR"] = "examples/generated"

using OCaml

include("generated/ocamljl_examples.jl")

@show evaluate(add(constant(1), constant(2)))

@show array_sum([1, 2, 3])

@show add_opt(1, nothing)

@show add_opt(1, 2)