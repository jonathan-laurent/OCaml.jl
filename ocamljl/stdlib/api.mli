val array_get: 'a array -> int -> 'a

val array_length: 'a array -> int

val array_range: int -> int array

val array_set: 'a array -> int -> 'a -> unit

val array_make: int -> 'a -> 'a array
(** [array_make n v] creates an array of [n] elements initialized with value [a]. *)

val array_of_list: 'a list -> 'a array

val list_of_array: 'a array -> 'a list

val run_gc: unit -> unit
(** Run the OCaml GC in full major mode. *)