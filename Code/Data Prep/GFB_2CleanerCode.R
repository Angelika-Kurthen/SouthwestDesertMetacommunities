###############################
# Code to clean GFB_2
###############################

library(readxl) # install necessary libraries 

GFB_2 <- read_excel("Private-MetacommunityData/RawData/GFB composite (1).xlsx", 
                    sheet = "GFB 2")

# only select relevant columns and headers
GFB_2Clean <- GFB_2[, c(2, 3, 4)] 

# save file 
write.csv(GFB_2Clean, 
          file = 
            paste0("Private-MetacommunityData/CleanData/","GFB_2Clean.csv"))
