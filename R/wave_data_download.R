# This script is used to download the ww3.pac_4m.201901.nc file 
# programmatically, using the THREDDS data server NetCDF Subset Service.


# Load required packages --------------------------------------------------
# These packages will be installed automatically if they are not already 
# installed.

if (!require(httr))
  install.packages("httr")
library(httr)

# Build the query / URL ---------------------------------------------------

# Change these variables and parameters to query a different subset from the 
# server.

waves_url = modify_url(file.path("http://data-cbr.csiro.au", "thredds", "ncss", 
                                 "catch_all", "CMAR_CAWCR-Wave_archive", 
                                 "CAWCR_Wave_Hindcast_aggregate", "gridded", 
                                 "ww3.aus_4m.201606.nc"),
                       
                       query = list(var = "cge",  # Wave energy flux (kW/m)
                                    var = "dp",   # Peak wave direction (from)
                                    var = "uwnd", # Eastward wind (m/s)
                                    var = "vwnd", # Northward wind (m/s)
                                    var = "hs",   # Significant wave height (m)
                                    var = "spr",  # Directional spread (degrees)
                                    
                                    time_start = "2016-06-03T00:00:00Z",
                                    time_end = "2016-06-09T23:00:00Z",
                                    timeStride = 1,
                                    addLatLon = "true",
                                    accept = "netcdf4"))

# Retrieve response information (and other info) from the URL
request = GET(waves_url)

# Check that the response is OK (200), and stop if it isn't
if (request$status_code != 200)
  stop("The URL is not valid (Status code: ", request$status_code, ")")

# Create a /Data directory if one does not already exist. This will store the
# NetCDF file.
if (!dir.exists("Data"))
  dir.create("Data")

# Download the file.
download.file(waves_url, "Data/storm_wave_jun_2016.nc4", method = "auto")
