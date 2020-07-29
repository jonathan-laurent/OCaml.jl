# OCaml.jl

A package to make OCaml libraries available in Julia.

## References

- https://github.com/ocaml/dune/issues/1832
- https://stackoverflow.com/questions/61416259/ocaml-as-c-library-hello-world-example
- http://caml.inria.fr/pub/docs/oreilly-book/pdf/chap12.pdf
- http://www.mega-nerd.com/erikd/Blog/CodeHacking/Ocaml/calling_ocaml.html
- Inverted C stubs: http://lists.ocaml.org/pipermail/ctypes/2014-October/000100.html
- https://stackoverflow.com/questions/48801340/ocaml-produce-shared-object-with-ocaml-runtime-linked-in

```
readelf -Ws _build/default/ocaml/libocaml.so | grep constant
```