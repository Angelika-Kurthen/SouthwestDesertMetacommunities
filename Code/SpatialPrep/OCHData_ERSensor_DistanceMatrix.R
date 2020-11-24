#################################
#
#################################

# so here is the thing - not all data as bug-relevant time 
# so for spring 2012, we basically have no sensor data -> need to throw out all those points
# for fall 2012, we rarely have data the month before sampeling took place, so maybe we take the month after sampeling took place (depending on if t)



# ok so now we want to basically create a distance matrix between points
library(lubridate)
library(geosphere)

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

mat <- distm(Sensor_df[c(16:22), c(3,2)], OCH_lat_lon[c(1:5) ,c(5,4)], fun=distVincentyEllipsoid) # cols are OCH sites and rows are ER sensors
rownames(mat) <- ER_LatLong$data.Sensor[which(Sensor_df$X2012.2013 == 1)]
colnames(mat) <- OCH_lat_lon$Site
df <- as.data.frame(mat)


# ok now I want to determine the ER sensor with the minimum 
minlist <- apply(df, 2, FUN = min) 
ER_vector <- vector()
for (i in 1:length(minlist)){
  a <- rownames(df)[which(df[i] == minlist[i])]
  ER_vector <- c(ER_vector, a)
}



DistanceMatrices <- function(basin, season, year){
  if (basin == "Ash Canyon" & season == "Spring" & year == "2013")
    mat <- distm(Sensor_df[c(1:4), c(3,2)], OCH_lat_lon[c(34:39), c(5,4)], fun=distVincentyEllipsoid)
  rownames(mat) <- Sensor_df$data.Sensor[1:4]
  colnames(mat) <- OCH_lat_lon$Site[34:39]
  df <- as.data.frame(mat)
  OCH_ER_Match <- MinDistList(data = df)
  OCH_ER_Match <- as.data.frame(OCH_ER_Match)
  OCH_ER_Match$ER_vector <- as.character(OCH_ER_Match$ER_vector)
  OCH_ER_Match$OCH_names <- as.character(OCH_ER_Match$OCH_names)
  stat <- vector()
  for (i in 1:length(OCH_ER_Match$ER_vector)){
    b <- DateStatus(ER_Name = OCH_ER_Match$ER_vector[i], OCH_Name = OCH_ER_Match$OCH_names[i], season = season, year = year)
    stat <- c(stat, b)
  }
  
  
}
}




interval(start = SampleDates$`DAY/MONTH/YEAR`[1], end = SampleDates$PrevMonth[1]) %within% interval(start = sensor_info$StartDate2013[1], end = sensor_info$EndDate2013[1]) 




# Basically need to make a series of distance matrices though a very very specific function
