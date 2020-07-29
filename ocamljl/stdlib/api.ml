let array_get arr i = arr.(i)

let array_length = Array.length

let array_range n = Array.init n (fun x -> x)

let array_set = Array.set

let array_make = Array.make

let array_of_list = Array.of_list

let list_of_array = Array.to_list

let make_pair x y = (x, y)

let make_triple x y z = (x, y, z)

let pair_fst (x, _) = x

let pair_snd (_, y) = y

let triple_fst (x, _, _) = x

let triple_snd (_, y, _) = y

let triple_trd (_, _, z) = z

let run_gc = Gc.full_major