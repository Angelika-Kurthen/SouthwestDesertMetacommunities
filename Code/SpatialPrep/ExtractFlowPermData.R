##########################################################
# Code to extract FlowPermance data for bug relevant flows
###########################################################
library(readr)
# Tried with for loop - wont work 
# see below

# at this point, will have to brute force it

AC_Fall_2012 <- cbind(AC_Fall_2012, FlowPermCalc(dataframe = AC_Fall_2012, season = "Fall", year = "2012", ERData = "2013"))
AC_Spring_2013 <- cbind(AC_Spring_2013, FlowPermCalc(dataframe = AC_Spring_2013, season = "Spring", year = "2013", ERData = "2013"))
AC_Fall_2013 <- cbind(AC_Fall_2013, FlowPermCalc(dataframe = AC_Fall_2013, season = "Fall", year = "2013", ERData = "2013"))

# Problem with WC_Fall_2012 is ER sensors didnt go in until Nov (so ER sensor time would be Nov - Dec --> winter flows start in Dec so reading might be way off)
#WC_Fall_2012 <- cbind(WC_Fall_2012, FlowPermCalc(dataframe = WC_Fall_2012, season = "Fall", year = "2012", ERData = "2013"))
WC_Spring_2013 <- cbind(WC_Spring_2013, FlowPermCalc(dataframe = WC_Spring_2013, season = "Spring", year = "2013", ERData = "2013"))
WC_Fall_2013 <- cbind(WC_Fall_2013, FlowPermCalc(dataframe = WC_Fall_2013, season = "Fall", year = "2013", ERData = "2013"))

GC_Fall_2012 <- cbind(GC_Fall_2012, FlowPermCalc(dataframe = GC_Fall_2012, season = "Fall", year = "2012", ERData = "2013"))
GC_Spring_2013 <- cbind(GC_Spring_2013, FlowPermCalc(dataframe = GC_Spring_2013, season = "Spring", year = "2013", ERData = "2013"))
GC_Fall_2013 <- cbind(GC_Fall_2013, FlowPermCalc(dataframe = GC_Fall_2013, season = "Fall", year = "2013", ERData = "2014"))

HC_Fall_2012 <- cbind(HC_Fall_2012, FlowPermCalc(dataframe = HC_Fall_2012, season = "Fall", year = "2012", ERData = "2013"))
HC_Spring_2013 <- cbind(HC_Spring_2013, FlowPermCalc(dataframe = HC_Spring_2013, season = "Spring", year = "2013", ERData = "2013"))
# Check
HC_Fall_2013 <- cbind(HC_Fall_2013, FlowPermCalc(dataframe = HC_Fall_2013, season = "Fall", year = "2013", ERData = "2014"))

GFB_Fall_2012 <- cbind(GFB_Fall_2012, FlowPermCalc(dataframe = GFB_Fall_2012, season = "Fall", year = "2012", ERData = "2013"))
# check
GFB_Spring_2013 <- cbind(GFB_Spring_2013, FlowPermCalc(dataframe = GFB_Spring_2013, season = "Spring", year = "2013", ERData = "2013"))
# check
GFB_Fall_2013 <- cbind(GFB_Fall_2013, FlowPermCalc(dataframe = GFB_Fall_2013, season = "Fall", year = "2013", ERData = "2013"))

# connection problem - I've edited it but its not showing?


SAN_Fall_2012 <- cbind(SAN_Fall_2012, FlowPermCalc(dataframe = SAN_Fall_2012, season = "Fall", year = "2012", ERData = "2013"))
SAN_Spring_2013 <- cbind(SAN_Spring_2013, FlowPermCalc(dataframe = SAN_Spring_2013, season = "Spring", year = "2013", ERData = "2013"))
SAN_Fall_2013 <- cbind(SAN_Fall_2013, FlowPermCalc(dataframe = SAN_Fall_2013, season = "Fall", year = "2013", ERData = "2013"))



# now save them all as csv files so we can read them into ArcGus or QGis


write.csv(AC_Fall_2012, file = "Private-MetacommunityData/SpatialData/AC_Fall_2012.csv")
write.csv(AC_Spring_2013, file = "Private-MetacommunityData/SpatialData/AC_Spring_2013.csv")
write.csv(AC_Fall_2013, file = "Private-MetacommunityData/SpatialData/AC_Fall_2013.csv")

write.csv(WC_Fall_2013, file = "Private-MetacommunityData/SpatialData/WC_Fall_2013.csv")
write.csv(WC_Spring_2013, file = "Private-MetacommunityData/SpatialData/WC_Spring_2013.csv")

write.csv(GC_Fall_2012, file = "Private-MetacommunityData/SpatialData/GC_Fall_2012.csv")
write.csv(GC_Spring_2013, file = "Private-MetacommunityData/SpatialData/GC_Spring_2013.csv")
write.csv(GC_Fall_2013, file = "Private-MetacommunityData/SpatialData/GC_Fall_2013.csv")

write.csv(HC_Fall_2012, file = "Private-MetacommunityData/SpatialData/HC_Fall_2012.csv")
write.csv(HC_Spring_2013, file = "Private-MetacommunityData/SpatialData/HC_Spring_2013.csv")
write.csv(HC_Fall_2013, file = "Private-MetacommunityData/SpatialData/HC_Fall_2013.csv")

write.csv(GFB_Fall_2012, file = "Private-MetacommunityData/SpatialData/GFB_Fall_2012.csv")
write.csv(GFB_Spring_2013, file = "Private-MetacommunityData/SpatialData/GFB_Spring_2013.csv")
write.csv(GFB_Fall_2013, file = "Private-MetacommunityData/SpatialData/GFB_Fall_2013.csv")

write.csv(SAN_Fall_2012, file = "Private-MetacommunityData/SpatialData/SAN_Fall_2012.csv")
write.csv(SAN_Spring_2013, file = "Private-MetacommunityData/SpatialData/SAN_Spring_2013.csv")
write.csv(SAN_Fall_2013, file = "Private-MetacommunityData/SpatialData/SAN_Fall_2013.csv")







# DEFUNCT FOR LOOP THAT WONT WORK FOR SOME REASON

dflist <- list( # make list of data frames
  AC_Fall_2012,
  AC_Spring_2013,
  AC_Fall_2013,
  WC_Fall_2012, #
  WC_Spring_2013,
  WC_Fall_2013,
  GC_Fall_2012,
  GC_Spring_2013,
  GC_Fall_2013,
  HC_Fall_2012,
  HC_Spring_2013,
  HC_Fall_2013,
  GFB_Fall_2012,
  GFB_Spring_2013,
  GFB_Fall_2013,
  SAN_Fall_2012,
  SAN_Spring_2013,
  SAN_Fall_2013
)
namelist <- c("AC_Fall_2012", # make list of names
                "AC_Spring_2013",
                "AC_Fall_2013",
                "WC_Fall_2012",
                'WC_Spring_2013',
                'WC_Fall_2013',
                'GC_Fall_2012',
                'GC_Spring_2013',
                'GC_Fall_2013',
                'HC_Fall_2012',
                'HC_Spring_2013',
                'HC_Fall_2013',
                'GFB_Fall_2012',
                'GFB_Spring_2013',
                "GFB_Fall_2013",
                "SAN_Fall_2012",
                'SAN_Spring_2013',
                "SAN_Fall_2013")
ERDatalist <- c(rep("2013", 8), "2014", rep("2013", 2), "2014", rep("2013", 6)) # make list of ERData years
for(h in 1:length(dflist)){ # cycle through each data frame
  k <- namelist[h] # data frame position should line up with appropriate name
  j <- str_split_fixed(k, "_", 3) # extract infor about year and season
  l <- FlowPermCalc(dataframe = dflist[[h]], season = j[1,2], year = j[1,3], ERData = ERDatalist[h]) # plug into formula
  m <- cbind(dflist[[h]], l) # append flowperm to dataframe
  assign(noquote(k), m) # reassign new updated dataframe to name
}

