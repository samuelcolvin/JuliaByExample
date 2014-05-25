using Winston

# optionally call figure prior to plotting to set the size
figure(width=600, height=400)
# plot some data
pl = plot(cumsum(rand(500) .- 0.5), "r", cumsum(rand(500) .- 0.5), "b")
# display the plot (not done automatically!)
display(pl)

# by default display will not wait and the plot will vanish as soon as it appears
# using readline is a blunt wait to allow the user to choose when to continue
println("Press enter to continue: ")
readline(STDIN)

# save the current figure
savefig("winston.svg")
# .eps, .pdf, & .png are also supported
# we used svg here because it respects the width and height specified above

# TODO: needs more expansive explanation