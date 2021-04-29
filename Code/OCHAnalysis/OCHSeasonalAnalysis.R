########################################################
## OCH Seasonal Comparison
########################################################

# want to compare seasonal changes in different sites
# compare Fall2012 to Spring 2013, Spring 2013 to Fall 2013, and Fall 2012 to Fall 2013 for each site

library(tidytable)
library(dplyr)
library(readxl)
library(stringr)
library(vegan)
library(ggplot2)



DrainMetacom <- read.csv("~/SouthwestDesertMetacommunities/Private-MetacommunityData/CleanOCHData/DrainMetacom_Sorted.csv")
DrainMetacom <- DrainMetacom[ , -1]
sites <- levels(DrainMetacom$Site)
seasonalsitechao <- data.frame()

for(i in sites){ # cycle through all sites
  a <- DrainMetacom[which(DrainMetacom$Site == i & DrainMetacom$Season == "Fall"  # get Fall 2012 data
                          & DrainMetacom$`DAY.MONTH.YEAR` == 2012),]
  b <-DrainMetacom[which(DrainMetacom$Site == i & DrainMetacom$Season == "Spring" # get Spring 2013 data
                          & DrainMetacom$`DAY.MONTH.YEAR` == 2013),]
if (length(a$Site) < 1 | length(b$Site) < 1){ # if both don't exist, can't compare
  c <- NA
} else {
  c <- seasonchao(a, b)}
  c <- cbind(c, "Fall2012vSpring2013")
  
  d <- DrainMetacom[which(DrainMetacom$Site == i & DrainMetacom$Season == "Fall"  # get Fall 2012 data
                          & DrainMetacom$`DAY.MONTH.YEAR` == 2012),]
  e <- DrainMetacom[which(DrainMetacom$Site == i & DrainMetacom$Season == "Fall" # get Fall 2013 data
                          & DrainMetacom$`DAY.MONTH.YEAR` == 2013),]
  if (length(d$Site) < 1 | length(e$Site) < 1){
    f <- NA
  } else { 
    f <- seasonchao(d, e)
    }
    f <- cbind(f, "Fall2012vFall2013")
    
  g <- DrainMetacom[which(DrainMetacom$Site == i & DrainMetacom$Season == "Spring"  # get Spring 2013 data
                          & DrainMetacom$`DAY.MONTH.YEAR` == 2013),]
  h <- DrainMetacom[which(DrainMetacom$Site == i & DrainMetacom$Season == "Fall" # get Fall 2013 data
                          & DrainMetacom$`DAY.MONTH.YEAR` == 2013),]
  if (length(g$Site) < 1 | length(h$Site) < 1){
    l <- NA
  } else { 
    l <- seasonchao(g, h)}
    l <- cbind(l, "Spring2013vFall2013")
  
  m <- rbind(c,  f , l)
  n <- as.data.frame(cbind(rep(paste(i),length(m)), m))
  seasonalsitechao<- rbind(seasonalsitechao, n)
  seasonalsitechao <- na.omit(seasonalsitechao)
  }

# need to merge seasonsitechao with OCH ER Match
colnames(seasonalsitechao) <- c("Site", "Chao", "Comparison")
ER_OCH_Match <- read_excel("Private-MetacommunityData/RawData/ER_OCH_Match.xlsx")

seasonalsitechao <- merge(seasonalsitechao, ER_OCH_Match, by = "Site")
seasonalsitechao <- merge(seasonalsitechao, ER_Flowperm, by = "Sensor")

seasonalsitechao$Chao <- as.numeric(as.character(seasonalsitechao$Chao))
seasonalsitechao$flowperm <- as.numeric(as.character(seasonalsitechao$flowperm))

ggplot(data = seasonalsitechao, aes(x = flowperm, y = Chao, col = ))+
  geom_point()+
  stat_smooth(se = T, method = lm)+
  facet_grid(.~Basin)
  
  
hist(seasonalsitechao$Chao)
  
hist(seasonalsitechao$Chao[which(seasonalsitechao$Basin == "Ash Canyon" | seasonalsitechao$Basin == "San Andres Canyon")])
