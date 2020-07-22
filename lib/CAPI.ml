let () =
  Callback.register "zero"     Lib.zero;
  Callback.register "constant" Lib.constant;
  Callback.register "add"      Lib.add;
  Callback.register "evaluate" Lib.evaluate