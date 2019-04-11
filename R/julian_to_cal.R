# Load required packages --------------------------------------------------
# These packages will be installed automatically if they are not already 
# installed.

if (!require(lubridate))
  install.packages("lubridate")
library(lubridate)

# Convert Julian Days into Calendar Dates ---------------------------------

# This function converts decimal julian days since a specified date, and 
# converts them into calendar dates with a specified timezone.
# 
# start_date:  A POSIXct, or Date object referring to the initial date used for 
#              calculating the julian days since.
# julian_days: A numeric vector containing the decimal days since start_date.
# tz:          A character string indicating the timezone. Defaults to UTC.
# 
# The hours for each day are calculated by julian_days mod 1, which leaves the 
# decimal portion, which is then multiplied by 24, and rounded to the nearest 
# integer.

julian_to_cal = function(start_date, julian_days, tz = "UTC") {
  
  initial_date = start_date + 
    days(floor(julian_days)) + 
    hours(round(julian_days %% 1 * 24))
  
  with_tz(initial_date, tzone = tz)
}