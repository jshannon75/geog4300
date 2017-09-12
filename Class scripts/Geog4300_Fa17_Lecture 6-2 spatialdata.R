#Spatial data in R

#Before starting this lab, download the zipped ACS county data shapefile from GitHub.
#Copy the files into the data folder of your class project.
#Link: https://github.com/jshannon75/geog4300/raw/master/Data/ACSCtyData_2014ACS.zip

#There are several packages available to create and edit spatial data in R.
#This includes both raster and vector data. This script focuses on the latter.
#The relatively new sf (stands for simple features) package is one efficent way to load vector data.
#Other popular packages for spatial data are rgdal, sp, and raster.

#install.packages(sf)

library(tidyverse)
library(sf)

#Read in the shapefile (assuming you have it in a folder called "Data")
ACSctydata<-st_read("Data/ACSCtyDat_2014ACS_simplify.shp")

#Notice when you load the data, you're given the number of features and fields, projection ID (4326),
#and type of objects (multipolygon). You can also view the attribute table:
View(ACSctydata)

#Notice that the last column is called "geometry." In sf, this is where the spatial data are stored.
#We can use commands on this file just like it was a regular data frame. 
#Let's just select Georgia counties. 
ACSctydata_ga<-ACSctydata %>% filter(State=="Georgia")

#We could just plot this data set. But it's messy.
plot(ACSctydata_ga)

#Let's use the also still new mapview package to view these data.
#install.packages("mapview")
#devtools::install_github("r-spatial/mapview@develop")--if you need development version
library(mapview)
mapview(ACSctydata_ga)

#The zcol parameter let's us choose a variable to map.
mapview(ACSctydata_ga,zcol="POV_POP_PC")

#The tmap (thematic map) package provides a robust set of functions for creating print like maps.
#For more info, see this page: https://cran.r-project.org/web/packages/tmap/vignettes/tmap-nutshell.html
#install.packages("tmap")
library(tmap)

#Basic plot
tm_shape(ACSctydata_ga)+
  tm_polygons()

#Add a thematic variable
tm_shape(ACSctydata_ga)+
  tm_polygons("POV_POP_PC", title="% in poverty")

#Add scale bar and north arrow
tm_shape(ACSctydata_ga)+
  tm_polygons("POV_POP_PC", title="% in poverty")+
  tm_compass()+
  tm_scale_bar(position="left")

#Create a small multiples map for our race variables. There's several ways to do this.
#The easiest is simply to list multiple variables
tm_shape(ACSctydata_ga)+
  tm_polygons(c("WHT_POP_PC","AFAM_POP_P","ASN_POP_PC"),
              style="jenks", #define classification scheme
              title=c("% White","% African American","% Asian American"))

#You try it!
#Use tmap to create a thematic map of the rate of insurance for U.S. born citizens (NAT_INS_PC) 
#in the southern region (Region)


