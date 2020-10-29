#########################
# Raw Data Cleaning
#########################
# source functions to clean data
source('~/SouthwestDesertMetacommunities/Code/MetacommunityFunctions.R')
# Fort Huachuca Data
# 2013 Data from Garden and Huachuca Canyon
Clean1(csv = "G1_April2013.csv")
Clean1(csv = "G2_April2013.csv")
Clean1(csv = "G3_April2013.csv")
Clean1(csv = "G4_April2013.csv")
Clean1(csv = "G5_April2013.csv")
Clean1(csv = "G6_April2013.csv")
Clean1(csv = "G7_April2013.csv")
Clean1(csv = "H1_April2013.csv")
Clean1(csv = "H2_April2013.csv")
Clean1(csv = "H3_April2013.csv")
Clean1(csv = "H4_April2013.csv")
Clean1(csv = "H5_April2013.csv")
Clean1(csv = "H6_April2013.csv")
Clean1(csv = "H7_April2013.csv")

# 2014 Data from Garden and Huachuca Canyon
Clean1(csv = "G2_21.csv")
Clean1(csv = "H1A_27_13Apr2014.csv")
Clean1(csv = "H3_19_13Apr2014.csv")
Clean1(csv = "H4_25_Apr2014.csv")
Clean1(csv = "H5_68_14Apr2014.csv")
Clean1(csv = "H6_37_Apr2014.csv")
Clean1(csv = "H7_63_Apr2014.csv")

#Note: Based on this, only ER sensors 
#G2, H1, H3, H4, H5, H6 and H7 have 
#continuous data from 2013 to 2014

#2014 Data from SAN1 and SAN2

Clean1(csv = "31_SAN_INT9Apr14.csv")  #SAN1 2014
Clean1(csv = "48_SANSASL_9Apr14.csv") #SAN2 2014

#2014 Data from Ash Canyon
Clean1(csv = "54_ASH_LAS_7Apr14.csv") #ASH1 2014
Clean1(csv = "35_ASH_MID_8Apr14.csv") #ASH2 2014
Clean1(csv = "51_ASH_UAL_8Apr14.csv") #ASH3 2014
Clean1(csv = "69_AshUpper_8Apr14.csv") #ASH4 2014

#2014 WAT data
Clean1(csv = "12Wat_SFBP1Apr14.csv") #WAT1 2014
Clean (csv = )