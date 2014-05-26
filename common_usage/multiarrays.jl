


# multidmensional arrays

# Julia has very good multidimensional array capabilities. Check out [the manual](http://julia.readthedocs.org/en/latest/manual/arrays/).

# repeat can be useful to expand a grid
# as in R's expand.grid() function:

m1 = hcat(repeat([1:2],inner=[1],outer=[3*3]),repeat([1:3],inner=[2],outer=[3]),repeat([1:3],inner=[3*2],outer=[1]))

# for simple repetitions of arrays,
# use repmat
m2 = repmat(m1,1,2) 	# replicate a9 once into dim1 and twice into dim2
m3 = repmat(m1,2,1) 	# replicate a9 twice into dim1 and once into dim2

# Julia comprehensions are another way to easily create 
# multidimensional arrays

m4 = [i+j+k for i=1:2, j=1:3, k=1:2]	# creates a 2x3x2 array of Int64
m5 = ["Hi Im # $(i+2*(j-1 + 3*(k-1)))" for i=1:2, j=1:3, k=1:2]	# expressions are very flexible
# you can force the type by of the array by just 
# placing it in front of the expression
m5 = ASCIIString["Hi Im element # $(i+2*(j-1 + 3*(k-1)))" for i=1:2, j=1:3, k=1:2]

# Array reductions
# many functions in Julia have an array method
# to be applied to specific dimensions of an array:

sum(m4,3)		# takes the sum over the third dimension
sum(m4,(1,3))	# sum over first and third dim

maximum(m4,2)	# find the max elt along dim 2
findmax(m4,3)	# find the max elt and it's index along dim 2 (available only in very recent Julia versions)

# Broadcasting
# when you combine arrays of different sizes in an operation,
# an attempt is made to "spread" or "broadcast" the smaller array
# so that the sizes match up. broadcast operators are preceded by a dot: 

m4 .+ 3		# add 3 to all elements
m4 .+ [1:2]		# adds vector [1,2] to all elements along first dim

# slices and views
m4[:,:,1]	# holds dim 3 fixed and displays the resulting view
m4[:,2,:]	# that's a 2x1x2 array. not very intuititive to look at

# get rid of dimensions with size 1:
squeeze(m4[:,2,:],2)	# that's better

# assign new values to a certain view
m4[:,:,1] = rand(1:6,2,3)
m4[:,:,1] = rand(2,3)	# ERROR. you have to assign the correct type
m4[:,:,1] = rand(1:6,3,2) # ERROR. you have to assign the right shape




