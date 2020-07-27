type expr

val zero: expr

val constant: int -> expr

val add: expr -> expr -> expr

val evaluate: expr -> int

val is_sum: expr -> bool

val sum_terms: expr -> expr array

val array_get: 'a array -> int -> 'a