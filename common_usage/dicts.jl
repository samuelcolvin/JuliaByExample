function print_sum(a)
    # summary generates a summary of an object
    print(summary(a), ": ")
    show(a)
    println()
end

# dicts can be initialised directly:
a1 = {1=>"one", 2=>"two"}
print_sum(a1)
#> Dict{Any,Any}: {2=>"two",1=>"one"}

# then added to:
a1[3]="three"
print_sum(a1)
#> Dict{Any,Any}: {2=>"two",3=>"three",1=>"one"}
# (note dicts cannot be assumed to keep their original order)

# dicts may also be created with the type explicitly set
a2 = Dict{Int64, String}()
a2[0]="zero"

# loops may be achived using the keys argument:
for k in keys(a1)
    print(k, ": ", a1[k], ", ")
end
println()
#> 2: two, 3: three, 1: one, 

haskey(a1,1)
#> true