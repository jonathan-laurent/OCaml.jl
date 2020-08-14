OCAML_LIB_PATH=$(shell ocamlopt -where)
DUNE_BUILD_PATH=_build/default
GENERATED_PATH=examples/generated

.PHONY: lib testc testjl clean

lib:
	dune build
	mkdir $(GENERATED_PATH) || true
	cp -f $(DUNE_BUILD_PATH)/ocamljl/base/ocamljl_base.h $(GENERATED_PATH)
	cp -f $(DUNE_BUILD_PATH)/ocamljl/stdlib/ocamljl_stdlib.h $(GENERATED_PATH)
	cp -f $(DUNE_BUILD_PATH)/ocamljl/stdlib/ocamljl_stdlib.jl $(GENERATED_PATH)
	cp -f $(DUNE_BUILD_PATH)/examples/libocaml/ocamljl_examples.h $(GENERATED_PATH)
	cp -f $(DUNE_BUILD_PATH)/examples/libocaml/ocamljl_examples.jl $(GENERATED_PATH)
	cp -f $(DUNE_BUILD_PATH)/examples/libocaml/libocaml.so $(GENERATED_PATH)

testc: lib
	$(CC) -I $(GENERATED_PATH) -I $(OCAML_LIB_PATH) \
				-L $(GENERATED_PATH) \
	    	-Wl,--no-as-needed -ldl -lm \
				-locaml \
				examples/client.c
	LD_LIBRARY_PATH=$(GENERATED_PATH) ./a.out

testjl: lib
	julia --project --color=yes examples/client.jl

clean:
	dune clean
	rm -f a.out

full-clean: clean
	-rm -rf $(GENERATED_PATH)