.PHONY: all
all: slides.html slides.pdf

.PHONY: preview
preview: slides.adoc
	docker run --user "$$(id -u)" --rm --publish 35729:35729 --publish 2020:2020 --volume "$${PWD}":/build vshn/slides-preview:1.11

slides.html: slides.adoc
	docker run --rm --tty --user "$$(id -u)" --volume "$${PWD}":/build vshn/asciidoctor-slides:1.10 --filename slides.adoc

slides.pdf: slides.html
	docker run --rm --tty --user "$$(id -u)" --volume "$${PWD}":/slides astefanutti/decktape:3.1.0 --size '2560x1440' --pause 2000 --chrome-arg=--allow-file-access-from-files slides.html slides.pdf

.PHONY: docker
docker: slides.pdf
	docker build -t {{cookiecutter.presentation_folder_name}}:1.0 .

.PHONY: clean
clean:
	find . -maxdepth 1 -name 'Caddyfile' | xargs rm -f; \
	find . -maxdepth 1 -name 'Guardfile' | xargs rm -f; \
	find . -maxdepth 1 -name '*.adoc' | sed 's/.adoc$$/.html/' | xargs rm -f; \
	find . -maxdepth 1 -name '*.adoc' | sed 's/.adoc$$/.pdf/' | xargs rm -f; \
	find . -maxdepth 1 -name 'theme' | xargs rm -rf; \
	find . -maxdepth 1 -name 'node_modules' | xargs rm -rf
