#pragma once

#include <caml/mlvalues.h>

value* zero();

value* constant(value *x0);

value* add(value *x0, value *x1);

value* evaluate(value *x0);

value* is_sum(value *x0);

value* sum_terms(value *x0);

value* array_sum(value *x0);

value* list_sum(value *x0);

value* square_float(value *x0);

value* array_maximum(value *x0);

value* vec_mul(value *x0, value *x1);

value* point2i_add(value *x0, value *x1);

value* point3f_add(value *x0, value *x1);

value* add_opt(value *x0, value *x1);

value* safe_div(value *x0, value *x1);

