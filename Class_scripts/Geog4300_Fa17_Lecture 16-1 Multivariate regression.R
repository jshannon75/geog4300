##Multivariate regression
#It uses the same command as simple regression. Just add more variables.
#Install required packages for this script
#install.packages(c("car","lmtest","stargazer"))
library(car)
library(tidyverse)
library(stargazer)
library(tmap)
library(lmtest)
library(sf)
library(Hmisc)

#Data
dlsf<-st_read("https://raw.githubusercontent.com/jshannon75/geog4300/master/Data/DLSF_data.geojson")

#Regression
model_lat<-lm(AvgDLSpF~Latitude,data=dlsf)
model_elev<-lm(AvgDLSpF~Elevation,data=dlsf)
model_dist<-lm(AvgDLSpF~DisttoCoas,data=dlsf)
model_all<-lm(AvgDLSpF~Latitude+Elevation+DisttoCoas,data=dlsf)
summary(model_lat)
summary(model_elev)
summary(model_dist)
summary(model_all)

#You can check for multicollinearity using the vif test (variance inflation factor)
#Look for values below 5
vif(model_all)

#Also just look at the correlation matrix
dlsf_corr<-dlsf[,c(4,5,7,8)]
st_geometry(dlsf_corr)<-NULL
rcorr(as.matrix(dlsf_corr))

#Check for heterosketasticity
bptest(model_all)

#Remove outliers/extreme values using the outlier test in the car package
cooks_dist<-cooks.distance(model_all)
plot(cooks_dist, pch="*", cex=2, main="Influential Obs by Cooks distance")
abline(h = 4*mean(cooks_dist, na.rm=T), col="red") # add cutoff line
text(x=1:length(cooks_dist)+1, y=cooks_dist, labels=ifelse(cooks_dist>4*mean(cooks_dist, na.rm=T),names(cooks_dist),""), col="red")  # add labels

influential <- as.numeric(names(cooks_dist)[(cooks_dist > 4*mean(cooks_dist, na.rm=T))])  # influential row numbers
outliers<-(dlsf[influential, ])  # influential observations.

#Where are these outliers?
tmap_mode("view")
tm_shape(outliers) +
  tm_dots(size=.2)
#There are many ways to identify and deal with outliers.
#If you know you have them, 
#be sure to run the model without them to see the effect. 

dlsf_no_outlier<-dlsf[-influential,]
model_all2<-lm(AvgDLSpF~Latitude+Elevation+DisttoCoas,data=dlsf_no_outlier)
summary(model_all2)
summary(model_all)

#You can also the anova command to compare model strength using ANOVA
#A significant finding shows that one model is significantly different from the other
model_all<-lm(AvgDLSpF~Latitude+Elevation+DisttoCoas,data=dlsf)
model_LatElev<-lm(AvgDLSpF~Latitude+Elevation,data=dlsf)
model_Lat<-lm(AvgDLSpF~Latitude,data=dlsf)
anova(model_all,model_LatElev)
anova(model_LatElev,model_Lat)

#The stargazer package allows you to compare/list model results
stargazer(model_Lat,model_LatElev,model_all,title="Comparison",type="text")
stargazer(model1,model2,model3,title="Comparison",
          type="text", #Sets type to text output,
          no.space=TRUE,
          out="models.txt") #Saves the file in your working folder

#See this page for more information on customizing stargazer: 
#http://jakeruss.com/cheatsheets/stargazer.html