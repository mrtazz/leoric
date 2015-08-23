#
# some housekeeping tasks
#

NAME=leoric
.PHONY: test






test:
	cd tests && ./run_tests.sh
