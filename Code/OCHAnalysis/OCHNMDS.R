#################################################
## OCH NMDS
#################################################
# First load the vegan package
library(vegan)

nmds_results <- metaMDS(comm = test[2:46, 2:98],  # Define the community data 
                        distance = "chao",       # Specify a bray-curtis distance
                        try = 100)               # Number of iterations 

library(ggplot2)
library(viridis)
data_scores <- as.data.frame(scores(nmds_results))

# Now add the extra aquaticSiteType column
data_scores <- cbind(data_scores, test[2:46, 1])


# Next, we can add the scores for species data
species_scores <- as.data.frame(scores(nmds_results, "species"))

# Add a column equivalent to the row name to create species labels
species_scores$species <- rownames(species_scores)

# Now we can build the plot!

ggplot() +
  geom_text(data = data_scores, aes(x = NMDS1, y = NMDS2, label =`test[2:46, 1]`),
            alpha = 0.5, size = 3) +
  geom_point(data = data_scores, aes(x = NMDS1, y = NMDS2,), size = 3) +
  scale_color_manual(values = inferno(15)[c(3, 8, 11)],
                     name = "Aquatic System Type") +
  annotate(geom = "label", x = -1, y = 1.25, size = 1,
           label = paste("Stress: ", round(nmds_results$stress, digits = 3))) +
  theme_minimal() +
  theme(legend.position = "right",
        text = element_text(size = 1))
