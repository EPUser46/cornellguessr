.PHONY: build run clean test

PORT = 8000

build:
	dune build public/index.html

run: build
	cd _build/default/public && python3 -m http.server $(PORT)

# run Ocaml tests
test:
	dune runtest

# run browser tests
test-browser:
	dune exec ./test/test_browser_map.exe

clean:
	dune clean