# OpaBDDC. (c) Valdabondance.com 2011
# @author Matthieu Guffroy

OPA=opa

OPX_DIR=_build_o
DB_DIR=db
#TRANSLATIONS_DIR=translations

OPT-DB=--db-local $(DB_DIR)/db --db-force-upgrade
OPT=--opx-dir $(OPX_DIR) #--i18n-dir $(TRANSLATIONS_DIR)
OPT-RELEASE=$(OPT) --compile-release
DEBUG=--debug-editable-css --verbose 100
FILES=$(shell find src -name '*.opa')
EXE=main.exe

all: $(FILES)
	$(OPA) $^ -o main.exe $(OPT)

all-release: $(FILES)
	$(OPA) $^ -o main.exe $(OPT-RELEASE)

translation: $(FILES)
	$(OPA) --i18n-template-opa $^ --i18n-dir $(TRANSLATIONS_DIR)

run:
	./$(EXE) $(OPT-DB)

run-debug:
	./$(EXE) $(OPT-DB) $(DEBUG)


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
