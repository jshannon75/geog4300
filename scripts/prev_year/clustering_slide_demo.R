library(tidyverse)
library(sf)
library(tmap)

acs_cty<-st_read("data/ACSCtyData_2019ACS_simplify.gpkg")

hca_ex<-acs_cty %>%
  filter(St_name=="Georgia") %>% 
  select(wht_pop_pct:thr_pop_pct) %>%
  st_set_geometry(NULL)

hca_dist<-dist(hca_ex)

clust_num=5

hca_clust<-hclust(hca_dist)
plot(hca_clust)

rect.hclust(hca_clust, k = clust_num)

groups<-data.frame(hca_clust=cutree(hca_clust,k=clust_num))

acs_sf_ga<-acs_cty %>%
  filter(St_name=="Georgia") 

acs_sf_ga_1<-acs_sf_ga %>%
  bind_cols(groups)

tm_shape(acs_sf_ga_1)+
  tm_polygons("hca_clust")
