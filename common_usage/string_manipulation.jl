s1 = "The quick brown fox jumps over the lazy dog α,β,γ"

# search returns the first index of a char
i = search(s1, 'b')
println(i)
#> 11
# the second argument is equivilent to the second arguemtn of split, see below

# or a range if called with another strings
r = search(s1, "brown")
show(r); println("")
#> 11:15

# string replacement is done thus:
s3 = replace(s1, "brown", "red")
println(s3)
#> "The quick red fox jumps over the lazy dog"

# a string can be repeated using the repeat function, or more succinctly with the ^ syntax:
show("hello "^3)
#> "hello hello hello "

# the strip funciton works the same as python:
# eg with one argument it strips that strings outer spaces
show(strip("hello "))
#> "hello"
# or with a second argument of an array of chars it strips any of them;
show(strip("hello ", ['h', ' ']))
#> "ello"
# (note the array is of chars not strings)

# similarly split works in basically the same way as python:
show(split("hello, there,bob", ','))
#> ["hello"," there","bob"]
show(split("hello, there,bob", ", "))
#> ["hello","there,bob"]
show(split("hello, there,bob", [',', ' '], 0, false))
#> ["hello","there","bob"]
# (the last two arguements are limit and include_empty