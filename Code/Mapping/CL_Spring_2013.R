####################################################
# Code to map for China Lake, CA data, Spring 2013
####################################################
require(ggplot2)
require(ggmap)

range(CL_Spring_2013$Latitude)
range(CL_Spring_2013$Longitude)
CLbase = get_map(location=c(-117.5,35.8,-117.35,35.99), zoom = 12, maptype="terrain-background")

CLS13 <- ggmap(CLbase)

X11()
CLS13+ geom_point(data = CL_Spring_2013, aes(x = Longitude , y= Latitude, fill = FlowPermanence), shape = 21,cex = 4) +
  scale_fill_gradient2(low = "blue", mid = "blue", high = "blue", midpoint = 0.5, na.value = NA, guide = "colourbar") +
  labs(x="Longitude", y="Latitude", title= "China Lake, CA - Spring 2013") + # label the axes
  theme_bw() + theme(legend.position="bottom", legend.key = element_rect(colour = "white"), axis.text.x = element_text(angle=45, vjust=0.5))+
  geom_text(x= -117.43 , y=35.95, label="Water Canyon")+
  geom_text(x = -117.38, y = 35.87, label = "Great Falls Basin" )
