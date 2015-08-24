#
# some housekeeping tasks
#

NAME=leoric
PREFIX ?= /usr/local
TARGETS= $(PREFIX)/bin/leoric $(PREFIX)/share/man/man1/leoric.1

.PHONY: test

leoric.1: leoric.1.txt
	txt2man -t "leoric" -s 1 -v "User Manual" $< > $@

$(PREFIX)/bin/leoric: leoric
	install -m 755 $< $@

$(PREFIX)/share/man/man1/leoric.1: leoric.1
	install -m 755 $< $@

install: $(TARGETS)

test:
	cd tests && ./run_tests.sh
