val array_get: 'a array -> int -> 'a

val array_length: 'a array -> int

val array_range: int -> int array

val array_set: 'a array -> int -> 'a -> unit

val array_make: int -> 'a -> 'a array
(** [array_make n v] creates an array of [n] elements initialized with value [a]. *)

val array_of_list: 'a list -> 'a array

val list_of_array: 'a array -> 'a list

val make_pair: 'a -> 'b -> 'a * 'b

val make_triple: 'a -> 'b -> 'c -> 'a * 'b * 'c

val pair_fst: 'a * 'b -> 'a

val pair_snd: 'a * 'b -> 'b

val triple_fst:  'a * 'b * 'c -> 'a

val triple_snd:  'a * 'b * 'c -> 'b

val triple_trd:  'a * 'b * 'c -> 'c

val run_gc: unit -> unit
(** Run the OCaml GC in full major mode. *)