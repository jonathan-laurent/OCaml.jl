# The path of the directory in which one can find libocaml.so
ENV["OCAML_LIB_DIR"] = "_build/default/ocaml"

using OCaml

# Testing the API

# @caml zero :: Caml{:expr}

@macroexpand @caml evaluate(::Caml{:expr}) :: Int

@caml evaluate(::Caml{:expr}) :: Int

# @caml constant(::Int) :: Caml{:expr}

# @caml add(::Caml{:expr}, :: Caml{:expr}) :: Caml{:expr}

# @show evaluate(zero)

# @show evaluate(add(constant(1), constant(2)))

# @macroexpand @caml get(::Caml{Tuple{:array, A}}, ::Int) :: Caml{A} where {A}