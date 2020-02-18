#!/usr/bin/env bash

git clone --depth 1 --branch master git@git.vshn.net:education/revealjs-template.git "$1"
cd "$1" || exit
rm -rf .git
rm -f CHANGELOG.adoc
rm -f README.adoc
rm -f bootstrap.sh

echo "= CHANGELOG

== Version 1.0

* First version" >> CHANGELOG.adoc

echo "= $1

TODO: Describe your presentation here." >> README.adoc

