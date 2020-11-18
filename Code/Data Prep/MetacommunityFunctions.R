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
