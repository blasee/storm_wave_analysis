# This script is used to create a GIF animation, and store it in
# the Animation/ directory. This will create an animation/ directory if it does
# not already exist.

# Load / Install required packages ----------------------------------------
# These packages will be installed automatically if they are not already 
# installed.

if (!require(animation))
  install.packages("animation")
library(animation)

if (!require(clifro))
  install.packages("clifro")
library(clifro)

if (!require(maptools))
  install.packages("maptools")

# Source necessary files --------------------------------------------------

# Source the post-process.R file, if necessary
if (!exists("wave_dp") | !exists("wave_cge_nsw"))
  source("R/post_process.R")

# Create necessary directories --------------------------------------------

# Create an animation directory, if necessary
if (!dir.exists("Animation"))
  dir.create("Animation")

# Prepare the data --------------------------------------------------------

aus_map = map("world", "Australia", plot = FALSE)
IDs = sapply(strsplit(aus_map$names, ":"), function(x) x[1])

setwd("Animation/")

saveGIF({
  for (i in seq_along(unique(nsw_waves$date))) {
    
    plot(subset(wave_cge, i))
    plot(map2SpatialPolygons(aus_map, IDs = IDs), add = TRUE, col = "lightgrey",
         border = "darkgrey")
    title(main = format(unique(nsw_waves$date)[i], "%A %d %B, %H%M %Z"))
    mtext("Wave energy flux (kW/m)", line = .2)
  }},
  ,
  movie.name = "entire_region_energy.gif",
  title = "Entire region wave energy flux",
  interval = .1,
  autobrowse = FALSE)

setwd("../")