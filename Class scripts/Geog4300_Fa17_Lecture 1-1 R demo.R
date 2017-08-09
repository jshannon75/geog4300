#install.packages("tidycensus")
#install.packages("mapview")
#install.packages("tidyverse")
#install.packages("viridis")
#install.packages("forcats")
#install.packages("tmap")

library(tidycensus)
library(tidyverse)
library(mapview)
library(viridis)
library(forcats)
library(tmap)
options(tigris_use_cache = TRUE)

census_api_key("733eb53a4287ab992637dcdd57408410992465ed")

#Code adapted from https://walkerke.github.io/tidycensus/articles/spatial-data.html

##Mapping median income
Atl_median_income <- get_acs(state = "GA", county = c("Fulton","DeKalb"), geography = "tract", 
                  variables = "B19013_001", geometry = TRUE)

hist(Atl_median_income$estimate)
boxplot(Atl_median_income$estimate)

mapview(Atl_median_income,zcol="estimate")


##Mapping race
racevars <- c("P0050003", "P0050004", "P0050006", "P0040003")

Atl_race <- get_decennial(geography = "tract", variables = racevars, 
                        state = "GA", county = c("Fulton","DeKalb"), geometry = TRUE,
                        summary_var = "P0010001") 

#Calculate rates
Atl_race_transform<-Atl_race %>%
  mutate(pct = 100 * (value / summary_value),
         variable = fct_recode(variable,
                               WhtAm = "P0050003",
                               AfAm = "P0050004",
                               AsnAm = "P0050006",
                               Latinx = "P0040003")) %>%
  select(-value) %>%
  filter(summary_value!=0) %>%
  spread(variable,pct)

#Map using tmap
tm_shape(Atl_race_transform) +
  tm_polygons(c("WhtAm","AfAm","AsnAm","Latinx"),
              style="jenks",
              palette=list("Reds", "Purples","Blues", "YlGn"),
              auto.palette.mapping=FALSE,
              title=c("% White American", "% African American","% Asian American","% Latinx"))+
  tm_scale_bar() +
  tm_compass()
