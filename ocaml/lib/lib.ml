external dummy: unit -> unit = "dummy_lib"

let register () =
  Callback.register "zero"     Api.zero;
  Callback.register "constant" Api.constant;
  Callback.register "add"      Api.add;
  Callback.register "evaluate" Api.evaluate;