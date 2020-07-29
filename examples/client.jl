# The path of the directory in which one can find libocaml.so
ENV["OCAML_LIB_DIR"] = "_build/default/examples/libocaml"

using OCaml

include("../_build/default/examples/libocaml/ocamljl_examples.jl")

@show evaluate(add(constant(1), constant(2)))

@show array_sum([1, 2, 3])

@show list_sum(collect(1:10))

@show square_float(2.0)

@show array_maximum([1.0, 2.3])

@show array_maximum([])

@show vec_mul(2.0, [1.5, 0.5])

@show vec_mul(0, [1.5, 0.5])

@show point2i_add((1, 2), (2, 1))

@show point3f_add((1, 2, 0), (2, 1, -3))