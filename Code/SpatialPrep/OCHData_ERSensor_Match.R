#################################
#
#################################

# so here is the thing - not all data as bug-relevant time 
# so for spring 2012, we basically have no sensor data -> need to throw out all those points
# for fall 2012, we rarely have data the month before sampeling took place, so maybe we take the month after sampeling took place (depending on if t)



# ok so now we want to basically create a distance matrix between points
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


# tried to make a for loop to cycle through all the basin names but it wasn't working?
# brute force it
ER_OCH_ReadCheckDates(data = AC_Fall_2012, season = "Fall", year = "2012") # back calculate fall dates
ER_OCH_ReadCheckDates(data = WC_Fall_2012, season = "Fall", year = "2012") # note: WAT1 and WAT2 start in spring 2013
ER_OCH_ReadCheckDates(data = WC_Spring_2013, season = "Spring", year = "2013") # note: WAT1 and WAT2 start in spring 2013
ER_OCH_ReadCheckDates(data = WC_Fall_2013, season = "Fall", year = "2013") # should be fine 
ER_OCH_ReadCheckDates(data = GC_Spring_2013, season = 'Spring', year = "2013") # basically need to switch end dates of OCH sampleing to end date of ER sample because a lot of 2014 data is missng
ER_OCH_ReadCheckDates(data = GC_Fall_2013, season = "Fall", year = "2013") # can only use G2 and G3 from 2014, rest of sensors swept away in flash flood
ER_OCH_ReadCheckDates(data = HC_Spring_2013, season = "Spring", year = "2013") # basically need to switch end dates of OCH sampleing to end date of ER sample - seems to be some missing data between when ER sensors ends for 2013 and begins for 2014
ER_OCH_ReadCheckDates(data = HC_Fall_2013, season = "Fall", year = "2013") # should be fine if we use 2014 dates
ER_OCH_ReadCheckDates(data = GFB_Fall_2012, season = "Fall", year = "2012") # back calculate fall dates
ER_OCH_ReadCheckDates(data = SAN_Fall_2012, season = "Fall", year = "2012") # back calculate fall dates

ER_OCH_Check(basin = "Garden Canyon", season = "Spring", year = "2013")


# calculate a month later, not a month previously 

#AC_Fall_2012
AC_Fall_2012_Check <- AC_Fall_2012[AC_Fall_2012$stat == "CheckDates", ]
for (i in 1:length(AC_Fall_2012_Check$stat)) {
  row <- # isolate row with the OCH Site Name
    which(
      SampleDates$Site == AC_Fall_2012_Check$OCH_names[i] &
        SampleDates$Season == "Fall" &
        substr(
          SampleDates$`DAY/MONTH/YEAR`,
          start = 1,
          stop = 4
        ) == "2012"
    )
  ER <- which(Sensor_df$data.Sensor == AC_Fall_2012_Check$ER_vector[i])
  SampleDates$`DAY/MONTH/YEAR`[row] <- sensor_info$StartDate2013[ER]
  a <- (sensor_info$StartDate2013[ER] + days(30))
  SampleDates$PrevMonth[row] <- a
}

# GFB_Fall_2012
GFB_Fall_2012_Check <- GFB_Fall_2012[GFB_Fall_2012$stat == "CheckDates", ]
for (i in 1:length(GFB_Fall_2012_Check$stat)) {
  row <- # isolate row with the OCH Site Name
    which(
      SampleDates$Site == GFB_Fall_2012_Check$OCH_names[i] &
        SampleDates$Season == "Fall" &
        substr(
          SampleDates$`DAY/MONTH/YEAR`,
          start = 1,
          stop = 4
        ) == "2012"
    )
  ER <- which(Sensor_df$data.Sensor == GFB_Fall_2012_Check$ER_vector[i])
  SampleDates$`DAY/MONTH/YEAR`[row] <- sensor_info$StartDate2013[ER]
  a <- (sensor_info$StartDate2013[ER] + days(30))
  SampleDates$PrevMonth[row] <- a
}

# SAN_Fall_2012
SAN_Fall_2012_Check <- SAN_Fall_2012[SAN_Fall_2012$stat == "CheckDates", ]
for (i in 1:length(SAN_Fall_2012_Check$stat)) {
  row <- # isolate row with the OCH Site Name
    which(
      SampleDates$Site == SAN_Fall_2012_Check$OCH_names[i] &
        SampleDates$Season == "Fall" &
        substr(
          SampleDates$`DAY/MONTH/YEAR`,
          start = 1,
          stop = 4
        ) == "2012"
    )
  ER <- which(Sensor_df$data.Sensor == SAN_Fall_2012_Check$ER_vector[i])
  SampleDates$`DAY/MONTH/YEAR`[row] <- sensor_info$StartDate2013[ER]
  a <- (sensor_info$StartDate2013[ER] + days(30))
  SampleDates$PrevMonth[row] <- a
}

# use ER_OCH_Check to write new if_statement and get the WC years that don't have WAT1 or WAT2 ER Sensor info
WC_Fall_2013 <- ER_OCH_Check(basin = "Water Canyon without WAT1/WAT2", season = "Fall", year = "2013")
WC_Spring_2013 <- ER_OCH_Check(basin = "Water Canyon without WAT1/WAT2", season = "Spring", year = "2013")

# use ER_OCH_Check to write new if-statement for GC seasons that have limited number of sensors bc of flash flood
GC_Fall_2013 <- ER_OCH_Check(basin = "Garden Canyon with G2 and G3 Only", season = "Fall", year = "2013")

# GC_Spring_2013
GC_Spring_2013_Check <- GC_Spring_2013[GC_Spring_2013$stat == "CheckDates", ]
for (i in 1:length(GC_Spring_2013$stat)) {
  row <- # isolate row with the OCH Site Name
    which(
      SampleDates$Site == GC_Spring_2013_Check$OCH_names[i] &
        SampleDates$Season == "Spring" &
        substr(
          SampleDates$`DAY/MONTH/YEAR`,
          start = 1,
          stop = 4
        ) == "2013"
    )
  ER <- which(Sensor_df$data.Sensor == GC_Spring_2013_Check$ER_vector[i])
  SampleDates$`DAY/MONTH/YEAR`[row] <- sensor_info$EndDate2013[ER]
}

# HC_Spring_2013
HC_Spring_2013_Check <- HC_Spring_2013[HC_Spring_2013$stat == "CheckDates", ]
for (i in 1:length(HC_Spring_2013$stat)) {
  row <- # isolate row with the OCH Site Name
    which(
      SampleDates$Site == HC_Spring_2013_Check$OCH_names[i] &
        SampleDates$Season == "Spring" &
        substr(
          SampleDates$`DAY/MONTH/YEAR`,
          start = 1,
          stop = 4
        ) == "2013"
    )
  ER <- which(Sensor_df$data.Sensor == HC_Spring_2013_Check$ER_vector[i])
  SampleDates$`DAY/MONTH/YEAR`[row] <- sensor_info$EndDate2013[ER]
}

# HC Fall 2013
HC_Fall_2013 <- ER_OCH_Check(basin = "Huachuca Canyon Fall 2013", season = "Fall", year = "2013")

