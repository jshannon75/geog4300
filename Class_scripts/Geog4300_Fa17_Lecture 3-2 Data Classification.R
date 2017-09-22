#install.packages("sf")
#install.packages("tmap")

library(tidyverse)
library(sf)
library(tmap)

#Import the data
censusdata_csv<-read_csv("https://github.com/jshannon75/geog4300/raw/master/Data/ACSCtyData_2014ACS.csv") %>%
  mutate(state=substr(GEOID,1,2)) %>%
  filter(state!="15" & state !="02" )

summary(censusdata_csv$nat_ins_pct)
sd(censusdata_csv$nat_ins_pct)
hist(censusdata_csv$nat_ins_pct,breaks=30)


#Map the data
#Import the shapefile
censusdata<-st_read("Data/ACSCtyData_2014ACS.shp") %>%
  mutate(state=substr(GEOID,1,2),
         natins_je = NAT_INS_PC,
         natins_qu = NAT_INS_PC,
         natins_nb = NAT_INS_PC,
         natins_sd = NAT_INS_PC) %>%
  filter(state!="15" & state !="02" )

#Set the breaks
jenks<-c(0,50,83,86,90,100)
quantile<-c(0,60,73,86,95,100)
natural_breaks<-c(0,30,60,80,90,100)
st_dev<-c(0,55,65,75,85,100)

#Make the map
tm_shape(censusdata) +
  tm_polygons(c("natins_je","natins_qu","natins_nb","natins_sd"),
              breaks=list(jenks,quantile,natural_breaks,st_dev))+
  tm_facets()
