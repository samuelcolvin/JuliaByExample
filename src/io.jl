fname = "simple.dat"
# using [do](https://docs.julialang.org/en/v1/manual/functions/#Do-Block-Syntax-for-Function-Arguments-1) means the file is closed automatically
# in the same way "with" does in python
open(fname,"r") do f
	for line in eachline(f)
	    println(line)
	end
end
#> this is a simple file containing
#> text and numbers:
#> 43.3
#> 17

f = open(fname,"r")
show(readlines(f)); println()
#> ["this is a simple file containing", "text and numbers:", "43.3", "17"]
close(f)

f = open(fname,"r")
fstring = read(f, String)
close(f)
println(summary(fstring))
#> String
print(fstring)
#> this is a simple file containing
#> text and numbers:
#> 43.3
#> 17

outfile = "outfile.dat"
# writing to files is very similar:
f = open(outfile, "w")
# both print and println can be used as usual but with f as their first arugment
println(f, "some content")
print(f, "more content")
print(f, " more on the same line")
close(f)

# we can then check the content of the file written
# "do" above just creates an anonymous function and passes it to open
# we can use the same logic to pass readall and thereby succinctly
# open, read and close a file in one line
outfile_content = open(f->read(f, String), outfile, "r")
println(repr(outfile_content))
#> "some content\nmore content more on the same line"
