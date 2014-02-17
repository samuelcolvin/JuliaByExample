
# calcualte the volume of a sphere
function sphere_vol(r)
    # julia allows [Unicode names](http://docs.julialang.org:8000/en/latest/manual/variables/#variables) (in UTF-8 encoding)
    # so either "pi" or the symbol π can be used
    return 4/3*π*r^3
end

# calculates x for 0 = a*x^2+b*x+c
function quadratic(a, b, c)
    # unlike other languages 2a is equivilent to 2*a
    # a^2 is used instead of a**2 or pow(a,2)
    sqr_term = sqrt(b^2-4a*c)
    r1 = (-b+sqr_term)/2a
    r2 = (-b-sqr_term)/2a
    # multiple values can be returned from a function using tuples
    return r1, r2
end

vol = sphere_vol(3)
# @printf allows number formatting but does not automatically append the \n to statements, see below
@printf "volume = %0.3f\n" vol 
#> volume = 113.097

quad1, quad2 = quadratic(2, -2, -12)
println("result 1: ", quad1)
#> result 1: 3.0
println("result 2: ", quad2)
#> result 2: -2.0