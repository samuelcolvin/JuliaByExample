#### quine.jl

This script prints a string identical to it's own source code, see [here](http://rosettacode.org/wiki/Quine).

[github.com/karbarcca/Rosetta-Julia/blob/master/src/Quine.jl](https://github.com/karbarcca/Rosetta-Julia/blob/master/src/Quine.jl): In Julia, `$x` in a string literal interpolates the value of the variable into the string. `$(expression)` evaluates the expression and interpolates the result into the string. Normally, the string value `"hi\tworld"` would be inserted without quotation marks and with a literal tab

The `repr` function returns a string value that contains quotation marks and in which the literal tab is replaced by the characters `\t`. When the result of the `repr` function is interpolated, the result is what you would type into your code to create that string literal.

#### quine.jl

{{ code_file('quine.jl') }} 

#### bubblesort.jl

{{ code_file('bubblesort.jl') }} 

#### enum.jl

Some description [here](https://groups.google.com/forum/#!msg/julia-users/f-nKrMh09K4/Ko8EeOEpCEkJ).

{{ code_file('enum.jl') }} 

#### modint.jl

{{ code_file('modint.jl') }} 

#### queens.jl

Example of the [8 Queens Puzzle](http://en.wikipedia.org/wiki/Eight_queens_puzzle).

{{ code_file('queens.jl') }} 

#### preduce.jl

{{ code_file('preduce.jl') }} 

#### time.jl

{{ code_file('time.jl') }} 

#### ndgrid.jl

{{ code_file('ndgrid.jl') }} 

#### lru_test.jl

{{ code_file('lru_test.jl') }} 

#### staged.jl

{{ code_file('staged.jl') }} 

#### plife.jl

{{ code_file('plife.jl') }} 

#### quaternion.jl

{{ code_file('quaternion.jl') }} 

#### wordcount.jl

{{ code_file('wordcount.jl') }} 

#### lru.jl

{{ code_file('lru.jl') }} 

#### typetree.jl

{{ code_file('typetree.jl') }} 

#### hpl.jl

{{ code_file('hpl.jl') }} 
