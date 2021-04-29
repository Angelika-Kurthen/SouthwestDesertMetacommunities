#################################################
## OCH NMDS

# First load the vegan package
library(vegan)
library(tidytable)
library(dplyr)
library(readxl)
library(stringr)
library(ggplot2)
library(RColorBrewer)
library(viridis)


sitespecies <-  as.data.frame(pivot_wider.(DrainMetacom, names_from = Taxa, values_from = Count, id_cols = c(Site, Drainage)))

# 
nmds_results <- metaMDS(comm = sitespecies[2:46, 3:99],  # Define the community data 
                        distance = "chao", k = 2,       # Specify a bray-curtis distance
                        try = 100)               # Number of iterations 

data_scores <- as.data.frame(scores(nmds_results))

# Now add the extra aquaticSiteType column
data_scores <- cbind(data_scores, sitespecies[2:46, 1])


# Next, we can add the scores for species data
species_scores <- as.data.frame(scores(nmds_results, "species"))

# Add a column equivalent to the row name to create species labels
species_scores$species <- rownames(species_scores)

# Now we can build the plot


MDS1 <- nmds_results$points[,1] # get axis 1
MDS2 <- nmds_results$points[,2] # get axis 2
NMDS = data.frame(MDS1 = MDS1, MDS2 = MDS2, group = sitespecies$Drainage[2:46])

brewer.pal(6, "Paired")
col <- c("#A6CEE3", "#1F78B4", "#B2DF8A", "#33A02C","#FB9A99", "#E31A1C")
# need to reorder factoral levels to match colors

NMDS$group <- factor(NMDS$group, levels = c("Ash Canyon", "San Andres Canyon", "Great Falls Basin", "Water Canyon", "Huachuca Canyon", "Garden Canyon"))


# we also want environmental data
env <- env %>% group_by(Site) %>% summarise(`Average Canopy Cover` = mean(`Average Canopy Cover`, na.rm = T),
                                     Bedrock = mean(Bedrock, na.rm = T), 
                                     Cobble = mean(Cobble, na.rm = T),
                                     Silt = mean(Silt, na.rm = T),
                                     Sand = mean(Sand, na.rm = T),
                                     Temperature = mean(Temperature, na.rm = T), 
                                     `Dissolved oxygen` = mean(`Dissolved oxygen`, na.rm = T), 
                                     pH = mean(pH, na.rm = T), 
                                     `Conductivity (microsiemens` = mean(`Conductivity (microsiemens`, na.rm = T)
)

env <- merge(env, ER_OCH_Match, by = "Site")
env <- merge(env, ER_Flowperm, by = "Sensor")

env$flowperm <- as.numeric(as.character(env$flowperm))
envr <- env[-37 , c(3:11,16)]


en <- envfit(nmds_results$points, env = envr, permutations = 999, na.rm = TRUE)

en_coord_cont = as.data.frame(scores(en, "vectors")) * ordiArrowMul(en)
en_coord_cat = as.data.frame(scores(en, "factors")) * ordiArrowMul(en)

ggplot(data = NMDS, aes(x=MDS1, y= MDS2, col= group)) +
  geom_point()+
  stat_ellipse(level = 0.344) +
  theme_bw() +
  theme(axis.text=element_text(size=14))+
  theme(axis.title=element_text(size=14,face="bold"))+ 
  theme(legend.text=element_text(size=12))+
  theme(legend.title=element_text(size=12, face = "bold"))+
  #guides(color=guide_legend(title="Location"))+
  geom_segment(aes(x = 0, y = 0, xend = MDS1, yend = MDS2), 
               data = en_coord_cont, size =1, alpha = 0.5, colour = "grey30") +
  
  geom_text(data = en_coord_cont, aes(x = MDS1, y = MDS2), colour = "grey30", 
            fontface = "bold", label = row.names(en_coord_cont)) + 
  scale_color_manual(name = "Location", labels= c("Ash Canyon","San Andres Canyon", "Great Falls Basin", "Water Canyon", "Huachuca Canyon", "Garden Canyon"), values=c("#A6CEE3", "#1F78B4", "#B2DF8A", "#33A02C", "#FB9A99", "#E31A1C"))


a1 <- adonis(sitespecies[2:46 , 3:99] ~ sitespecies$Site, method = "chao")

# ok so we can clearly divide by desert
# take it to the drainage level for more in-depth analysis
# use d50 instead of silt/sand/cobble

