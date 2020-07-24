type expr

val zero: expr

val constant: int -> expr

val add: expr -> expr -> expr

val evaluate: expr -> int