OCAML_LIB_PATH=$(shell ocamlopt -where)
OCAMLJL_PATH=_build/default/ocamljl
SO_PATH=_build/default/examples/libocaml

.PHONY: lib testc testjl clean

lib:
	dune build

testc: lib
	$(CC) -I $(OCAMLJL_PATH)/stdlib -I $(OCAMLJL_PATH)/base -I $(SO_PATH) \
	    	-I $(OCAML_LIB_PATH) -L $(SO_PATH) \
	    	-Wl,--no-as-needed -ldl -lm \
				-locaml \
				examples/client.c
	LD_LIBRARY_PATH=$(SO_PATH) ./a.out

testjl: lib
	julia --project --color=yes examples/client.jl


clean:
	dune clean
	rm -f a.out