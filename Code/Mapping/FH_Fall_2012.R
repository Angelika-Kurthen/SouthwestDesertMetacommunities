####################################################
# Code to map for Fort Huachuca, AZ data, Fall 2012
####################################################
require(ggplot2)
require(ggmap)

range(FH_Fall_2012$Latitude)
range(FH_Fall_2012$Longitude)
FHbase = get_map(location=c(-110.45,31.42,-110.3,31.55), zoom = 12, maptype="terrain-background")

FHF12 <- ggmap(FHbase)

X11()
FHF12+ geom_point(data = FH_Fall_2012, aes(x = Longitude , y= Latitude, fill = FlowPermanence), shape = 21,cex = 4) +
  scale_fill_gradient2(low = "red", mid = "yellow", high = "blue", midpoint = 0.5, na.value = NA) +
  labs(x="Longitude", y="Latitude", title= "Fort Huachuca, AZ - Fall 2012") + # label the axes
  theme_bw() + theme(legend.position="bottom", legend.key = element_rect(colour = "white"), axis.text.x = element_text(angle=45, vjust=0.5))+
  geom_text(x= -110.355 , y=31.525, label="Huachuca Canyon")+
  geom_text(x = -110.35, y = 31.475, label = "Garden Canyon" )
