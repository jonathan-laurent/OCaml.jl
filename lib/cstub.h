#pragma once

#include <caml/mlvalues.h>

void __caml_initialize__(char** argv);

void __release__(value *obj);

// Conversion functions

long __long_of_caml__(value *v);

int __bool_of_caml__(value *v);

const char* __string_of_caml__(value *v);

value* __caml_of_long__(long x);

value* __caml_of_bool__(int x);

value* __caml_of_string__(char *str);

// Custom API

value* zero();

value* constant(value *x);

value* add(value *x, value *y);

value* evaluate(value *x);