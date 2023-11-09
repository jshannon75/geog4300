library(tidyverse)
library(sf)
library(ggcorrplot)
library(car)

wh_cty<-read_csv("data/wh_locations_coords.csv") %>%
  count(cty_fips,name="wh_count") %>%
  rename(GEOID=cty_fips)
census<-read_csv("data/ACSCtyData_2019ACS.csv") %>%
  left_join(wh_cty) %>%
  mutate(wh_100k=wh_count/totpop_race*100000)

#Normality
hist(census$wh_100k)

#Multicollinearity
census_sel<-census %>%
  select(totpop_race,wht_pop_pct:fb_ins_pct,wh_count,wh_100k)%>% 
  filter(is.na(wh_100k)==FALSE)

correlation_matrix <- cor(census_sel)
ggcorrplot(correlation_matrix, 
           type = "upper", 
           method="circle")


#Trying out the models

#Base model
model<-(lm(wh_100k~pov_pop_pct+LessHS_pct, 
        data=census_sel))
summary(model)
        
plot(model)

vif(model)

#Model with multicollinearity issues
modelmc<-(lm(wh_100k~pov_pop_pct+fb_pct+nat_pct, 
           data=census_sel))
vif(modelmc)

#Model with counts rather than rates
model_count<-(lm(wh_count~pov_pop_pct+LessHS_pct, 
           data=census_sel))
summary(model_count)

#Model with counts and including total population
model_count1<-(lm(wh_count~totpop_race+pov_pop_pct+LessHS_pct, 
                 data=census_sel))
summary(model_count1)

##What other variables could we try? 
model_count<-(lm(wh_100k~??, 
                 data=census_sel))
summary(model_count)
