using Gadfly

# plot some data
pl = plot(x -> cos(x)/x, 5, 25)
# and save it to a file
draw(PNG("gadfly.png", 300, 100), pl)