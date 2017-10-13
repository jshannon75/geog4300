#Spatial data in R

#There are several packages available to create and edit spatial data in R.
#This includes both raster and vector data. This script focuses on the latter.
#The relatively new sf (stands for simple features) package is one efficent way to load vector data.
#Other popular packages for spatial data are rgdal, sp, and raster.

#install.packages("sf")

library(tidyverse)
library(sf)

#Read in the data. It's stored as a geojson file
#That's similar to a shapefile but all in one file.
ACSctydata<-st_read("https://github.com/jshannon75/geog4300/raw/master/Data/ACSCtyDat_2014ACS_simplify.geojson")

#First a review. We can identify high poverty (rate of >20%) counties in this dataset using ifelse
ACSctydata$highpov<-ifelse(ACSctydata$POV_POP_PC>=20,1,0)

#We can also use table to look at the overall pattern
table(ACSctydata$highpov)

#Let's make a non-spatial dataframe
countydata<-ACSctydata
st_geometry(countydata)<-NULL

#Using group_by and summarise allows us to summarise by state
statepov<-countydata %>%
  group_by(State) %>%
  summarise(counties=n(),
            highpov=sum(highpov))

#Your task--figure out how to calculate a location quotient for high poverty counties in each state!

######

#Notice when you load the geojson (ACSctydata), you're given the number of features and fields, projection ID (4326),
#and type of objects (multipolygon). You can also view the attribute table:
View(ACSctydata)

#Notice that the last column is called "geometry." In sf, this is where the spatial data are stored.
#We can use commands on this file just like it was a regular data frame. 
#Let's just select Georgia counties. 
ACSctydata_ga<-ACSctydata %>% filter(State=="Georgia")

#We could just plot this data set. But it's messy and ugly.
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

#Add in a new layer--major cities
GA_cities<-st_read("https://github.com/jshannon75/geog4300/raw/master/Data/GA_cities.geojson")

tm_shape(ACSctydata_ga)+
  tm_polygons("POV_POP_PC", title="% in poverty")+
tm_shape(GA_cities)+
  tm_bubbles(size=0.5)+
  tm_text("Name",ymod=1) #Adds a text label above the dot
  
#Add scale bar and north arrow. Make sure legend is outside the box
tm_shape(ACSctydata_ga)+
  tm_polygons("POV_POP_PC", title="% in poverty")+
tm_shape(GA_cities)+
  tm_bubbles(size=0.5)+
  tm_text("Name",ymod=1)+
tm_compass()+
tm_scale_bar(position="left")+
tm_legend(legend.outside=TRUE)

#Create a small multiples map for our race variables. There's several ways to do this.
#The easiest is simply to list multiple variables
tm_shape(ACSctydata_ga)+
  tm_polygons(c("WHT_POP_PC","AFAM_POP_P","ASN_POP_PC"),
              style="jenks", #define classification scheme
              title=c("% White","% African American","% Asian American"))

#You can also make a map interactive by shifting to the view mode
tmap_mode("view") #To shift back to static maps, use tmap_mode("plot")
tm_shape(ACSctydata_ga)+
  tm_polygons("POV_POP_PC", title="% in poverty")

#You can specify the basemap for interactvie maps
tm_shape(ACSctydata_ga)+
  tm_polygons("POV_POP_PC", title="% in poverty")+
  tm_layout(basemaps = c("CartoDB.Positron"))

tm_shape(ACSctydata_ga)+
  tm_polygons("POV_POP_PC", title="% in poverty")+
  tm_layout(basemaps = c("Thunderforest.SpinalMap"))

#See a list of many available basemaps here: 
#http://leaflet-extras.github.io/leaflet-providers/preview/

#In view mode, what happens to the faceted maps?
tm_shape(ACSctydata_ga)+
  tm_polygons(c("WHT_POP_PC","AFAM_POP_P","ASN_POP_PC"),
              style="jenks", 
              title=c("% White","% African American","% Asian American"))

#You try it!
#Use tmap to create a thematic map of the rate of insurance for U.S. born citizens (NAT_INS_PC) 
#in the southern region (Region)


