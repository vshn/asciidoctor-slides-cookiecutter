SHELL := /bin/bash

.PHONY: all
all: slides.html slides.pdf

.PHONY: preview
preview: slides.adoc
	docker run --user "$$(id -u)" --rm --publish 35729:35729 --publish 2020:2020 --volume "$${PWD}":/build vshn/slides-preview:1.12

slides.html: slides.adoc
	docker run --rm --tty --user "$$(id -u)" --volume "$${PWD}":/build vshn/asciidoctor-slides:1.12 --filename slides.adoc

slides.pdf: slides.html
	docker run --rm --tty --user "$$(id -u)" --volume "$${PWD}":/slides astefanutti/decktape:3.4.0 --size '1920x1080' --chrome-arg=--allow-file-access-from-files slides.html slides.pdf

slides-with-notes.html: slides.adoc
	docker run --rm --tty --user "$$(id -u)" --volume "$${PWD}":/build vshn/asciidoctor-slides:1.12 --filename slides.adoc --show-notes --output slides-with-notes.html

slides-with-notes.pdf: slides-with-notes.html
	docker run --rm --tty --user "$$(id -u)" --volume "$${PWD}":/slides astefanutti/decktape:3.4.0 --size '1920x1080' --chrome-arg=--allow-file-access-from-files slides-with-notes.html slides-with-notes.pdf

# This target lists the images not used in the final presentation,
# and which could be removed. This command requires `ag` installed:
# https://github.com/ggreer/the_silver_searcher
.PHONY: unused_images
unused_images: slides.html
	@for file in assets/images/* ; do \
		if ! ag -U $${file##*/} slides.html > /dev/null; then \
			echo $$file; \
		fi; \
	done;

.PHONY: docker
docker: slides.pdf
	docker build -t {{cookiecutter.presentation_folder_name}}:1.0 .

.PHONY: clean
clean:
	find . -maxdepth 1 -name 'Caddyfile' | xargs rm -f; \
	find . -maxdepth 1 -name 'Guardfile' | xargs rm -f; \
	find . -maxdepth 1 -name '*.html' | xargs rm -f; \
	find . -maxdepth 1 -name '*.pdf' | xargs rm -f; \
	find . -maxdepth 1 -name 'theme' | xargs rm -rf; \
	find . -maxdepth 1 -name 'node_modules' | xargs rm -rf

