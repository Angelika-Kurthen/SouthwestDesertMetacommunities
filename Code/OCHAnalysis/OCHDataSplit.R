##################################################
## Splitting Drainage Lm data 
################################################### 



install.packages("ggpmisc")
library(ggpmisc)


densityCurve <- ggplot(weighted_mean_dataframe, aes(x=Chao)) + geom_density()
# extract the data from the graph
densityCurveData <- ggplot_build(densityCurve)
# get the indices of the local minima
localMins <- which(ggpmisc:::find_peaks(-densityCurveData$data[[1]]$density) == TRUE)
# get the value of the local minima
localMins <- densityCurveData$data[[1]]$x[localMins]
localMins <- c(-Inf, localMins, +Inf)

ggplot(weighted_mean_dataframe, aes(x= Chao)) + geom_density() + geom_vline(xintercept = localMins, color="red", linetype = "dashed")

# split data and test normality
low_chao <- weighted_mean_dataframe[which(weighted_mean_dataframe$Chao < 0.3855186), ] # lower half
high_chao <- weighted_mean_dataframe[which(weighted_mean_dataframe$Chao > 0.3855186), ] # higher half
shapiro.test(low_chao$Chao) # not normal
shapiro.test(high_chao$Chao) # not normal
hist(low_chao$Chao)
hist(high_chao$Chao)


