# OpaBDDC. (c) Valdabondance.com 2011
# @author Matthieu Guffroy

OPA=opa
OPX_DIR=_build_o
OPT=--opx-dir $(OPX_DIR)
OPT-RELEASE=$(OPT) --compile-release
DEBUG=--debug-editable-css --verbose 100
FILES=$(shell find src -name '*.opa')
EXE=main.exe

all: $(FILES)
	$(OPA) $^ -o main.exe $(OPT)

all-release: $(FILES)
	$(OPA) $^ -o main.exe $(OPT-RELEASE)



run:
	./$(EXE) --db-local db/db

run-debug:
	./$(EXE) --db-local db/db $(DEBUG)

new-db:	all
	./$(EXE) --db-local db/db --db-force-upgrade

new-db-debug: all
	./$(EXE) --db-local db/db --db-force-upgrade $(DEBUG)

clean-db:
	rm -rf db/*

clean:
	rm -rf $(OPX_DIR)/*.opx $(OPX_DIR)/*.opx.broken
	rm -f *.exe
	rm -rf doc
	rm -rf _build _tracks
	rm -f *.log
	rm -f *.apix
	rm -f src/*.api
	rm -rf *.opp
	rm -f src/*.api-txt
