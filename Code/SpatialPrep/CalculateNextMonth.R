###########################################
# Calculating bug relevant OCH Dates for a month after sample date (not previous month)
###########################################
library(lubridate)
library(geosphere)
library(stringr)

# calculate a month later, not a month previously for AC_Fall_2012, GFB_Fall_2012, and SAN_Fall_2012 

#AC_Fall_2012
AC_Fall_2012_Check <- AC_Fall_2012[AC_Fall_2012$stat == "CheckDates", ]
for (i in 1:length(AC_Fall_2012_Check$stat)) {
  row <- # isolate row with the OCH Site Name
    which(
      SampleDates$Site == AC_Fall_2012_Check$OCH_names[i] &
        SampleDates$Season == "Fall" &
        substr(
          SampleDates$`DAY/MONTH/YEAR`,
          start = 1,
          stop = 4
        ) == "2012"
    )
  ER <- which(Sensor_df$data.Sensor == AC_Fall_2012_Check$ER_vector[i])
  SampleDates$`DAY/MONTH/YEAR`[row] <- sensor_info$StartDate2013[ER]
  a <- (sensor_info$StartDate2013[ER] + days(30))
  SampleDates$PrevMonth[row] <- a
}

# GFB_Fall_2012
GFB_Fall_2012_Check <- GFB_Fall_2012[GFB_Fall_2012$stat == "CheckDates", ]
for (i in 1:length(GFB_Fall_2012_Check$stat)) {
  row <- # isolate row with the OCH Site Name
    which(
      SampleDates$Site == GFB_Fall_2012_Check$OCH_names[i] &
        SampleDates$Season == "Fall" &
        substr(
          SampleDates$`DAY/MONTH/YEAR`,
          start = 1,
          stop = 4
        ) == "2012"
    )
  ER <- which(Sensor_df$data.Sensor == GFB_Fall_2012_Check$ER_vector[i])
  SampleDates$`DAY/MONTH/YEAR`[row] <- sensor_info$StartDate2013[ER]
  a <- (sensor_info$StartDate2013[ER] + days(30))
  SampleDates$PrevMonth[row] <- a
}

# SAN_Fall_2012
SAN_Fall_2012_Check <- SAN_Fall_2012[SAN_Fall_2012$stat == "CheckDates", ]
for (i in 1:length(SAN_Fall_2012_Check$stat)) {
  row <- # isolate row with the OCH Site Name
    which(
      SampleDates$Site == SAN_Fall_2012_Check$OCH_names[i] &
        SampleDates$Season == "Fall" &
        substr(
          SampleDates$`DAY/MONTH/YEAR`,
          start = 1,
          stop = 4
        ) == "2012"
    )
  ER <- which(Sensor_df$data.Sensor == SAN_Fall_2012_Check$ER_vector[i])
  SampleDates$`DAY/MONTH/YEAR`[row] <- sensor_info$StartDate2013[ER]
  a <- (sensor_info$StartDate2013[ER] + days(30))
  SampleDates$PrevMonth[row] <- a
}
