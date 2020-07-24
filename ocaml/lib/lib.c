#include <caml/mlvalues.h>
#include <caml/callback.h>
#include <caml/alloc.h>
#include <caml/memory.h>

#include <stdio.h>

#define Alloc_return(res) ({\
  value *allocated = malloc(sizeof(value));\
  *allocated = (res);\
  caml_register_generational_global_root(allocated);\
  return allocated;\
})

void dummy_lib() { return; }

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