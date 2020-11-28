#################################################################################
# Code to check if dates of bug relevant OCH samples fits within ER sensor dates
##################################################################################

library(lubridate)
library(geosphere)
library(stringr)

# Check Ash Canyon Dates
AC_Fall_2012 <- ER_OCH_Check(basin = "Ash Canyon", season = "Fall", year = "2012")  # Check dates
AC_Spring_2013 <- ER_OCH_Check(basin = "Ash Canyon", season = "Spring", year = "2013")
AC_Fall_2013 <- ER_OCH_Check(basin = "Ash Canyon", season = "Fall", year = "2013")

# Check Water Canyon Dates
WC_Fall_2012 <- ER_OCH_Check(basin = "Water Canyon", season = "Fall", year = "2012") # Check Dates
WC_Spring_2013 <- ER_OCH_Check(basin = "Water Canyon", season = "Spring", year = "2013") # some Check Dates
WC_Fall_2013 <- ER_OCH_Check(basin = "Water Canyon", season = "Spring", year = "2013") # some Check Dates

# Check Garden Canyon Dates
GC_Fall_2012 <- ER_OCH_Check(basin = "Garden Canyon", season = "Fall", year = "2012")
GC_Spring_2013 <- ER_OCH_Check(basin = "Garden Canyon", season = "Spring", year = "2013") # Check Dates
GC_Fall_2013 <- ER_OCH_Check(basin = "Garden Canyon", season = "Fall", year = "2013") # Check Dates

# Check Huachuca Canyon Dates
HC_Fall_2012 <- ER_OCH_Check(basin = "Huachuca Canyon", season = "Fall", year = "2012")
HC_Spring_2013 <- ER_OCH_Check(basin = "Huachuca Canyon", season = "Spring", year = "2013") # Check Dates
HC_Fall_2013 <- ER_OCH_Check(basin = "Huachuca Canyon", season = "Fall", year = "2013") # check dates

# Check Great Falls Basin Dates
GFB_Fall_2012 <- ER_OCH_Check(basin = "Great Falls Basin", season = "Fall", year = "2012") # Check Dates
GFB_Spring_2013 <- ER_OCH_Check(basin = "Great Falls Basin", season = "Spring", year = "2013")
GFB_Fall_2013 <- ER_OCH_Check(basin = "Great Falls Basin", season = "Fall", year = "2013")

SAN_Fall_2012 <- ER_OCH_Check(basin = "San Andres Canyon", season = "Fall", year = "2012") # check dates
SAN_Spring_2013 <- ER_OCH_Check(basin = "San Andres Canyon", season = "Spring", year = "2013")
SAN_Fall_2013 <- ER_OCH_Check(basin = "San Andres Canyon", season = "Spring", year = "2013")


# Site/seasons that have missing ER sensors 

# use ER_OCH_Check to write new if_statement and get the WC years that don't have WAT1 or WAT2 ER Sensor info
WC_Fall_2013 <- ER_OCH_Check(basin = "Water Canyon without WAT1/WAT2", season = "Fall", year = "2013")
WC_Spring_2013 <- ER_OCH_Check(basin = "Water Canyon without WAT1/WAT2", season = "Spring", year = "2013")

# use ER_OCH_Check to write new if-statement for GC seasons that have limited number of sensors bc of flash flood
GC_Fall_2013 <- ER_OCH_Check(basin = "Garden Canyon with G2 and G3 Only", season = "Fall", year = "2013")
# HC Fall 2013
HC_Fall_2013 <- ER_OCH_Check(basin = "Huachuca Canyon Fall 2013", season = "Fall", year = "2013")
