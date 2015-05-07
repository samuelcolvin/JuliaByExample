using Bokeh
using Dates # this is for julia < 0.4, for >=0.4 you would need Base.Dates

# here we have to set the size to get the plot to display properly below, usually you could skip this
Bokeh.width(800)
Bokeh.height(320)

start = now()
days = 720
x = map(d -> start + Dates.Day(d), 1:days)
y1 = cumsum(rand(days) - 0.5)
small_bit = (maximum(y1) - minimum(y1))*0.02
y2 = y1 + (2*rand(days) - 1) * small_bit
glyphs = [Glyph(:Line, linecolor="red"), 
          Glyph(:Circle, fillcolor="rgba(255, 77, 255, 0.4)", size=6, linecolor="transparent")]
plot(x, [y1 y2], glyphs, title="Share Price Prediction", legends=["Average", "Closing Price"])
showplot()
