using Gadfly

# plot some data
pl = @plot(cos(x)/x, 5, 25)
# and save it to a file
draw(PNG("gadfly.png", 300, 100), pl)

# TODO: needs more expansive explanation