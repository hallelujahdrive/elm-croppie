all: build-demo

build-npm: node_modules src/elm-croppie.ts
	rollup -c
	cp node_modules/croppie/croppie.css dist/elm-croppie.css

build-demo: build-npm
	cp dist/elm-croppie.js demo
	cp dist/elm-croppie.css demo
	cd demo && rollup -c

build-docs: src/*.elm src/**/*.elm
	elm make --docs=docs.json

release: clean all

clean:
	rm -rf dist
	rm -f dcos.json
	rm -f demo/demo.js
	rm -f demo/elm-croppie.js
	rm -f demo/elm-croppie.css