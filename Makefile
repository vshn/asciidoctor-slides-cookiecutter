all: slides.html slides.pdf

clean:
	find . -maxdepth 1 -name '*.adoc' | sed 's/.adoc$$/.html/' | xargs rm -f
	find . -maxdepth 1 -name '*.adoc' | sed 's/.adoc$$/.pdf/' | xargs rm -f

embedded:
	asciidoctor-revealjs --attribute data-uri --attribute revealjsdir=https://cdnjs.cloudflare.com/ajax/libs/reveal.js/3.7.0 --attribute revealjs_embedded=true --out-file=demo_embedded.html demo.adoc

%.html: %.adoc node_modules
	FILENAME=$< npm run build

%.pdf: %.html
	docker run --rm -t -v $$(pwd):/slides -v $$(pwd):/home/user astefanutti/decktape:2.9.2 --size '2560x1440' --chrome-arg=--allow-file-access-from-files /home/user/slides.html slides.pdf

node_modules:
	npm install

