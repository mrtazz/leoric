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

# function to create all files from the skeleton directory location in the
# current directory. This is using the passed in M4 command to create the
# target file
#
# Parameters:
#  $1 - m4 command to use
#  $2 - skeleton directory
#  $3 - project name to substitute filenames with
#
function install_files {
  local M4_CMD=$1
  local SKEL_DIR=$2
  local PROJECT_NAME=$3
  for the_file in $(cd ${SKEL_DIR} && find . -type f -mindepth 1)
  do
    local TARGET_NAME=$(echo ${the_file} | sed -e "s/PROJECTNAME/${PROJECT_NAME}/g")
    ${M4_CMD} ${SKEL_DIR}/${the_file} > ${TARGET_NAME}
  done
}

# main

SKELETON_DIR=""
PROJECT_NAME=$(basename ${PWD})
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
elif [[ ! -d "${SKELETON_DIR}/default" ]]; then
  warn "Skeleton default directory does not exist. No idea what to do now. Aborting."
  usage
  exit 1
fi

# check if we should do macro expansion. If there is no m4 installed or the
# macro directory isn't set or doesn't exist, we just use `cat` instead to
# only copy over files and not do any macro expansion

M4=$(which m4)
M4_COMMAND="${M4} --define=PROJECTNAME=${PROJECT_NAME} -I ${MACRO_DIR} leoric.m4 "

if [[ -z ${M4} && ${QUIET} -eq 0 ]]; then
  warn "Missing m4 executable. Please make sure m4 is in your \$PATH"
  warn "Skeleton directories and files are still created,"
  warn "but no macro expansion is taking place."
  warn "Turn off this warning with -q."
  M4_COMMAND="cat "
elif [[ -z ${MACRO_DIR} && ${QUIET} -eq 0 ]]; then
  warn "m4 macro include directory is not set."
  warn "Skeleton directories and files are still created,"
  warn "but no macro expansion is taking place."
  warn "Turn off this warning with -q."
  M4_COMMAND="cat "
elif [[ ! -d ${MACRO_DIR} && ${QUIET} -eq 0 ]]; then
  warn "m4 macro include directory does not exist."
  warn "Skeleton directories and files are still created,"
  warn "but no macro expansion is taking place."
  warn "Turn off this warning with -q."
  M4_COMMAND="cat "
fi

# create directories from default skeleton folder
install_directories "${SKELETON_DIR}/default"

# create files from default skeleton folder
install_files "${M4_COMMAND}" "${SKELETON_DIR}/default" "${PROJECT_NAME}"

if [[ ! -z ${PROJECT_TYPE} ]]; then
  # warn if the project type folder doesn't exist
  if [[ ! -d "${SKELETON_DIR}/${PROJECT_TYPE}" ]]; then
    warn "Skeleton directory '${SKELETON_DIR}/${PROJECT_TYPE}' doesn't exist."
    warn "Not doing anything."
  else
    # create directories from type skeleton folder if given
    install_directories "${SKELETON_DIR}/${PROJECT_TYPE}"
    # create files from type skeleton folder if given
    install_files "${M4_COMMAND}" "${SKELETON_DIR}/${PROJECT_TYPE}" "${PROJECT_NAME}"
  fi
fi

echo "All done. Project repo initialized."
