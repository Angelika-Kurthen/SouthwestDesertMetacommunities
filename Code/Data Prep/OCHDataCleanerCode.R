###################################
# Code to Clean Raw OCH Data
###################################

#clear environment
rm(list = ls())

# We need to clean up our data
#------------------------------------------------------------------------------------------
library(tidytable)
library(dplyr)
library(readxl)
library(stringr)
library(vegan)
library(ggplot2)

DesertMetacommunityDataSet <- read_excel("Private-MetacommunityData/RawData/DesertMetacommunityDataset.xlsx", sheet = "Full Database OCH Only")
#we don't need the last 3 columns right now
DesertMetacommunityDataSet <- DesertMetacommunityDataSet[-c(14, 15, 16)]

#let us look at the structure
str(DesertMetacommunityDataSet)
#we want the state to be a factor
DesertMetacommunityDataSet$State <- as.factor(DesertMetacommunityDataSet$State)
str(DesertMetacommunityDataSet)
levels(DesertMetacommunityDataSet$State)

#we want all NM: White Sands to factors together
a <- print(which(DesertMetacommunityDataSet$State == "NM: White sands"))

for (i in a){
  DesertMetacommunityDataSet$State[i] <- "NM: White Sands"
}

#we want the Drainage to be a factor
DesertMetacommunityDataSet$Drainage <- as.factor(DesertMetacommunityDataSet$Drainage)
levels(DesertMetacommunityDataSet$Drainage)


#want to be able to factor by site
DesertMetacommunityDataSet$Site <- as.factor(DesertMetacommunityDataSet$Site)

#want to be able to factor by season
DesertMetacommunityDataSet$Season <- as.factor(DesertMetacommunityDataSet$Season)
levels(DesertMetacommunityDataSet$Season)

#want to be able to factor by year
#we first need to convert dates into years
Year <- substr(DesertMetacommunityDataSet$`DAY/MONTH/YEAR`, 1, 4)
DesertMetacommunityDataSet$`DAY/MONTH/YEAR` <- Year
DesertMetacommunityDataSet$`DAY/MONTH/YEAR` <- as.factor(DesertMetacommunityDataSet$`DAY/MONTH/YEAR`)


# We will be only be looking at these Drainages: 
# Ash Canyon, Garden Canyon, Great Falls Basin, Huachuca Canyon, Water Canyon, Salt Creek (2 from each region)

AC <- subset.data.frame(DesertMetacommunityDataSet, Drainage == "Ash Canyon" & (Season == "Fall" | Season == "Spring"))
GC <- subset.data.frame(DesertMetacommunityDataSet, Drainage == "Garden Canyon" & (Season == "Fall" | Season == "Spring"))

GFB <- subset.data.frame(DesertMetacommunityDataSet, Drainage == "Great Falls Basin" & (Season == "Fall" | Season == "Spring"))
HC <- subset.data.frame(DesertMetacommunityDataSet, Drainage == "Huachuca Canyon" & (Season == "Fall" | Season == "Spring"))
WC <- subset.data.frame(DesertMetacommunityDataSet, Drainage == "Water Canyon" & (Season == "Fall" | Season == "Spring"))
SA <- subset.data.frame(DesertMetacommunityDataSet, Drainage == "San Andres Canyon" & (Season == "Fall" | Season == "Spring"))

MetacommunityDrainages <- rbind(AC, GC, GFB, HC, WC, SA)


# we have about 202 sites we want to look at
# each sites has about 5 subsamp
Subsamples <- levels(factor((MetacommunityDrainages$`Sample ID`)))

c <- matrix(data = NA, nrow = length(Subsamples), ncol = 4)
for (i in 1:length(Subsamples)){
  a <- DrainageHabitats[which(DrainageHabitats$`Sample Code with Date` == Subsamples[i]), ]
  c[i,1] <- Subsamples[i]
  c[i,2] <- a$SampleHydro
  c[i,3] <- a$Season
  c[i,4] <- a$Years
}

d <- c(rep("Ash ",55), rep("Garden", 70), rep("GFB", 62), rep("Huachuca", 76), rep("San", 36), rep("Water", 59))
Drainage_conn<- as.data.frame(cbind(c, d))

conn_levels <- levels(factor(Drainage_conn$d))
e <- c("Spring", "Fall")
f <- c("2012", "2013")
conn_df1 <- list()
conn_df2<- list()
conn_df3 <- list()
conn_df4 <- list()
for (i in 1:length(rep(conn_levels))){ 
 for (j in e){
    for (k in f){
      a <- Drainage_conn[which(Drainage_conn$d == conn_levels[i] & Drainage_conn$V3 == j & Drainage_conn$V4 == k),]
      b <- length(a[,1])
      c <- a[which(a$V2 == "intermittent"),]
      d <- length(c[,1])
      conn_df1 <- c(conn_df1, conn_levels[i])
      conn_df2 <- c(conn_df2, j)
      conn_df3 <- c(conn_df3, k)
      conn_df4 <- c(conn_df4, d/b)
    }
  }
}

conn_df1 <- unlist(conn_df1)
conn_df2 <- unlist(conn_df2)
conn_df3 <- unlist(conn_df3)
conn_df4 <- unlist(conn_df4)
conn_df <- cbind(conn_df1, conn_df2, conn_df3, conn_df4) # no results for spring 2012 in san andres canyon

#perhaps divide into fully perennial vs intermittent


#make a few brute force adjustments
a <- print(which(MetacommunityDrainages$Taxa == "Aeschna multicolor"))

for (i in a){
  MetacommunityDrainages$Taxa[i] <- "Rhionaeschna multicolor"
}

a <- print(which(MetacommunityDrainages$Taxa == "Coenagrion / Enallagma"))
           
for (i in a){
  MetacommunityDrainages$Taxa[i] <- "Enallagma"
} 

a <- print(which(MetacommunityDrainages$Taxa == "Aeschnidae"))

for (i in a){
  MetacommunityDrainages$Taxa[i] <- "Aeshnidae"
}

a <- print(which(MetacommunityDrainages$Taxa == "Aeschna"))

for (i in a ){
  MetacommunityDrainages$Taxa[i] <- "Aeshna"
}


MetacommunityDrainages$Taxa <- gsub("\\s*\\([^\\)]+\\)","",as.character(MetacommunityDrainages$Taxa))

#resolve ambiguous data at subsample level
#family to genus level 
newdata <- data.frame()
for(j in 1:length(Subsamples)){
  a <- MetacommunityDrainages[which(MetacommunityDrainages$`Sample ID` == Subsamples[j]), ]
  for(i in unique(a$Family)){
  fam=subset(a,a$Family==i)
  if (length(fam$Family) <= 1){
    fam$proportion <- NA
    newdata <- rbind(newdata, fam)
  }else{
  x=as.numeric(sum(fam[which(!is.na(fam$`Genus/sub-genus`)),]$Count))
  fam$proportion=fam$Count/x; fam[which(is.na(fam$`Genus/sub-genus`)),]$proportion=NA
  y=as.numeric(fam[which(is.na(fam$`Genus/sub-genus`)),]$Count)
  if (length(y) == 0){
    newdata <- rbind(newdata, fam)
  } else {
    fam$Count=fam$Count+(y*fam$proportion)
    newdata <- rbind(newdata,fam)
  }
  }}}
#now from genus to species

newdata2 <- data.frame()
for(j in 1:length(Subsamples)){
  a <- newdata[which(newdata$`Sample ID` == Subsamples[j]), ]
  for(i in unique(a$`Genus/sub-genus`)){
    gen=subset(a,a$`Genus/sub-genus`==i)
    if (length(gen$`Genus/sub-genus`) <= 1){
      gen$proportion <- NA
      newdata2 <- rbind(newdata2, gen)
    }else{
      x=as.numeric(sum(gen[which(!is.na(gen$Species)),]$Count))
      gen$proportion=gen$Count/x; gen[which(is.na(gen$Species)),]$proportion=NA
      y=as.numeric(gen[which(is.na(gen$Speices)),]$Count)
      if (length(y) == 0){
        newdata2 <- rbind(newdata2, gen)
      } else {
        gen=gen$Count+(y*gen$proportion)
        newdata2 <- rbind(newdata2,gen)
      }
    }}}

#now sort by site
agg <- newdata2 %>% 
  group_by(Drainage, Site, Season, `DAY/MONTH/YEAR`, Family, `Genus/sub-genus`, Species, Taxa) %>% 
  summarise(Count = sum(Count))

NamesList <- c("ASH_LAS", "ASH_SCS", "ASH_SNS", "ASH_UAIS", "ASH_UAL" ,"ASH_UAU",  "GaC", "GaCASP",
               "GaMCT" , "GaS" , "GaUP" , "GaW", "GaMCSY", "GaMCCH", "GaM", "GaL", "GFB_ARR" , 
               "GFB_BUU" , "GFB_MAIN", "GFB_Nfmort", "GFB_NFHill", "GFB_SSA", "GFB_UU", "GFB_TRL", 
               "GFB_BFF", "GFB_AFF", "GFB_BFFC", "GFB_BUU" , "HuBR", "HuF", "HuG" , "HuNF", "HuTL", 
               "HuTU", "HuM", "HuL", "HuC", "HuA", "SAL_MAL", "SAN_SASL", "SAN_SASU", "SAN_UU",
               "WAT_BFS1", "WAT_BFS2", "WAT_BR", "WAT_LM" , "WAT_Main_HRS", "WAT_MAM" , "WAT_SFBN", 
              "WAT_SFBP", "WAT_MAIN_CON", "WAT_SFAC", "WAT_SFBP")

newdata3 <- data.frame()
for (i in NamesList){
  for (j in c(2012, 2013)){
    for (k in c("Fall", "Spring")){
      a <- newdata2[which((newdata2$Site == i) & (newdata2$`DAY/MONTH/YEAR` == j) & (newdata2$Season == k)), ]
      a <- as.data.frame(a)
      b <- length(a$Site)
      if (b <= 1){
        print("Site DNE")
      }else{
      for(l in unique(a$Family)){
        fam=subset(a,a$Family==l)
        x=as.numeric(sum(fam[which(!is.na(fam$`Genus/sub-genus`)),]$Count))
        fam$proportion=fam$Count/x
        #fam[which(is.na(fam$`Genus/sub-genus`)),]$proportion=NA
        y= as.numeric(fam[which(is.na(fam$`Genus/sub-genus`)),]$Count)
        if(length(y) == 0){
          newdata3 <- rbind(data.frame(newdata3), data.frame(fam))
          print("No overlaps")
        } else {
          fam$Count=fam$Count+(y*fam$proportion)
          newdata3 <- rbind(data.frame(newdata3),data.frame(fam))
          "Done"
        }
      }
      }
    }}}


# look at drainges indiviudally
Drainages <- c("Ash Canyon", "Garden Canyon", "Great Falls Basin", "Huachuca Canyon", "Water Canyon", "San Andres Canyon")
agg2 <- agg
for (i in Drainages){
  for (j in c(2012, 2013)){
    for (k in c("Fall", "Spring")){
      a <- subset(agg2, agg2$Drainage == i & agg2$`DAY/MONTH/YEAR` == j & agg2$Season == k)
      b <-paste0(i, j, k)
      assign(b, a)
    }}}

`Garden Canyon2012Fall`[which(`Garden Canyon2012Fall`$Taxa == "Helichus Triangularis"),]$Taxa = "Helichus triangularis"

# we have some genuses that need to be reconciled with species that they are likely to be
# in that case, we have to take the count that went to the genus and add it to the species count

GenusSpecies(basin = `Ash Canyon2012Fall`, genus = "Anax", species1 = "Anax longipes", species2 = 0)
GenusSpecies(basin = `Ash Canyon2013Fall`, genus = "Peltodytes", species1 = "Peltodytes dispersus", species2 = 0)
GenusSpecies(basin = `Ash Canyon2013Fall`, genus = "Helichus", species1 = "Helichus triangularis", species2 = 0)
GenusSpecies(basin = `Garden Canyon2012Fall`, genus = "Helichus", species1 = "Helichus triangularis", species2 = "Helichus lithophilus")
GenusSpecies(basin = `Garden Canyon2012Fall`, genus = "Postelichus", species1 = "Postelichus confluentus", species2 = 0)
GenusSpecies(basin = `Garden Canyon2012Fall`, genus = "Helichus", species1 = "Helichus triangularis", species2 = 0)
GenusSpecies(basin = `Great Falls Basin2012Fall`, genus = "Sanfilippodytes", species1 = "Sanfilippodytes villis", species2 = 0)
GenusSpecies(basin = `Great Falls Basin2012Fall`, genus = "Ilybiosoma", species1 = "Ilybiosoma perplexum", species2 = 0)
GenusSpecies(basin = `Huachuca Canyon2012Fall`, genus = "Helichus", species1 = "Helichus triangularis", species2 = "Helichus lithophilus")
GenusSpecies(basin = `Huachuca Canyon2012Spring`, genus = "Helichus", species1 = "Helichus triangularis", species2 = 0 )
GenusSpecies(basin = `Huachuca Canyon2013Fall`, genus = "Helichus", species1 = "Helichus triangularis", species2 = "Helichus suturalis" )
GenusSpecies(basin = `Huachuca Canyon2013Fall`, genus = "Postelichus", species1 = "Postelichus confluentus", species2 = 0)
GenusSpecies(basin = `Huachuca Canyon2013Spring`, genus = "Peltodytes", species1 = "Peltodytes dispersus", species2 = 0)
GenusSpecies(basin = `Huachuca Canyon2013Spring`, genus = "Helichus", species1 = "Helichus triangularis", species2 = "Helichus suturalis")



DrainMetacom <- rbind(`Ash Canyon2012Spring`, `Ash Canyon2012Fall`, `Ash Canyon2013Spring`, `Ash Canyon2013Fall`,
                      `Garden Canyon2012Spring`, `Garden Canyon2012Fall`, `Garden Canyon2013Spring`, `Garden Canyon2013Fall`,
                      `Great Falls Basin2012Spring`, `Great Falls Basin2012Fall`, `Great Falls Basin2013Spring`,`Great Falls Basin2013Fall`,
                      `Huachuca Canyon2012Spring`, `Huachuca Canyon2013Fall`, `Huachuca Canyon2013Spring`, `Huachuca Canyon2013Fall`,
                      `Water Canyon2012Spring`, `Water Canyon2012Fall`, `Water Canyon2013Spring`, `Water Canyon2013Fall`,
                      `San Andres Canyon2012Spring`, `San Andres Canyon2012Fall`, `San Andres Canyon2013Spring`, `San Andres Canyon2013Fall`)
write.csv(DrainMetacom, file = "Private-MetacommunityData/CleanData/DrainMetacom_Sorted.csv")


