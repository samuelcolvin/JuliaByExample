s1 = "The quick brown fox jumps over the lazy dog α,β,γ"

# [search](http://docs.julialang.org/en/release-0.1/stdlib/base/#Base.search) returns the first index of a char
i = search(s1, 'b')
println(i)
#> 11
# the second argument is equivilent to the second argument of split, see below

# or a range if called with another strings
r = search(s1, "brown")
show(r); println("") #> 11:15

# string [replace](http://docs.julialang.org/en/release-0.1/stdlib/base/#Base.replace) is done thus:
s3 = replace(s1, "brown", "red")
println(s3)
#> "The quick red fox jumps over the lazy dog"

# a string can be repeated using the [repeat](http://julia.readthedocs.org/en/latest/manual/strings/#common-operations) function, 
# or more succinctly with the [^ syntax](http://julia.readthedocs.org/en/latest/stdlib/base/#Base.^):
r="hello "^3
show(r); println("") #> "hello hello hello "

# the [strip](http://docs.julialang.org/en/release-0.1/stdlib/base/#Base.strip) funciton works the same as python:
# eg with one argument it strips that strings outer spaces
r = strip("hello ")
show(r); println("") #> "hello"
# or with a second argument of an array of chars it strips any of them;
r = strip("hello ", ['h', ' '])
show(r); println("") #> "ello"
# (note the array is of chars not strings)

# similarly [split](http://docs.julialang.org/en/release-0.1/stdlib/base/#Base.split) works in basically the same way as python:
r = split("hello, there,bob", ',')
show(r); println("") #> ["hello"," there","bob"]
r = split("hello, there,bob", ", ")
show(r); println("") #> ["hello","there,bob"]
r = split("hello, there,bob", [',', ' '], 0, false)
show(r); println("") #> ["hello","there","bob"]
# (the last two arguements are limit and include_empty, see docs)

# the oposite of split: [join](http://docs.julialang.org/en/release-0.1/stdlib/base/#Base.join) is simply
r= join([1:10], ", ")
println(r) #> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10