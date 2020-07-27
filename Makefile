OCAML_LIB_PATH=$(shell ocamlopt -where)
SO_PATH=_build/default/ocaml

.PHONY: run lib example clean

run:
	make lib
	make example
	LD_LIBRARY_PATH=$(SO_PATH) ./a.out

lib:
	dune build

example:
	$(CC) -I $(SO_PATH)/lib -I $(SO_PATH)/base \
	    	-I $(OCAML_LIB_PATH) -L $(SO_PATH) \
	    	-Wl,--no-as-needed -ldl -lm \
				-locaml \
				examples/client.c

clean:
	dune clean
	rm -f a.out