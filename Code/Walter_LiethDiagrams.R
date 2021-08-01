# Code to make Walter Climate Diagrams

# Walter Climate Diagrams show different climate patterns in each of the three deserts 

library(readxl)
library(ggplot2)
library(climatol)


par(mfrow = c(1,1))

#read in China Lake climate data
CLClimateData <- as.data.frame(read_excel("Private-MetacommunityData/RawData/ClimateData.xlsx", sheet = "ChinaLake"))

#use diagwl to make a walter leith diagram
clwl <- diagwl(CLClimateData[,-1], est = "China Lake, CA", alt = 68.3, per= "1978-2012", margen = c(4,4,5,4), mlab = "en")
# add some labels to make everything clearer
clwl <- clwl + mtext("Avg. Temp.", side = 3, line = 1, adj = 0.59, cex = 0.9) +
  mtext("Annual Precip.", side = 3.5, line = 1, adj = 0.85, cex = 0.9)+
  mtext("Max", side = 2, line = -0.5, at = 0.6, las=1)+
  mtext("Min", side = 2, line = -0.5, at = 0.27, las = 1)

#read in Fort Huachuca climate data
FHClimateData <- as.data.frame(read_excel("Private-MetacommunityData/RawData/ClimateData.xlsx", sheet = "FortHuachuca"))

#use diagwl to make a walter leith diagram
fhwl <- diagwl(FHClimateData[,-1], est = "Ft. Huachuca, AZ", alt = 142, per = "1900-2012", margen = c(4,4,5,4), mlab = "en")

#add some labels to make everything clearer
fhwl <- fhwl + mtext("Avg. Temp.", side = 3, line = 1, adj = 0.59, cex = 0.9) +
  mtext("Annual Precip.", side = 3.5, line = 1, adj = 0.85, cex = 0.9)+
  mtext("Max", side = 2, line = -0.5, at = 0.6, las=1)+
  mtext("Min", side = 2, line = -0.5, at = 0.27, las = 1)


# read in White Sands climate data 
WSClimateData <- as.data.frame(read_excel("Private-MetacommunityData/RawData/ClimateData.xlsx", sheet = "WhiteSands"))
# use diagwl to make walter leith diagram
wswl <- diagwl(WSClimateData[,-1], est = "White Sands, NM", alt = 122, per = "1939-2012", margen = c(4,4,5,4), mlab = "en")
# add labels
wswl <- wswl + mtext("Avg. Temp.", side = 3, line = 1, adj = 0.59, cex = 0.9) +
  mtext("Annual Precip.", side = 3.5, line = 1, adj = 0.85, cex = 0.9)+
  mtext("Max", side = 2, line = -0.5, at = 0.6, las=1)+
  mtext("Min", side = 2, line = -0.5, at = 0.27, las = 1)

