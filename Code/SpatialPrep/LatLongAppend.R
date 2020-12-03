###########################################################
# Code to extract Lat Longs of OCH Sites and append to flow data
############################################################


AC_Fall_2012 <- cbind(AC_Fall_2012, GetLatLong(data = AC_Fall_2012))
AC_Spring_2013 <- cbind(AC_Spring_2013, GetLatLong(data = AC_Spring_2013))
AC_Fall_2013 <- cbind(AC_Fall_2013, GetLatLong(data = AC_Fall_2013))

WC_Spring_2013 <- cbind(WC_Spring_2013, GetLatLong(data = WC_Spring_2013))
WC_Fall_2013 <- cbind(WC_Fall_2013, GetLatLong(data = WC_Fall_2013))

GC_Fall_2012 <- cbind(GC_Fall_2012, GetLatLong(data = GC_Fall_2012))
GC_Spring_2013 <- cbind(GC_Spring_2013, GetLatLong(data = GC_Spring_2013))
GC_Fall_2013 <- cbind(GC_Fall_2013, GetLatLong(data = GC_Fall_2013))

HC_Fall_2012 <- cbind(HC_Fall_2012, GetLatLong(data = HC_Fall_2012))
HC_Spring_2013 <- cbind(HC_Spring_2013, GetLatLong(data = HC_Spring_2013))
HC_Fall_2013 <- cbind(HC_Fall_2013, GetLatLong(data = HC_Fall_2013))

GFB_Fall_2012 <- cbind(GFB_Fall_2012, GetLatLong(data = GFB_Fall_2012))
GFB_Spring_2013 <- cbind(GFB_Spring_2013, GetLatLong(data = GFB_Spring_2013))
GFB_Fall_2013 <- cbind(GFB_Fall_2013, GetLatLong(data = GFB_Fall_2013))

SAN_Fall_2012 <- cbind(SAN_Fall_2012, GetLatLong(data = SAN_Fall_2012))
SAN_Spring_2013 <- cbind(SAN_Spring_2013, GetLatLong(data = SAN_Spring_2013))
SAN_Fall_2013 <- cbind(SAN_Fall_2013, GetLatLong(data = SAN_Spring_2013))
