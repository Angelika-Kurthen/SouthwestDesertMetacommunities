#########################################################
# Garden Canyon ER Sensor Cleaning Code
########################################################

#install packages and libraries
install.packages("tidyverse")
library (stringr)
library(lubridate)
library(plyr)

#import 2013 data
G1_April2013 <- read.csv("G1_April2013.csv", header=FALSE)
View(G1_April2013)

#isolate date of ER sampeling
G1_April2013 <- G1_April2013[-c(1,2), -c(1,4,5,6,7,8)]
G1_April2013$V2 <- str_sub(G1_April2013$V2, start = 1L, end = 8L)

#get daily means and sort by date
G1_April2013$V3 <- as.numeric(as.character(G1_April2013$V3))
G1_2013 <- aggregate(G1_April2013[, 2], list(G1_April2013$V2), mean)
G1_2013$Group.1 <- mdy(G1_2013$Group.1)
G1_2013 <- arrange(G1_2013, Group.1)
View(G1_2013)

# No 2014 data
# Save
write.csv(G1_2013, file = "G1_CleanedData")


