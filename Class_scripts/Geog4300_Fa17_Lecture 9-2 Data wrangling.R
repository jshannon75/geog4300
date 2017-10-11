#Reshaping data using the tidyverse

#Let's load in our census dataset and select just the rate variables
library(tidyverse)
acsdata<-read_csv("https://github.com/jshannon75/geog4300/raw/master/Data/ACSCtyData_2014ACS.csv") %>%
  select(c(cty_name,St_name,wht_pop_pct:nat_ins_pct))

#What if we want to average all of these variables by state?
#We could do each individually using group_by and summarise, but that would create a lot of code
#Let's use gather/spread
acsdata_long<-acsdata %>%
  gather(key="var",value="value",-cty_name,-St_name)

#Now we can do all the variables at once
acsdata_long_mean<-acsdata_long %>%
  group_by(St_name,var)%>%
  summarise(value_mean=mean(value))

#We can use spread to make this data wide agian
acs_data_mean<-acsdata_long_mean %>%
  spread(var,value_mean)

#We can even chain all these commands with pipes
acs_data_mean2<-acsdata %>%
  gather(key="var",value="value",-cty_name,-St_name) %>%
  group_by(St_name,var)%>%
  summarise(value_mean=mean(value)) %>%
  spread(var,value_mean)

#Reshaping data can also make it easier to read. 
#Here's some hypothetical data on graduate enrollments
degree<-c("geography","geography","geography","geography","atmos sci","atmos sci","atmos sci","gis","gis")
year<-c("2011","2012","2013","2014","2012","2013","2014","2011","2012")
admit<-c(32,35,31,36,6,10,12,15,8)
degree_data<-data.frame(cbind(degree,year,admit))

#Let's tidy this long data using spread
degree_data_wide<-degree_data %>%
  spread(year,admit)

#We can also use spread to facet plots with ggplot and tmap
ggplot(acsdata_long,aes(x=value))+
  geom_histogram()+
  facet_wrap(~var)

library(sf)
library(tmap)
acsdata_sf<-st_read("https://github.com/jshannon75/geog4300/raw/master/Data/ACSCtyDat_2014ACS_simplify.geojson") %>%
  select(c(CTY_NAME,State,WHT_POP_PC,AFAM_POP_P,ASN_POP_PC,AMIN_POP_P,POV_POP_PC,LESSHS_PCT)) %>%
  filter(State!="Alaska",State!="Hawaii")
acsdata_sf_long<-acsdata_sf %>%
  gather(key="var",value="value",-CTY_NAME,-State,-geometry)

tm_shape(acsdata_sf_long)+
  tm_fill("value")+
  tm_facets("var",free.coords=TRUE,free.scales.fill=TRUE)
