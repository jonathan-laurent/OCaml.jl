"""
```ocaml
val zero: expr
```
"""
@caml zero :: Caml{:expr} 

"""
```ocaml
val constant: int -> expr
```
"""
@caml constant(::Caml{:int}) :: Caml{:expr} 

"""
```ocaml
val add: expr -> expr -> expr
```
"""
@caml add(::Caml{:expr}, ::Caml{:expr}) :: Caml{:expr} 

"""
```ocaml
val evaluate: expr -> int
```
"""
@caml evaluate(::Caml{:expr}) :: Caml{:int} 

"""
```ocaml
val is_sum: expr -> bool
```
"""
@caml is_sum(::Caml{:expr}) :: Caml{:bool} 

"""
```ocaml
val sum_terms: expr -> expr array
```
"""
@caml sum_terms(::Caml{:expr}) :: Caml{Tuple{:array, :expr}} 

"""
```ocaml
val array_sum: int array -> int
```
"""
@caml array_sum(::Caml{Tuple{:array, :int}}) :: Caml{:int} 

"""
```ocaml
val list_sum: int list -> int
```
"""
@caml list_sum(::Caml{Tuple{:list, :int}}) :: Caml{:int} 

"""
```ocaml
val square_float: float -> float
```
"""
@caml square_float(::Caml{:float}) :: Caml{:float} 

"""
```ocaml
val array_maximum: float array -> float
```
"""
@caml array_maximum(::Caml{Tuple{:array, :float}}) :: Caml{:float} 

"""
```ocaml
val vec_mul: float -> float array -> float array
```
"""
@caml vec_mul(::Caml{:float}, ::Caml{Tuple{:array, :float}}) :: Caml{Tuple{:array, :float}} 

"""
```ocaml
val point2i_add: (int * int) -> (int * int) -> (int * int)
```
"""
@caml point2i_add(::Caml{Tuple{:tuple, :int, :int}}, ::Caml{Tuple{:tuple, :int, :int}}) :: Caml{Tuple{:tuple, :int, :int}} 

"""
```ocaml
val point3f_add: (float * float * float) -> (float * float * float) -> (float * float * float)
```
"""
@caml point3f_add(::Caml{Tuple{:tuple, :float, :float, :float}}, ::Caml{Tuple{:tuple, :float, :float, :float}}) :: Caml{Tuple{:tuple, :float, :float, :float}} 

"""
```ocaml
val add_opt: int option -> int option -> int
```
"""
@caml add_opt(::Caml{Tuple{:option, :int}}, ::Caml{Tuple{:option, :int}}) :: Caml{:int} 

"""
```ocaml
val safe_div: float -> float -> float option
```
"""
@caml safe_div(::Caml{:float}, ::Caml{:float}) :: Caml{Tuple{:option, :float}} 

