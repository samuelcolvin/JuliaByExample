# <hide>
function printsum(a)
    println(summary(a), ": ", repr(a))
end
# </hide>

# Type Definition's are probably most similar to tyepdefs in c?
# a simple type with no special constructor functions might look like this
type Person
	name::String
	male::Bool
	age::Float64
	children::Int
end

p = Person("Julia", false, 4, 0)
printsum(p)
#> Person: Person("Julia",false,4.0,0)

people = Person[]
push!(people, Person("Steve", true, 42, 0))
push!(people, Person("Jade", false, 17, 3))
printsum(people)
#> 2-element Array{Person,1}: [Person("Steve",true,42.0,0),Person("Jade",false,17.0,3)]

# types may also contains arrays and dicts
# constructor functinos can be defined to easy creating objects
# note: in the array definition the 
type Family
	name::String
	members::Array{String, 1}
	extended::Bool
	# constructor that takes one argument and generates a default
	# for the other two values
	Family(name::String) = new(name, String[], false)
	# constructor that takes two arguements and infers the thir
	Family(name::String, members::Array{String, 1}) = new(name, members, length(members) > 5)
end

# TODO: describle type hierachy
