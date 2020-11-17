#######################################
# Code to clean raw GFB_3 data
#######################################

library(readxl) # install necessary libraries 

GFB_3 <- read_excel("Private-MetacommunityData/RawData/GFB composite (1).xlsx", 
                    sheet = "12Nov13-3apr14 G3")

# only select relevant columns and headers
GFB_3Clean <- GFB_3[, c(2, 3, 4)] 

# save file 
write.csv(GFB_3Clean, 
          file = 
            paste0("Private-MetacommunityData/CleanERData/","GFB_3Clean.csv"))