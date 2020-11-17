#################################################
# Code to determine wet/dry ratio of bug relevant time period
#################################################

# So first we want to loop through the CleanERData file

# 

path = "Private-MetacommunityData/CleanERData"  # create path to folder in project
file.names <- dir(path, pattern =".csv")        # create a list of file names of all the csv files in that folder

ERSensorHydrology <- function(path, pattern){
for(i in 1:length(file.names)){
  file <- read.table(paste0(path, "/",file.names[i]),header=TRUE, sep=",", stringsAsFactors=FALSE)
  rm(hydro)
  hydro <- vector()
  for(j in 1:length(file[, 3])){
    if (is.na(file[j, 3])) {
      hydro[j] <- NA
    } else {
    if (file[j,3] > -120) {
      hydro[j] <- "Wet"}
    
    if (file[j,3] <= -120){
      hydro[j] <- "Dry"
    }
}
  }
  bound <- cbind(file, hydro)
  write.table(bound, file = paste0(path, "/", file.names[i],sep=";", 
            row.names = FALSE)
}

}
