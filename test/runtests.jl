using Test

ENV["OCAML_LIB_DIR"] = "../examples/generated"

using OCaml

include("../examples/generated/ocamljl_examples.jl")

@test evaluate(add(constant(1), constant(2))) == 3

@test array_sum([1, 2, 3]) == 6

@test list_sum(collect(1:10)) == 55

@test square_float(2.0) == 4.0

@test array_maximum([1.0, 2.3]) == 2.3

@test array_maximum([]) == -Inf

@test vec_mul(2.0, [1.5, 0.5]) == [3.0, 1.0]

@test vec_mul(0, [1.5, 0.5]) == [0.0, 0.0]

@test point2i_add((1, 2), (2, 1)) == (3, 3)

@test point3f_add((1, 2, 0), (2, 1, -3)) == (3.0, 3.0, -3.0)

@test add_opt(1, nothing) == 1

@test add_opt(1, 2) == 3

@test safe_div(1, 0) |> isnothing

@test safe_div(1, 2) == 0.5