###############################
# Code to clean San2 raw data
###############################

library(readxl) # install necessary libraries 

San2 <- read_excel("Private-MetacommunityData/RawData/Sensor composites (1).xlsx",
                   sheet = "San Andres")
San2Clean <- San2[ , c(5,6)]
colnames(San2Clean) <- c("Date", "Value")
#save file
write.csv(San2Clean, 
          file = 
            paste0("Private-MetacommunityData/CleanERData/","San2Clean2013.csv"))
