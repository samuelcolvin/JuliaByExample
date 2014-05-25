# <hide>
function printsum(a)
    println(summary(a), ": ", repr(a))
end
# </hide>

fname = "simple.dat"
# try enumerate
open(fname,"r") do f
  for line in eachline(f)
        print(line)
  end
end
#> this is a simple file containing
#> text and numbers:
#> 43.3
#> 17

file_stream = open(fname,"r")
printsum(readlines(file_stream))
#> 4-element Array{Any,1}: {"this is a simple file containing\n","text and numbers:\n","43.3\n","17\n"}

file_stream = open(fname,"r")
file_string = readall(file_stream)
println(summary(file_string))
#> ASCIIString
print(file_string)
#> this is a simple file containing
#> text and numbers:
#> 43.3
#> 17