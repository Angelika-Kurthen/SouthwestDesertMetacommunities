###############################
# Code to clean Wat1
###############################

library(readxl)

Wat1 <- read_excel("Private-MetacommunityData/RawData/Sensor composites (1).xlsx", 
                   sheet = "Water canyon")

Wat1Clean <- Wat1[ ,c(2,3,4)]
colnames(Wat1Clean) <- c("Date", "Value", "Interpretation")

#save file
write.csv(Wat1Clean, 
          file = 
            paste0("Private-MetacommunityData/CleanERData/","Wat1Clean2013.csv"))
