# <hide>
function printsum(a)
    println(summary(a), ": ", repr(a))
end
# </hide>
for i in 1:5
    print(i, ", ")
end
#> 1, 2, 3, 4, 5,
# In loop definitions "in" is equivilent to "=" 
# (AFAIK, the two are interchangable in this context)
for i = 1:5
    print(i, ", ")
end
println() #> 1, 2, 3, 4, 5,

# arrays can also be looped over directly:
a1 = [1,2,3,4]
for i in a1
    print(i, ", ")
end
println() #> 1, 2, 3, 4,

# **continue** and **break** work in the same way as python
a2 = collect(1:20)
for i in a2
    if i % 2 != 0
        continue
    end
    print(i, ", ")
    if i >= 8
        break
    end
end
println() #> 2, 4, 6, 8,

# if the array is being manipulated during evaluation a while loop shoud be used
# [pop](https://docs.julialang.org/en/v1/base/collections/#Base.pop!-Tuple{Any,Any,Any}) removes the last element from an array
while !isempty(a1)
    print(pop!(a1), ", ")
end
println() #> 4, 3, 2, 1,

d1 = Dict(1=>"one", 2=>"two", 3=>"three")
# dicts may be looped through using the keys function:
for k in sort(collect(keys(d1)))
    print(k, ": ", d1[k], ", ")
end
println() #> 1: one, 2: two, 3: three,

# like python [enumerate](https://docs.julialang.org/en/v1/base/iterators/#Base.Iterators.enumerate) can be used to get both the index and value in a loop
a3 = ["one", "two", "three"]
for (i, v) in enumerate(a3)
    print(i, ": ", v, ", ")
end
println() #> 1: one, 2: two, 3: three,

# (note enumerate starts from 1 since Julia arrays are 1 indexed unlike python)

# [map](https://docs.julialang.org/en/v1/base/collections/#Base.map) works as you might expect performing the given function on each member of 
# an array or iter much like comprehensions
a4 = map((x) -> x^2, [1, 2, 3, 7])
print(a4) 
println() #> [1, 4, 9, 49]
