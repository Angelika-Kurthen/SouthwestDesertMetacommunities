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
  RawData <- read.csv(csvpath, header = FALSE) #full path
  
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
  name <- paste0("Clean", csv)
  write.csv(CleanData,
            file = paste0("Private-MetacommunityData/CleanData/", name))
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

