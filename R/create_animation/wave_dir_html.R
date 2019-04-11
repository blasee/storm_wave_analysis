# This script is used to create an HTML animation, and store it in
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

if (!require(tidyr))
  install.packages("tidyr")

# Source necessary files --------------------------------------------------

# Source the post-process.R file, if necessary
if (!exists("wave_dp") | !exists("wave_cge_nsw"))
  source("R/post_process.R")


# Create necessary directories --------------------------------------------

# Create an animation directory, if necessary
if (!dir.exists("Animation"))
  dir.create("Animation")

# Prepare the data --------------------------------------------------------

nsw_waves = getValues(wave_dp) %>% 
  as_tibble() %>% 
  gather("date", "peak_dir") %>% 
  bind_cols(getValues(wave_cge_nsw) %>% 
              as_tibble() %>% 
              gather("date", "flux") %>% 
              select(flux)) %>% 
  mutate(date = rep(wave_dates, each = ncell(wave_dp))) %>% 
  filter(!is.na(peak_dir) & !is.na(flux))

setwd("Animation/")

saveHTML({
  for (i in seq_along(unique(nsw_waves$date))) {
    
    data_subset = subset(nsw_waves, date == unique(nsw_waves$date)[i])
    
    print(windrose(data_subset$flux,
                   data_subset$peak_dir,
                   n_directions = 60,
                   speed_cuts = c(2, 6, 10, 100, 200, 300, Inf),
                   legend_title = "Wave energy\nflux (kW/m)",
                   ggtheme = "minimal",
                   text = element_text(size = 16)
    ) +
      labs(title = format(unique(data_subset$date), "%A %d %B, %H%M %Z")))
  }},
  htmlfile = "nsw_wave_directions.html",
  title = "NSW wave directions",
  verbose = FALSE,
  interval = .2,
  autobrowse = FALSE,
  img.name = "wave_direction")

setwd("../")