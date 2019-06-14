all: demo.html

clean:
	find . -maxdepth 1 -name '*.adoc' | sed 's/.adoc$$/.html/' | xargs rm -f

embedded:
	asciidoctor-revealjs --attribute data-uri --attribute revealjsdir=https://cdnjs.cloudflare.com/ajax/libs/reveal.js/3.7.0 --attribute revealjs_embedded=true --out-file=demo_embedded.html demo.adoc

%.html: %.adoc lib/reveal.js lib/asciinema
	FILENAME=$< yarn build

lib/reveal.js:
	mkdir -p $@
	curl -sL https://github.com/hakimel/reveal.js/archive/3.8.0.tar.gz | tar xvz --strip 1 -C $@

lib/asciinema:
	mkdir -p $@
	curl -sL https://github.com/asciinema/asciinema-player/releases/download/v2.6.1/asciinema-player.css -o $@/asciinema-player.css
	curl -sL https://github.com/asciinema/asciinema-player/releases/download/v2.6.1/asciinema-player.js -o $@/asciinema-player.js

