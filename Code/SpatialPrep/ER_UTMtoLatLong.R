##################################################
# 
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
ER_UTM_WS <- subset(ER_UTM_WS_CL[which(ER_UTM_WS_CL$Zone == "13S"), ]) # White Sands Sensors

# Lat and Long conversion for China Lake
ER_UTM_CL$Northing <- as.numeric(as.character(ER_UTM_CL$Northing))
ER_UTM_CL$Easting <- as.numeric(as.character(ER_UTM_CL$Easting))
sputm <- SpatialPoints(ER_UTM_CL[ ,c(2,3)], proj4string=CRS("+proj=utm +zone=11 +datum=WGS84"))  
spgeo <- spTransform(sputm, CRS("+proj=longlat +datum=WGS84"))
utm2 <- spTransform(sputm,CRS("+proj=longlat +datum=WGS84"))

proj4string <- "+proj=utm +zone=11 +ellps=WGS84 +datum=WGS84 +units=m +no_defs "
pj <- project(ER_UTM_CL[ ,c(2,3)], proj4string, inverse=TRUE)
latlon <- data.frame(lat=pj$y, lon=pj$x)
print(latlon)
