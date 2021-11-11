#Interpreting clusters created with k-means

library(tidyverse)
library(sf)
library(tmap)
library(factoextra)
library(ggpubr)

cty<-st_read("data/ACSCtyData_2019ACS_simplify.gpkg") %>%
  st_transform(5070) %>%
  rename(geometry=geom)

cty_demog<-cty %>% 
  st_set_geometry(NULL) %>% 
  select(wht_pop_pct:GradDeg_pct) %>%
  #select(wht_pop_pct:fb_pct) %>%
  scale()

fviz_nbclust(cty_demog, kmeans, method = "wss")

#set.seed(123)
clusters<-kmeans(cty_demog,centers= 4,nstart=25)

cty$cluster<-as.character(clusters$cluster)

tm_shape(cty)+tm_polygons("cluster",border.alpha=0.1)

#Visualize
graph1<-cty %>%
  st_set_geometry(NULL) %>%
  select(GEOID,cluster,wht_pop_pct:thr_pop_pct) %>%
  pivot_longer(wht_pop_pct:thr_pop_pct,
               names_to="var",values_to="value") %>%
  ggplot(aes(x=cluster,y=value,color=cluster))+
    geom_boxplot()+
    facet_wrap(~var,scales="free")

graph2<-cty %>%
  st_set_geometry(NULL) %>%
  select(GEOID,cluster,LessHS_pct:GradDeg_pct) %>%
  pivot_longer(LessHS_pct:GradDeg_pct,
               names_to="var",values_to="value") %>%
  ggplot(aes(x=cluster,y=value,color=cluster))+
  geom_boxplot()+
  facet_wrap(~var,scales="free")

ggarrange(graph1,graph2,
          nrow=1,ncol=2)

ggsave("cluster_box.jpg",width=10,height=6)

#getis_ord
#install.packages("spdep")
library(spdep)

cty1<-st_read("C:/Users/jshannon/Dropbox/Jschool/GIS data/Census/US_counties/2012 Counties/US_county_2012_WGS84.shp") %>%
  left_join(cty %>%  st_set_geometry(NULL)) %>%
  filter(!STATEFP %in% c("72","02")) 

cty1[is.na(cty1)]<-0

tm_shape(cty1)+tm_borders()

# cty_se<-cty %>%
#   filter(St_name %in% c("Georgia","Alabama","Mississippi","Louisiana",
#                         "Arkansas","Kentucky","Tennessee","Virginia",
#                         "North Carolina","South Carolina","Florida"))

cty_nb<-poly2nb(cty1,queen=TRUE)
cty_wt<-nb2listw(cty_nb,style="W",zero.policy=TRUE)

local_g<-localG(cty1$HSGrad_pct,cty_wt,zero.policy=TRUE)

cty1$localG<-local_g

cty2<-cty %>%
  select(-localG) %>%
  left_join(cty1 %>%
              st_set_geometry(NULL) %>%
              select(GEOID,localG))

tm_shape(cty2 %>% st_transform(5070))+
  tm_polygons("localG",border.alpha=0.2)
