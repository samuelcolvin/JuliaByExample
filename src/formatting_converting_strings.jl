# strings can be converted using [float](http://julia.readthedocs.org/en/latest/stdlib/base/#Base.float) and [int](http://julia.readthedocs.org/en/latest/stdlib/base/#Base.int):
e_str1 = "2.718"
e = float(e_str1)
println(5e)
#> 13.5914
num_15 = parse(Int, "15")
println(3num_15)
#> 45

# numbers can be converted to strings and formatted using [printf](http://julia.readthedocs.org/en/latest/stdlib/base/#Base.@printf)
@printf "e = %0.2f\n" e
#> 2.718
# or to create another string [sprintf](http://julia.readthedocs.org/en/latest/stdlib/base/#Base.@sprintf)
e_str2 = @sprintf("%0.3f", e)

# to show that the 2 strings are the same
println("e_str1 == e_str2: $(e_str1 == e_str2)")
#> e_str1 == e_str2: true

# available number format characters are [f, e, g, c, s, p, d](https://github.com/JuliaLang/julia/blob/master/base/printf.jl#L15):
# (pi is a predefined constant; however, since its type is 
# "MathConst" it has to be converted to a float to be formatted)
@printf "fix trailing precision: %0.3f\n" float(pi)
#> fix trailing precision: 3.142
@printf "scientific form: %0.6e\n" 1000pi
#> scientific form: 3.141593e+03
# g is not implemented yet
@printf "a character: %c\n" 'α'
#> a character: α
@printf "a string: %s\n" "look I'm a string!"
#> a string: look I'm a string!
@printf "right justify a string: %50s\n" "width 50, text right justified!"
#> right justify a string:                    width 50, text right justified!
@printf "a pointer: %p\n" 100000000
#> a pointer: 0x0000000005f5e100
@printf "print a integer: %d\n" 1e10
#> print an integer: 10000000000
