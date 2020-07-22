LIB_PATH=_build/install/default/lib/binding-julia
OCAML_LIB_PATH=$(shell ocamlopt -where)

.PHONY: run lib client clean

run:
	make lib
	make client
	LD_LIBRARY_PATH=$(LIB_PATH) ./a.out

lib:
	dune build @install

client:
	$(CC) -I $(LIB_PATH) -L $(LIB_PATH) -I $(OCAML_LIB_PATH) \
	    	-Wl,--no-as-needed -ldl -lm -lbinding-julia \
				client/client.c

clean:
	dune clean
	rm -f a.out