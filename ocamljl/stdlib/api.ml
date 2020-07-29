let array_get arr i = arr.(i)

let array_length = Array.length

let array_range n = Array.init n (fun x -> x)

let array_set = Array.set

let array_make = Array.make

let array_of_list = Array.of_list

let list_of_array = Array.to_list

let run_gc = Gc.full_major