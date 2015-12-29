% LEORIC(1) Leoric User Manual | Leoric User Manual
% Daniel Schauenberg <d@unwiredcouch.com>
% REPLACE_DATE

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

## Skeleton setup
The skeleton directory should include a `default` folder which will always be
used. After that if you pass a type it will try to find a folder with that
name and copy all contents from there as well, thus taking precedence over the
default files.

## Macros
Since Leoric is based on m4 macros, whatever you define in your macros files
will be substituted. The only requirement right now is that your macros are in
a file called `leoric.m4` in the include directory you provide with the `-I`
flag. The only default substitution is that filenames that contain the macro
`PROJECTNAME` will have it replaced with the project's name (either whatever
you passed in with `-n` or the basename of the current directory).

Note that the usage of m4 is entirely optional and if there is no m4
installed, leoric will warn but still continue. The only difference is that
macro expansion within files will not be done, but instead the files are just
copied. Substitution of file names will still be done as it doesn't rely on
m4.

### M4 and Markdown
Since the default mode for m4 is to just echo lines that are comments (denoted
with a `#`), this means substitution in Markdown headlines doesn't work by
default. The way to work around this is by changing the comment token in your
`leoric.m4` to something that isn't likely to appear in any of your skeleton
files. E.g. ``changecom(`@@')dnl``.

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

