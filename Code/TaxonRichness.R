###############################################
# Code to determine basin-wide species richness
###############################################

library("tidyverse")

#Import species site data
DrainMetacom_Sorted <- read_csv("Private-MetacommunityData/CleanOCHData/DrainMetacom_Sorted.csv")

#We need to reorganize species site data

basins <- c("Ash Canyon", "Garden Canyon", "Great Falls Basin", "Huachuca Canyon", "San Andres Canyon", "Water Canyon")
Site <-  c(
  "ASH_LAS",
  "ASH_SCS",
  "ASH_SNS",
  "ASH_UAIS",
  "ASH_UAL" ,
  "ASH_UAU",
  "GaC",
  "GaCASP",
  "GaMCT" ,
  "GaS" ,
  "GaUP" ,
  "GaW",
  "GaMCSY",
  "GaMCCH",
  "GaM",
  "GaNF",
  "GaL",
  "GFB_ARR" ,
  "GFB_BUU" ,
  "GFB_MAIN",
  "GFB_Nfmort",
  "GFB_NFHill",
  "GFB_SSA",
  "GFB_UU",
  "GFB_TRL",
  "GFB_BFF",
  "GFB_AFF",
  "GFB_BFFC",
  "GFB_BUU" ,
  "HuBR",
  "HuF",
  "HuG" ,
  "HuNF",
  "HuTL",
  "HuTU",
  "HuM",
  "HuL",
  "HuC",
  "HuA",
  "SAN_SASL",
  "SAN_SASU",
  "SAN_UU",
  "SAN_MID",
  "SAN_INT",
    "WAT_BFS1",
    "WAT_BFS2",
    "WAT_BR",
    "WAT_CC",
    "WAT_LM" ,
    "WAT_Main_HRS",
    "WAT_MAM" ,
    "WAT_SFBN",
    "WAT_SFBP",
    "WAT_MAIN_CON",
    "WAT_SFAC",
    "WAT_SFBP"
  )
taxon_richness <- vector()
for (i in 1:length(Site)){
  output <- as.data.frame(pivot_wider(DrainMetacom_Sorted[which(DrainMetacom_Sorted$Site == Site[i]),], names_from = Taxa, id_cols = Site, values_from = Count, values_fill = list(Count = 0), values_fn = list(Count = sum) ))
  output[is.na(output)] <- 0
  output <- colSums(output[-1])
  sums <- sum(replace(output, which(output > 0), 1))
  taxon_richness[i] <- sums
}
site_taxon_richness <- as.data.frame(cbind(taxon_richness, Site))


site_taxon_richness <- merge(site_taxon_richness, ER_OCH_Match, by = "Site")
site_taxon_richness <- merge(site_taxon_richness, ER_Flowperm, by = "Sensor")
site_taxon_richness <- site_taxon_richness[which(as.numeric(as.character(site_taxon_richness$taxon_richness)) > 0), ]
site_taxon_richness$taxon_richness <- as.numeric(as.character(site_taxon_richness$taxon_richness))
site_taxon_richness$flowperm <- as.numeric(as.character(site_taxon_richness$flowperm))
site_taxon_richness <- cbind(site_taxon_richness, c(rep("White Sands, NM", times = 6), rep("Fort Huachuca, AZ", times = 9), rep("China Lake, CA", times = 10), rep("Fort Huachuca, AZ", times = 5), rep("White Sands, NM", times = 5), rep("China Lake, CA", times = 10)))
site_taxon_richnessres.aov <- aov(taxon_richness ~ Basin, data = site_taxon_richness)
colnames(site_taxon_richness) <- c("Sensor"                                                              
                                   ,"Site"                                                                
                                   ,"taxon_richness"                                                      
                                   ,"Basin"                                                               
                                   ,"Hydrology"                                                           
                                   ,"DaysTotal"                                                           
                                   ,"DaysWet"                                                             
                                   ,"flowperm"                                                            
                                   ,"Region")

library("ggpubr")

# comparing basins to each other
basin_compare <- list(c("Ash Canyon", "San Andres Canyon"), c("Great Falls Basin", "Water Canyon"), c("Garden Canyon", "Huachuca Canyon"))
p <- ggboxplot(site_taxon_richness, x = "Basin", y = "taxon_richness", 
          color = "Basin", palette = c("#A6CEE3", "#1F78B4", "#B2DF8A", "#33A02C","#FB9A99", "#E31A1C"), order = c("Ash Canyon", "San Andres Canyon", "Great Falls Basin", "Water Canyon", "Garden Canyon", "Huachuca Canyon"),
          ylab = "Taxon Richness", xlab = " ") 
p+ theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  stat_compare_means(comparisons = basin_compare)+ 
  stat_compare_means(method = "anova", label.y = 50)

# comparing regions to one another
region_compare <- list(c("White Sands, NM", "Fort Huachuca, AZ"), c("White Sands, NM", "China Lake, CA"), c("Fort Huachuca, AZ", "China Lake, CA"))
q <- ggboxplot(site_taxon_richness, x = "Region", y = "taxon_richness",
               color = "Region", palette = c("#1F78B4", "#33A02C", "#E31A1C"), ylab = "Taxon Richness", xlab = " ", order = c("White Sands, NM", "China Lake, CA", "Fort Huachuca, AZ"))
q+ stat_compare_means(comparison = region_compare)+ 
  stat_compare_means(method = "anova", label.y = 50)


# within basins, comparing differences in flow permanence

# need to create groups
hydro_group <- vector()
for (i in 1:length(site_taxon_richness$flowperm)){
  if (site_taxon_richness$flowperm[i] >= 0.99 ){
    hydro_group[i] <- "Perennial"
  }
  if (site_taxon_richness$flowperm[i] >= 0.5 & site_taxon_richness$flowperm[i] < 0.99){
    hydro_group[i] <- "Intermittent"
  }
  if (site_taxon_richness$flowperm[i] < 0.5){
    hydro_group[i] <- "Ephemeral"
  }
}

site_taxon_richness <- cbind(site_taxon_richness, hydro_group)


whitesands <- subset(site_taxon_richness, Region == "White Sands, NM")
TukeyHSD(aov(whitesands$taxon_richness ~ whitesands$hydro_group))
chinalake <- subset(site_taxon_richness, Region == "China Lake, CA")
TukeyHSD(aov(chinalake$taxon_richness ~ chinalake$hydro_group))
huachuca <- subset(site_taxon_richness, Region == "Fort Huachuca, AZ")
TukeyHSD(aov(huachuca$taxon_richness ~ huachuca$hydro_group))


hydrocompare <- list(c("Perennial", "Intermittent"), c("Perennial", "Ephemeral"), "Intermittent", "Ephemeral")
r <- ggboxplot(site_taxon_richness, x = "hydro_group", y = "taxon_richness", color = "hydro_group", palette = c("#7570B3","#D95F02","black"), ylab = "Taxon Richness", xlab = "Site Hydrology", facet.by = "Region" )
r + 
  stat_compare_means(comparisons = hydrocompare)+ 
  stat_compare_means(method = "anova", label.y = 45)+
theme(axis.text.x = element_text(angle = 45, hjust=1))

