##########################################################
# Code to extract FlowPermance data for bug relevant flows
###########################################################




FlowPermCalc <- function(data, season, year, ERData) {
  rm(flowperm)
  flowperm <- vector()
  for (i in 1:length(data$ER_vector)) {
    if (data$stat[i] != "DNE") {
      row <-
        SampleDates[which(
          SampleDates$Site == data$OCH_names[i] &
            SampleDates$Season == season &
            substr(
              SampleDates$`DAY/MONTH/YEAR`,
              start = 1,
              stop = 4
            ) == year
        ),]
      day1 <- as.character.Date(row[5])
      day1 <- as.character(day1)
      lastday <- as.character.Date(row[6])
      lastday <- as.character(lastday)
      if (ERData == "2013") {
        sensorfile <-
          as.character(Sensor_df[which(Sensor_df$data.Sensor == data$ER_vector[2]), 8])
        sensorfile <- gsub(" ", "", sensorfile, fixed = TRUE)
      }
      if (ERData == "2014") {
        sensorfile <-
          as.character(Sensor_df[which(Sensor_df$data.Sensor == data$ER_vector[2]), 11])
        sensorfile <- gsub(" ", "", sensorfile, fixed = TRUE)
      }
      table <-
        read.csv(paste0("Private-MetacommunityData/CleanERData/", sensorfile))
      table$Date <- as.Date(table$Date)
      a <- which(table$Date == day1)
      b <- which(table$Date == lastday)
      c <- length(table$hydro[a:b])
      d <- sum(table$hydro[a:b] == "Wet")
      e <- d / c
      flowperm <- c(flowperm, e)
    } else {
      f <- NA
      flowperm <- c(flowperm, f)
    }
  }
  return(flowperm)
  }

