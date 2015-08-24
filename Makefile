#
# some housekeeping tasks
#

NAME=leoric
PREFIX ?= /usr/local
VERSION=$(shell grep "VERSION=" leoric | grep -o "[0-9\.]\{5,\}")
PKG_RELEASE ?= 1
PROJECT_URL="https://github.com/mrtazz/leoric"
SOURCES= leoric leoric.1
TARGETS= $(PREFIX)/bin/leoric $(PREFIX)/share/man/man1/leoric.1

.PHONY: test install rpm deb

leoric.1: leoric.1.txt
	txt2man -t "leoric" -s 1 -v "User Manual" $< > $@

$(PREFIX)/bin:
	install -m 755 -d $@

$(PREFIX)/share/man/man1:
	install -m 755 -d $@

$(PREFIX)/bin/leoric: leoric $(PREFIX)/bin
	install -m 755 $< $@

$(PREFIX)/share/man/man1/leoric.1: leoric.1 $(PREFIX)/share/man/man1
	install -m 755 $< $@

install: $(TARGETS)

rpm: $(SOURCES)
	  fpm -t rpm -s dir \
    --name leoric \
    --version $(VERSION) \
    --iteration $(PKG_RELEASE) \
    --epoch 1 \
    --license MIT \
    --maintainer "Daniel Schauenberg <d@unwiredcouch.com>" \
    --url $(PROJECT_URL) \
    --vendor mrtazz \
    usr

deb: $(SOURCES)
	  fpm -t deb -s dir \
    --name leoric \
    --version $(VERSION) \
    --iteration $(PKG_RELEASE) \
    --epoch 1 \
    --license MIT \
    --maintainer "Daniel Schauenberg <d@unwiredcouch.com>" \
    --url $(PROJECT_URL) \
    --vendor mrtazz \
    usr

test:
	cd tests && ./run_tests.sh
