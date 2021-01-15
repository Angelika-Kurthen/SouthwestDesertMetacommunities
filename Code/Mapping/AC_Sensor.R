##################################################
# Code to map for White Sands, NM data, fall 2012
###################################################
require(ggplot2)
require(ggmap)


range(WS_Fall_2012$Latitude) # get ranges for lat and long
range(WS_Fall_2012$Longitude)

# gat map 
base = get_map(location=c(-106.6,32.575,-106.5,32.65), zoom = 12, maptype="terrain-background")

x11()
WSF12 <- ggmap(base)
WSF12 + geom_point(data = OCH_lat_lon[c(34:39), ], aes(x = Longitude , y= Latitude), shape = 21, color = "blue") +
  geom_point(data = ER_LatLong[c(1:4), ], aes(x = lon, y = lat), shape = 22, color = "red")+
  geom_text(data = ER_LatLong[c(1:4), ], aes(label = data.Sensor))+
labs(x="Longitude", y="Latitude", title= "White Sands, NM - Fall 2012") + # label the axes
  theme_bw() + theme(legend.position="bottom", legend.key = element_rect(colour = "white"), axis.text.x = element_text(angle=45, vjust=0.5))+
  geom_text(x= -106.5 , y=32.75, label="San Andres Canyon")+
  geom_text(x = -106.5, y = 32.64, label = "Ash Canyon" )
