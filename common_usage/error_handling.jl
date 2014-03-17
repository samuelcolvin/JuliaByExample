a=[]
try
    push!(a,1)
catch err
    showerror(STDOUT, err, backtrace());println()
end
println("Continueing after error")