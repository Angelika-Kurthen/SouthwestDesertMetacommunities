###############################
# Code to clean Wat2
###############################

library(readxl)

Wat2 <- read_excel("Private-MetacommunityData/RawData/Sensor composites (1).xlsx", 
                   sheet = "Water canyon")

Wat2Clean <- Wat1[ ,c(2,6,7)]

#save file
write.csv(Wat2Clean, 
          file = 
            paste0("Private-MetacommunityData/CleanData/","Wat2Clean2013.csv"))
