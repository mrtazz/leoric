---
title: LEORIC(1) Leoric User Manual | Leoric User Manual
author: Daniel Schauenberg <d@unwiredcouch.com>
date: REPLACE_DATE
---

# NAME
leoric - initialize code repositories from skeleton folders

# SYNOPSIS

leoric [-hqV] [-s skeleton directory] [-I macro includes]
       [-n project name] [-t project type]

# DESCRIPTION
leoric is a shell script to initialize code repositories from a set of
skeleton files. This means you can set the default layout of your projects
by type once and reuse it for each new project you start. This is most
helpful for things you share between most of your projects like README
scaffolds, LICENSE files, or contributing guidelines.

# OPTIONS
**-h**
:   show this help

**-q**
:   don't show warnings

**-s** *DIRECTORY*
:   skeleton directory to choose from

**-I** *DIRECTORY*
:   m4 macro definitions to use

**-t** *TYPE*
:   type of repository to initialize

**-n** *NAME*
:   name of the project (defaults to current directory name)

**-V**
:   print version and exit

# EXAMPLE
In order to initialize a repository from skeleton files stored in
~/.leoric/skeleton, run this command:

`% leoric -s ~/.leoric/skeletons -I ~/.leoric/macros -t ruby -n name`

# REPORTING BUGS
Bugs and issues can be reported on GitHub:

https://github.com/mrtazz/leoric/issues

# SEE ALSO
git-init(1), http://vimdoc.sourceforge.net/htmldoc/autocmd.html#skeleton

