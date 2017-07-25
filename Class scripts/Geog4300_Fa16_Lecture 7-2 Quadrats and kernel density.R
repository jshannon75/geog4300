install.packages("spatstat")
library(spatstat)

#To use the spatstat package, you must first determine the maximum and minimum values for your lat/long coordinates.
#You should now be able to easily do this using "summary"
#Spatstat uses a "ppp" object, which takes your X and Y points plus the range of your X and Y coordinates.
tornado_ppp<-ppp(tornado_points$CLONG,tornado_points$CLAT,c(-92,-75),c(30,37))
plot(tornado_ppp)

#Basic descriptives
summary(tornado_ppp) #Remember that the unit here is decimal degrees
plot(density(tornado_ppp))

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

