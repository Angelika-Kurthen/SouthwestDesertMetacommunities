##################################################
# Code to map for White Sands, NM data, fall 2012
###################################################
require(ggplot2)
require(ggmap)


range(WS_Fall_2012$Latitude) # get ranges for lat and long
range(WS_Fall_2012$Longitude)

# gat map 
base = get_map(location=c(-106.7,32.55,-106.4,32.8), zoom = 12, maptype="terrain-background")

x11()
WSF12 <- ggmap(base)
WSF12 + geom_point(data = WS_Fall_2012, aes(x = Longitude , y= Latitude, fill = FlowPermanence), shape = 21,cex = 4) +
  scale_fill_gradient2(low = "red", mid = "yellow", high = "blue", midpoint = 0.5, na.value = NA) +
labs(x="Latitude", y="Longitude", title= "White Sands, NM - Fall 2012") + # label the axes
  theme_bw() + theme(legend.position="bottom", legend.key = element_rect(colour = "white"), axis.text.x = element_text(angle=45, vjust=0.5))+
  geom_text(x= -106.5 , y=32.75, label="San Andres Canyon")+
  geom_text(x = -106.5, y = 32.64, label = "Ash Canyon" )
