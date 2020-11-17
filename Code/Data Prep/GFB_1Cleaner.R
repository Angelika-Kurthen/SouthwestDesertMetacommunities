#################################
# Code to clean GFB 1 raw data
#################################
library(readxl)

GFB1 <- read_excel("Private-MetacommunityData/RawData/Sensor composites (1).xlsx", 
                   sheet = "GFB")

GFB_1Clean <- GFB1[ , c(1,2,3)]

# save file 
write.csv(GFB_1Clean, 
          file = 
            paste0("Private-MetacommunityData/CleanData/","GFB_1Clean.csv"))
