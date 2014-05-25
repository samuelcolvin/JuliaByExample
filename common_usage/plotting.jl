# PyPlot: needs Python and matplotlib installed
# (matplotlib.pyplot docs)[http://matplotlib.org/api/pyplot_api.html]

import PyPlot
# plot 5 random numbers in [0,1], PyPlot.plot creates a new figure
PyPlot.plot(rand(5))
# labeling the axes, creating a title:
PyPlot.xlabel("x-axis")
PyPlot.ylabel("y-axis")
PyPlot.title("Random")
# creating the legend:
l = ["random data"]
# legend takes an array of strings, but since strings can be indexed to get
# chars (e.g. l[1] == 'r') the brackets are necessary
PyPlot.legend(l)

# create a new figure:
f = PyPlot.figure(2)
# generating data:
y1 = randn(10)
y2 = randn(10)
x = 1:10 # PyPlot can handle ranges as well as arrays
# setup a grid for plotting:
PyPlot.subplot2grid((3, 1), (0, 0), rowspan=2)
# options for plotting are passed as keyword-arguments:
PyPlot.plot(x, y1, c="red", marker=".", linestyle="None")
# a second plot will plot in an existing figure/subplot
PyPlot.plot(x, y2)
# add text to the plot:
PyPlot.text(x[4]+.1, y1[4], "value #4", verticalalignment="center")
# PyPlot will adjust the axes automatically, but xlim and ylim can explicitly
# change the smallest and largest value displayed on either axis
PyPlot.xlim([0, 11])
PyPlot.legend(["dots", "line"], loc="upper left")

# change into the other subplot:
PyPlot.subplot2grid((3, 1), (2, 0), rowspan=2)
# plot some more data into the lower subplot
PyPlot.plot(x, y1-y2)
PyPlot.xlim([0, 11])
PyPlot.ylim([-3, 3])
# change the ticks used on the y-axis
PyPlot.yticks([-3, 0, 3])
# save the current figure
PyPlot.savefig("pyplot.pdf")


# Winston: Matlab-like plotting
# all dependencies are installed automatically by Pkg.add("Winston")

import Winston

# plot some data
pl = Winston.plot(randn(5))
# display the plot (not done automatically!)
display(pl)
# save the current figure
Winston.savefig("winston.pdf")


# Gadfly: ggplot2-like plotting
# all dependencies are installed automatically by Pkg.add("Gadfly")

import Gadfly

# plot some data
pl = Gadfly.plot(x=[1:10], y=rand(10))
# and save it to a file
Gadfly.draw(Gadfly.PDF("gadfly.pdf", 300, 100), pl)
