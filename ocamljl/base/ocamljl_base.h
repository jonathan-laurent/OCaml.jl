#pragma once

#include <caml/mlvalues.h>

// To handle ocaml exceptions

value caml_last_exception;

const char* caml_last_exception_message();

// For memory management

void caml_release(value *obj);

// Conversion functions

long caml_to_long(value *v);

int caml_to_bool(value *v);

double caml_to_double(value *v);

const char* caml_to_string(value *v);

value* caml_of_long(long x);

value* caml_of_bool(int x);

value* caml_of_double(double x);

value* caml_of_string(char *str);

value* caml_make_unit();

value* caml_base_make_array(value **elts);

value* caml_base_make_double_array(int n, double *src);