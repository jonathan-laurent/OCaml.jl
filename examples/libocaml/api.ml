type expr =
  | Const of int
  | Add of expr array

let zero = Const 0

let constant x = Const x

let add e e' = Add [|e; e'|]

let rec evaluate = function
  | Const x -> x
  | Add xs ->
    Array.map evaluate xs |> Array.fold_left (+) 0

let is_sum = function
  | Add _ -> true
  | _ -> false

let sum_terms = function
  | Add ts -> ts
  | _ -> assert false

let array_sum = Array.fold_left (+) 0

let list_sum = List.fold_left (+) 0

let square_float x = x *. x

let array_maximum = Array.fold_left Float.max Float.neg_infinity

let vec_mul lam = Array.map (fun x -> lam *. x)