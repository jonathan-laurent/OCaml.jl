"""
```ocaml
val array_get: 'a array -> int -> 'a
```
"""
@caml array_get(::Caml{Tuple{:array, A}}, ::Caml{:int}) :: Caml{A} where {A}

"""
```ocaml
val array_length: 'a array -> int
```
"""
@caml array_length(::Caml{Tuple{:array, A}}) :: Caml{:int} where {A}

"""
```ocaml
val array_range: int -> int array
```
"""
@caml array_range(::Caml{:int}) :: Caml{Tuple{:array, :int}} 

"""
```ocaml
val array_set: 'a array -> int -> 'a -> unit
```
"""
@caml array_set(::Caml{Tuple{:array, A}}, ::Caml{:int}, ::Caml{A}) :: Caml{:unit} where {A}

"""
```ocaml
val array_make: int -> 'a -> 'a array
```
`array_make(n, v)` creates an array of `n` elements initialized with value `a`.
"""
@caml array_make(::Caml{:int}, ::Caml{A}) :: Caml{Tuple{:array, A}} where {A}

"""
```ocaml
val array_of_list: 'a list -> 'a array
```
"""
@caml array_of_list(::Caml{Tuple{:list, A}}) :: Caml{Tuple{:array, A}} where {A}

"""
```ocaml
val list_of_array: 'a array -> 'a list
```
"""
@caml list_of_array(::Caml{Tuple{:array, A}}) :: Caml{Tuple{:list, A}} where {A}

"""
```ocaml
val make_pair: 'a -> 'b -> ('a * 'b)
```
"""
@caml make_pair(::Caml{A}, ::Caml{B}) :: Caml{Tuple{:tuple, A, B}} where {A, B}

"""
```ocaml
val make_triple: 'a -> 'b -> 'c -> ('a * 'b * 'c)
```
"""
@caml make_triple(::Caml{A}, ::Caml{B}, ::Caml{C}) :: Caml{Tuple{:tuple, A, B, C}} where {A, B, C}

"""
```ocaml
val pair_fst: ('a * 'b) -> 'a
```
"""
@caml pair_fst(::Caml{Tuple{:tuple, A, B}}) :: Caml{A} where {A, B}

"""
```ocaml
val pair_snd: ('a * 'b) -> 'b
```
"""
@caml pair_snd(::Caml{Tuple{:tuple, A, B}}) :: Caml{B} where {A, B}

"""
```ocaml
val triple_fst: ('a * 'b * 'c) -> 'a
```
"""
@caml triple_fst(::Caml{Tuple{:tuple, A, B, C}}) :: Caml{A} where {A, B, C}

"""
```ocaml
val triple_snd: ('a * 'b * 'c) -> 'b
```
"""
@caml triple_snd(::Caml{Tuple{:tuple, A, B, C}}) :: Caml{B} where {A, B, C}

"""
```ocaml
val triple_trd: ('a * 'b * 'c) -> 'c
```
"""
@caml triple_trd(::Caml{Tuple{:tuple, A, B, C}}) :: Caml{C} where {A, B, C}

"""
```ocaml
val some: 'a -> 'a option
```
"""
@caml some(::Caml{A}) :: Caml{Tuple{:option, A}} where {A}

"""
```ocaml
val is_none: 'a option -> bool
```
"""
@caml is_none(::Caml{Tuple{:option, A}}) :: Caml{:bool} where {A}

"""
```ocaml
val get_some: 'a option -> 'a
```
"""
@caml get_some(::Caml{Tuple{:option, A}}) :: Caml{A} where {A}

"""
```ocaml
val run_gc: unit -> unit
```
Run the OCaml GC in full major mode.
"""
@caml run_gc(::Caml{:unit}) :: Caml{:unit} 

