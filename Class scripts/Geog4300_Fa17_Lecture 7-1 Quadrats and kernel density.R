#Load the tidyverse
library(tidyverse)
library(sf)

#For this script, we'll use data on tornado centroids in sections of the Southeast
tornado_points<-read_csv("https://raw.githubusercontent.com/jshannon75/geog4300/master/Data/tornado_points.csv")

#Let's just take a quick look at these data using mapview
library(mapview)

tornado_points_sf<-st_as_sf(tornado_points,coords=c("CLONG","CLAT"),crs=4326)
mapview(tornado_points_sf)

#Quadrat analysis in R often uses a package called spatstat
#A lot of info on spatstat available here: https://research.csiro.au/software/wp-content/uploads/sites/6/2015/02/Rspatialcourse_CMIS_PDF-Standard.pdf
#With spatstat, you can create square quadrants of varying sizes
install.packages("spatstat")
library(spatstat)

#To use the spatstat package, you must first determine the maximum and minimum values for your lat/long coordinates.
#You should now be able to easily do this using "summary"
#Spatstat uses a "ppp" object, which takes your X and Y points plus the range of your X and Y coordinates.
tornado_ppp<-ppp(tornado_points$CLONG,tornado_points$CLAT,c(-92,-75),c(30,37))
plot(tornado_ppp)

#Basic descriptives
summary(tornado_ppp) #Remember that the unit here is decimal degrees
plot(density(tornado_ppp)) #This creates a kernel density map

#We can change the size of the "kernel" used to interpolate this map
plot(density(tornado_ppp,.25))
plot(density(tornado_ppp,.5))
plot(density(tornado_ppp,1))
plot(density(tornado_ppp,3))

#Countour map of tornado count
contour(density(tornado_ppp))

#Quadrat maps
qmap<-quadratcount(tornado_ppp,10,5) #How does the pattern change with size?
plot(qmap)

plot(density(tornado_ppp,.5))
plot(qmap, add=TRUE,col="white") #Messy, but can see how the points intersect with the grid boundaries

##You try it! Create a kernel density map for just tornadoes in Georgia
##Use the "ST" field to subset the dataset
##Longitude for Georgia goes from -80.7 to -85.8
##Latitude is from 35.1 to 30.3

