#!/usr/bin/env bash

# no uninitialised variables
set -o nounset

PROGNAME=$(basename $0)
FAILURES=0

# helper function to print something to stderr
function warn {
  >&2 echo "${PROGNAME}: ${1:-"Unknown Error"}"
}

# basic assertion function. Takes a command that needs to exit with 0 for
# success and a string to print out if it exited with another code.
#
# Parameters:
# $1 - command to execute
# $2 - string to print for error
#
function assert {
  eval "$1"
  if [[ $? != 0 ]]; then
    warn "${2}"
    FAILURES=$((FAILURES+1))
  fi
}

# test definitions
function create_default_project {
  echo "running ${FUNCNAME}"
  ../leoric.sh -s fixtures -I fixtures/macros
  assert "test -d tests"   "directory 'tests' not created"
  assert "test -f LICENSE" "file 'LICENSE' not created"
  assert "test -f README.md" "file 'README.md' not created"
  assert "grep -q tests README.md 2>/dev/null" "project name substitution not working in README"
}

function create_default_project_with_name {
  echo "running ${FUNCNAME}"
  ../leoric.sh -s fixtures -I fixtures/macros -n the_name
  assert "test -d tests"   "directory 'tests' not created"
  assert "test -f LICENSE" "file 'LICENSE' not created"
  assert "test -f README.md" "file 'README.md' not created"
  assert "grep -q the_name README.md 2>/dev/null" "project name substitution not working in README"
}

function create_ruby_project {
  echo "running ${FUNCNAME}"
  ../leoric.sh -s fixtures -I fixtures/macros -t ruby
  assert "test -d tests"   "directory 'tests' not created"
  assert "test -f LICENSE" "file 'LICENSE' not created"
  assert "test -f README.md" "file 'README.md' not created"
  assert "grep -q tests README.md 2>/dev/null" "project name substitution not working in README"
  assert "test -d lib"   "directory 'lib' not created"
  assert "test -f tests.gemspec" "file 'tests.gemspec' not created"
}

function create_ruby_project_with_name {
  echo "running ${FUNCNAME}"
  ../leoric.sh -s fixtures -I fixtures/macros -t ruby -n the_name
  assert "test -d tests"   "directory 'tests' not created"
  assert "test -f LICENSE" "file 'LICENSE' not created"
  assert "test -f README.md" "file 'README.md' not created"
  assert "grep -q the_name README.md 2>/dev/null" "project name substitution not working in README"
  assert "test -d lib"   "directory 'lib' not created"
  assert "test -f the_name.gemspec" "file 'the_name.gemspec' not created"
}


# run tests
create_default_project
create_default_project_with_name
create_ruby_project
create_ruby_project_with_name

if [[ ${FAILURES} -eq 0 ]]; then
  echo "All tests passed."
  exit 0
else
  echo "There were ${FAILURES} assertion failures."
  exit 1
fi
