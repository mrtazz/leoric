#!/usr/bin/env bash

#
# The king of skeletons, initializing project structures for you.
#
PROGNAME=$(basename $0)

# no uninitialised variables
set -o nounset
# strict error checking
set -e

# functions

function warn {
  >&2 echo "${PROGNAME}: ${1:-"Unknown Error"}"
}

function warn_and_exit {
  warn "${1}"
  exit 1
}



# main
M4=$(which m4)

if [[ -z ${M4} ]]; then
  warn "Missing m4 executable."
fi
