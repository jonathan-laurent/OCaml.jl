#pragma once

#include <caml/mlvalues.h>

value* zero();

value* constant(value *x);

value* add(value *x, value *y);

value* evaluate(value *x);