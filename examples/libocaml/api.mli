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

val list_sum: int list -> int

val square_float: float -> float

val array_maximum: float array -> float

val vec_mul: float -> float array -> float array