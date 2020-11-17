######################################
# Code to clean Ash 4 2013 raw data
######################################
library(readxl) # install necessary libraries 

Ash4 <- read_excel("Private-MetacommunityData/RawData/Sensor composites (1).xlsx",
                   sheet = "Ash cyn")

# only select relevant columns and headers
Ash4Clean <- Ash4[, c(3,4,5)] 

#save file
write.csv(Ash4Clean, 
          file = 
            paste0("Private-MetacommunityData/CleanData/","Ash4Clean2013.csv"))
