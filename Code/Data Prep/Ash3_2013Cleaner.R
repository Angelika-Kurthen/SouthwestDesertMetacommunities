#####################################
# Code to clean Ash3 2013
#####################################

library(readxl) # install necessary libraries 

Ash3 <- read_excel("Private-MetacommunityData/RawData/Sensor composites (1).xlsx",
                                   sheet = "Ash cyn")
# only select relevant columns and headers
Ash3Clean <- Ash3[, c(1,2)] 
colnames(Ash3Clean) <- c("Date", "Value")

#save file
write.csv(Ash3Clean, 
          file = 
            paste0("Private-MetacommunityData/CleanERData/","Ash3Clean2013.csv"))
