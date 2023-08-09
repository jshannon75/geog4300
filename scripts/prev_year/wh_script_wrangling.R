library(tidyverse)
library(sf)
library(tidygeocoder)
library(SafeGraphR)

wh<-read_csv("data/wh_georgia_safegraph.csv") %>%
  mutate(weekly_visitor=raw_visitor_counts/7)

wh_geo<-wh %>%
  distinct(placekey,location_name,street_address,city,region,postal_code) %>%
  unite("full_add",street_address:postal_code,sep=", ") %>%
  geocode(full_add,method="arcgis")

wh_bg<-wh %>%
  left_join(wh_geo)

write_csv(wh_bg,"data/wh_georgia_safegraph_xy.csv")  

test<-expand_cat_json(wh_bg, 'visitor_home_cbgs', by = 'placekey') %>%
  group_by(index,placekey) %>%
  summarise(count=sum(visitor_home_cbgs)) %>%
  filter(count>5) %>%
  rename(visitor_home_cbgs_ex=index)

wh_bg1<-wh_bg %>%
  distinct(placekey,location_name,street_address,city,region,postal_code,lat,long) %>%
  left_join(test)
write_csv(wh_bg1,"data/wh_georgia_safegraph_xy_bg.csv")  

library(tigris)
wh_bg1<-read_csv("data/wh_georgia_safegraph_xy_bg.csv")

bg<-block_groups(state="GA") %>%
  rename(visitor_home_cbgs_ex=GEOID)

bg_dissolve <- function(place_sel) {
  data_sel<-wh_bg1 %>%
    filter(placekey==place_sel)
  
  bg_sel<-bg %>%
    inner_join(data_sel) %>%
    group_by(placekey) %>%
    summarise()
}

placekeys<-unique(wh_bg1$placekey)
bg_areas<-map_df(placekeys,bg_dissolve)

st_write(bg_areas,"data/wh_georgia_safegraph_bgareas.shp",delete_dsn=TRUE)
