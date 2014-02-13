using Base.Test

function print_evalfile(fname)
    println("")
    println("EVALUATING ", fname, ':')
    result = evalfile(fname)
    println("_____________")
    return result
end

print_evalfile("hello_world.jl")

vol, quad1, quad2 = print_evalfile("simple_function.jl")
@test (quad1, quad2) == (3, -2)
@test vol > 113.097 && vol < 113.098