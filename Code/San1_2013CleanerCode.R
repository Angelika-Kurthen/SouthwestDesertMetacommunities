############################################
# Code to clean San1 2012-2013 raw data
###########################################
library(readxl) # install necessary libraries 
library(chron)

San1 <- read_excel("Private-MetacommunityData/RawData/Sensor composites (1).xlsx",
                   sheet = "San Andres")
# only select relevant columns and headers
San1Clean <- San1[c(1:374), c(1,3,4)]

# date is in Julian Date format so we need to convert it to year-month-day
# origin is also day 1, we need to subtract 1 from the Julian Date
days_passed_2012 <- c(298:366)   
days_passed_2013 <- c(1:305)

# different origins based on year
#2012 dates
dates2012 <- month.day.year(days_passed_2012, c(month = 1, day = 1, year = 2012))
dates2012 <- as.Date(paste0(dates2012$year, "-", dates2012$month,"-", dates2012$day))

#2013 dates
dates2013 <- month.day.year(days_passed_2013, c(month = 1, day = 1, year = 2013))
dates2013 <- as.Date(paste0(dates2013$year, "-", dates2013$month, "-", dates2013$day))

#combine lists
dates <- c(dates2012, dates2013)

#add to San1 data
San1Clean[1] <- dates

#save file
write.csv(San1Clean, 
          file = 
            paste0("Private-MetacommunityData/CleanData/","San1Clean2013.csv"))
