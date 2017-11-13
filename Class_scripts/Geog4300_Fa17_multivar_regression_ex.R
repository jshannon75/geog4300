library(tidyverse)
library(sf)
library(mapview)
library(tmap)

dlsf<-st_read("Data/DLSF_data.geojson")

mapview(dlsf)

hist(dlsf$AvgDLSpF)

model_lat<-lm(AvgDLSpF~Latitude,data=dlsf)
summary(model_lat)
plot(dlsf$Latitude,dlsf$AvgDLSpF)
abline(model_lat,col="red")

model_elev<-lm(AvgDLSpF~Elevation,data=dlsf)
summary(model_elev)
plot(dlsf$Elevation,dlsf$AvgDLSpF)
abline(model_elev,col="red")

model_dist<-lm(AvgDLSpF~DisttoCoas,data=dlsf)
summary(model_dist)
plot(dlsf$DisttoCoas,dlsf$AvgDLSpF)
abline(model_dist,col="red")

model_lat_elev<-lm(AvgDLSpF~Latitude+Elevation,data=dlsf)
summary(model_lat_elev)

model_all<-lm(AvgDLSpF~Latitude+Elevation+DisttoCoas,data=dlsf)
summary(model_all)

dlsf$residuals<-residuals(model_all)
hist(dlsf$residuals)

tmap_mode("view")
tm_shape(dlsf) + 
  tm_dots("residuals", size=.2)

cooks_dist<-cooks.distance(model_all)

#Two more links explaining Cook's Distance
#Link 1: https://onlinecourses.science.psu.edu/stat501/node/340
#Link 2: http://www.statisticshowto.com/cooks-distance/

#Look at a graph of potential problems
plot(cooks_dist, pch="*", cex=2, main="Influential Obs by Cooks distance")
abline(h = 4*mean(cooks_dist, na.rm=T), col="red") # add cutoff line
text(x=1:length(cooks_dist)+1, y=cooks_dist, labels=ifelse(cooks_dist>4*mean(cooks_dist, na.rm=T),names(cooks_dist),""), col="red")  # add labels

#Identify outlying rows
influential <- as.numeric(names(cooks_dist)[(cooks_dist > 4*mean(cooks_dist, na.rm=T))])  # influential row numbers
outliers<-(dlsf[influential, ])  # influential observations.
outliers
hist(Midwest_Pollen_Data$Betula) #How do the values of the outliers compare?

#Where are these outliers?
tm_shape(outliers) +
  tm_dots(size=.2)

#Heteroskedasticity
library(lmtest)
bptest(model_all)
