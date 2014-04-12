# <hide>
function print_sum(a)
    print(summary(a), ": ")
    show(a)
    println()
end
# </hide>

type State
    second::Int64
    price::Float64
end

state = State(10, 100.0)
print_sum(state)
#> State: State(10,100.0)

history = State[]
push!(history, State(20, 110.0))
push!(history, State(30, 120.0))
print_sum(history)
#> 2-element Array{State,1}: [State(20,110.0),State(30,120.0)]

# TODO: describle type hierachy