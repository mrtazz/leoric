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

function usage {
  >&2 echo "
Usage: `basename $0` [-qh] [-I macro dir] [-t project type] [-n project name] -s <skeleton directory> -- utility to initialize code repositories

where:
  -h show this help
  -q don't show warnings
  -s skeleton directory to choose from
  -I m4 macro definitions to use
  -t type of repository to initialize
  -n name of the project (defaults to current directory name)

"
}

# function to install all directories from a given skeleton location into the
# current directory
#
# Parameters:
#  $1 - skeleton location to install from
#
function install_directories {
  local SKEL_DIR=$1

  for dir in $(cd ${SKEL_DIR} && find . -type d -mindepth 1)
  do
    install -m 755 -d ${SKEL_DIR}/${dir} .
  done
}

# main

SKELETON_DIR=""
PROJECT_NAME=$(dirname $0)
MACRO_DIR=""
PROJECT_TYPE=""
QUIET=0

# parse command line options
while getopts ":hqs:I:t:n:" opt; do
  case $opt in
    h)
      usage && exit 1
      ;;
    q)
      QUIET=1
      ;;
    s)
      SKELETON_DIR=$OPTARG
      ;;
    I)
      MACRO_DIR=$OPTARG
      ;;
    t)
      PROJECT_TYPE=$OPTARG
      ;;
    n)
      PROJECT_NAME=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage && exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      usage && exit 1
      ;;
  esac
done

# we at least need a skeleton dir and it needs to exist
if [[ -z ${SKELETON_DIR} ]]; then
  warn "No skeleton directory set. No idea what to do now. Aborting."
  usage
  exit 1
elif [[ ! -d ${SKELETON_DIR} ]]; then
  warn "Skeleton directory does not exist. No idea what to do now. Aborting."
  usage
  exit 1
fi

# check if we should do macro expansion

M4=$(which m4)
NO_M4=0

if [[ -z ${M4} && ${QUIET} -eq 0 ]]; then
  warn "Missing m4 executable."
  warn "Skeleton directories and files are still created,"
  warn "but no macro expansion is taking place."
  warn "Turn off this warning with -q."
  NO_M4=1
elif [[ -z ${MACRO_DIR} && ${QUIET} -eq 0 ]]; then
  warn "m4 macro include directory is not set."
  warn "Skeleton directories and files are still created,"
  warn "but no macro expansion is taking place."
  warn "Turn off this warning with -q."
  NO_M4=1
elif [[ ! -d ${MACRO_DIR} && ${QUIET} -eq 0 ]]; then
  warn "m4 macro include directory does not exist."
  warn "Skeleton directories and files are still created,"
  warn "but no macro expansion is taking place."
  warn "Turn off this warning with -q."
  NO_M4=1
fi

# TODO: create files and directories from default skeleton folder
# TODO: create files and directories from type skeleton folder if given
