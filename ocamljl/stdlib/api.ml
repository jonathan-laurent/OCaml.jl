let array_get arr i = arr.(i)

let array_length = Array.length

let array_range n = Array.init n (fun x -> x)

let array_set = Array.set

let array_make = Array.make

let run_gc = Gc.full_major