for i in 1:5
    print(i, ", ")
end
#> 1, 2, 3, 4, 5, 
# In loop definitions "in" is equivilent to "=" (as far as I know, the two are interchangable in this context)
for i = 1:5
    print(i, ", ")
end
println()
#> 1, 2, 3, 4, 5, 

# arrays can also be looped over directly:
a1 = [1,2,3,4]
for i in a1
    print(i, ", ")
end
println()
#> 1, 2, 3, 4, 

# **continue** and **break** work in the same way as python
a4 = [1:20]
for i in a4
    if i % 2 != 0
        continue
    end
    print(i, ", ")
    if i >= 8
        break
    end
end
println()
#> 2, 4, 6, 8, 

# if the arry is being manipulated during evaluation a while loop shoud be used
# [pop](http://docs.julialang.org/en/latest/stdlib/base/#Base.pop!) removes the last element from an array
while !isempty(a1)
    print(pop!(a1), ", ")
end
println()
#> 4, 3, 2, 1,