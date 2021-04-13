###############################################
# Code to determine basin-wide species richness
###############################################

library("tidyverse")

#Import species site data
DrainMetacom_Sorted <- read.csv("~/SouthwestDesertMetacommunities/Private-MetacommunityData/RawData/DrainMetacom_Sorted.txt")

#We need to reorganize species site data

basins <- c("Ash Canyon", "Garden Canyon", "Great Falls Basin", "Huachuca Canyon", "San Andres Canyon", "Water Canyon")

taxon_richness <- vector()
for (i in 1:length(basins)){
  output <- as.data.frame(pivot_wider(DrainMetacom_Sorted[which(DrainMetacom_Sorted$Drainage == basins[i]),], names_from = Taxa, values_from = Count, id_cols = Site, values_fill = list(Count = 0), values_fn = list(Count = sum) ))
  output[is.na(output)] <- 0
  output <- colSums(output[-1])
  sums <- sum(replace(output, which(output > 0), 1))
  taxon_richness[i] <- sums
}

taxon_richness <- cbind(as.data.frame(basins), as.data.frame(taxon_richness))
