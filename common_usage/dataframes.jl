# The DataFrames.jl package provides tool for working with tabular data
using DataFrames

# A DataFrame is an in-memory database
df = DataFrame(A = [1, 2], B = [e, pi], C = ["xx", "xy"])

# The columns of a DataFrame can be indexed using numbers or names
df[1]
df[:A]

df[2]
df[:B]

df[3]
df[:C]

# The rows of a DataFrame can be indexed only by using numbers
df[1, :]
df[1:2, :]

# DataFrames can be loaded from CSV files using readtable()
iris = readtable(joinpath("common_usage", "iris.csv"))

# Check the names and element types of the columns of our new DataFrame
names(iris)
eltypes(iris)

# Subset the DataFrame to only include rows for one species
iris[iris[:Species] .== "setosa", :]

# Count the number of rows for each species
by(iris, :Species, df -> size(df, 1))

# Discretize entire columns at a time
iris[:SepalLength] = iround(iris[:SepalLength])
iris[:SepalWidth] = iround(iris[:SepalWidth])

# Tabulate data according to discretized columns to see "clusters"
tabulated = by(
    iris,
    [:Species, :SepalLength, :SepalWidth],
    df -> size(df, 1)
)
