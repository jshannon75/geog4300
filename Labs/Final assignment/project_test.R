library(tidyverse)
library(sf)
library(tmap)
library(ggridges)
#library(kableExtra)

districts<-st_read("districts_data_all.shp") 

districts_select<-districts %>%
  filter(Region=="South Region" & year==1990) 

tm_shape(districts_select) +
  tm_polygons("badeg_pct")

ggplot(districts_select,aes(x=badeg_pct,y=st_abbr))+
  geom_density_ridges(scale=3)+
  theme_ridges()

plot(districts_select$pct_dem,districts_select$nonwht_pct)
plot(districts_select$pct_dem,districts_select$medhhinc)

model<-lm(pct_dem~nonwht_pct,data=districts_select)
summary(model)

model<-lm(pct_dem~medhhinc,data=districts_select)
summary(model)

model<-lm(pct_dem~badeg_pct,data=districts_select)
summary(model)

districts_select$residuals<-residuals(model)

tm_shape(districts_select) +
  tm_polygons("residuals")
