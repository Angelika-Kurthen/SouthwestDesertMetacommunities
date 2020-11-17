######################################
# Code to clean Ash2 2013 raw data
#####################################

library(readxl) # install necessary libraries 

Ash2 <- read_excel("Private-MetacommunityData/RawData/Sensor composites (1).xlsx",
                   sheet = "Ash cyn")
# only select relevant columns and headers
Ash2Clean <- Ash2[-c(1:170), c(6,7,8)] 

#save file
write.csv(Ash2Clean, 
          file = 
            paste0("Private-MetacommunityData/CleanERData/","Ash2Clean2013.csv"))
