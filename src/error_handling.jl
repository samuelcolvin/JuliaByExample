a=[]
# [try, catch](http://julia.readthedocs.org/en/latest/manual/control-flow/#the-try-catch-statement) can be used to deal with errors as with many other languages
try
    push!(a,1)
catch err
    showerror(STDOUT, err, backtrace());println()
end
println("Continuing after error")
