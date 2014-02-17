function print_sum(a)
    # [summary](http://julia.readthedocs.org/en/latest/stdlib/base/#Base.summary) generates a summary of an object
    print(summary(a), ": ")
    show(a)
    println()
end

# arrays can be initialised directly:
a1 = [1,2,3]
print_sum(a1)
#> 3-element Array{Int64,1}: [1,2,3]

# or initialised empty:
a2 = []
print_sum(a2) #> 0-element Array{None,1}: []

# since this array has no type, functions like push! (see below) don't work
# instead arrays can be initialised with a type:
a3 = Int64[]
print_sum(a3) #> 0-element Array{Int64,1}: []

# ranges are different from arrays:
a4 = 1:20
print_sum(a4) #> 20-element Range1{Int64}: 1:20
# however they can be used to create arrays thus:
a4 = [1:20]
print_sum(a4) #> 20-element Array{Int64,1}: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]

# arrays can be any type, so arrays of arrays can be created:
a5 = (Array{Int64, 1})[]
print_sum(a5) #> 1-element Array{Array{Int64,1},1}: []
# (note this is a "jagged array" eg. an array of arrays, not a [multidimensional array](http://julia.readthedocs.org/en/latest/manual/arrays/), these are not covered here)

# Julia provided a number of ["Dequeue"](http://docs.julialang.org/en/latest/stdlib/base/#dequeues) functions, however the most common for appending to the end of arrays is [**push!**](http://docs.julialang.org/en/latest/stdlib/base/#Base.push!)
# ! at the end of a function name indicates that the first argument is updated.

push!(a1, 4)
print_sum(a1) #> 4-element Array{Int64,1}: [1,2,3,4]

# push!(a2, 1) would cause error:
#> ERROR: [] cannot grow. Instead, initialize the array with "T[]", where T is the desired element type.

push!(a3, 1)
print_sum(a3) #> 1-element Array{Int64,1}: [1]

push!(a5, [1,2,3])
print_sum(a5) #> 1-element Array{Array{Int64,1},1}: [[1,2,3]]

