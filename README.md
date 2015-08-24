# Leoric ![](https://travis-ci.org/mrtazz/leoric.svg?branch=master)

![](http://i.imgur.com/yXshPER.png)

## Overview
Project initialization from skeleton files. This should just work on any Unix
as the only requirements are bash and m4.

## Usage

```bash
% leoric -s ~/.leoric/skeletons -I ~/.leoric/macros -t ruby -n name
```

## Installation

In order to ease installation, there are some package on
[packagecloud][packagecloud]. You can also run the `make install` task if you
prefer:

```bash
make install PREFIX=/usr/local
```

It might be a good idea to just set up an alias with default configurations:

```bash
alias leoric='leoric -s ~/.leoric/skeletons -I ~/.leoric/macros'
```

And then use it like `leoric -n name -t ruby`.

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
files. E.g. `changecom(\`@@')dnl`.

## Inspiration and related work

- [git init template directory](http://git-scm.com/docs/git-init)
- [vim skeleton files](http://vimdoc.sourceforge.net/htmldoc/autocmd.html#skeleton)
- [vim-stencil](https://github.com/mrtazz/vim-stencil)

## Why m4?

- it's available almost anywhere
- no real additional dependency
- macros should be simple anyways


[packagecloud]: https://packagecloud.io/mrtazz/leoric
