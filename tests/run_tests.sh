#!/usr/bin/env bash

# no uninitialised variables
set -o nounset

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )

function tear_down {
  warn "cleaning up sandbox.."
  git clean -qfdx ../sandbox
}

# test definitions
function test_create_default_project {
  ../../leoric -s `pwd`/../fixtures -I `pwd`/../fixtures/macros
  assert "test -d tests"   "directory 'tests' not created"
  assert "test -f LICENSE" "file 'LICENSE' not created"
  assert "test -f README.md" "file 'README.md' not created"
  assert "grep -q sandbox README.md 2>/dev/null" "project name substitution not working in README"
}

function test_create_default_project_with_name {
  ../../leoric -s `pwd`/../fixtures -I `pwd`/../fixtures/macros -n the_name
  assert "test -d tests"   "directory 'tests' not created"
  assert "test -f LICENSE" "file 'LICENSE' not created"
  assert "test -f README.md" "file 'README.md' not created"
  assert "grep -q the_name README.md 2>/dev/null" "project name substitution not working in README"
}

function test_create_ruby_project {
  ../../leoric -s `pwd`/../fixtures -I `pwd`/../fixtures/macros -t ruby
  assert "test -d tests"   "directory 'tests' not created"
  assert "test -f LICENSE" "file 'LICENSE' not created"
  assert "test -f README.md" "file 'README.md' not created"
  assert "grep -q sandbox README.md 2>/dev/null" "project name substitution not working in README"
  assert "test -d lib"   "directory 'lib' not created"
  assert "test -f sandbox.gemspec" "file 'sandbox.gemspec' not created"
}

function test_create_ruby_project_with_name {
  ../../leoric -s `pwd`/../fixtures -I `pwd`/../fixtures/macros -t ruby -n the_name
  assert "test -d tests"   "directory 'tests' not created"
  assert "test -f LICENSE" "file 'LICENSE' not created"
  assert "test -f README.md" "file 'README.md' not created"
  assert "grep -q the_name README.md 2>/dev/null" "project name substitution not working in README"
  assert "test -d lib"   "directory 'lib' not created"
  assert "test -f the_name.gemspec" "file 'the_name.gemspec' not created"
}

# go into the sandbox to run tests
cd ${SCRIPTPATH}/sandbox
source "${SCRIPTPATH}/minibashtest.sh"
# run tests
run_test_suite
