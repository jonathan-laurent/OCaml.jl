#include <caml/mlvalues.h>
#include <caml/callback.h>
#include <caml/alloc.h>
#include <caml/memory.h>

#include <stdio.h>

// Dealing with OCaml's GC

#define Alloc_return(res) ({\
  value *allocated = malloc(sizeof(value));\
  *allocated = (res);\
  caml_register_generational_global_root(allocated);\
  return allocated;\
})

void __release__(value *obj) {
  caml_remove_generational_global_root(obj);
  free(obj);
  // printf("Releasing %p\n", obj);
}

// Initialize the Ocaml runtime

void __caml_initialize__ (char** argv) {
  // printf("Initializing the OCaml environment.\n");
  caml_startup(argv);
}

// Useful conversion functions

long __long_of_caml__(value *v) { return Long_val(*v); }
int __bool_of_caml__(value *v) { return Bool_val(*v); }
const char* __string_of_caml__(value *v) { return String_val(*v); }

value* __caml_of_long__(long x) { Alloc_return(Val_long(x)); }
value* __caml_of_bool__(int x) { Alloc_return(Val_bool(x)); }
value* __caml_of_string__(char *str) { Alloc_return(caml_copy_string(str)); }

// Custom API

value* zero() {
  static const value* v = NULL;
  if (v == NULL)
    v = caml_named_value("zero");
  Alloc_return(*v);
}

value* constant(value *x) {
  static const value* closure = NULL;
  if (closure == NULL)
    closure = caml_named_value("constant");
  Alloc_return(caml_callback(*closure, *x));
}

value* add(value *x, value *y) {
  static const value* closure = NULL;
  if (closure == NULL)
    closure = caml_named_value("add");
  Alloc_return(caml_callback2(*closure, *x, *y));
}

value* evaluate(value *x) {
  static const value* closure = NULL;
  if (closure == NULL)
    closure = caml_named_value("evaluate");
  Alloc_return(caml_callback(*closure, *x));
}