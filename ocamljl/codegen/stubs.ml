open Parsetree

let pp = Format.fprintf

let err ~loc msg =
  failwith (Format.asprintf "Error at %a: %s" Location.print_loc loc msg)

let tuple_name = "tuple"

let atomic_types_ctors =
  [ "int"; "string"; "array"; "list"; "option"; "pair"; tuple_name ]

type atomic_type =
  | Type of string * atomic_type list
  | Var of string

type value_type = {args: atomic_type list; ret: atomic_type}

module SSet = Set.Make(String)

let union_list = List.fold_left (SSet.union) SSet.empty

let rec type_variables = function
  | Var s  -> SSet.singleton s
  | Type (_, args) ->
    List.map type_variables args |> union_list

let convert_longident ~loc = function
  | Longident.Lident s -> s
  | _ -> err ~loc "Long identifiers are not allowed."

let rec convert_atomic_type ~loc t =
  match t.ptyp_desc with
  | Ptyp_var s -> Var s
  | Ptyp_tuple ts ->
      Type (tuple_name, List.map (convert_atomic_type ~loc) ts)
  | Ptyp_constr (name, args) ->
      Type (convert_longident ~loc name.txt, List.map (convert_atomic_type ~loc) args)
  | Ptyp_arrow _ -> err ~loc "Higher order functions are not supported yet."
  | _ -> err ~loc "The declared type is not currently supported."

let rec collect_arrows ~loc t =
  match t.ptyp_desc with
  | Ptyp_arrow (Nolabel, lhs, rhs) ->
    lhs :: collect_arrows ~loc rhs
  | Ptyp_arrow (Labelled _, _, _) | Ptyp_arrow (Optional _, _, _)  ->
      err ~loc "Labelled or optional arguments are not allowed."
  | _ -> [t]

let convert_type ~loc t =
  match collect_arrows ~loc t |> List.map (convert_atomic_type ~loc) |> List.rev with
  | [] -> assert false
  | ret :: rev_args -> {args = List.rev rev_args; ret}

let rec julia_type = function
  | Var a -> String.capitalize_ascii a
  | Type (t, []) -> ":" ^ t
  | Type (t, args) ->
    "Tuple{:" ^ t ^ ", " ^ String.concat ", " (List.map julia_type args) ^ "}"

let julia_value_type t = "Caml{" ^ julia_type t ^ "}"

let write_julia_stub_item f name {args; ret} =
  let args_str =
    match List.map julia_value_type args with
    | [] -> ""
    | args -> "(" ^ String.concat ", " (List.map (fun a -> "::" ^ a) args) ^ ")" in
  let where_str = 
    let tvars =
      List.map type_variables (ret :: args)
      |> union_list
      |> SSet.elements
      |> List.map String.capitalize_ascii in
    match tvars with
    | [] -> ""
    | _ -> "where {" ^ String.concat ", " tvars ^ "}" in
  let ret_str = julia_value_type ret in
  pp f "@caml %s%s :: %s %s\n\n" name args_str ret_str where_str

let write_c_header_prelude f =
  pp f "#pragma once\n\n";
  pp f "#include <caml/mlvalues.h>\n\n"

let write_c_header_item f name {args; _} =
  let args_str =
    List.mapi (fun i _a -> "value *x" ^ string_of_int i) args
    |> String.concat ", " in
  pp f "value* %s(%s);\n\n" name args_str

let write_c_source_prelude f libname =
  pp f "#include <caml/mlvalues.h>\n";
  pp f "#include <caml/callback.h>\n";
  pp f "#include <caml/alloc.h>\n";
  pp f "#include <caml/memory.h>\n\n";
  pp f "#include <stdio.h>\n\n"; (* for debugging *)
  pp f "extern value caml_last_exception;\n\n";
  pp f "void dummy_%s() { return; }\n\n" libname

let write_c_source_item f name {args; _} =
  let arg_names =
    List.mapi (fun i _a -> "x" ^ string_of_int i) args in
  let args_str =
    List.map (fun a -> "value *" ^ a) arg_names
    |> String.concat ", " in
  let res =
    begin match arg_names with
    | [] -> "*_f"
    | _ ->
      let n = List.length arg_names in
      Printf.sprintf "caml_callback%s_exn(*_f, %s)"
        (if n = 1 then "" else if n = 2 then "2" else if n = 3 then "3"
         else
           failwith "Functions with more than 3 arguments are currently not supported.")
        (List.map (fun a -> "*" ^ a) arg_names |> String.concat ", ")
    end in
  pp f "value* %s(%s) {\n" name args_str;
  pp f "  static const value *_f = NULL;\n";
  pp f "  if (_f == NULL) _f = caml_named_value(\"%s\");\n" name;
  pp f "  value *_r = malloc(sizeof(value));\n";
  pp f "  *_r = %s;\n" res;
  pp f "  if (Is_exception_result(*_r)) {\n";
  pp f "    caml_last_exception = Extract_exception(*_r);\n";
  pp f "    caml_register_generational_global_root(&caml_last_exception);\n";
  pp f "    free(_r);\n";
  pp f "    return NULL;\n";
  pp f "  }\n";
  pp f "  else {\n";
  pp f "    caml_register_generational_global_root(_r);\n";
  pp f "    return _r;\n";
  pp f "  }\n";
  pp f "}\n\n"

let write_ml_prelude f libname =
  pp f "external dummy: unit -> unit = \"dummy_%s\"\n\n" libname;
  pp f "let register () =\n"

let write_ml_item f name =
  pp f "  Callback.register \"%s\" Api.%s;\n" name name

let get_attribute_docstring = function 
  | { attr_name;
      attr_payload =
        PStr [{pstr_desc =
         Pstr_eval ({pexp_desc =
           Pexp_constant (Pconst_string (doc, _))
              ; _}, _); _}]; _}
    when attr_name.txt = "ocaml.doc" -> Some doc
  | _ -> None

let get_docstring vdescr =
  vdescr.pval_attributes
  |> List.filter_map get_attribute_docstring
  |> String.concat "\n"
  |> String.trim

let convert_code_quote s =
  let words = Str.split (Str.regexp "[ ]+") (Str.matched_group 1 s) in
  let quote  s = "`" ^ s ^ "`" in
  let parens s = "(" ^ s ^ ")" in
  match words with
  | [] -> ""
  | [x] -> quote x
  | f::args -> quote (f ^ parens (String.concat ", " args))

let write_julia_doc f name coretype doc =
  let typestr =
    Format.asprintf "%a" Pprintast.core_type coretype
    |> String.trim in
  let doc =
    Str.global_substitute
      (Str.regexp "\\[\\([^][]*\\)\\]") convert_code_quote doc in
  pp f "\"\"\"\n";
  pp f "```ocaml\n";
  pp f "val %s: %s\n" name typestr;
  pp f "```\n";
  if String.length doc > 0 then pp f "%s\n" doc;
  pp f "\"\"\"\n"

let make ~name ~h ~c ~jl ~ml s =
  let abstract_types = Queue.create () in
  write_c_header_prelude h;
  write_c_source_prelude c name ;
  write_ml_prelude ml name;
  List.iter (fun it ->
  let loc = it.psig_loc in
    match it.psig_desc with
    | Psig_value v ->
      begin
        let name = v.pval_name.txt in
        let typ = convert_type ~loc v.pval_type in
        let doc = get_docstring v in
        write_julia_doc jl name v.pval_type doc;
        write_julia_stub_item jl name typ;
        write_c_header_item h name typ;
        write_c_source_item c name typ;
        write_ml_item ml name;
      end
    | Psig_type (_, [{ptype_kind=Ptype_abstract; _} as decl]) ->
      begin
        let name = decl.ptype_name.txt in
        Queue.push name abstract_types
      end
    | _ -> err ~loc "Unsupported signature item."
  ) s
