#################################
#Functions
################################


# cleaner function one is used to clean and sort G1_April2013.csv, G2_April2013.csv...
# requires tidyverse

#what folder as second argument
PrepAndCleanHoboCSV <- function(csv, csvpath) {
  require(stringr)
  require(lubridate)
  require(plyr)
  
  #import data
  RawData <- read.csv(csvpath, header = F) #full path
  
  #isolate date of ER sampleing
  SemiRawData <-
    RawData[-c(1, 2), -c(1, 4, 5, 6, 7, 8)] # delete extra columns and headers
  SemiRawData$V2 <-
    str_sub(SemiRawData$V2, start = 1L, end = 8L) # remove time from date and time column
  
  #get daily means and sort by date
  SemiRawData$V3 <-
    as.numeric(as.character(SemiRawData$V3)) # convert sensor data to numeric
  CleanData <-
    aggregate(SemiRawData[, 2], list(SemiRawData$V2), mean) # aggregate by date and calculate daily means
  CleanData$Group.1 <-
    mdy(CleanData$Group.1) # make sure dates are in month-day-year form
  CleanData <-
    arrange(CleanData, Group.1) # put data into chronological order
  name <- paste0(str_sub(csv, end = -5 ),"Clean", ".csv")
  write.csv(CleanData,
            file = paste0("Private-MetacommunityData/CleanERData/", name))
}


GenusSpecies <- function(basin, genus, species1, species2) {
  if (species2 == 0) {
    x <- sum(basin[which(basin$Taxa == genus), ]$Count)
    y <- basin[which(basin$Taxa == species1), ]$Count
    wt <- basin[which(basin$Taxa == species1), ]$Count /
      sum(basin[which(basin$Taxa == species1), ]$Count)
    wtx <- x * wt
    wtx <- wtx + y
    basin[which(basin$Taxa == species1), ]$Count = c(wtx)
    basin[which(basin$Taxa == genus), ]$Count = NA
    print("no species 2")
  }
  
  
  if (species2 != 0) {
    x <- basin[which(basin$Taxa == genus), ]$Count
    y <- basin[which(basin$Taxa == species1, ), ]$Count
    z <- basin[which(basin$Taxa == species2, ), ]$Count
    sum <- sum(y) + sum(z)
    wty <- y / sum
    wty <- sum(x) * wty
    wtz <- z / sum
    wtz <- sum(x) * wtz
    wty <- wty + y
    wtz <- wtz + z
    basin[which(basin$Taxa == species1, ), ]$Count = c(wty)
    basin[which(basin$Taxa == species2, ), ]$Count = c(wtz)
    basin[which(basin$Taxa == genus), ]$Count = NA
    print("species2 present")
  }
}

ERSensorHydrology <- function(path) {  # need to enter file path 
  file.names <- dir(path)              # get a list of file names in the folder
  for (i in 1:length(file.names)) {             # cycle through file names in folder
    file <-                                     # isolate each file name               
      read.table(
        paste0(path, "/", file.names[i]),
        header = TRUE,
        sep = ",",
        stringsAsFactors = FALSE
      )
    hydro <- vector()                          # create empty vector
    for (j in 1:length(file[, 3])) {           # cycle through resistance values 
      if (is.na(file[j, 3])) {                 # if NA, keep it NA
        hydro[j] <- NA
      } else {                                 # we are using the electircal resistance value of -120 as out 'wet' threshold
        if (file[j, 3] > -120) {               # this was value used in Constantz et al. 2001
          hydro[j] <- "Wet"                    # if value above -120, stream bed is wet
        }
        
        if (file[j, 3] <= -120) {              # if value below -120, stream bed is dry
          hydro[j] <- "Dry"
        }
      }
    }
    bound <- cbind(file, hydro)                # append hydology list to ER sensor data
    write.csv(bound, file = paste0(path, "/", file.names[i]))  # export as csv in CleanER
  }
}

# Lat and Long conversion for China Lake

# data needs to be in this format: data frame with three columns in order: "Zone", Northing","Easting", "Sensor"
UTMtoLatLon <- function(data, zone, output_name){

  data$Northing <-as.numeric(as.character(data$Northing))  # need to make sure Northing and Easting are of class numeric
  data$Easting <- as.numeric(as.character(data$Easting))
  
  proj4string <- paste0("+proj=utm +zone=", zone, " +ellps=WGS84 +datum=WGS84 +units=m +no_defs ") # string with coordinate reference system
  pj <- project(data[ ,c(2,3)], proj4string, inverse=TRUE) # create projection object
  latlon <- data.frame(lat=pj$y, lon=pj$x, data$Sensor)
  return(latlon)
}

MinDistList <-
  function(data) {
    # function to return a distance matrix between ER sensors and OCH sample sites
    minlist <-
      apply(data, 2, FUN = min) # pulls minimum values for each column (OCH site)
    ER_vector <-
      vector()                # empty vector to put ER sensor names into
    for (i in 1:length(minlist)) {
      # cycle through minimum values
      a <-
        rownames(data)[which(data[, i] == minlist[i])] # pull rownames of minimum value (ER sensor name)
      ER_vector <- c(ER_vector, a)       # append to vector
    }
    OCH_names <- colnames(data)          # get OCH site names
    ER_OCH_match <- cbind(ER_vector, OCH_names) # combine into dataframe with match between OCH site and ER sensor
    return(ER_OCH_match)
  }

# function to check to make sure the bug relevant samples dates are ok

DateStatus <- function(ER_Name, OCH_Name, season, year) { 
  row <- # isolate row with the OCH Site Name
    which(
      SampleDates$Site == OCH_Name &
        SampleDates$Season == season &
        year == substr(
          SampleDates$`DAY/MONTH/YEAR`,
          start = 1,
          stop = 4
        )
    )
  if (length(row) == 0) { # if the OCH Site/season/year combo doesn't exist, write DNE
    status <- "DNE"
  } else { # if OCH Site/season/year combo does exist then check to make sure bug relevant interval is within sample interval
    ER <- which(Sensor_df$data.Sensor == ER_Name)
    int <-
      interval(start = SampleDates$`DAY/MONTH/YEAR`[row],
               end = SampleDates$PrevMonth[row]) %within% interval(start = Sensor_df$StartDate2013[ER], end = Sensor_df$EndDate2013[ER])
    if (int == T) { # if bug relevant dates within ER sample, then wite Good
      status <- "Good"
    } else { # if not, we need to go an check the dates
      status <- "CheckDates"
  }
  }
  return(status)
}

ER_OCH_Check <- function(basin, season, year) {
  if (basin == "Ash Canyon") {
    mat <-
      distm(Sensor_df[c(1:4), c(3, 2)], OCH_lat_lon[c(34:39), c(5, 4)], fun =
              distVincentyEllipsoid)
    rownames(mat) <- Sensor_df$data.Sensor[1:4]
    colnames(mat) <- OCH_lat_lon$Site[34:39]
  }
  if (basin == "Garden Canyon") {
    mat <-
      distm(Sensor_df[c(5:11), c(3, 2)], OCH_lat_lon[c(6:14), c(5, 4)], fun = distVincentyEllipsoid)
    rownames(mat) <- Sensor_df$data.Sensor[5:11]
    colnames(mat) <- OCH_lat_lon$Site[6:14]
  }
  if (basin == "Great Falls Basin") {
    mat <- # note: GFB4 does not have data from 2012 and 2013
      distm(Sensor_df[c(12:14), c(3, 2)], OCH_lat_lon[c(15:23), c(5, 4)], fun = distVincentyEllipsoid)
    rownames(mat) <- Sensor_df$data.Sensor[12:14]
    colnames(mat) <- OCH_lat_lon$Site[15:23]
  }
  if (basin == "Huachuca Canyon") {
    mat <-
      distm(Sensor_df[c(16:22), c(3, 2)], OCH_lat_lon[c(1:5), c(5, 4)], fun = distVincentyEllipsoid)
    rownames(mat) <- Sensor_df$data.Sensor[16:22]
    colnames(mat) <- OCH_lat_lon$Site[1:5]
  }
  if (basin == "San Andres Canyon") {
    mat <-
      distm(Sensor_df[c(23:24), c(3, 2)], OCH_lat_lon[c(40:42), c(5, 4)], fun = distVincentyEllipsoid)
    rownames(mat) <- Sensor_df$data.Sensor[23:24]
    colnames(mat) <- OCH_lat_lon$Site[40:42]
  }
  if (basin == "Water Canyon") {
    mat <-
      distm(Sensor_df[c(25:28), c(3, 2)], OCH_lat_lon[c(24:33), c(5, 4)], fun = distVincentyEllipsoid)
    rownames(mat) <- Sensor_df$data.Sensor[25:28]
    colnames(mat) <- OCH_lat_lon$Site[24:33]
  }
  if (basin == "Water Canyon without WAT1/WAT2"){
    mat <- 
      distm(Sensor_df[c(27:28), c(3,2)], OCH_lat_lon[c(24:33), c(5,4)], fun = distVincentyEllipsoid)
    rownames(mat) <- Sensor_df$data.Sensor[27:28]
    colnames(mat) <- OCH_lat_lon$Site[24:33]
  }
  if (basin == "Garden Canyon with G2 and G3 Only" ){
    mat <- 
      distm(Sensor_df[c(5:7), c(3,2)], OCH_lat_lon[c(6:14), c(5,4)], fun = distVincentyEllipsoid)
    rownames(mat) <- Sensor_df$data.Sensor[5:7]
    colnames(mat) <- OCH_lat_lon$Site[6:14]
  }
  if (basin == "Huachuca Canyon Fall 2013") {
    mat <-
      distm(Sensor_df[c(16, 18:22), c(3, 2)], OCH_lat_lon[c(1:5), c(5, 4)], fun = distVincentyEllipsoid)
    rownames(mat) <- Sensor_df$data.Sensor[c(16, 18:22)]
    colnames(mat) <- OCH_lat_lon$Site[1:5]
  }
  df <- as.data.frame(mat)
  OCH_ER_Match <- MinDistList(data = df)
  OCH_ER_Match <- as.data.frame(OCH_ER_Match)
  OCH_ER_Match$ER_vector <- as.character(OCH_ER_Match$ER_vector)
  OCH_ER_Match$OCH_names <- as.character(OCH_ER_Match$OCH_names)
  stat <- vector()
  if (basin == "Garden Canyon with G2 and G3 Only" | basin == "Huachuca Canyon Fall 2013"){ 
    b <- DateStatusFor2014Data(
      ER_Name = OCH_ER_Match$ER_vector[i],
      OCH_Name = OCH_ER_Match$OCH_names[i], 
      season = season, 
      year = year)
    stat <- c(stat, b)
    } else {
  for (i in 1:length(OCH_ER_Match$ER_vector)) {
    b <-
      DateStatus(
        ER_Name = OCH_ER_Match$ER_vector[i],
        OCH_Name = OCH_ER_Match$OCH_names[i],
        season = season,
        year = year
      )
    stat <- c(stat, b)
  }}
  c <- cbind(OCH_ER_Match, stat)
  return(c)
}


# Function to 
ER_OCH_ReadCheckDates <- function(data, season, year){
  dat <- data[which(data$stat == "CheckDates"),]
  for (i in 1:length(dat$stat)) {
    row <- # isolate row with the OCH Site Name
      which(
        SampleDates$Site == dat$OCH_names[i] &
          SampleDates$Season == season &
          substr(
            SampleDates$`DAY/MONTH/YEAR`,
            start = 1,
            stop = 4
          ) == year
      )
    ER <- which(Sensor_df$data.Sensor == dat$ER_vector[i])
    if (SampleDates$PrevMonth[row] < sensor_info$StartDate2013[ER]) {
      print("sample dates start before ER sensors")
    } else {
      print("OCH interval")
      print(interval(
        start = SampleDates$`DAY/MONTH/YEAR`[row],
        end = SampleDates$PrevMonth[row]
      ))
      print("ER interval 2013")
      print(interval(
        start = sensor_info$StartDate2013[ER],
        end = sensor_info$EndDate2013[ER]
      ))
      print("ER interval 2014")
      print(
        interval(
          start = sensor_info$StartDate2014[ER],
          end = sensor_info$StartDate2014.1[ER]
        )
      )
    }
  }
}

BackCalculateSampleDates <- function(data, season, year){
  dat <- data[which(data$stat == "CheckDates"),]
  for (i in 1:length(dat$stat)) {
    row <- # isolate row with the OCH Site Name
      which(
        SampleDates$Site == dat$OCH_names[i] &
          SampleDates$Season == season &
          substr(
            SampleDates$`DAY/MONTH/YEAR`,
            start = 1,
            stop = 4
          ) == year
      )
    ER <- which(Sensor_df$data.Sensor == dat$ER_vector[i])
    SampleDates$`DAY/MONTH/YEAR`[row] <- sensor_info$StartDate2013[ER]
    a <- (sensor_info$StartDate2013[ER] + days(30))
    SampleDates$PrevMonth[row] <- a
  }
}

DateStatusFor2014Data <- function(ER_Name, OCH_Name, season, year) { 
  row <- # isolate row with the OCH Site Name
    which(
      SampleDates$Site == OCH_Name &
        SampleDates$Season == season &
        year == substr(
          SampleDates$`DAY/MONTH/YEAR`,
          start = 1,
          stop = 4
        )
    )
  if (length(row) == 0) { # if the OCH Site/season/year combo doesn't exist, write DNE
    status <- "DNE"
  } else { # if OCH Site/season/year combo does exist then check to make sure bug relevant interval is within sample interval
    ER <- which(Sensor_df$data.Sensor == ER_Name)
    int <-
      interval(start = SampleDates$`DAY/MONTH/YEAR`[row],
               end = SampleDates$PrevMonth[row]) %within% interval(start = Sensor_df$StartDate2014[ER], end = Sensor_df$StartDate2014.1[ER])
    if (int == T) { # if bug relevant dates within ER sample, then wite Good
      status <- "Good"
    } else { # if not, we need to go an check the dates
      status <- "CheckDates"
    }
  }
  return(status)
}
