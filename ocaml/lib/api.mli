type expr

val zero: expr

val constant: int -> expr

val add: expr -> expr -> expr

val evaluate: expr -> int

val is_sum: expr -> bool

val sum_terms: expr -> expr array

val array_get: 'a array -> int -> 'a

val array_length: 'a array -> int

val array_range: int -> int array

val array_set: 'a array -> int -> 'a -> unit

val array_make: int -> 'a -> 'a array

val array_sum: int array -> int