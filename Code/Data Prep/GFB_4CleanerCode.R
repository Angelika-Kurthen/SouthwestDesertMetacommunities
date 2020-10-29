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
<<<<<<< HEAD
            paste0("Private-MetacommunityData/CleanData/","GFB_Clean.csv"))
=======
            paste0("Private-MetacommunityData/CleanData/","GFB_4Clean.csv"))
>>>>>>> 5e2d303102a4a1f422ee55ea20102864f25f1e39
