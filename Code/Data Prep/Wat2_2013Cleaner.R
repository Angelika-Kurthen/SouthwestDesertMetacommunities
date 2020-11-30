###############################
# Code to clean Wat2
###############################

library(readxl)

Wat2 <- read_excel("Private-MetacommunityData/RawData/Sensor composites (1).xlsx", 
                   sheet = "Water canyon")

Wat2Clean <- Wat1[ ,c(2,6,7)]
colnames(Wat2Clean) <- c("Date", "Value", "Interpretation")
#save file
write.csv(Wat2Clean, 
          file = 
            paste0("Private-MetacommunityData/CleanERData/","Wat2Clean2013.csv"))
