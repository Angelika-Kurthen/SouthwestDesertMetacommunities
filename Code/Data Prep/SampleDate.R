#############################################
# Code to match sample dates with sample ID
#############################################

# install necessary libraries
require(readxl)
require(lubridate)
#read in pre-sorted OCH data
OCHData <-
  read.table(
    "Private-MetacommunityData/CleanOCHData/DrainMetacom_Sorted.csv",
    header = T,
    sep = ","
  )

#read in unsorted dates
DesertMetacommunityDataset <-
  read_excel(
    "Private-MetacommunityData/RawData/DesertMetacommunityDataset.xlsx",
    sheet = "Full Database OCH Only",
    col_types = c(
      "skip",
      "text",
      "text",
      "text",
      "text",
      "text",
      "date",
      "skip",
      "skip",
      "skip",
      "skip",
      "skip",
      "skip",
      "skip",
      "skip",
      "skip"
    )
  )

# we need to join our OCHData sites and the DesertMetacommunityDataset sites so we can match dates
# here is what I want to do:
# for each year, I want to find the couple sample dates

rm(datetable)  # remove any previous iterations of this dataframe
datetable <-   # we want to create an empty dataframe for our data
  data.frame(
    State = character(0),
    Drainage = character(0),
    Site = character(0),
    Season = character(0),
    `DAY/MONTH/YEAR` = character(0)
  )
for (i in levels(factor(OCHData$Site))) {  # cycle through the sites in OCHData
  for (j in c("Spring", "Fall")) {         # cycle through the seasons
    for (k in c(2012, 2013)) {             # cycle through the years
      sub <-
        as.data.frame(DesertMetacommunityDataset[which(   # we want to isolate by site, season, and year
          DesertMetacommunityDataset$Site == i &
            DesertMetacommunityDataset$Season == j &
            substr(DesertMetacommunityDataset$`DAY/MONTH/YEAR`, 1, 4) == k
        ),])
      table <- unique(sub[, c(1, 2, 3, 4, 6)])            # find the unique sample dates (multiple subsamples)
      datetable <- rbind(datetable, table)                # add to data frame we made outside of the for loop
    }
  }
}

# we know that we don't have sensor data for spring 2012 samples, so remove 
for (i in 1:length(datetable$State)) {  # cycle through the sites in OCHData
  for (j in c("Spring", "Fall")) {         # cycle through the seasons
    for (k in c(2012, 2013)) { 
      if (datetable$Season[i] == "Spring" & substr(datetable$`DAY/MONTH/YEAR`[i], 1, 4) == "2012"){
        datetable <- datetable[-i,]  }}}}


# now I want to find the unique earliest sample dates for each of the sites
UniqueDateTable <-  # want to create an empty data frame for our data
  data.frame(
    State = character(0),
    Drainage = character(0),
    Site = character(0),
    Season = character(0),
    `DAY/MONTH/YEAR` = character(0)
  )
for (i in levels(factor(datetable$Site))) {  # cycle through sites in datetable
  for (j in c("Spring", "Fall")) {           # cycle through seasons
    for (k in c(2012, 2013)) {               # cycle through years
      set <-                                 # want to isolate by site, season, and year
        as.data.frame(datetable[which(
          datetable$Site == i & datetable$Season == j
          &
            substr(datetable$`DAY/MONTH/YEAR`, 1, 4) == k
        ), ])
      if (length(set$State) > 1) {           # want to identify if this site/season/year combo has more than one sample date
        a <- set[which(set$`DAY/MONTH/YEAR` == min(set$`DAY/MONTH/YEAR`)), ] # get the earliest sample date from that set
        UniqueDateTable <- rbind(UniqueDateTable, a)  # add to dataframe we made
      } else {
        UniqueDateTable <- rbind(UniqueDateTable, set) # if there is only one sample date, just append site/season/year combo dataframe 
      }
    }
  }
}

# Now we want to get the dates of the months prior and append to UniqueDateTable
PrevMonth <- UniqueDateTable[, 5] - months(1) # gets dates of the month prior

SampleDates <- cbind(UniqueDateTable, PrevMonth) # appends to the dates calculated to UniqueDateTable

#some of the samples taken on Oct 31st have NAs (no Sept 31st)
# we want to calculate based on days (30) instead of months (1)

for (i in length(SampleDates$PrevMonth)) { # cucle through rows
  if (is.na(SampleDates$PrevMonth[i])) {   # get samples that have NAs
    d <- SampleDates$`DAY/MONTH/YEAR`[i] - days(30) # get dates 30 days prior
    SampleDates$PrevMonth[i] <- d          # change in SampleDates
  }
}





