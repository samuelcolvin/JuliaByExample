using Base.Test

function print_evalfile(fpath)
    path, fname = splitdir(fpath)
    println("EVALUATING ", fname, ":\n*************")
    result = evalfile(fpath)
    println("*************\n")
    return result
end

path, this_fname = splitdir(@__FILE__)
path = joinpath(path, "../src")
cd(path)

for fname in readdir(".")
    if endswith(fname, ".jl") && fname != this_fname
        print_evalfile("$path/$fname")
    end
end