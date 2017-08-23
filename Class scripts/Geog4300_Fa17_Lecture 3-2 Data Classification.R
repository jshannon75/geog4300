#install.packages("sf")
#install.packageS("tmap")

library(tidyverse)
library(sf)
library(tmap)

censusdata<-st_read("Data/ACSCtyData_2014ACS.shp")
