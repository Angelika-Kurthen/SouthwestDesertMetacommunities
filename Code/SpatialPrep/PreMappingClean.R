#################################################################
# Code to clean up OCH sites, flow data, lat long before mapping
#################################################################

# remove NAS

AC_Fall_2012 <- na.omit(AC_Fall_2012)
AC_Spring_2013 <- na.omit(AC_Spring_2013)
AC_Fall_2013 <- na.omit(AC_Fall_2013)

WC_Spring_2013 <- na.omit(WC_Spring_2013)
WC_Fall_2013 <- na.omit(WC_Fall_2013)

GC_Fall_2012 <- na.omit(GC_Fall_2012)
GC_Spring_2013 <- na.omit(GC_Spring_2013)
GC_Fall_2013 <- na.omit(GC_Fall_2013)

HC_Fall_2012 <- na.omit(HC_Fall_2012)
HC_Spring_2013 <- na.omit(HC_Spring_2013)
HC_Fall_2013 <- na.omit(HC_Fall_2013)

GFB_Fall_2012 <- na.omit(GFB_Fall_2012)
GFB_Spring_2013 <- na.omit(GFB_Spring_2013)
GFB_Fall_2013 <- na.omit(GFB_Fall_2013)

SAN_Fall_2012 <- na.omit(SAN_Fall_2012)
SAN_Spring_2013 <- na.omit(SAN_Spring_2013)
SAN_Fall_2013 <- na.omit(SAN_Fall_2013)

# change colume names

colnames(AC_Fall_2012) <- c("ER_vector", "OCH_names", "stat", "FlowPermanence", "Latitude", "Longitude")
colnames(AC_Spring_2013) <- c("ER_vector", "OCH_names", "stat", "FlowPermanence", "Latitude", "Longitude")
colnames(AC_Fall_2013) <- c("ER_vector", "OCH_names", "stat", "FlowPermanence", "Latitude", "Longitude")

colnames(WC_Spring_2013) <- c("ER_vector", "OCH_names", "stat", "FlowPermanence", "Latitude", "Longitude")
colnames(WC_Fall_2013) <- c("ER_vector", "OCH_names", "stat", "FlowPermanence", "Latitude", "Longitude")

colnames(GC_Fall_2012) <- c("ER_vector", "OCH_names", "stat", "FlowPermanence", "Latitude", "Longitude")
colnames(GC_Spring_2013) <- c("ER_vector", "OCH_names", "stat", "FlowPermanence", "Latitude", "Longitude")
colnames(GC_Fall_2013)<- c("ER_vector", "OCH_names", "stat", "FlowPermanence", "Latitude", "Longitude")

colnames(HC_Fall_2012) <- c("ER_vector", "OCH_names", "stat", "FlowPermanence", "Latitude", "Longitude")
colnames(HC_Spring_2013) <- c("ER_vector", "OCH_names", "stat", "FlowPermanence", "Latitude", "Longitude")
colnames(HC_Fall_2013) <- c("ER_vector", "OCH_names", "stat", "FlowPermanence", "Latitude", "Longitude")

colnames(GFB_Fall_2012)<- c("ER_vector", "OCH_names", "stat", "FlowPermanence", "Latitude", "Longitude")
colnames(GFB_Spring_2013)<- c("ER_vector", "OCH_names", "stat", "FlowPermanence", "Latitude", "Longitude")
colnames(GFB_Fall_2013) <- c("ER_vector", "OCH_names", "stat", "FlowPermanence", "Latitude", "Longitude")

colnames(SAN_Fall_2012) <- c("ER_vector", "OCH_names", "stat", "FlowPermanence", "Latitude", "Longitude")
colnames(SAN_Spring_2013) <- c("ER_vector", "OCH_names", "stat", "FlowPermanence", "Latitude", "Longitude")
colnames(SAN_Fall_2013) <- c("ER_vector", "OCH_names", "stat", "FlowPermanence", "Latitude", "Longitude")

# maybe group by season

WS_Fall_2012 <- rbind(AC_Fall_2012, SAN_Fall_2012)
WS_Spring_2013 <- rbind(AC_Spring_2013, SAN_Spring_2013)
WS_Fall_2013 <- rbind(AC_Fall_2013, SAN_Fall_2013)

FH_Fall_2012 <- rbind(HC_Fall_2012, GC_Fall_2012)
FH_Spring_2013 <- rbind(HC_Spring_2013, GC_Spring_2013)
