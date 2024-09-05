#County data update
library(tidycensus)
library(tidyverse)

old<-read_csv("data/archive/ACSCtyData_2019ACS.csv") %>%
  select(GISJn_St,St_name,Region) %>%
  rename(gisjn_st=GISJn_St,
         st_name=St_name,
         region=Region) %>%
  distinct()

vars<-load_variables(2022,"acs5",cache=TRUE)

var_list<-c("B03002","B15003","B17025","B19019","B27020","B28011","B14001")

var_select<-vars %>%
  filter(substr(name,1,6) %in% var_list)
write_csv(var_select,"data/censusvars.csv")

ctydata<-get_acs(geography="county",variable=var_select$name,year=2022)

ctydata_format<-ctydata %>%
  select(-moe) %>%
  pivot_wider(names_from=variable,values_from=estimate) %>%
  mutate(totpop_race=B03002_001,
         wht_pop=B03002_003,
         blk_pop=B03002_004,
         amin_pop=B03002_005,
         asn_pop=B03002_006,
         hisp_pop=B03002_012,
         hpi_pop=B03002_007,
         oth_pop=B03002_008,
         two_pop=B03002_009+B03002_010,
         thr_pop=B03002_011,
         totpop_ed=B15003_001,
         LessHS=B15003_002+B15003_003+B15003_004+B15003_005+
                  B15003_006+B15003_007+B15003_008+B15003_009+
                  B15003_010+B15003_011+B15003_012+B15003_013+
                  B15003_014+B15003_015+B15003_016,
         HSGrad=B15003_017+B15003_018,
         SomeCol=B15003_019+B15003_021,
         BADeg=B15003_022,
         GradDeg=B15003_023+B15003_024+B15003_025,
         ugrad_pop=B14001_008,
         gradstd_pop=B14001_009,
         totpop_intnet=B28011_001,
         intnet_all_pop=B28011_002,
         intnet_dial_pop=B28011_003,
         intnet_brd_pop=B28011_004,
         intnet_none_pop=B28011_008,
         medinc=B19019_001,
         totpop_pov=B17025_001,
         pov_pop=B17025_002,
         allcit_pop=B27020_001,
         nat_pop=B27020_002,
         fbnat_pop=B27020_008,
         fb_pop=B27020_013,
         nat_ins=B27020_003,
         fbnat_ins=B27020_009,
         fb_ins=B27020_014,
         wht_pop_pct=wht_pop/totpop_race*100,
         blk_pop_pct=blk_pop/totpop_race*100,
         amin_pop_pct=amin_pop/totpop_race*100,
         asn_pop_pct=asn_pop/totpop_race*100,
         hisp_pop_pct=hisp_pop/totpop_race*100,
         hpi_pop_pct=hpi_pop/totpop_race*100,
         oth_pop_pct=oth_pop/totpop_race*100,
         two_pop_pct=two_pop/totpop_race*100,
         thr_pop_pct=thr_pop/totpop_race*100,
         LessHS_pct=LessHS/totpop_ed*100,
         HSGrad_pct=HSGrad/totpop_ed*100,
         SomeCol_pct=SomeCol/totpop_ed*100,
         BADeg_pct=BADeg/totpop_ed*100,
         GradDeg_pct=GradDeg/totpop_ed*100,
         ugrad_pct=ugrad_pop/B14001_001*100,
         gradstd_pct=gradstd_pop/B14001_001*100,
         intnet_all_pct=intnet_all_pop/totpop_intnet*100,
         intnet_dial_pct=intnet_dial_pop/totpop_intnet*100,
         intnet_brd_pct=intnet_brd_pop/totpop_intnet*100,
         intnet_none_pct=intnet_none_pop/totpop_intnet*100,
         pov_pop_pct=pov_pop/totpop_pov*100,
         nat_pct=nat_pop/allcit_pop*100,
         fbnat_pct=fb_pop/allcit_pop*100,
         fb_pct=fb_pop/allcit_pop*100,
         nat_ins_pct=if_else(nat_pop>0,nat_ins/nat_pop*100,0),
         fbnat_ins_pct=if_else(fbnat_pop>0,fbnat_ins/fbnat_pop*100,0),
         fb_ins_pct=if_else(fb_pop>0,fb_ins/fb_pop*100,0)) %>%
  select(-B03002_001:-B28011_008) %>%
  rename(cty_name=NAME,cty_fips=GEOID) %>%
  mutate(gisjn_st=paste("G",substr(cty_fips,1,2),sep=""))

ctydata_all<-old %>%
  left_join(ctydata_format) 

write_csv(ctydata_all,"data/ACSCtyData_2022ACS.csv")

library(sf)
cty_boundary<-st_read("data/archive/ACSCtyData_2019ACS_simplify.gpkg") %>%
  select(GEOID) %>%
  rename(cty_fips=GEOID) %>%
  left_join(ctydata_all)
st_write(cty_boundary,"data/ACSCtyData_2022ACS_simplify.gpkg",delete_dsn=TRUE)
