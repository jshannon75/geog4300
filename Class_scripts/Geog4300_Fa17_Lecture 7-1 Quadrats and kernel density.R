#Load the tidyverse and sf
library(tidyverse)
library(sf)

#For this script, we'll use data on tornado centroids in sections of the Southeast
tornado_points<-read_csv("https://raw.githubusercontent.com/jshannon75/geog4300/master/Data/tornado_points.csv")

#Let's just take a quick look at these data using mapview
library(mapview)

#The st_as_sf function allows you to convert non-spatial point data to spatial data using lat/long coordinates
#CRS command defines the spatial projection (here, WGS84)
tornado_points_sf<-st_as_sf(tornado_points,coords=c("CLONG","CLAT"),crs=4326)
mapview(tornado_points_sf)

#Quadrat analysis in R often uses a package called spatstat
#A lot of info on spatstat available here: https://research.csiro.au/software/wp-content/uploads/sites/6/2015/02/Rspatialcourse_CMIS_PDF-Standard.pdf
#With spatstat, you can create square quadrants of varying sizes
install.packages("spatstat")
library(spatstat)

#To use the spatstat package, you must first determine the maximum and minimum values for your lat/long coordinates.
maxlat<-max(tornado_points$CLAT)
minlat<-min(tornado_points$CLAT)
maxlon<-max(tornado_points$CLONG)
minlon<-min(tornado_points$CLONG)

#Spatstat uses a "ppp" object, which takes your X and Y points plus the range of your X and Y coordinates.
tornado_ppp<-ppp(tornado_points$CLONG,tornado_points$CLAT,c(minlon,maxlon),c(minlat,maxlat))
plot(tornado_ppp)

#Basic descriptives
summary(tornado_ppp) #Remember that the unit here is decimal degrees
plot(density(tornado_ppp)) #This creates a kernel density map

#We can change the size of the "kernel" used to interpolate this map
plot(density(tornado_ppp,.1))
plot(density(tornado_ppp,.25))
plot(density(tornado_ppp,.5))
plot(density(tornado_ppp,1))

#Countour map of tornado count
contour(density(tornado_ppp))

#Quadrat maps
qmap<-quadratcount(tornado_ppp,10,5) #How does the pattern change with size?
plot(qmap)

plot(density(tornado_ppp,.25))
plot(qmap, add=TRUE,col="white") #Messy, but can see how the points intersect with the grid boundaries

##You try it! Create a kernel density map for just tornadoes in Georgia
##Use the "ST" field to subset the dataset
#How does it look compared to the map you made here?

