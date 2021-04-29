##################################################
# OCH Habitat Data Cleaner
###################################################


DesertMetacommunityHabitat <- read_excel("Private-MetacommunityData/RawData/DesertMetacommunityDataset.xlsx", sheet = "Habitat 2009-2015")
#------------------------------------------------------------------------------------------
library(tidytable)
library(dplyr)
library(readxl)
library(stringr)
library(vegan)
library(ggplot2)
library(purrrlyr)

source('Code/Data Prep/MetacommunityFunctions.R')


habitat <- DesertMetacommunityHabitat[ , c(2, 3, 6, 8, 21:36)]

#we want the Drainage to be a factor
habitat$Drainage <-
  as.factor(habitat$Drainage)

#want to be able to factor by site
habitat$Site <-
  as.factor(habitat$Site)

#want to be able to factor by season
habitat$Season <-
  as.factor(habitat$Season)


NamesList <-
 

env<- data.frame()
for (i in NamesList) {
  for (j in c(2012, 2013)) {
    for (k in c("Fall", "Spring")) {
      a <-
        habitat[which((habitat$Site == i) &
                         (habitat$Years == j) & (habitat$Season == k)),]
      env <- rbind(env, a)
          }
        }
}

cols <- colnames(env[5:20])

env <- env %>% group_by(Drainage, Site, Season, Years) %>% summarise(`Average Canopy Cover` = mean(`Average Canopy Cover`, na.rm = T),
                                                                        Bedrock = mean(Bedrock, na.rm = T), 
                                                                        Cobble = mean(Cobble, na.rm = T),
                                                                        Silt = mean(Silt, na.rm = T),
                                                                        Sand = mean(Sand, na.rm = T),
                                                                        Temperature = mean(Temperature, na.rm = T), 
                                                                        `Dissolved oxygen` = mean(`Dissolved oxygen`, na.rm = T), 
                                                                        pH = mean(pH, na.rm = T), 
                                                                        `Conductivity (microsiemens` = mean(`Conductivity (microsiemens`, na.rm = T)
                                                                        )
