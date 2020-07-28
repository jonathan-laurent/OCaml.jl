type expr =
  | Const of int
  | Add of expr array

let constant x = Const x

let add e e' = Add [|e; e'|]

let rec evaluate = function
  | Const x -> x
  | Add xs ->
    Array.map evaluate xs |> Array.fold_left (+) 0

let zero = Const 0

let is_sum = function
  | Add _ -> true
  | _ -> false

let sum_terms = function
  | Add ts -> ts
  | _ -> assert false

let array_get arr i = arr.(i)

let array_length = Array.length

let array_range n = Array.init n (fun x -> x)

let array_set = Array.set

let array_make = Array.make

let array_sum = Array.fold_left (+) 0

let caml_run_gc = Gc.full_major