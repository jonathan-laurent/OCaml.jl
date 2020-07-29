#include <stdio.h>
#include <ocamljl_base.h>
#include <ocamljl_stdlib.h>
#include <ocamljl_examples.h>

#include <caml/mlvalues.h>
#include <caml/callback.h>
#include <caml/alloc.h>
#include <caml/memory.h>

int main(int argc, char** argv) {
  caml_startup(argv);
  value *one = caml_of_long(1L);
  value *two = caml_of_long(2L);
  value *e1 = constant(one);
  value *e2 = constant(two); 
  value *e3 = add(e1, e2);
  value *res = evaluate(e3);
  printf("The result is: %ld.\n", caml_to_long(res));
  caml_release(one);
  caml_release(two);
  caml_release(e1);
  caml_release(e2);
  caml_release(e3);
  caml_release(res);
}