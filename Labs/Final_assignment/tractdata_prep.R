library(tidyverse)
library(sf)

#Import data from NHGIS and calculate variables
tract1990_1<-read_csv("supporting_data/Tract data/nhgis0054_ds120_1990_tract.csv")
tract1990_2<-read_csv("supporting_data/Tract data/nhgis0054_ds123_1990_tract.csv")
tract1990_3<-read_csv("supporting_data/Tract data/nhgis0057_ds123_1990_tract.csv")
tract1990<-left_join(tract1990_1,tract1990_2) %>%
  left_join(tract1990_3)%>%
  select(-ANRCA:-BLCK_GRPA,-CDA,-C_CITYA,-CTY_SUBA,-PLACEA,-ZIPA) %>%
  mutate(rce_totpop=ET2001+ET2002+ET2003+ET2004+ET2005+ET2006+ET2007+ET2008+ET2009+ET2010,
         whtnh_pct=ET2001/rce_totpop*100,
         blknh_pct=ET2002/rce_totpop*100,
         asnnh_pct=ET2004/rce_totpop*100,
         hisp_pct=(ET2006+ET2007+ET2008+ET2009+ET2010)/rce_totpop*100,
         medhhinc=E4U001,
         medhhinc_adj=E4U001*1.8134, #Median household income in 2015 dollars
         pov_totpop=E1C001+E1C002+E1C003+E1C004+E1C005+E1C006+E1C007+E1C008+E1C009,
         pov100_pct=(E1C001+E1C002+E1C003)/pov_totpop*100,
         ed_totpop=E33001+E33002+E33003+E33004+E33005+E33006+E33007,
         badeg_pct=(E33006+E33007)/ed_totpop*100) %>%
  select(-EUW001:-E33007)

write_csv(tract1990,"nhgis0054_1990_tract_calc.csv")

tract2015a<-read_csv("Tract data/nhgis0057_ds215_20155_2015_tract.csv")
tract2015<-read_csv("Tract data/nhgis0054_ds215_20155_2015_tract.csv") %>%
  left_join(tract2015a) %>%
  select(-BLKGRPA:-BTBGA) %>%
  mutate(whtnh_pct=ADK5E003/ADK5E001*100,
         blknh_pct=ADK5E004/ADK5E001*100,
         asnnh_pct=ADK5E006/ADK5E001*100,
         hisp_pct=ADK5E012/ADK5E001*100,
         medhhinc=ADNKE001,
         pov100_pct=(ADNEE002+ADNEE003)/ADNEE001*100,
         badeg_pct=(ADMZE022+ADMZE023+ADMZE024+ADMZE025)/ADMZE001*100) %>%
  select(-ADK5E001:-ADMZM025)

write_csv(tract2015,"nhgis0054_2015_tract_calc.csv")

#Read in shapefiles and join
#1990
library(sf)
tracts_1990<-st_read("supporting_data/Tract data/US_tract_1990_cd_wgs84.shp") %>%
  left_join(tract1990) %>%
  filter(rce_totpop>0,medhhinc>0)

#st_write(tracts_1990,"Tract data/US_tract_1990_data.geojson")
st_write(tracts_1990,"Tract data/US_tract_1990_data.shp")

#Code for looking at GA
# tracts_1990_a<-tracts_1990 %>%
#   filter(NHGISST==130)
# 
# district1990<-
#   st_read("cd99_103_wgs84.shp") %>%
#   filter(ST==13)
# 
# library(tmap)
# tm_shape(tracts_1990_a)+
#   tm_polygons("whtnh_pct",border.alpha=0,breaks=c(0,10,20,40,60,100))+
# tm_shape(district1990) + 
#   tm_borders(lwd=2,col="black") + 
#   tm_text("CD",shadow=TRUE)

#2015
tracts_2015<-st_read("Tract data/US_tract_2015_cd_wgs84.shp") %>%
  left_join(tract2015)

#st_write(tracts_2015,"Tract data/US_tract_2015_data.geojson")
st_write(tracts_2015,"Tract data/US_tract_2015_data.shp")

# tracts_2015a<-tracts_2015 %>%
#   filter(STATEFP==13)
# 
# district2015<-st_read("cb_2016_us_cd115_500k_wgs84.shp") %>%
#   filter(STATEFP==13)
# 
# tm_shape(tracts_2015a)+tm_polygons("whtnh_pct",border.alpha=0,breaks=c(0,10,20,40,60,100)) + 
#   tm_shape(district2015) + 
#   tm_borders(lwd=2,col="black") + 
#   tm_text("CD115FP",shadow=TRUE)

#Combine files and add tract ID
tracts_1990_short<-tracts_1990 %>%
  mutate(STATEFP=substr(NHGISST,1,2))%>%
  select(STATEFP,UA,GISJOIN,whtnh_pct:geometry,-medhhinc,-pov_totpop,-ed_totpop) %>%
  mutate(nonwht_pct=100-whtnh_pct,
         year="1990") %>%
  rename("medhhinc"=medhhinc_adj)

tracts_2015_short<-tracts_2015 %>%
  select(STATEFP,UA,GISJOIN,whtnh_pct:geometry) %>%
  mutate(nonwht_pct=100-whtnh_pct,
         year="2015") 

#Attempt to do spatial join in R
# district1990<-st_read("cd99_103_wgs84.shp") %>%
#   mutate(year="1990") %>%
#   rename("STATEFP"=ST) %>%
#   select(STATEFP,CD,CD_ID,year)
# district2015<-st_read("cb_2016_us_cd115_500k_wgs84.shp") %>%
#   mutate(year="2015") %>%
#   rename("CD"=CD115FP) %>%
#   select(STATEFP,CD,CD_ID,year)

# tracts_1990_dist<-st_join(tracts_1990_short,district1990)
# tracts_1990_dist1<-tracts_1990_dist %>%
#   select(-STATEFP.y,-year.y) %>%
#   rename("STATEFP"=STATEFP.x,"year"=year.x)
# 
# tracts_2015_dist<-st_join(tracts_2015_short,district2015)
# tracts_2015_dist1<-tracts_2015_dist %>%
#   select(-STATEFP.y,-year.y) %>%
#   rename("STATEFP"=STATEFP.x,"year"=year.x)


#Create medians by district
#Read data from spatial join in Arc
tracts_2015<-st_read("supporting_data/tract_data/US_tract_2015_data_dist.shp") %>%
  select(-Join_Count,-TARGET_FID,-COUNTYFP:-NAME_E,-LSAD) %>%
  rename("CD"=CD115FP) %>%
  mutate(nonwht_pct=100-whtnh_pct,
         year=2015)
 
tracts_1990<-st_read("supporting_data/tract_data/US_tract_1990_data_dist.shp") %>%
  select(-OBJECTID:-rc_ttpp,-Shape_Area,-Shape_Leng,-REP_NAME,
         -medhhnc,-pv_ttpp,-ed_ttpp) %>%
  rename("whtnh_pct"=whtnh_p,
         "blknh_pct"=blknh_p,
         "asnnh_pct"=asnnh_p,
         "hisp_pct"=hsp_pct,
         "medhhinc"=mdhhnc_,
         "pov100_pct"=pv100_p,
         "badeg_pct"=bdg_pct,
         "STATEFP"=ST) %>%
  mutate(nonwht_pct=100-whtnh_pct,
         year=1990)

tracts_all<-rbind(tracts_1990,tracts_2015)

tracts_all_df<-tracts_all[,c(8,9,10,1:7,11,12,13)]
st_geometry(tracts_all_df)<-NULL

tracts_all_table<-tracts_all_df %>%
  gather(whtnh_pct:nonwht_pct,key="var",value="value") %>%
  group_by(year,CD_ID,var) %>%
  summarise(median=median(value)) %>%
  spread(var,median)

#Adding vote totals
district1990<-st_read("supporting_data/cd99_103_wgs84.shp") %>%
  mutate(year="1990") %>%
  rename("STATEFP"=ST) %>%
  select(STATEFP,CD,CD_ID,year)
district2015<-st_read("supporting_data/cb_2016_us_cd115_500k_wgs84.shp") %>%
  mutate(year="2015") %>%
  rename("CD"=CD115FP) %>%
  select(STATEFP,CD,CD_ID,year)
districts<-rbind(district1990,district2015) 

votingdata<-read_csv("districts_votes1.csv") %>%
  rename("CD_ID"=cd_id)
votingdata$year<-as.character(votingdata$year)

districts_data<-left_join(districts,votingdata) 

#read in state regions/codes
state_regions<-read_csv("supporting_data/state_regional codes.csv") %>%
  rename("STATEFP"=st_fips)
districts_data1<-left_join(districts_data,state_regions) %>%
  mutate(CD_ID1=paste(st_abbr,CD,sep="-"),
         CDIDYR=paste(CD_ID1,year,sep="-"))

st_write(districts_data1,"supporting_data/districts_voting.shp")

#Combine districts and tract medians
tracts_all_table$year<-as.character(tracts_all_table$year)
districts_data_demog<-left_join(districts_data1,tracts_all_table)

omitcount<-read_csv("district_count_omit.csv") %>%
  rename("State"=state_name)
districts_data_demog<-left_join(districts_data_demog,omitcount)
districts_data_demog<-districts_data_demog[,c(1:4,10:24,5:9,25,26)] %>%
  mutate(uncontest_r=ifelse(repub_vote==0,1,0),
         uncontest_d=ifelse(dem_vote==0,1,0),
         missing=ifelse(repub_vote==-99,1,ifelse(dem_vote==-99,1,0)))

st_write(districts_data_demog,"districts_data_all.shp")

districts_data_demog_df<-districts_data_demog
st_geometry(districts_data_demog_df)<-NULL

write_csv(districts_data_demog_df,"districts_data_all.csv")

library(ggridges)
testdata<-districts_data1 %>%
  filter(year==1990 & Region=="South Region")

ggplot(testdata,aes(x=pct_dem,y=State)) +
  geom_density_ridges(scale=2)

ggplot(tracts_select,aes(x=nonwht_pct,y=CD))+
  geom_density_ridges(scale=3)+
  theme_ridges() +
  facet_grid(.~year)