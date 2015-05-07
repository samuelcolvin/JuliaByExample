# You might not want to run this file completely, as the Pkg-commands can take a
# long time to complete.

# list all available packages:
Pkg.available()

# install one package (e.g. [Calculus](https://github.com/johnmyleswhite/Calculus.jl)) and all its dependencies:
Pkg.add("Calculus")

# to list all installed packages
Pkg.installed()

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

# Using `import` is especially useful if there are conflicts in function/type-names
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
