using DataFrames
showln(x) = (show(x); println())
# TODO: needs more links to docs.

# A DataFrame is an in-memory database
df = DataFrame(A = [1, 2], B = [e, pi], C = ["xx", "xy"])
showln(df)
#> 2x3 DataFrame
#> |-------|---|---------|------|
#> | Row # | A | B       | C    |
#> | 1     | 1 | 2.71828 | "xx" |
#> | 2     | 2 | 3.14159 | "xy" |

# The columns of a DataFrame can be indexed using numbers or names
showln(df[1])
#> [1,2]
showln(df[:A])
#> [1,2]

showln(df[2])
#> [2.718281828459045,3.141592653589793]
showln(df[:B])
#> [2.718281828459045,3.141592653589793]

showln(df[3])
#> String["xx","xy"]
showln(df[:C])
#> String["xx","xy"]

# The rows of a DataFrame can be indexed only by using numbers
showln(df[1, :])
#> 1x3 DataFrame
#> |-------|---|---------|------|
#> | Row # | A | B       | C    |
#> | 1     | 1 | 2.71828 | "xx" |
showln(df[1:2, :])
#> 2x3 DataFrame
#> |-------|---|---------|------|
#> | Row # | A | B       | C    |
#> | 1     | 1 | 2.71828 | "xx" |
#> | 2     | 2 | 3.14159 | "xy" |

# importing data into DataFrames
# ------------------------------

# DataFrames can be loaded from CSV files using readtable()
iris = readtable("iris.csv")

# the iris dataset (and plenty of others) is also available from
using RData, RDatasets
iris = dataset("datasets","iris")

# you can directly import your own R .rda dataframe with
# mydf = DataFrame(read_rda("path/to/your/df.rda")["name_of_df"]), e.g.
diamonds = DataFrame(load(joinpath(Pkg.dir("RDatasets"),"data","ggplot2","diamonds.rda"))["diamonds"])

# showing DataFrames
# ------------------

# Check the names and element types of the columns of our new DataFrame
showln(names(iris))
#> [:SepalLength,:SepalWidth,:PetalLength,:PetalWidth,:Species]
showln(eltypes(iris))
#> Type[Float64,Float64,Float64,Float64,UTF8String]

# Subset the DataFrame to only include rows for one species
showln(iris[iris[:Species] .== "setosa", :])
#> 50x5 DataFrame
#> |-------|-------------|------------|-------------|------------|----------|
#> | Row # | SepalLength | SepalWidth | PetalLength | PetalWidth | Species  |
#> | 1     | 5.1         | 3.5        | 1.4         | 0.2        | "setosa" |
#> | 2     | 4.9         | 3.0        | 1.4         | 0.2        | "setosa" |
#> | 3     | 4.7         | 3.2        | 1.3         | 0.2        | "setosa" |
#> | 4     | 4.6         | 3.1        | 1.5         | 0.2        | "setosa" |
#> | 5     | 5.0         | 3.6        | 1.4         | 0.2        | "setosa" |
#> | 6     | 5.4         | 3.9        | 1.7         | 0.4        | "setosa" |
#> | 7     | 4.6         | 3.4        | 1.4         | 0.3        | "setosa" |
#> | 8     | 5.0         | 3.4        | 1.5         | 0.2        | "setosa" |
#> | 9     | 4.4         | 2.9        | 1.4         | 0.2        | "setosa" |
#> ⋮
#> | 41    | 5.0         | 3.5        | 1.3         | 0.3        | "setosa" |
#> | 42    | 4.5         | 2.3        | 1.3         | 0.3        | "setosa" |
#> | 43    | 4.4         | 3.2        | 1.3         | 0.2        | "setosa" |
#> | 44    | 5.0         | 3.5        | 1.6         | 0.6        | "setosa" |
#> | 45    | 5.1         | 3.8        | 1.9         | 0.4        | "setosa" |
#> | 46    | 4.8         | 3.0        | 1.4         | 0.3        | "setosa" |
#> | 47    | 5.1         | 3.8        | 1.6         | 0.2        | "setosa" |
#> | 48    | 4.6         | 3.2        | 1.4         | 0.2        | "setosa" |
#> | 49    | 5.3         | 3.7        | 1.5         | 0.2        | "setosa" |
#> | 50    | 5.0         | 3.3        | 1.4         | 0.2        | "setosa" |

# Count the number of rows for each species
showln(by(iris, :Species, df -> size(df, 1)))
#> 3x2 DataFrame
#> |-------|--------------|----|
#> | Row # | Species      | x1 |
#> | 1     | "setosa"     | 50 |
#> | 2     | "versicolor" | 50 |
#> | 3     | "virginica"  | 50 |

# Discretize entire columns at a time
iris[:SepalLength] = round.(Integer, iris[:SepalLength])
iris[:SepalWidth] = round.(Integer, iris[:SepalWidth])


# Tabulate data according to discretized columns to see "clusters"
tabulated = by(
    iris,
    [:Species, :SepalLength, :SepalWidth],
    df -> size(df, 1)
)
showln(tabulated)
#> 17x4 DataFrame
#> |-------|--------------|-------------|------------|----|
#> | Row # | Species      | SepalLength | SepalWidth | x1 |
#> | 1     | "setosa"     | 4           | 3          | 4  |
#> | 2     | "setosa"     | 5           | 2          | 1  |
#> | 3     | "setosa"     | 5           | 3          | 23 |
#> | 4     | "setosa"     | 5           | 4          | 17 |
#> | 5     | "setosa"     | 6           | 4          | 5  |
#> | 6     | "versicolor" | 5           | 2          | 3  |
#> | 7     | "versicolor" | 5           | 3          | 3  |
#> | 8     | "versicolor" | 6           | 2          | 6  |
#> | 9     | "versicolor" | 6           | 3          | 29 |
#> | 10    | "versicolor" | 7           | 3          | 9  |
#> | 11    | "virginica"  | 5           | 3          | 1  |
#> | 12    | "virginica"  | 6           | 2          | 1  |
#> | 13    | "virginica"  | 6           | 3          | 22 |
#> | 14    | "virginica"  | 7           | 3          | 19 |
#> | 15    | "virginica"  | 7           | 4          | 1  |
#> | 16    | "virginica"  | 8           | 3          | 4  |
#> | 17    | "virginica"  | 8           | 4          | 2  |

# you can setup a grouped dataframe like this
gdf = groupby(iris,[:Species, :SepalLength, :SepalWidth])

# and then iterate over it
for idf in gdf
	println(size(idf,1))
end

# Adding/Removing columns
# -----------------------

# insert!(df::DataFrame,index::Int64,item::AbstractArray{T,1},name::Symbol)
# insert random numbers at col 5:
insert!(iris, 5, rand(nrow(iris)), :randCol)

# remove it
delete!(iris, :randCol)
