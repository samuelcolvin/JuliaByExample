# strings are defined with double quotes
# like variables, strings can contain any unicode character
s1 = "The quick brown fox jumps over the lazy dog α,β,γ"
println(s1)

# println adds a new line to the end of output
# print can be used if you dont want that:
print("this")
print(" and")
print(" that.\n")
#> this and that.

# chars are defined with single quotes
c1 = 'a'
println(c1)
#> a
# the ascii value of a char can be found with int():
println(c1, " ascii value = ", int(c1))
#> a ascii value = 97
println("int('α') == ", int('α'))
#> int('α') == 945

# so be aware that
println(int('1') == 1)
#> false

# strings can be convered to upper case or lower case:
s1_caps = uppercase(s1)
s1_lower = lowercase(s1)
println(s1_caps, "\n", s1_lower)

# sub strings can be indexed like arrays:
# (show is prints the raw value)
show(s1[11]); println("")
#> 'b'

# or sub strings created:
show(s1[1:10]); println("")
#> "The quick "

# end is used for the end of the array or string
show(s1[end-10:end]); println("")
#> "dog α,β,γ"

# julia allows string Interpolation:
a = "wolcome"
b = "julia"
println("$a to $b.")
#> welcome to julia.

# this can extend to evaluate statements:
println("1 + 2 = $(1 + 2)")
#> 1 + 2 = 3

# strings can also be concatinated using the string function
s2 = string("this", " and", " that")
println(s2)
#> this and that

# search returns the first index of a char
i = search(s1, 'b')
println(i)
#> 11

# or a range if called with another strings
r = search(s1, "brown")
show(r); println("")
#> 11:15

# string replace is done thus:
s3 = replace(s1, "brown", "red")
println(s3)
#> "The quick red fox jumps over the lazy dog"

# strings can be converted to floats or ints:
e_str1 = "2.718"
e = float(e_str1)
println(5e)
#> 13.5914
num_15 = int("15")
println(3num_15)
#> 45

# numbers can be converted to strings using printf 
@printf "e = %0.2f\n" e
#> 2.718
# or to create another string sprintf
e_str2 = @sprintf("%0.3f", e)

# to show the 2 strings are the same
println("e_str1 == e_str2: $(e_str1 == e_str2)")

# repeat and strip and split