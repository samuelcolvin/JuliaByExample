Set of unofficial examples of Julia the high-level, high-performance dynamic programming language for technical computing.

Below are a series of examples of common operations in Julia. They assume you already have Julia installed and working
(the examples are currently tested with **Julia v1.0.5**).

[![Build Status](https://travis-ci.org/samuelcolvin/JuliaByExample.svg?branch=master)](https://travis-ci.org/samuelcolvin/JuliaByExample)

### Hello World

The simplest possible script.

{{ code_file('hello_world.jl') }}

With Julia [installed and added to your path](https://julialang.org/downloads/)
this script can be run by `julia hello_world.jl`, it can also be run from REPL by typing
`include("hello_world.jl")`, that will evaluate all valid expressions in that file and return the last output.

### Simple Functions

The example below shows two simple functions, how to call them and print the results.
Further examples of number formatting are shown below.

{{ code_file('functions.jl') }}

### Strings Basics

Collection of different string examples (string indexing is the same as array indexing: see below).

{{ code_file('strings_basics.jl') }}

### String: Converting and formatting

{{ code_file('formatting_converting_strings.jl') }}

### String Manipulations

{{ code_file('string_manipulation.jl') }}

### Arrays

{{ code_file('arrays.jl') }}

### Error Handling

{{ code_file('error_handling.jl') }}

### Multidimensional Arrays

Julia has very good multidimensional array capabilities.
Check out [the manual](https://docs.julialang.org/en/v1/manual/arrays/).

{{ code_file('multiarrays.jl') }}

### Dictionaries

Julia uses [Dicts](https://docs.julialang.org/en/v1/base/collections/#Dictionaries-1) as
associative collections. Usage is very like python except for the rather odd `=>` definition syntax.

{{ code_file('dicts.jl') }}

### Loops and Map

[For loops](https://docs.julialang.org/en/v1/manual/control-flow/#man-loops-1)
can be defined in a number of ways.

{{ code_file('loops_map.jl') }}

### Conditional Evaluation

if/else statements work much like other languages -
the boolean opperators are `true` and `false`.

{{ code_file('booleans.jl') }}

### Types

Types are a key way of structuring data within Julia.

{{ code_file('types.jl')}}

### Input & Output

The basic syntax for reading and writing files in Julia is quite similar to python.

The `simple.dat` file used in this example is available
[from github](https://github.com/samuelcolvin/JuliaByExample/blob/master/src/simple.dat).

{{ code_file('io.jl')}}

### Packages and Including of Files

[Packages](https://pkg.julialang.org/docs/)
extend the functionality of Julia's standard library.

{{ code_file('using_packages.jl') }}

### Plotting

Plotting in Julia is only possible with additional Packages.
Examples of some of the main packages are given below.

<!--
TODO:
add comment about py plot

PyPlot needs Python and matplotlib installed [matplotlib.pyplot docs](https://matplotlib.org/api/pyplot_api.html).
-->

#### Plots

[Plots.jl Package Page](http://docs.juliaplots.org/latest/)

Installed via `Pkg.add("Plots"); Pkg.add("GR");`

{{ code_file('plots.jl') }}

{{ src_image('plots.svg') }}

### DataFrames

The [DataFrames.jl package](https://github.com/JuliaStats/DataFrames.jl) provides tool for working with tabular data.

The `iris.csv` file used in this example is available
[from github](https://github.com/samuelcolvin/JuliaByExample/blob/master/src/iris.csv).

You may also need [CSV.jl package](https://github.com/JuliaData/CSV.jl) to read data from CSV file.

{{ code_file('dataframes.jl') }}
