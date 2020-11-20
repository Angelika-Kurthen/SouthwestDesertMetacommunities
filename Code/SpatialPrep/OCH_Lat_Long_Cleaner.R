########################################
# Code to clean up LatLong data
########################################

library(readxl)
Lat_and_Long <- read_excel("Private-MetacommunityData/RawData/Lat and Long.xlsx") # read in OCH sample lat and long

OCH_lat_lon <- Lat_and_Long[which(Lat_and_Long$Site %in% datetable$Site), ] # only want Lat and Long that are in the cleaned OCH data -> use date table as a proxy

# looks like there are some typos - we have longitudes that are missing negative signs

for (i in 1:length(OCH_lat_lon$Longitude)){ # quickly run through values in the longitude column
  if (OCH_lat_lon$Longitude[i] > 1) {       # if they are positive  
    OCH_lat_lon$Longitude[i] <- -(OCH_lat_lon$Longitude[i]) # make them negative
  }
}

