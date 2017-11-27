library(tidyverse)
library(sf)
library(ggridges)

#Read in data
tracts_1990<-st_read("Tract data/US_tract_1990_data.shp")
tracts_2015<-st_read("Tract data/US_tract_2015_data.shp")

#Select the state
tracts_1990_a<-tracts_1990 %>%
  filter(NHGISST==130)

#Make the data long 
tracts_1990_long <- tracts_1990_a %>%
  select(-medhhnc,-pv_ttpp) %>%
  gather(whtnh_p:pv100_p,key="var",value="value")

#Order the variables
tracts_1990_long$var<-factor(tracts_1990_long$var,
                             levels=c("whtnh_p","blknh_p","hsp_pct","asnnh_p",
                                      "mdhhnc","pv100_p"))

#Table for variables (removing geometry column)
tracts_1990_long_df<-tracts_1990_long
st_geometry(tracts_1990_long_df)<-NULL
tracts_1990_table<-tracts_1990_long_df %>%
  group_by(var,CD) %>%
  summarise(median=median(value)) %>%
  spread(var,median)
tracts_1990_table

#Plot the variables
ggplot(tracts_1990_long,aes(x=CD,y=value))+
  geom_boxplot() + 
  theme_minimal()+
  facet_wrap(~var,scales="free")

ggplot(tracts_1990_a,aes(x=whtnh_p,y=CD))+
  geom_density_ridges(scale=3)+
  theme_ridges()
  

#Map the variables
library(tmap)
map1<-tm_shape(tracts_1990_a)+
  tm_polygons("whtnh_p",border.alpha=0,breaks=c(0,10,20,40,60,100),
              title="% White, non-Hispanic")+
  tm_layout(legend.outside=TRUE)+
  tm_shape(district1990) + 
  tm_borders(lwd=2,col="black") 

map2<-tm_shape(tracts_1990_a)+
  tm_polygons("blknh_p",border.alpha=0,breaks=c(0,10,20,40,60,100),
              title="% Black, non-Hispanic")+
  tm_layout(legend.outside=TRUE)+
  tm_shape(district1990) + 
  tm_borders(lwd=2,col="black") 
  
map3<-tm_shape(tracts_1990_a)+
  tm_polygons("hsp_pct",border.alpha=0,breaks=c(0,3,5,10,15,100),
              title="% Latinx/Hispanic")+
  tm_layout(legend.outside=TRUE)+
  tm_shape(district1990) + 
  tm_borders(lwd=2,col="black") 

map3
tmap_arrange(map1, map2, map3, nrow=2,asp = NA)
