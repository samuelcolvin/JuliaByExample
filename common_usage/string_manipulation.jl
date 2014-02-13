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

# repeat and strip and split