##################################
# Code to clean Wat3 2013 raw data
##################################

library(readxl)


Wat3 <- read_excel("Private-MetacommunityData/RawData/Sensor composites (1).xlsx", 
                   sheet = "Water canyon")

Wat3Clean <- Wat3[ ,c(2,9, 10)]

#save file
write.csv(Wat3Clean, 
          file = 
            paste0("Private-MetacommunityData/CleanData/","Wat3Clean2013.csv"))
