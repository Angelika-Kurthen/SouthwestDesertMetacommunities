# Code to make Walter Climate Diagrams

# Walter Climate Diagrams show different climate patterns in each of the three deserts 

library(readxl)
library(ggplot2)
ClimateData <- read_excel("Private-MetacommunityData/RawData/ClimateData.xlsx")
ClimateData <- ClimateData[ , c(-3, -5, -7)]
name<- c("Location", "Month", "Temperature", "Precipitation")
names(ClimateData) <- name

colors <- c("Temperature" = "red")
fills <- c("Precipitation" = "blue")

month_order <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

ggplot(ClimateData, aes(x = Month, y = Precipitation))+
  geom_bar(aes(x=Month, y=Precipitation, fill = "Precipitation"), stat="identity", color="black")+
  geom_line(aes(x=Month, y=Temperature*2, group=1, color = "Temperature"), size=1.5)+
  scale_color_manual(values = colors)+
  scale_fill_manual(values = fills)+
  facet_wrap(~Location)+
  ylab("Precipitation (mm)")+
  scale_x_discrete(limits=month_order)+
  scale_y_continuous(sec.axis = sec_axis(~.*.5, name = "Temperature (C)"))+
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 90))+
  theme(legend.title = element_blank())
  