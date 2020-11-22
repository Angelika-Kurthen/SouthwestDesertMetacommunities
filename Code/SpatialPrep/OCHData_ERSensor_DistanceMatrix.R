#################################
#
#################################

# so here is the thing - not all data as bug-relevant time 
# so for spring 2012, we basically have no sensor data -> need to throw out all those points
# for fall 2012, we rarely have data the month before sampeling took place, so maybe we take the month after sampeling took place (depending on if t)



# ok so now we want to basically create a distance matrix between points
install.packages("geosphere")
library(geosphere)
]

# since some sensors got broken 
# create distance matrix
mat <- distm(ER_LatLong[,c(2,1)], OCH_lat_lon[,c(5,4)], fun=distVincentyEllipsoid) # cols are OCH sites and rows are ER sensors
rownames(mat) <- ER_LatLong$data.Sensor
colnames(mat) <- OCH_lat_lon$Site
df <- as.data.frame(mat)


# ok now I want to determine the ER sensor with the minimum 
minlist <- apply(df, 2, FUN = min) 
ER_vector <- vector()
for (i in 1:length(minlist)){
  a <- rownames(df)[which(df[i] == minlist[i])]
  ER_vector <- c(ER_vector, a)
}


