val array_get: 'a array -> int -> 'a

val array_length: 'a array -> int

val array_range: int -> int array

val array_set: 'a array -> int -> 'a -> unit

val array_make: int -> 'a -> 'a array
(** [array_make n v] creates an array of [n] elements initialized with value [a]. *)

val run_gc: unit -> unit
(** Run the OCaml GC in full major mode. *)