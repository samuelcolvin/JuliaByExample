# You might not want to run this file completely, as the Pkg-commands can take a
# long time to complete.
using Pkg

# list all available packages:
#Pkg.available()

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
