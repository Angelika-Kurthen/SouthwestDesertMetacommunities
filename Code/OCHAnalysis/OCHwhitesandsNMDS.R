#################################################
## OCH NMDS

# First load the vegan package
library(vegan)
library(plyr)
library(tidytable)
library(dplyr)
library(readxl)
library(stringr)
library(ggplot2)
library(RColorBrewer)
library(viridis)



sitespecies <-  as.data.frame(pivot_wider.(DrainMetacom, names_from = Taxa, values_from = Count, id_cols = c(Site, Drainage, Season, `DAY.MONTH.YEAR`)))

#isolate white sands data
whitesands <- sitespecies[which(sitespecies$Drainage == "Ash Canyon" | sitespecies$Drainage == "San Andres Canyon"), ]

#remove any species with a column sum of 0 and any sites with a row sum of 0
whitesands <- whitesands[ , c(1,3, which(colSums(whitesands[ ,5:101]) != 0))]
whitesands <- whitesands[which(rowSums(whitesands[ ,5:55]) != 0), ]

# 
white_sands_nmds_results <- metaMDS(comm = whitesands[1:19 ,5:55],  # Define the community data 
                        distance = "chao", k = 2,       # Specify a  distance
                        try = 100)               # Number of iterations 

data_scores <- as.data.frame(scores(white_sands_nmds_results))

# Now add the extra aquaticSiteType column
data_scores <- cbind(data_scores, whitesands[1:19, c(1:4)])


# Next, we can add the scores for species data
species_scores <- as.data.frame(scores(white_sands_nmds_results, "species"))

# Add a column equivalent to the row name to create species labels
species_scores$species <- rownames(species_scores)

env_ws <- merge(data_scores, env)
envr <- env_ws[ , c(8:17,21)]
en <- envfit(white_sands_nmds_results$points, env = envr, permutations = 999, na.rm = TRUE)

en_coord_cont = as.data.frame(scores(en, "vectors")) 



* ordiArrowMul(en)



# Now we can build the plot
ggplot(data_scores, aes(x = NMDS1, y = NMDS2, color = Drainage))+
  geom_point()+
  stat_ellipse(data = data_scores, aes(x = NMDS1, y = NMDS2, group = Drainage), level =0.334)+
  geom_segment(aes(x = 0, y = 0, xend = MDS1, yend= MDS2), 
               data = en_coord_cont, size =1, alpha = 0.5, colour = "grey30") +
  geom_text(data = en_coord_cont, aes(x = MDS1, y = MDS2), colour = "grey30", 
            fontface = "bold", label = row.names(en_coord_cont))

               