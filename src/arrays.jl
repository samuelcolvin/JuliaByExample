function printsum(a)
    # [summary](http://julia.readthedocs.org/en/latest/stdlib/base/#Base.summary) generates a summary of an object
    println(summary(a), ": ", repr(a))
end

# arrays can be initialised directly:
a1 = [1,2,3]
printsum(a1)
#> 3-element Array{Int64,1}: [1,2,3]

# or initialised empty:
a2 = []
printsum(a2)
#> 0-element Array{None,1}: None[]

# since this array has no type, functions like push! (see below) don't work
# instead arrays can be initialised with a type:
a3 = Int64[]
printsum(a3)
#> 0-element Array{Int64,1}: []

# ranges are different from arrays:
a4 = 1:20
printsum(a4)
#> 20-element UnitRange{Int64}: 1:20

# however they can be used to create arrays thus:
a4 = collect(1:20)
printsum(a4)
#> 20-element Array{Int64,1}: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]

# arrays can also be generated from [comprehensions](http://julia.readthedocs.org/en/latest/manual/arrays/#comprehensions):
a5 = [2^i for i = 1:10]
printsum(a5)
#> 10-element Array{Int64,1}: [2,4,8,16,32,64,128,256,512,1024]

# arrays can be any type, so arrays of arrays can be created:
a6 = (Array{Int64, 1})[]
printsum(a6)
#> 0-element Array{Array{Int64,1},1}: []
# (note this is a "jagged array" (i.e., an array of arrays), not a [multidimensional array](http://julia.readthedocs.org/en/latest/manual/arrays/),
# these are not covered here)

# Julia provided a number of ["Dequeue"](http://docs.julialang.org/en/latest/stdlib/base/#dequeues) functions, the most common for appending to the end of arrays
# is [**push!**](http://docs.julialang.org/en/latest/stdlib/base/#Base.push!)
# ! at the end of a function name indicates that the first argument is updated.

push!(a1, 4)
printsum(a1)
#> 4-element Array{Int64,1}: [1,2,3,4]

# push!(a2, 1) would cause error:

push!(a3, 1)
printsum(a3) #> 1-element Array{Int64,1}: [1]
#> 1-element Array{Int64,1}: [1]

push!(a6, [1,2,3])
printsum(a6)
#> 1-element Array{Array{Int64,1},1}: [[1,2,3]]

# using repeat() to create arrays
# you must use the keywords "inner" and "outer"
# all arguments must be arrays (not ranges)
a7 = repeat(a1,inner=[2],outer=[1])
printsum(a7)
#> 8-element Array{Int64,1}: [1,1,2,2,3,3,4,4]
a8 = repeat(collect(4:-1:1),inner=[1],outer=[2])
printsum(a8)
#> 8-element Array{Int64,1}: [4,3,2,1,4,3,2,1]
