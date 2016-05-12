#
# some housekeeping tasks
#

NAME=leoric
PREFIX ?= /usr/local
VERSION = $(shell git describe --tags --always --dirty)
PROJECT_URL="https://github.com/mrtazz/leoric"
SOURCES= leoric leoric.1.md
TARGETS= $(PREFIX)/bin/leoric $(PREFIX)/share/man/man1/leoric.1
BUILDDIR=build
BUILDDATE=$(shell date -u +"%B %d, %Y")

.PHONY: test install all local-install

$(BUILDDIR):
	install -d $@

$(BUILDDIR)/leoric.1.md: leoric.1.md  $(BUILDDIR)
	sed "s/REPLACE_DATE/$(BUILDDATE)/" $< > $@

$(BUILDDIR)/leoric.1: $(BUILDDIR)/$(NAME).1.md $(BUILDDIR)
	pandoc -s -t man $< -o $@

$(BUILDDIR)/leoric: leoric $(BUILDDIR)
	sed "s/REPLACE_VERSION/$(VERSION)/" $< > $@

$(PREFIX)/bin:
	install -m 755 -d $@

$(PREFIX)/share/man/man1:
	install -m 755 -d $@

$(PREFIX)/bin/leoric: $(BUILDDIR)/leoric $(PREFIX)/bin
	install -m 755 $< $@

$(PREFIX)/share/man/man1/leoric.1: $(BUILDDIR)/leoric.1 $(PREFIX)/share/man/man1
	install -m 755 $< $@

all: $(BUILDDIR)/leoric $(BUILDDIR)/leoric.1

install: $(TARGETS)

local-install:
	$(MAKE) install PREFIX=./usr

test:
	cd tests && ./run_tests.sh

# packaging tasks

PKG_RELEASE ?= 1
FPM_FLAGS= --name $(NAME) \
           --version $(VERSION) \
           --iteration $(PKG_RELEASE) \
           --epoch 1 \
           --license MIT \
           --maintainer "Daniel Schauenberg <d@unwiredcouch.com>" \
           --url $(PROJECT_URL) \
           --description "Project initialization from skeleton files" \
           --depends m4 \
           --vendor mrtazz \
           usr

.PHONY: rpm deb packages deploy-packages

rpm: $(SOURCES) local-install
		fpm -t rpm -s dir $(FPM_FLAGS)

deb: $(SOURCES) local-install
		fpm -t deb -s dir $(FPM_FLAGS)

packages: rpm deb

deploy-packages: packages
	package_cloud push mrtazz/$(NAME)/el/7 *.rpm
	package_cloud push mrtazz/$(NAME)/debian/wheezy *.deb
	package_cloud push mrtazz/$(NAME)/ubuntu/trusty *.deb

# docs tasks

GAUGES_CODE="55db4e89de2e262cc50075cd"

.PHONY: jekyll docs clean-clean deploy-docs

jekyll:
	install -d ./docs
	echo "gaugesid: $(GAUGES_CODE)" > docs/_config.yml
	echo "projecturl: $(PROJECT_URL)" >> docs/_config.yml
	echo "basesite: http://www.unwiredcouch.com" >> docs/_config.yml
	echo "markdown: redcarpet" >> docs/_config.yml
	echo "---" > docs/index.md
	echo "layout: project" >> docs/index.md
	echo "title: $(NAME)" >> docs/index.md
	echo "---" >> docs/index.md
	cat README.md >> docs/index.md

docs/leoric.1.html: $(BUILDDIR)/$(NAME).1.md $(BUILDDIR)
	pandoc -t html $< -o $@

docs: jekyll docs/leoric.1.html

clean-docs:
	rm -rf ./docs

deploy-docs: docs
	@cd docs && git init && git remote add upstream "https://${GH_TOKEN}@github.com/mrtazz/$(NAME).git" && \
	git submodule add https://github.com/mrtazz/jekyll-layouts.git ./_layouts && \
	git submodule update --init && \
	git fetch upstream && git reset upstream/gh-pages && \
	git config user.name 'Daniel Schauenberg' && git config user.email d@unwiredcouch.com && \
	touch . && git add -A . && \
	git commit -m "rebuild pages at $(VERSION)" && \
	git push -q upstream HEAD:gh-pages
