##################################################
# Code to convert ER UTM data to Lat Long
##################################################

library(readxl)
library(rgdal)
library(sp)
library(raster)
library(Rcpp)
library(proj4)
# We have ER sensor data and OCH Site Sample data - we need to link these together

# We have the UTM info for the ER Sensor data
# Need to convert to latitude and longitude

# ER sensor locations in UTM for New Mexico and California (White Sands and Chine Lake)
ER_Sensor_locations <- read_excel("Private-MetacommunityData/RawData/ER_Sensor_locationinfo_WS_CLNWS (1).xlsx")

# need to split up the GPS waypoint UTM column by spaces 
ER_Northing_Easting <- strsplit(ER_Sensor_locations$`GPS waypoint UTM`, " ") # use strsplit() to split by space
mat  <- matrix(unlist(ER_Northing_Easting), ncol=3, byrow=TRUE)              # unlist and convert to matrix
df   <- as.data.frame(mat)                                                   # convert matrix to dataframe
ER_UTM_WS_CL <- as.data.frame(cbind(df, ER_Sensor_locations[ ,1]))           # append sensor names
colnames(ER_UTM_WS_CL) <- c("Zone", "Northing", "Easting", "Sensor")         # change column names

# Problem: White Sands sensors and China Lake sensors are in two different UTM zones
# Converting them will be difficult if they are together in the same dataframe
# Solution: subset data frame and change lat-long 

ER_UTM_CL <- as.data.frame(subset(ER_UTM_WS_CL[which(ER_UTM_WS_CL$Zone == "11S"), ])) # China Lake Sensors

ER_LatLon_CL <- UTMtoLatLon(data = ER_UTM_CL, zone = 11) # use UTMtoLatLong to convert UTMs 

ER_UTM_WS <- subset(ER_UTM_WS_CL[which(ER_UTM_WS_CL$Zone == "13S"), ]) # White Sands Sensors

ER_LatLon_WS <- UTMtoLatLon(data = ER_UTM_WS, zone = 13)  # use UTMtoLatLong to convert UTMs 

# now we need to read in our huachuca canyon and garden canyon info

SensorLocations_FH <- read_excel("Private-MetacommunityData/RawData/SensorLocationDescriptionUTMs.xlsx")

zones <- rep(12, times = 15)
ER_UTM_FH <- as.data.frame(cbind(zones, SensorLocations_FH$Easting, SensorLocations_FH$Northing, SensorLocations_FH$ID...2))  # Think the northing and easting was confused in the excel file so sorted that out
colnames(ER_UTM_FH) <- c("Zone", "Northing", "Easting", "Sensor")

ER_LatLong_FH <- UTMtoLatLon(data = ER_UTM_FH, zone = 12)
