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
plot(counties)

#Graph the county data
hist(counties$WHT_POP_PC)
hist(counties$POV_POP_PC)

ggplot(counties,aes(x=WHT_POP_PC,y=POV_POP_PC))+
  geom_point()

#Map the county data
ggplot(counties) + geom_sf()

#Map the county data with fill
ggplot(counties) +
  geom_sf(aes(fill=WHT_POP_PC)) +
  scale_fill_viridis_c()

ggplot(counties) +
  geom_sf(aes(fill=POV_POP_PC)) +
  scale_fill_viridis_c()

#Project the counties
counties_proj<-counties %>%
  st_transform(102004)

ggplot(counties_proj) +
  geom_sf(aes(fill=POV_POP_PC)) +
  scale_fill_viridis_c()

#Make an interactive map
tmap_mode("view")

tm_shape(counties) +
  tm_polygons("BADEG_PCT")

#Calculate table of mean poverty rate by state
statepov<-counties %>%
  st_set_geometry(NULL) %>%
  group_by(State) %>%
  summarise(meanpov=mean(POV_POP_PC))

