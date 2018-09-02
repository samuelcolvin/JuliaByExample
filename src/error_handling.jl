# [try, catch](https://docs.julialang.org/en/v1/manual/control-flow/#The-try/catch-statement-1) can be used to deal with errors as with many other languages
try
    push!(a,1)
catch err
    showerror(stdout, err, backtrace());println()
end
println("Continuing after error")
