#Regression

#Enter the garden data
med.age<-c(43, 21, 25, 42, 56, 59)
garden<-c(99, 65, 79, 75, 87, 81)
data<-data.frame(cbind(med.age, garden))

#Create a linear model
lm(garden~med.age, data=data) #This doesn't tell you much
model<-lm(garden~med.age, data=data)
summary(model)

#You can also plot this model
plot(garden~med.age, data=data)
abline(model) ##plots the regression line created by the model

#Let's do a more complex model: pollen data
#Does yearly mean temperature predict the levels of pollen from birch trees (Betula)?
library(tidyverse)
library(sf)
Midwest_Pollen_Data<-st_read("Data/Midwest_Pollen_Data.geojson")

#Let's look at our variables first
hist(Midwest_Pollen_Data$Betula)
hist(Midwest_Pollen_Data$tmeanyr)

plot(Betula~tmeanyr,data=Midwest_Pollen_Data)

library(tmap)
tmap_mode("view")
tm_shape(Midwest_Pollen_Data) +
  tm_dots("Betula",size=.2)

tm_shape(Midwest_Pollen_Data) +
  tm_dots("tmeanyr",size=.2)

#Create a model
model<-lm(Betula~tmeanyr,data=Midwest_Pollen_Data)
summary(model)

plot(Betula~tmeanyr,data=Midwest_Pollen_Data)
abline(model)

#There's several diagnostics that can be used for regression
#Plot/test the residuals to see if they're normal
Midwest_Pollen_Data$residuals<-residuals(model) #Pull the residuals from the model
hist(Midwest_Pollen_Data$residuals)
qqnorm(Midwest_Pollen_Data$residuals)
shapiro.test(Midwest_Pollen_Data$residuals)

#Map the residuals using tmap
tm_shape(Midwest_Pollen_Data) +
  tm_dots("residuals",size=.2)

#Testing for heteroskedasticity using the Breusch-Pagan test. 
#Requires the lmtest package
#Null hypothesis is that the data is NOT heterosketastic
install.packages("lmtest")
library(lmtest)
bptest(model)

#We'll use Cook's Distance to assess outliers
#Adapted from: http://r-statistics.co/Outlier-Treatment-With-R.html
cooks_dist<-cooks.distance(model)

#Two more links explaining Cook's Distance
#Link 1: https://onlinecourses.science.psu.edu/stat501/node/340
#Link 2: http://www.statisticshowto.com/cooks-distance/

#Look at a graph of potential problems
plot(cooks_dist, pch="*", cex=2, main="Influential Obs by Cooks distance")
abline(h = 4*mean(cooks_dist, na.rm=T), col="red") # add cutoff line
text(x=1:length(cooks_dist)+1, y=cooks_dist, labels=ifelse(cooks_dist>4*mean(cooks_dist, na.rm=T),names(cooks_dist),""), col="red")  # add labels

#Identify outlying rows
influential <- as.numeric(names(cooks_dist)[(cooks_dist > 4*mean(cooks_dist, na.rm=T))])  # influential row numbers
outliers<-(Midwest_Pollen_Data[influential, ])  # influential observations.
outliers
hist(Midwest_Pollen_Data$Betula) #How do the values of the outliers compare?

#Where are these outliers?
tm_shape(outliers) +
  tm_dots()

#Let's run a model without the outliers
rev_data<-(Midwest_Pollen_Data[-influential, ]) 
model_rev<-lm(Betula~tmeanyr,data=rev_data)
summary(model_rev)

plot(Betula~tmeanyr,data=rev_data)
abline(model_rev)

summary(model)

#You try it!
#Run a model for one other tree species
#Assess the model results and run diagnostics