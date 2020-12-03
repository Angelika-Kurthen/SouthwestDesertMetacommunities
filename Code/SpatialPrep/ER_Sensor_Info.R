#################################
# Code to compile sensor dates and info
#################################

library(lubridate)
library(geosphere)
library(stringr)

# ok now we need to cross reference the dates sampled and the matched ER sensors with the sensor dates

# read in all the sensor dates and info
sensor_info <- as.data.frame(read.table("Private-MetacommunityData/RawData/ER_Sensor_Years.txt", header = T, sep = ","))

# convert all the start and end dates to date class
sensor_info$StartDate2013<- mdy(sensor_info$StartDate2013)
sensor_info$EndDate2013 <- mdy(sensor_info$EndDate2013)
sensor_info$StartDate2014 <- mdy(sensor_info$StartDate2014)
sensor_info$StartDate2014.1 <- mdy(sensor_info$StartDate2014.1)

# since some sensors got broken 
# create distance matrix

Sensor_df <- merge(ER_LatLong, sensor_info, by.x = "data.Sensor", by.y = "Sensor")
Sensor_df$data.Sensor <- as.character(Sensor_df$data.Sensor)

