##################################################
# Code to map for White Sands, NM data, Fall 2013
###################################################
require(ggplot2)
require(ggmap)

range(WS_Fall_2013$Latitude)
range(WS_Fall_2013$Longitude)

base = get_map(location=c(-106.7,32.55,-106.4,32.8), zoom = 12, maptype="terrain-background")

WSF13 <- ggmap(base)

X11()
WSF13 + geom_point(data = WS_Fall_2013, aes(x = Longitude , y= Latitude, fill = FlowPermanence), shape = 21,cex = 4) +
  scale_fill_gradient2(low = "red", mid = "yellow", high = "blue", midpoint = 0.5, na.value = NA) +
  labs(x="Longitude", y="Latitude", title= "White Sands, NM - Fall 2013") + # label the axes
  theme_bw() + theme(legend.position="bottom", legend.key = element_rect(colour = "white"), axis.text.x = element_text(angle=45, vjust=0.5))+
  geom_text(x= -106.5 , y=32.75, label="San Andres Canyon")+
  geom_text(x = -106.5, y = 32.64, label = "Ash Canyon" )
