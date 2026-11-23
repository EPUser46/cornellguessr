.PHONY: build run clean test

PORT = 8000

build:
	dune build public/index.html

run: build
	cd _build/default/public && python3 -m http.server $(PORT)

test:
	dune runtest

clean:
	dune clean