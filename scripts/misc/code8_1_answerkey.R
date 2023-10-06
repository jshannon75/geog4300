##Code for script 8-1

library(tidyverse)
cps_data<-read_csv("data/IPUMS_CPS_FoodSec.csv")

#Chunk 1: Code for 90% confidence interval and sample size of 80

mean<-43
se<-(6.2/sqrt(80))
z.score<-qnorm(0.95) #This function gets the z score associated with a .975 probability
error<-(se*z.score)
CI.lower<-mean-error
CI.upper<-mean+error

mean #Call the mean
error #Call the margin of error

#Chunk 2: Code for CI of weekly income

meaninc_region<-cps_data %>%
  group_by(Region) %>%
  summarise(meaninc=mean(EARNWEEK),
            earn_sd=sd(EARNWEEK),
            responses=n(),
            se=earn_sd/sqrt(responses))

z.score_upper=qnorm(0.975)
z.score_lower=qnorm(0.025)

meaninc_region1<-meaninc_region %>%
  mutate(error=z.score_upper*se,
         ci_high=meaninc+error,
         ci_low=meaninc-error)

meaninc_region_visual<-meaninc_region1 %>%
  pivot_longer(c(ci_high,ci_low),names_to="ci",values_to="est")

ggplot(meaninc_region_visual)+
  geom_line(aes(x=est,y=reorder(Region,meaninc),group=Region))+
  geom_point(aes(x=meaninc,y=Region))

#Chunk 3: Code for CI of % Divorced
cps_data_div<-cps_data %>%
  filter(is.na(MARST)==FALSE) %>% #Filters NAs
  group_by(STATE) %>%
  mutate(totpop=n()) %>% #Mutate adds the total responses but keeps indivdiual obervations
  ungroup() %>%
  group_by(STATE,MARST,totpop) %>%
  summarise(count=n()) %>%
  pivot_wider(names_from=MARST,values_from=count) %>%
  mutate(divorce_pct=`4`/totpop)

cps_data_div1<-cps_data_div %>%
  mutate(se=sqrt((divorce_pct*(1-divorce_pct))/(totpop-1)),
         error=z.score*se,
         ci_high=divorce_pct+error,
         ci_low=divorce_pct-error)

cps_div_visual<-cps_data_div1 %>%
  pivot_longer(c(ci_high,ci_low),
               names_to="ci",values_to="est")

ggplot(cps_div_visual) +
  geom_line(aes(x=est,y=reorder(STATE,divorce_pct),group=STATE))+
  geom_point(aes(x=divorce_pct,y=STATE))
