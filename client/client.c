#include <stdio.h>
#include <binding-julia.h>

int main(int argc, char** argv) {
  __caml_initialize__(argv);
  value *one = __caml_of_long__(1L);
  value *two = __caml_of_long__(2L);
  value *e1 = constant(one);
  value *e2 = constant(two); 
  value *e3 = add(e1, e2);
  value *res = evaluate(e3);
  printf("The result is: %ld.\n", __long_of_caml__(res));
  __release__(one);
  __release__(two);
  __release__(e1);
  __release__(e2);
  __release__(e3);
  __release__(res);
}