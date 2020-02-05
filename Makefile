all: slides.html slides.pdf

slides.html:
	docker run --rm --tty --user "$$(id -u)" --volume "$${PWD}":/build vshn/asciidoctor-slides:1.0 slides.adoc

slides.pdf: slides.html
	docker run --rm --tty --user "$$(id -u)" --volume $$(pwd):/slides --volume $$(pwd):/home/user astefanutti/decktape:2.9.2 --size '2560x1440' --chrome-arg=--allow-file-access-from-files /home/user/slides.html slides.pdf

clean:
	find . -maxdepth 1 -name '*.adoc' | sed 's/.adoc$$/.html/' | xargs rm -f
	find . -maxdepth 1 -name '*.adoc' | sed 's/.adoc$$/.pdf/' | xargs rm -f
	rm -r theme
	rm -r node_modules
