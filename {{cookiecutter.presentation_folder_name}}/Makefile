SHELL := /bin/bash
builder_cmd  ?= podman

ifeq ($(builder_cmd),docker)
	docker_opts ?= --rm --user "$$(id -u)"
else
	docker_opts ?= --rm --user 0:0
endif

.PHONY: all
all: slides.html slides.pdf

.PHONY: preview
preview: slides.adoc
	$(builder_cmd) run $(docker_opts) --publish 35729:35729 --publish 2020:2020 --volume "$${PWD}":/build ghcr.io/vshn/asciidoctor-slides-preview:1.17.1

slides.html: slides.adoc
	$(builder_cmd) run $(docker_opts) --volume "$${PWD}":/build ghcr.io/vshn/asciidoctor-slides:1.17.0 --filename slides.adoc

slides.pdf: slides.html
	$(builder_cmd) run $(docker_opts) --volume "$${PWD}":/slides ghcr.io/astefanutti/decktape:3.4.0 --size '1920x1080' --chrome-arg=--allow-file-access-from-files slides.html slides.pdf

slides-with-transitions.pdf: slides.html
	$(builder_cmd) run $(docker_opts) --volume "$${PWD}":/slides ghcr.io/astefanutti/decktape:3.4.0 --size '1920x1080' --chrome-arg=--allow-file-access-from-files slides.html?fragments=true slides-with-transitions.pdf

slides-with-notes.html: slides.adoc
	$(builder_cmd) run $(docker_opts) --volume "$${PWD}":/build ghcr.io/vshn/asciidoctor-slides:1.17.0 --filename slides.adoc --show-notes --attribute slides-pdf-export --output slides-with-notes.html

slides-embedded.html: slides.adoc
	$(builder_cmd) run $(docker_opts) --volume "$${PWD}":/build ghcr.io/vshn/asciidoctor-slides:1.17.0 --filename slides.adoc --embedded --output slides-embedded.html

slides-with-notes.pdf: slides-with-notes.html
	$(builder_cmd) run $(docker_opts) --volume "$${PWD}":/slides ghcr.io/astefanutti/decktape:3.4.0 --size '1920x1080' --chrome-arg=--allow-file-access-from-files slides-with-notes.html slides-with-notes.pdf

# This target lists the images not used in the final presentation,
# and which could be removed.
.PHONY: unused_images
unused_images: slides.html
	@for file in assets/images/* ; do \
		if ! grep -U $${file##*/} slides.html > /dev/null; then \
			echo $$file; \
		fi; \
	done;

speaker-notes.html: slides.adoc
	$(builder_cmd) run $(docker_opts) --volume ${PWD}:/convert:Z ghcr.io/vshn/asciidoctor-slides-notes-exporter:1.0 html /convert/slides.adoc

speaker-notes.pdf: slides.adoc
	$(builder_cmd) run $(docker_opts) --volume ${PWD}:/convert:Z ghcr.io/vshn/asciidoctor-slides-notes-exporter:1.0 pdf /convert/slides.adoc

.PHONY: speaker-notes
speaker-notes: slides.adoc
	$(builder_cmd) run $(docker_opts) --volume ${PWD}:/convert:Z ghcr.io/vshn/asciidoctor-slides-notes-exporter:1.0 /convert/slides.adoc

.PHONY: container
container: slides.pdf
	$(builder_cmd) build -t {{cookiecutter.presentation_folder_name}}:1.0 .

.PHONY: clean
clean:
	find . -maxdepth 1 -name 'Caddyfile' | xargs rm -f; \
	find . -maxdepth 1 -name 'Guardfile' | xargs rm -f; \
	find . -maxdepth 1 -name '*.html' | xargs rm -f; \
	find . -maxdepth 1 -name '*.pdf' | xargs rm -f; \
	find . -maxdepth 1 -name 'theme' | xargs rm -rf; \
	find . -maxdepth 1 -name 'node_modules' | xargs rm -rf

