CRYSTAL_BIN ?= $(shell which crystal)
PREFIX ?= /usr/local

build:
	mkdir -p bin
	$(CRYSTAL_BIN) build --no-debug src/memria.cr -o bin/memria

install:
	mkdir -p $(PREFIX)/bin
	cp ./bin/memria $(PREFIX)/bin

uninstall:
	rm $(PREFIX)/bin/memria
