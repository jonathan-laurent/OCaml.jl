(* Simple CLI to generate binding stubs *)

let mli_input = ref ""
let c_output = ref ""
let h_output = ref ""
let jl_output = ref ""
let ml_output = ref ""
let lib_name = ref ""

let usage = Sys.argv.(0) ^ " generates C and Julia stubs to access OCaml code from Julia"

let options = [
  "--name",  Arg.Set_string lib_name,  "Name of the compiled library";
  "-c",      Arg.Set_string c_output,  "C source output file";
  "-h",      Arg.Set_string h_output,  "C header output file";
  "-ml",     Arg.Set_string ml_output,  "OCaml output file";
  "-jl",     Arg.Set_string jl_output, "Julia output file"]

let open_output f = Format.formatter_of_out_channel (open_out f)

let main () =
  Arg.parse options (fun mli -> mli_input := mli) usage;
  let ic = open_in !mli_input in
  let lexbuf = Lexing.from_channel ic in
  let interface = Parse.interface lexbuf in
  let c = open_output !c_output in
  let h = open_output !h_output in
  let jl = open_output !jl_output in
  let ml = open_output !ml_output in
  Stubs.make ~name:!lib_name ~h ~c ~jl ~ml interface

let () = main ()

(* dune exec ./make_stubs.exe -- ../lib/api.mli --name stdlib -jl stub.jl -h cstub.h -c cstub.c *)