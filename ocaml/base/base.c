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

void dummy_base() { return; }

value caml_last_exception = 0;

const char *caml_last_exception_message() {
  static const value *f = NULL;
  if (f == NULL) f = caml_named_value("caml_exception_string");
  if (caml_last_exception == 0)
    return "";
  else
    return String_val(caml_callback(*f, caml_last_exception));
}

void caml_release(value *obj) {
  caml_remove_generational_global_root(obj);
  free(obj);
}

long caml_to_long(value *v) { return Long_val(*v); }

int caml_to_bool(value *v) { return Bool_val(*v); }

const char* caml_to_string(value *v) { return String_val(*v); }

value* caml_of_long(long x) { Alloc_return(Val_long(x)); }

value* caml_of_bool(int x) { Alloc_return(Val_bool(x)); }

value* caml_of_string(char *str) { Alloc_return(caml_copy_string(str)); }

value* caml_make_unit() { Alloc_return(Val_unit); }

value _deref_pointer_(char const *v) { return *((value*) v); }

value* caml_base_make_array(char const ** elts) {
  Alloc_return(caml_alloc_array(_deref_pointer_, elts));
}