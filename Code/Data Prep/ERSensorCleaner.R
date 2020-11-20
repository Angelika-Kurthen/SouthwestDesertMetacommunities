#########################
# Raw Data Cleaning
#########################
# source functions to clean data
source('Code/Data Prep/MetacommunityFunctions.R')

#make into for loop
#pull paste

# make vector with data that can be prepped, cleaned, and created into clean data for
# 2013 Data from Garden and Huachuca Canyon
# 2014 Data from Garden and Huachuca Canyon
# 2014 Data from SAN1 and SAN2
# 2014 Data from Ash Canyon
# 2014 Data from Water Canyon

csvs <-
  c(
    "G1_April2013.csv",
    "G2_April2013.csv",
    "G3_April2013.csv",
    "G4_April2013.csv",
    "G5_April2013.csv",
    "G6_April2013.csv",
    "G7_April2013.csv",
    "H1_April2013.csv",
    "H2_April2013.csv",
    "H3_April2013.csv",
    "H4_April2013.csv",
    "H5_April2013.csv",
    "H6_April2013.csv",
    "H7_April2013.csv",
    "G2_21.csv",
    "H1A_27_13Apr2014.csv",
    "H3_19_13Apr2014.csv",
    "H4_25_Apr2014.csv",
    "H5_68_14Apr2014.csv",
    "H6_37_Apr2014.csv",
    "H7_63_Apr2014.csv",
    "31_SAN_INT9Apr14.csv",
    "48_SANSASL_9Apr14.csv",
    "54_ASH_LAS_7Apr14.csv",
    "35_ASH_MID_8Apr14.csv",
    "51_ASH_UAL_8Apr14.csv",
    "69_AshUpper_8Apr14.csv",
    "12Wat_SFBP1Apr14.csv",
    "16WAT1Apr2014.csv",
    "17WATSFAC_1Apr2014.csv",
    "G1_2014.csv", 
    "G3_2014.csv"
  )

# add on full file name path so we can run through function
csvpaths <- paste0("Private-MetacommunityData/RawData/", csvs)

# loop through
for (i in 1:length(csvs)) {
  PrepAndCleanHoboCSV(csv = csvs[i], csvpath = csvpaths[i])
}
