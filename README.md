# Leoric

[![Build Status](https://travis-ci.org/mrtazz/leoric.svg?branch=master)](https://travis-ci.org/mrtazz/leoric)
[![Packagecloud](https://img.shields.io/badge/packagecloud-available-brightgreen.svg)](https://packagecloud.io/mrtazz/leoric)

![](http://i.imgur.com/yXshPER.png)

## Overview
Project initialization from skeleton files. This should just work on any Unix
as the only requirements are bash and m4.

## Usage

```bash
% leoric -s ~/.leoric/skeletons -I ~/.leoric/macros -t ruby -n name
```

Take a look at the [man page][manpage] for more detailed usage instructions.

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

## Inspiration and related work

- [git init template directory](http://git-scm.com/docs/git-init)
- [vim skeleton files](http://vimdoc.sourceforge.net/htmldoc/autocmd.html#skeleton)
- [vim-stencil](https://github.com/mrtazz/vim-stencil)

## Why m4?

- it's available almost anywhere
- no real additional dependency
- macros should be simple anyways


[packagecloud]: https://packagecloud.io/mrtazz/leoric
[manpage]: http://code.mrtazz.com/leoric/leoric.1.html
