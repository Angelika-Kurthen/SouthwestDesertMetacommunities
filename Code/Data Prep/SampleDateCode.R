#############################################
# Code to match sample dates with sample ID
#############################################

# install necessary libraries
require(readxl)
require(lubridate)
#read in pre-sorted OCH data 
OCHData <- read.table("Private-MetacommunityData/CleanData/DrainMetacom_Sorted.csv", header = T, sep = ",")

#read in unsorted dates
DesertMetacommunityDataset <- read_excel("Private-MetacommunityData/RawData/DesertMetacommunityDataset.xlsx", 
                                         sheet = "Full Database OCH Only", col_types = c("skip", 
                                         "text", "text", "text", "text", "text", 
                                         "date", "skip", "skip", "skip", "skip", 
                                         "skip", "skip", "skip", "skip", "skip"))

# we need to join our OCHData sites and the DesertMetacommunityDataset sites so we can match dates
# here is what I want to do:
# for each year, I want to find the couple sample dates 

rm(datetable)
datetable <- data.frame(State = character(0), Drainage = character(0), Site = character(0), Season = character(0), `DAY/MONTH/YEAR` = character(0))
for (i in levels(factor(OCHData$Site))){
  for (j in c("Spring", "Fall")){
    for (k in c(2012, 2013)){
      sub <- as.data.frame(DesertMetacommunityDataset[which(DesertMetacommunityDataset$Site == i & DesertMetacommunityDataset$Season == j & 
                                        substr(DesertMetacommunityDataset$`DAY/MONTH/YEAR`, 1, 4) == k),])
      table <- unique(sub[ ,c(1,2,3,4,6)])
      datetable <- rbind(datetable, table)
    }
  }
}
# now I want to find the date for the month before the first sample of the season
i = "HuNF"
j = "Fall"
k = 2013

MonthPrior <- vector()
for (i in levels(factor(datetable$Site))){
  for (j in c("Spring", "Fall")){
    for (k in c(2012, 2013)){
      set <- as.data.frame(datetable[which(datetable$Site == i & datetable$Season == j
                                             & substr(datetable$`DAY/MONTH/YEAR`, 1, 4) == k),])
      if ((set$State) > 1){
      a <- set[which(set$`DAY/MONTH/YEAR` == min(set$`DAY/MONTH/YEAR`)),]
      b <- a[1,5]-months(1)
  
      } else {
      
  }
    }
  }
}



datetable[1,5] < datetable[1,5]-months(1)
datetable[1,5]-months(1)
