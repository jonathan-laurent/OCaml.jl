(* Manipulating arithmetic expressions *)

type expr

val zero: expr

val constant: int -> expr

val add: expr -> expr -> expr

val evaluate: expr -> int

val is_sum: expr -> bool

val sum_terms: expr -> expr array


(* Other functions to try *)

val array_sum: int array -> int
