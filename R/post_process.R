# This script is used to read in the Data/storm_wave_jun_2016.nc4 file into R
# and to create raster objects for manipulating and plotting.

# Load / Install required packages ----------------------------------------
# These packages will be installed automatically if they are not already 
# installed.

if (!require(magrittr))
  install.packages("magrittr")
library(magrittr)

if (!require(ncdf4))
  install.packages("ncdf4")
library(ncdf4)

if (!require(raster))
  install.packages("raster")
library(raster)

if (!require(dplyr))
  install.packages("dplyr")
library(dplyr)

# Source necessary files --------------------------------------------------

# Source the 'julian_to_cal' function, to easily convert from Julian days to
# calendar datetimes. See R/julian_to_cal.R for more information.
source("R/julian_to_cal.R")

# Download the data, if it does not already exist.
if (!file.exists("Data/storm_wave_jun_2016.nc4"))
  source("R/wave_data_download.R")

# Check if the wave_nc object exists in the session environment.
if (!exists("wave_nc"))
  stop('Load in the data first before processing:\n', 
       'wave_nc = ncdf4::nc_open("Data/storm_wave_jun_2016.nc4").\n\n',
       "Don't forget to nc_close(wave_nc) when finished.")


# Process data ------------------------------------------------------------

# Create raster bricks (stacks) for the variables of interest

# Significant wave height
wave_hs = brick("Data/storm_wave_jun_2016.nc4", varname = "hs")

# Wave energy flux
wave_cge = brick("Data/storm_wave_jun_2016.nc4", varname = "cge")

# Peak wave direction
wave_dp = brick("Data/storm_wave_jun_2016.nc4", varname = "dp")

# Directional spread
wave_spr = brick("Data/storm_wave_jun_2016.nc4", varname = "spr")

# Crop the rasters to same extent as figure 5 in Louis et. al., or to
# a smaller region of NSW coastline for the directional variables.

# Create the geographical extent objects.
louis_fig5_ext = extent(139, 158, -40, -20)
nsw_ext = extent(150, 158, -37, -28)

# Crop each of the rasters to their respective sizes for analysis.
wave_hs = crop(wave_hs, louis_fig5_ext)
wave_cge = crop(wave_cge, louis_fig5_ext)
wave_cge_nsw = crop(wave_cge, nsw_ext)
wave_dp = crop(wave_dp, nsw_ext)
wave_spr = crop(wave_spr, nsw_ext)

# Create objects for analysis ---------------------------------------------

# Create a vector of datetimes representing the datetimes of the data, with the
# Australia/NSW time zone.
wave_dates = julian_to_cal(start_date = ymd_hms("1990-01-01T00:00:00Z"),
                           julian_days = ncvar_get(wave_nc, "time"),
                           tz = "Australia/NSW")

# Create a timeseries of maximum coastal significant wave heights in the region.
max_hs_df = tibble(max_hs = maxValue(wave_hs), date = wave_dates)

# Create a timeseries of maximum coastal wave energy flux in the region.
max_cge_df = tibble(max_cge = maxValue(wave_cge), date = wave_dates)

# Extract the timeseries of peak wave direction just off the coast of Sydney.
wave_dp_syd_df = wave_dp %>% 
  raster::extract(matrix(c(153, -33.8), ncol = 2)) %>% 
  t() %>% 
  as_tibble() %>% 
  rename(wave_dp = V1) %>% 
  mutate(date = wave_dates)

# Extract the timeseries of directional spread just off the coast of Sydney.
wave_spr_syd_df = wave_spr %>% 
  raster::extract(matrix(c(153, -33.8), ncol = 2)) %>% 
  t() %>% 
  as_tibble() %>% 
  rename(wave_spr = V1) %>% 
  mutate(date = julian_to_cal(start_date = ymd_hms("1990-01-01T00:00:00Z"),
                              julian_days = ncvar_get(wave_nc, "time"),
                              tz = "Australia/NSW"))
