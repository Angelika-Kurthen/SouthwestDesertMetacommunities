##################################################################################################
# Code to troubleshoot why there are discrepencies in OCH bug relevant samples and ER sensor dates
###################################################################################################

library(lubridate)
library(geosphere)
library(stringr)

# tried to make a for loop to cycle through all the basin names but it wasn't working?
# brute force it
ER_OCH_ReadCheckDates(data = AC_Fall_2012, season = "Fall", year = "2012") # back calculate fall dates
ER_OCH_ReadCheckDates(data = WC_Fall_2012, season = "Fall", year = "2012") # note: WAT1 and WAT2 start in spring 2013
ER_OCH_ReadCheckDates(data = WC_Spring_2013, season = "Spring", year = "2013") # note: WAT1 and WAT2 start in spring 2013
ER_OCH_ReadCheckDates(data = WC_Fall_2013, season = "Fall", year = "2013") # should be fine 
ER_OCH_ReadCheckDates(data = GC_Spring_2013, season = 'Spring', year = "2013") # basically need to switch end dates of OCH sampleing to end date of ER sample because a lot of 2014 data is missng
ER_OCH_ReadCheckDates(data = GC_Fall_2013, season = "Fall", year = "2013") # can only use G2 and G3 from 2014, rest of sensors swept away in flash flood
ER_OCH_ReadCheckDates(data = HC_Spring_2013, season = "Spring", year = "2013") # basically need to switch end dates of OCH sampleing to end date of ER sample - seems to be some missing data between when ER sensors ends for 2013 and begins for 2014
ER_OCH_ReadCheckDates(data = HC_Fall_2013, season = "Fall", year = "2013") # should be fine if we use 2014 dates
ER_OCH_ReadCheckDates(data = GFB_Fall_2012, season = "Fall", year = "2012") # back calculate fall dates
ER_OCH_ReadCheckDates(data = SAN_Fall_2012, season = "Fall", year = "2012") # back calculate fall dates

ER_OCH_Check(basin = "Garden Canyon", season = "Spring", year = "2013")

