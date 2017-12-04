# <hide>
function printsum(a)
    println(summary(a), ": ", repr(a))
end
# </hide>

# dicts can be initialised directly:
a1 = Dict(1=>"one", 2=>"two")
printsum(a1) #> Dict{Int64,String}: {2=>"two",1=>"one"}

# then added to:
a1[3]="three"
printsum(a1) #> Dict{Int64,String}: {2=>"two",3=>"three",1=>"one"}
# (note dicts cannot be assumed to keep their original order)

# dicts may also be created with the type explicitly set
a2 = Dict{Int64, AbstractString}()
a2[0]="zero"
printsum(a2)
#> Dict{Int64,AbstractString} with 1 entry: Dict{Int64,AbstractString}(Pair{Int64,AbstractString}(0,"zero"))

# dicts, like arrays, may also be created from [comprehensions](http://julia.readthedocs.org/en/latest/manual/arrays/#comprehensions)
a3 = Dict([i => @sprintf("%d", i) for i = 1:10])
printsum(a3)
#> Dict{Any,Any}: {5=>"5",4=>"4",6=>"6",7=>"7",2=>"2",10=>"10",9=>"9",8=>"8",3=>"3",1=>"1"}

# as you would expect, Julia comes with all the normal helper functions
# for dicts, e.g., [haskey](http://docs.julialang.org/en/latest/stdlib/base/#Base.haskey)
println(haskey(a1,1)) #> true

# which is equivalent to
println(1 in keys(a1)) #> true
# where [keys](http://docs.julialang.org/en/latest/stdlib/base/#Base.keys) creates an iterator over the keys of the dictionary

# similar to keys, [values](http://docs.julialang.org/en/latest/stdlib/base/#Base.values) get iterators over the dict's values:
printsum(values(a1)) 
#> Base.ValueIterator for a Dict{Int64,String} with 3 entries: String["two","three","one"]

# use [collect](http://docs.julialang.org/en/latest/stdlib/base/#Base.collect) to get an array:
printsum(collect(values(a1)))
#> 3-element Array{String,1}: String["two","three","one"]
