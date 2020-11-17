#################################################
# Code to determine wet/dry hydrology of ER sensor data
#################################################

# source functions to get wet/dry hydrology
source('Code/Data Prep/MetacommunityFunctions.R')

# determine the hydrology using the ERSensorHydrology Function
ERSensorHydrology(path  = "Private-MetacommunityData/CleanERData")
