external dummy: unit -> unit = "dummy_base"

let caml_exception_string e =
  let msg = Printexc.to_string e
  and stack = Printexc.get_backtrace () in
  msg ^ "\n" ^ stack

let register () =
  Callback.register "caml_exception_string" caml_exception_string