if true
    println("It's true!")
else
    println("It's false!")
end
#> It's true!

if false
   println("It's true!")
else
   println("It's false!")
end
#> It's false!

# Numbers can be compared with opperators like <, >, ==, !=

1 == 1.
#> true

1 > 2
#> false

"foo" != "bar"
#> true

# and many functions return boolean values

occursin("that", "this and that")
#> true

# More complex logical statments can be achieved with `elseif`

function checktype(x)
   if x isa Int
      println("Look! An Int!")
   elseif x isa AbstractFloat
      println("Look! A Float!")
   elseif x isa Complex
      println("Whoa, that's complex!")
   else
      println("I have no idea what that is")
   end
end

checktype(2)
#> Look! An Int!

checktype(√2)
#> Look! A Float!

checktype(√Complex(-2))
#> Whoa, that's complex!

checktype("who am I?")
#> I have no idea what that is

# For simple logical statements, one can be more terse using the "ternary operator",
# which takes the form `predicate ? do_if_true : do_if_false`

1 > 2 ? println("that's true!") : println("that's false!")
#> that's false!

noisy_sqrt(x) = x ≥ 0 ? sqrt(x) : "That's negative!"
noisy_sqrt(4)
#> 2.0
noisy_sqrt(-4)
#> That's negative!

# "Short-circuit evaluation" offers another option for conditional statements.
# The opperators `&&` for AND and `||` for OR only evaluate the right-hand
# statement if necessary based on the predicate.
# Logically, if I want to know if `42 == 0 AND x < y`,
# it doesn't matter what `x` and `y` are, since the first statement is false.
# This can be exploited to only evaluate a statement if something is true -
# the second statement doesn't even have to be boolean!

everything = 42
everything < 100 && println("that's true!")
#> "that's true!"
everything == 0 && println("that's true!")
#> false

√everything > 0 || println("that's false!")
#> true
√everything == everything || println("that's false!")
#> that's false!
