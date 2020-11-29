##########################################################
# Code to extract FlowPermance data for bug relevant flows
###########################################################


dflist <- list(
  AC_Fall_2012,
  AC_Spring_2013,
  AC_Fall_2013,
  WC_Fall_2012,
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
for(h in length(dflist)){
  k <- namelist[h]
  j <- str_split_fixed(k, "_", 3)
  l <- FlowPermCalc(data = dflist[[h]], season = j[1,2], year = j[1,3], ERData = ERDatalist[h])
  assign(cbind(dflist[[h]], l), noquote(k))
}

FlowPermCalc(data = AC_Fall_2012, season = "Fall", year = "2012", ERData = "2013")

