##Geog4300, Lecture 1-1
##Introduction to R

library(sf)
library(tidyverse)
library(tmap)

#Load the county data
counties<-st_read("data/ACSCtyData_2014ACS_simplify.gpkg") %>%
  rename("geometry"=geom) %>%
  filter(State!="Hawaii" & State!="Alaska")

#Look at the data
View(counties)

#Graph the county data
ggplot(counties,aes(x=WHT_POP_PC,y=POV_POP_PC))+
  geom_point()

#Map the county data
ggplot(counties) + geom_sf()

#Map the county data with fill
ggplot(counties) +
  geom_sf(aes(fill=WHT_POP_PC)) +
  scale_fill_viridis_c()

ggplot(counties) +
  geom_sf(aes(fill=BADEG_PCT)) +
  scale_fill_viridis_c()

#Make an interactive map
tmap_mode("view")

tm_shape(counties) +
  tm_polygons("BADEG_PCT")
