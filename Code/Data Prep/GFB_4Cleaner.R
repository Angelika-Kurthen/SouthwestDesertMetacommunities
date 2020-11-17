#########################################
# Code to clean raw GFB_4 data 
##########################################

# install libraries
library(readxl)

# load raw data
GFB_4 <- read_excel("Private-MetacommunityData/RawData/GFB composite (1).xlsx",
                    sheet = "GFB4")

# only select relevant columns and headers
GFB_4Clean <- GFB_4[, c(1, 2, 3)] 

# save file 
write.csv(GFB_4Clean, 
          file = 
            paste0("Private-MetacommunityData/CleanERData/","GFB_4Clean.csv"))
