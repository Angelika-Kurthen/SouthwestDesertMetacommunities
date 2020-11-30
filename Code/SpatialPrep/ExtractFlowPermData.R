##########################################################
# Code to extract FlowPermance data for bug relevant flows
###########################################################

# Tried with for loop - wont work 
# see below

# at this point, will have to brute force it

FlowPermCalc(dataframe = WC_Spring_2013, season = "Spring", year = "2013", ERData = "2013")
m <- cbind(dflist[[h]], l)
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

Sensor_df$FileName2013[23] <- as.factor("San1Clean2013.csv")
Semsor_df$FileName2013[24] <- "San2Clean2013.csv"
SAN_Fall_2012 <- cbind(SAN_Fall_2012, FlowPermCalc(dataframe = SAN_Fall_2012, season = "Fall", year = "2012", ERData = "2013"))
SAN_Spring_2013 <- cbind(SAN_Spring_2013, FlowPermCalc(dataframe = SAN_Spring_2013, season = "Spring", year = "2013", ERData = "2013"))
SAN_Fall_2013 <- cbind(SAN_Fall_2013, FlowPermCalc(dataframe = SAN_Fall_2013, season = "Fall", year = "2013", ERData = "2013"))




# DEFUNCT FOR LOOP THAT WONT WORK FOR SOME REASON

dflist <- list(
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
namelist <- c("AC_Fall_2012",
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
ERDatalist <- c(rep("2013", 8), "2014", rep("2013", 2), "2014", rep("2013", 6)) 
for(h in 1:length(dflist)){
  k <- namelist[h]
  j <- str_split_fixed(k, "_", 3)
  l <- FlowPermCalc(dataframe = dflist[[h]], season = j[1,2], year = j[1,3], ERData = ERDatalist[h])
  m <- cbind(dflist[[h]], l)
  print(h)
  assign(noquote(k), m)
}

