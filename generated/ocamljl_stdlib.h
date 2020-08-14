#pragma once

#include <caml/mlvalues.h>

value* array_get(value *x0, value *x1);

value* array_length(value *x0);

value* array_range(value *x0);

value* array_set(value *x0, value *x1, value *x2);

value* array_make(value *x0, value *x1);

value* array_of_list(value *x0);

value* list_of_array(value *x0);

value* make_pair(value *x0, value *x1);

value* make_triple(value *x0, value *x1, value *x2);

value* pair_fst(value *x0);

value* pair_snd(value *x0);

value* triple_fst(value *x0);

value* triple_snd(value *x0);

value* triple_trd(value *x0);

value* some(value *x0);

value* is_none(value *x0);

value* get_some(value *x0);

value* run_gc(value *x0);

