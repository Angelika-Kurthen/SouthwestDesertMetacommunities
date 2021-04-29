###########################################################
## OCH Drainage Analyses
###########################################################

library(MASS)
library(geoR)
library(readxl)
library(vegan)
library(tidytable)
library(dplyr)

Drainages <- #identify the different drainages
  c(
    "Ash Canyon",
    "Garden Canyon",
    "Great Falls Basin",
    "Huachuca Canyon",
    "Water Canyon",
    "San Andres Canyon"
  )

#load metacom data
DrainMetacom_Sorted <- read.csv("~/SouthwestDesertMetacommunities/Private-MetacommunityData/CleanOCHData/DrainMetacom_Sorted.csv")

drainage_lm <- data.frame() #want empty dataframes
drainagelist <- data.frame()
for (i in Drainages){ # cycle through each drainage, season, year and get dissimilarities, combine either in to grouped means or include all values
  for (j in c(2012, 2013)){
    for (k in c("Fall", "Spring")){
      a <- DrainMetacom_Sorted[which(
        (DrainMetacom_Sorted$Drainage == i) & 
          (DrainMetacom_Sorted$DAY.MONTH.YEAR == j) & 
          (DrainMetacom_Sorted$Season == k) &
          is.na(DrainMetacom_Sorted$Site) == F),]
      if (length(a$Drainage) < 1 ){
        g <- "DNE"
      }else{
        b <- as.data.frame(pivot_wider.(a, names_from = Taxa, values_from = Count, id_cols = Site ))
        c <- b[ , -(1)]
        c[is.na(c)] = 0
        d <- as.matrix(c)
        e <- vegdist(d, "chao", na.rm = T)
        f <- as.vector(e)
        g <- mean(f)
      }
      h <- cbind(paste(i), paste(k), paste(j), g)
      drainagelist <- rbind(drainagelist, h)
      n <- cbind(rep(paste(i), length(f)), rep(paste(k), length(f)), rep(paste(j), length(f)), f)
      drainage_lm <- rbind(drainage_lm, n)
    }}}
colnames(drainage_lm) <- c("Drainages", "Season", "Year", "Chao")

#weighted average flow perm of each drainage 
ER_OCH_Match <- read_excel("~/SouthwestDesertMetacommunities/Private-MetacommunityData/RawData/ER_OCH_Match.xlsx")  # get sensor site match data 

counts <- ER_OCH_Match %>% group_by(Basin, Sensor) %>% dplyr::summarize(count=n()) # count the number of sensors by site

weights <- data.frame() # empty data frame
for (i in Drainages){
  drain <- as.data.frame(counts[which(counts$Basin == i ), ]) # for each drainage, get the number of each sensor and determine weight
  total <- sum(drain$count)
  wt <- as.data.frame(drain$count/total)
  weighted <- cbind(drain, wt)
  weights <- rbind(weights, weighted)
}

Weighted_Flow <- merge(ER_Flowperm, weights, by = "Sensor") # combine weights with flowperm data
Weighted_Flow$flowperm <- as.numeric(as.character(Weighted_Flow$flowperm)) # convert from characters to numbers
we
weightedmeans <- vector()
for(i in Drainages){ #cycle through each drainage and get the weighted means of flow permanance 
  rows <- as.data.frame(Weighted_Flow[which(Weighted_Flow$Basin == i), ])
  mean <- weighted.mean(rows$flowperm, rows$`drain$count/total`)
  weightedmeans <- c(weightedmeans, mean)
} 
weightedmeans <- as.data.frame(cbind(Drainages, weightedmeans)) # combine with drainage info


weighted_mean_dataframe <- merge(drainage_lm, weightedmeans, by = "Drainages") # combine the Chao dissimilarities with the weighted flowperm means
weighted_mean_dataframe$Chao <- as.numeric(as.character(weighted_mean_dataframe$Chao)) # make sure the numbers are numeric
weighted_mean_dataframe$weightedmeans <- as.numeric(as.character(weighted_mean_dataframe$weightedmeans)) 

#plot of all the weighted avg flow permanences x Chao dissimilarity 
ggplot(data = weighted_mean_dataframe, aes(x = weightedmeans, y = Chao))+
  geom_point()+
  stat_smooth(se = T, method = lm)

#all lumped


hist(weighted_mean_dataframe$Chao, xlab = "Chao Dissimilarity", main= "Grouped Drainage Chao Dissimilarity")

# in fact, we have a bimodal distribution, which is quite interesting

hist(weighted_mean_dataframe$Chao[which(weighted_mean_dataframe$Drainages == "Great Falls Basin")], xlab = "Chao Dissimilarity", main = "Great Falls Basin Chao")

hist(weighted_mean_dataframe$Chao[which(weighted_mean_dataframe$Drainages == "Water Canyon")], xlab = "Chao Dissimilarity", main = "Water Canyon Chao")


                                        | weighted_mean_dataframe$Drainages == "Water Canyon")], xlab = "Chao Dissimilarity", main = "China Lake Chao Dissimilarity") # in fact, we have a bimodal distribution, which is quite interesting
hist(weighted_mean_dataframe$Chao[which(weighted_mean_dataframe$Drainages == "Huachuca Canyon" 
                                        | weighted_mean_dataframe$Drainages == "Garden Canyon")], xlab = "Chao Dissimilarity") # in fact, we have a bimodal distribution, which is quite interesting
hist(weighted_mean_dataframe$Chao[which(weighted_mean_dataframe$Drainages == "Ash Canyon" 
                                       | weighted_mean_dataframe$Drainages == "San Andres Canyon")]) # in fact, we have a bimodal distribution, which is quite interesting


ggplot(data = weighted_mean_dataframe, aes(x = weightedmeans, y = Chao))+
  geom_point()+
  stat_smooth(se = T, method = lm)



lm <- lm(weighted_mean_dataframe$Chao ~ weighted_mean_dataframe$weightedmeans)
plot(lm)
shapiro.test(residuals(lm))

bc <- boxcox(weighted_mean_dataframe$Chao ~ weighted_mean_dataframe$weightedmeans)
boxcoxfit(weighted_mean_dataframe$Chao)


anova(lm)  
summary(lm) # non sig

lm_drain <- lm(weighted_mean_dataframe$Chao ~ weighted_mean_dataframe$Chao + weighted_mean_dataframe$Drainages)
plot(lm_drain)
shapiro.test(residuals(lm_drain))
anova(lm_drain) # interaction is sig
summary(lm_drain)
