################################
# Code to clean Ash1 2013 data
################################
library(readxl) # install necessary libraries 

Ash1 <- read_excel("Private-MetacommunityData/RawData/Sensor composites (1).xlsx",
                   sheet = "Ash cyn")
# only select relevant columns and headers
Ash1Clean <- Ash1[, c(9,10)] 
colnames(Ash1Clean) <- c("Date", "Value")
#save file
write.csv(Ash1Clean, 
          file = 
            paste0("Private-MetacommunityData/CleanERData/","Ash1Clean2013.csv"))
