#####################################################################
## ER Cleaning and Hydrology Compiler
#####################################################################

source('Code/Data Prep/MetacommunityFunctions.R')


## Run the codes to clean the ER data sensors

source('Code/Data Prep/Ash1_2013Cleaner.R')
source('Code/Data Prep/Ash2_2013Cleaner.R')
source('Code/Data Prep/Ash3_2013Cleaner.R')
source('Code/Data Prep/Ash4_2013Cleaner.R')
source('Code/Data Prep/ERSensorCleaner.R')
source('Code/Data Prep/GFB_1Cleaner.R')
source('Code/Data Prep/GFB_2Cleaner.R')
source('Code/Data Prep/GFB_3Cleaner.R')
source('Code/Data Prep/GFB_4Cleaner.R')
source('Code/Data Prep/San1_2013Cleaner.R')
source('Code/Data Prep/San2_2013Cleaner.R')
source('Code/Data Prep/Wat1_Cleaner.R')
source('Code/Data Prep/Wat2_2013Cleaner.R')
source('Code/Data Prep/Wat3_2013Cleaner.R')
source('Code/Data Prep/Wat4_2013Cleaner.R')

# run hydrology of the ER data sensors
source('Code/Data Prep/ERSensorHydrology.R')

# % flow permanance 
# Zero Flow Days per year



df <- data.frame(Sensor = integer(), DaysTotal = double(), DaysWet = double(), flowperm = double())
  
list <- read.delim("~/SouthwestDesertMetacommunities/Private-MetacommunityData/RawData/ER_Sensor_Years.txt", header=T)

for (i in 1:length(list$Sensor)) {
if (list$FileName2013[i] == " NA"){ # if ER sensor data for 2013 not available, message that says it isn't
  print("2013 is NA")
} else { # if ER sensor data for 2013 available, get the hydrologies, get the days with wet or dry readings, and get the total length the ER sensor ran and the number of wet days
  dat2013 <- read.csv(paste0('Private-MetacommunityData/CleanERData/' , substring(list$FileName2013[i], 2)))
  dat2013 <- dat2013[which(is.na(dat2013$hydro)==F), ] ## get days with 
  tot2013 <- length(dat2013$hydro)
  wet2013 <- length(dat2013$hydro[which(dat2013$hydro == "Wet")])
}
 
if (list$FileName2014[i]== " NA"){
  print("2014 is NA") # if ER sensor data for 2014 not available, message that says it isn't
} else { # if ER sensor data for 2014 available, get hydrologies, get the days with wet and dry readings, and get the total length that ER sensor ran and the number of wet days
  dat2014 <- read.csv(paste0('Private-MetacommunityData/CleanERData/' , substring(list$FileName2014[i], 2)))
  dat2014 <- dat2014[which(is.na(dat2014$hydro)==F), ] ## get days with 
  tot2014 <- length(dat2014$hydro)
  wet2014 <- length(dat2014$hydro[which(dat2014$hydro == "Wet")])
}
  
if (list$X2012.2013[i]==1 & list$X2013.2014[i] == 1 ){
  tot <- tot2013 + tot2014
  wet <- wet2013 + wet2014
  flowperm <- wet/tot
}

if (list$X2012.2013[i]==1 & list$X2013.2014[i] == 0){
  tot <- tot2013
  wet <- wet2013
  flowperm <- wet/tot
}
  
if (list$X2012.2013[i]== 0 & list$X2013.2014[i] ==1){
  tot <- tot2014
  wet <- wet2014
  flowperm <- wet/tot
}

df[i, ] <- cbind(as.character(list$Sensor[i]), tot, wet, wet/tot)

}
ER_Flowperm <- df
