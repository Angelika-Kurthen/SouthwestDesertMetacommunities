#######################################################################################
# Code to make last day in bug relevant OCH sample dates the last day of ER sample dates
########################################################################################
library(lubridate)
library(geosphere)
library(stringr)
# because of some missing data or gaps in sample dates, might have to curtail OCH sample interval 
# end date of OCH sample interval is end date of ER sample interval
# for GC_Spring_2013, HC_Spring_2013

# GC_Spring_2013
GC_Spring_2013_Check <- GC_Spring_2013[GC_Spring_2013$stat == "CheckDates", ]
for (i in 1:length(GC_Spring_2013$stat)) {
  row <- # isolate row with the OCH Site Name
    which(
      SampleDates$Site == GC_Spring_2013_Check$OCH_names[i] &
        SampleDates$Season == "Spring" &
        substr(
          SampleDates$`DAY/MONTH/YEAR`,
          start = 1,
          stop = 4
        ) == "2013"
    )
  ER <- which(Sensor_df$data.Sensor == GC_Spring_2013_Check$ER_vector[i])
  SampleDates$`DAY/MONTH/YEAR`[row] <- sensor_info$EndDate2013[ER]
}

# HC_Spring_2013
HC_Spring_2013_Check <- HC_Spring_2013[HC_Spring_2013$stat == "CheckDates", ]
for (i in 1:length(HC_Spring_2013$stat)) {
  row <- # isolate row with the OCH Site Name
    which(
      SampleDates$Site == HC_Spring_2013_Check$OCH_names[i] &
        SampleDates$Season == "Spring" &
        substr(
          SampleDates$`DAY/MONTH/YEAR`,
          start = 1,
          stop = 4
        ) == "2013"
    )
  ER <- which(Sensor_df$data.Sensor == HC_Spring_2013_Check$ER_vector[i])
  SampleDates$`DAY/MONTH/YEAR`[row] <- sensor_info$EndDate2013[ER]
}


