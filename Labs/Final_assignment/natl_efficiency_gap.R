district_data<-read_csv("districts_data_all.csv") %>%
  mutate(year=as.character(year))

#Calculate wasted votes
#If a party wins the election, wasted votes are any more than 50% + 1 of all votes
#If a party loses the election, all votes are wasted votes

election_waste<-district_data %>%
  filter(total_vote!=-99 & dist_omit!=1) %>%
  mutate(pct_dem_adj=ifelse(uncontest_r==1,66,ifelse(uncontest_d==1,36,pct_dem)),
         dem_vote_adj=ifelse(uncontest_r==1 | uncontest_d==1, pct_dem_adj/100*total_vote, dem_vote),
         pct_gop_adj=ifelse(uncontest_r==1 | uncontest_d==1,100-pct_dem_adj,pct_gop),
         gop_vote_adj=ifelse(uncontest_r==1 | uncontest_d==1,pct_gop_adj/100*total_vote,repub_vote),
         dwaste=ifelse(dem_vote_adj>gop_vote_adj,dem_vote_adj-(total_vote/2+1),dem_vote_adj),
         rwaste=ifelse(gop_vote_adj>dem_vote_adj,gop_vote_adj-(total_vote/2+1),gop_vote_adj),
         netwasted=dwaste-rwaste,
         party_fav=ifelse(netwasted>0,"R",ifelse(netwasted<0,"D","T")))

#Sum the wasted votes and calculate the efficiency gap
election_totals<-election_waste %>%
  group_by(year,st_abbr)%>%
  summarise(total_votes=sum(total_vote),
            dwaste_all=sum(dwaste),
            rwaste_all=sum(rwaste),
            total_waste=dwaste_all-rwaste_all,
            party_fav=ifelse(dwaste_all>rwaste_all,"R","D"),
            eff_gap=total_waste/total_votes)

ggplot(election_totals,aes(x=eff_gap)) +
  geom_histogram()+
  facet_wrap(~year)

#Join to the state shapefile
states<-st_read("USstates_48.geojson") %>%
  select(STATE_NAME,st_abbr,STATE_FIPS,Region,gisjn_st)
states_1990<-states %>% mutate(year="1990")
states_2015<-states %>% mutate(year="2015")
states_all<-rbind(states_1990,states_2015)

states_effgap<-left_join(states_all,election_totals) %>%
  filter(total_votes>-1)
tm_shape(states_effgap) +
  tm_polygons()

st_write(states_effgap,"USstates_48_effgap.geojson")
