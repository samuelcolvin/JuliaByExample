Julia By Example
================

[![Build Status](https://travis-ci.org/samuelcolvin/JuliaByExample.svg?branch=master)](https://travis-ci.org/samuelcolvin/JuliaByExample)

*&copy; Samuel Colvin 2014, 2015, 2018*

Hosted at [samuelcolvin.github.io/JuliaByExample](http://samuelcolvin.github.io/JuliaByExample/).

Unofficial collection of Julia (Julia Lang) examples.

[Julia](http://www.julialang.org) is a high-level, high-performance dynamic programming language for technical computing.

Because Julia is young there are reletively limited resources to help you get started with it. This site contains a
series of simple examples of Julia performing common tasks like printing to stdout, reading from stdin, reading files,
declaring functions, plotting etc. etc.

I am not an expert in Julia and this is a work in progress: there are almost certainly mistakes and obvious omissions
from the examples. If you spot a problem create an issue, if you have a fix for a problem or want to add to the
examples please submit a pull request.

To build (first setup your `env` with `deps/requirements.txt`):

    python deps/build.py

To deploy:

    aws s3 sync --delete www/ s3://juliabyexample.helpmanual.io/
