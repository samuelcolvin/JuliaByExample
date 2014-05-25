# You might not want to run this file completly, as the Pkg-commands can take a
# long time to complete.

# list all available packages:
Pkg.available()

# install one package (e.g. [Calculus](https://github.com/johnmyleswhite/Calculus.jl)) and all it's dependencies:
Pkg.add("Calculus")

# to list all installed packages
a=Pkg.installed()

# to update all packages to their newest version
Pkg.update()

# to use a package:
using Calculus
# will import all functions of that package into the current namespace, so that
# it is possible to call
derivative(x -> sin(x), 1.0)
# without specifing the package it is included in.

import Calculus
# will enable you to specify which package the function is called from
Calculus.derivative(x -> cos(x), 1.0)

# Using `import` is especially useful if there are conflicts in function/tpye-names
# between packages.
# Example:
# Winston as well as Gadfly provide a plot() function (see below).
Pkg.add("Winston")
Pkg.add("Gadfly")

# If you were to "import" both of the packages with `using`, there would be a conflict.
# That can be prevented by using `import`, as follows:
import Winston
import Gadfly

Winston.plot(rand(4))
Gadfly.plot(x=[1:10], y=rand(10))

# To run a file in the REPL `include` should be used. This will evaluate all
# valid expressions in that file and return the last one evaluated. The following
# command may or may not produce an infinite loop, so be careful.
include("using_packages.jl")
