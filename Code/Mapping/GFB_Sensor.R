####################################################
# Code to map for China Lake, CA data, Fall 2012
####################################################
require(ggplot2)
require(ggmap)

range(CL_Fall_2012$Latitude)
range(CL_Fall_2012$Longitude)
CLbase = get_map(location=c(-117.425,35.84,-117.375,35.87), zoom = 12, maptype="terrain-background")

CLF12 <- ggmap(CLbase)
data = OCH_lat_lon[c(15:23), ]
X11()
CLF12+ geom_point(data = OCH_lat_lon[c(15:23), ], aes(x = Longitude , y= Latitude), shape = 21, color = "red", cex = 4) +
  geom_point(data = ER_LatLong[c(8:11), ], aes(x = lon, y = lat), shape = 22, color = "blue", cex = 4)+
  geom_text(data = ER_LatLong[c(8:11), ], aes(label= data.Sensor))+
  #geom_text(data = data, aes(label = Site))+
  #geom_label(data = OCH_lat_lon[c(15:23), ], aes(label = Site))+
  labs(x="Longitude", y="Latitude", title= "China Lake, CA - Fall 2013") + # label the axes
  theme_bw() + theme(legend.position="bottom", legend.key = element_rect(colour = "white"), axis.text.x = element_text(angle=45, vjust=0.5))
  

plot()
