# [try, catch](https://docs.julialang.org/en/v1/manual/control-flow/#The-try/catch-statement-1) can be used to deal with errors as with many other languages
try
    push!(a,1)
catch err
    showerror(stdout, err, backtrace());println()
end
#> UndefVarError: a not defined
#> Stacktrace:
#>  [1] top-level scope at C:\JuliaByExample\src\error_handling.jl:5
#>  [2] include at .\boot.jl:317 [inlined]
#>  [3] include_relative(::Module, ::String) at .\loading.jl:1038
#>  [4] include(::Module, ::String) at .\sysimg.jl:29
#>  [5] exec_options(::Base.JLOptions) at .\client.jl:229
#>  [6] _start() at .\client.jl:421
println("Continuing after error")
#> Continuing after error
