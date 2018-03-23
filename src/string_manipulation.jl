s1 = "The quick brown fox jumps over the lazy dog α,β,γ"

# [search](http://docs.julialang.org/en/latest/stdlib/base/#Base.search) returns the first index of a char
i = search(s1, 'b')
println(i)
#> 11
# the second argument is equivalent to the second argument of split, see below

# or a range if called with another string
r = search(s1, "brown")
println(r)
#> 11:15


# string [replace](http://docs.julialang.org/en/latest/stdlib/base/#Base.replace) is done thus:
r = replace(s1, "brown", "red")
show(r); println()
#> "The quick red fox jumps over the lazy dog"

# search and replace can also take a regular expressions by preceding the string with 'r'
r = search(s1, r"b[\w]*n")
println(r)
#> 11:15

# again with a regular expression
r = replace(s1, r"b[\w]*n", "red")
show(r); println()
#> "The quick red fox jumps over the lazy dog"

# there are also functions for regular expressions that return RegexMatch types
# [match](http://julia.readthedocs.org/en/latest/stdlib/base/#Base.match) scans left to right for the first match (specified starting index optional)
r = match(r"b[\w]*n", s1)
println(r)
#> RegexMatch("brown")

# RegexMatch types have a property match that holds the matched string
show(r.match); println()
#> "brown"

# [matchall](http://julia.readthedocs.org/en/latest/stdlib/base/#Base.matchall) returns a vector with RegexMatches for each match
r = matchall(r"[\w]{4,}", s1)
println(r)
#> SubString{UTF8String}["quick","brown","jumps","over","lazy"]

# [eachmatch](http://julia.readthedocs.org/en/latest/stdlib/base/#Base.eachmatch) returns an iterator over all the matches
r = eachmatch(r"[\w]{4,}", s1)
for i in r print("\"$(i.match)\" ") end
println()
#> "quick" "brown" "jumps" "over" "lazy" 

# a string can be repeated using the [repeat](http://julia.readthedocs.org/en/latest/manual/strings/#common-operations) function, 
# or more succinctly with the [^ syntax](http://julia.readthedocs.org/en/latest/stdlib/base/#Base.^):
r = "hello "^3
show(r); println() #> "hello hello hello "

# the [strip](http://docs.julialang.org/en/latest/stdlib/base/#Base.strip) function works the same as python:
# e.g., with one argument it strips the outer whitespace
r = strip("hello ")
show(r); println() #> "hello"
# or with a second argument of an array of chars it strips any of them;
r = strip("hello ", ['h', ' '])
show(r); println() #> "ello"
# (note the array is of chars and not strings)

# similarly [split](http://docs.julialang.org/en/latest/stdlib/base/#Base.split) works in basically the same way as python:
r = split("hello, there,bob", ',')
show(r); println() #> ["hello"," there","bob"]
r = split("hello, there,bob", ", ")
show(r); println() #> ["hello","there,bob"]
r = split("hello, there,bob", [',', ' '], limit=0, keep=false)
show(r); println() #> ["hello","there","bob"]
# (the last two arguements are limit and include_empty, see docs)

# the opposite of split: [join](http://docs.julialang.org/en/latest/stdlib/base/#Base.join) is simply
r = join(collect(1:10), ", ")
println(r) #> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
