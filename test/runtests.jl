using Base.Test

# have to prevent Bokeh trying to open a browser window as it hands on travis
using Bokeh
Bokeh.noshow(true)

function print_evalfile(fdir, fname)
    println("EVALUATING ", fname, ":\n*************")
    result = evalfile(joinpath(fdir, fname))
    println("*************\n")
    return result
end

fdir, this_fname = splitdir(@__FILE__)
fdir = joinpath(fdir, "../src")
cd(fdir)

for fname in readdir(".")
    if endswith(fname, ".jl") && fname != this_fname
        print_evalfile(fdir, fname)
    end
end