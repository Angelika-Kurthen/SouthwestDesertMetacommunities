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

ER_OCH_Match
ER_Flowperm


hydro_group <- vector()
for (i in 1:length(weighted_mean_dataframe$weightedmeans)){
  if (weighted_mean_dataframe$weightedmeans[i] >= 0.8 ){
    hydro_group[i] <- "Perennial"
  }
  if (weighted_mean_dataframe$weightedmeans[i] >= 0.6 & weighted_mean_dataframe$weightedmeans[i] < 0.8){
    hydro_group[i] <- "Intermittent"
  }
  if (weighted_mean_dataframe$weightedmeans[i] < 0.6){
    hydro_group[i] <- "Ephemeral"
  }
}

weighted_mean_dataframe <- cbind(drainage_lm, hydro_group)
weighted_mean_dataframe$Chao <- as.numeric(as.character(weighted_mean_dataframe$Chao))

ggboxplot(weighted_mean_dataframe, x = "hydro_group", y = "Chao")
TukeyHSD(aov(data = weighted_mean_dataframe, weighted_mean_dataframe$Chao ~ weighted_mean_dataframe$hydro_group))

hydro_group <- c(rep("Ephemeral", times = 4), rep("Intermittent", times = 4), rep("Perennial", times = 4), rep("Intermittent", time = 12))


drainagelist <- cbind(drainagelist, hydro_group)
drainagelist$g <- as.numeric(as.character(drainagelist$g))


hydrocompare <- list(c("Perennial", "Intermittent"), c("Perennial", "Ephemeral"), "Intermittent", "Ephemeral")
 
aov1 <- aov(drainagelist$g ~ drainagelist$hydro_group)
stat.test <- tukey_hsd(aov1)

s <- ggboxplot(drainagelist, x = "hydro_group", y = "g", color = "hydro_group", palette = c("#7570B3","#D95F02","black"), ylab = "Chao Dissimilarity", xlab = "")
s + stat_compare_means(comparisons = hydrocompare)+ 
  stat_compare_means(method = "anova", label.y = 1.5)+
  stat_pvalue_manual(stat.test, label = "p.adj", y.position = c(1.1, 1.3, 1.5))

flowperm <- c(rep(mean(as.numeric(as.character(ER_Flowperm$flowperm[1:4]))), 4),
rep(mean(as.numeric(as.character(ER_Flowperm$flowperm[5:11]))), 4),
rep(mean(as.numeric(as.character(ER_Flowperm$flowperm[12:15]))), 4),
rep(mean(as.numeric(as.character(ER_Flowperm$flowperm[16:22]))), 4),
rep(mean(as.numeric(as.character(ER_Flowperm$flowperm[23:24]))), 4),
rep(mean(as.numeric(as.character(ER_Flowperm$flowperm[25:28]))), 4))
drainagelist <- cbind(drainagelist, flowperm)
plot(drainagelist$flowperm, drainagelist$g)
line <- lm(drainagelist$g ~ drainagelist$flowperm)
summary(line)

hydro_list <- vector()
for(i in 1:length(drainage_lm$Drainages)){
  if (drainage_lm$Drainages[i] == "Ash Canyon"){
    hydro_list[i] <- "Ephemeral"
  }
  if (drainage_lm$Drainages[i] == "Garden Canyon" | drainage_lm$Drainages[i] == "Huachuca Canyon" | drainage_lm$Drainages[i] == "Water Canyon" | drainage_lm$Drainages[i] == "San Andres Canyon"){
    hydro_list[i] <- "Intermittent"
  }
  if (drainage_lm$Drainages[i] == "Great Falls Basin"){
    hydro_list[i] <- "Perennial"
  }
}

flowperms <- vector()
for(i in 1:length(drainage_lm$Drainages)){
    if (drainage_lm$Drainages[i] == "Ash Canyon"){
      flowperms[i] <- 0.2991587
    }
    if (drainage_lm$Drainages[i] == "Garden Canyon"){
      flowperms[i] <- 0.7321304
    } 
  if (drainage_lm$Drainages[i] == "Great Falls Basin"){
    flowperms[i] <- 0.8935106
  }
  if (drainage_lm$Drainages[i] == "Huachuca Canyon"){
    flowperms[i] <- 0.5467659
  }
  if (drainage_lm$Drainages[i] == "Water Canyon"){
    flowperms[i] <- 0.5365151
  }  
  if (drainage_lm$Drainages[i] == "San Andres Canyon"){
    flowperms[i] <- 0.5313677}
  }

drainage_lm <- as.data.frame(cbind(drainage_lm, hydro_list))
drainage_lm <- cbind(drainage_lm, flowperms)
drainage_lm$Chao <- as.numeric(as.character(drainage_lm$Chao))
drainage_lm$flowperms <- as.numeric(as.character(drainage_lm$flowperms))

aov2 <- aov(drainage_lm$Chao~ drainage_lm$hydro_list)
stat.test2 <- tukey_hsd(aov2)

q <- ggboxplot(data = drainage_lm, x = "hydro_list", y = "Chao", color = "hydro_list", palette = c("#7570B3","#D95F02","black"), ylab = "Chao Dissimilarity", xlab = "")
q + stat_compare_means(method = "anova", label.y = 1.5)+
  stat_pvalue_manual(stat.test2, label = "p.adj", y.position = c(1.1, 1.3, 1.5))

full <- aov(drainage_lm$Chao ~ drainage_lm$hydro_list)
TukeyHSD(full)

plot(drainage_lm$flowperms, drainage_lm$Chao)
fulllm <- lm(drainage_lm$Chao ~ drainage_lm$flowperms)
summary(fulllm)

ggplot(data = drainage_lm, aes(x = flowperms, y = Chao ))+
  geom_point()+
  theme_bw()+
  labs(x = "Flow Permanence")+
  xlim(0, 1)+ 
  stat_smooth(se = T, method = "lm", col = "orange")+
  geom_text(aes(x = 0.12, y = 0.95), label = "y = 0.15 + 0.64x")+
  geom_text(aes(x = 0.12, y = 0.85), label = "R2 = 0.08")+
  theme(text = element_text(size=14))+
  geom_text(aes(x = 0.12, y = 0.75), label = "p = 5.954e-08")
            