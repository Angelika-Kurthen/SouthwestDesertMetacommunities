#################################
#Functions
################################


# cleaner function one is used to clean and sort G1_April2013.csv, G2_April2013.csv...
# requires tidyverse

csv <- "G1_April2013.csv"
Clean1(csv)
Clean1 <- function(csv){
  library (stringr)
  library(lubridate)
  library(plyr)
  
  #import 2013 data
  RawData <- read.csv(paste0("RawData/", csv), header = FALSE)

  #isolate date of ER sampeling
  SemiRawData <- RawData[-c(1, 2),-c(1, 4, 5, 6, 7, 8)] # delete extra columns and headers
  SemiRawData$V2 <- str_sub(SemiRawData$V2, start = 1L, end = 8L) # remove time from date and time column
  
  
  #get daily means and sort by date
  SemiRawData$V3 <- as.numeric(as.character(SemiRawData$V3)) # convert sensor data to numeric 
  CleanData <- aggregate(SemiRawData[, 2], list(SemiRawData$V2), mean) # aggregate by date and calculate daily means
  CleanData$Group.1 <- mdy(CleanData$Group.1) # make sure dates are in month-day-year form
  CleanData <- arrange(CleanData, Group.1) # put data into chronological order
  name <- paste0(str_sub(csv, start = 1L, end = 12L), "Clean.csv")
  write.csv(CleanData, file = paste0("CleanData/",name))
  return(View(CleanData))
  
}


