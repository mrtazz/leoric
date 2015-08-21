# Leoric

![](http://i.imgur.com/yXshPER.png)

## Overview
Project initialization from skeleton files. This should just work on any Unix
as the only requirements are bash and m4.

## Usage

```bash
% leoric.sh -s ~/.leoric/skeletons -I ~/.leoric/macros -t ruby -n name
```

## Installation

Put `leoric.sh` somewhere in your path and use it. Alternatively it might be a
good idea to just set up an alias with default configurations:

```bash
alias leoric='leoric.sh -s ~/.leoric/skeletons -I ~/.leoric/macros'
```

And then use it like `leoric -n name -t ruby`.

## Skeleton setup

The skeleton directory should include a `default` folder which will always be
used. After that if you pass a type it will try to find a folder with that
name and copy all contents from there as well, thus taking precedence over the
default files.

## Macros

Since Leoric is based on m4 macros, whatever you define in your macros files
will be substituted. The only other default substitution is that filenames
that contain the macro `PROJECTNAME` will have it replaced with the project's
name (either whatever you passed in with `-n` or the basename of the current
directory).

## Inspiration and related work

- [git init template directory](http://git-scm.com/docs/git-init)
- [vim skeleton files](http://vimdoc.sourceforge.net/htmldoc/autocmd.html#skeleton)
- [vim-stencil](https://github.com/mrtazz/vim-stencil)

## Why m4?

- it's available almost anywhere
- no real additional dependency
- macros should be simple anyways



