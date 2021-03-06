###################################
# Code to clean Wat4 2013 raw data
###################################

library(readxl)

Wat4 <- read_excel("Private-MetacommunityData/RawData/Sensor composites (1).xlsx", 
                   sheet = "Water canyon")

Wat4Clean <- Wat4[ ,c(2,12,13)]
colnames(Wat4Clean) <- c("Date", "Value", "Interpretation")

#save file
write.csv(Wat4Clean, 
          file = 
            paste0("Private-MetacommunityData/CleanERData/","Wat4Clean2013.csv"))
