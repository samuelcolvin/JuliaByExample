using Base.Test
using PyCall
@pyimport os

println("finished loading PyCall")

function print_evalfile(fpath)
    path, fname = splitdir(fpath)
    println("EVALUATING ", fname, ":\n*************")
    result = evalfile(fpath)
    println("*************\n")
    return result
end

path, this_fname = splitdir(@__FILE__)

for fname in os.listdir(path)
    if endswith(fname, ".jl") && fname != this_fname
        print_evalfile("$path/$fname")
    end
end