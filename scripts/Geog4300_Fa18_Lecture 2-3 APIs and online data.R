#Geog4/6300 Fall 17
#Using APIs to import data

#While CSVs can be convenient ways to import data, 
#APIs (application program interfaces) provide another way to access data directly from the source.
#Many orgs provide APIs for those using their data. 
#Here's two examples:

##Star Wars API (SWAPI) ####
#See their website: https://swapi.co/
#See also this presentation from Amanda Gadrow about using SWAPI: https://www.rstudio.com/resources/videos/using-web-apis-from-r/
#And this one by Charlotte Wickham: https://www.rstudio.com/resources/videos/happy-r-users-purrr-tutorial/

#You can search for data directly on their site. For example, see results for Dagobah
#Search for planets/5 on the site
#These results are in JSON. Efficient way to store data, but not easy to look at in a table.
#See the walk through in the sites above for how to access in R

##Spotify API ####
#This tutorial is based on support materials from the spotifyr package: http://www.rcharlie.com/spotifyr/
#Install using the following link:
#devtools::install_github("charlie86/spotifyr")

#Register your Spotify user account. 
#You'll need to copy and paste the ID and secrets in the appropriate spots below:
Sys.setenv(SPOTIFY_CLIENT_ID = 'xxxxxxxxxxxxxxxxxxxxx')
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'xxxxxxxxxxxxxxxxxxxxx')

access_token <- get_spotify_access_token()

#Now you can get to work.
library(spotifyr)
library(tidyverse)

rem <- get_artist_audio_features('r.e.m.')
head(rem)

#Explore the data we can get
table(rem$key_mode)
table(rem$album_name)
table(rem$track_popularity) #What's their most and least popular song?
hist(rem$danceability) #What's the most and least danceable song?
hist(rem$valence) #Higher = happier



##APIs and census data####
#The tidycensus package gives us an easy way to explore census data
#See https://walkerke.github.io/tidycensus/
#install.packages(tidy.census)
library(tidycensus)

census_api_key("YOUR API KEY GOES HERE")

#Look at what variables are available. You can use the Filter and search boxes to identify variables 
v15 <- load_variables(2016, "acs5", cache = TRUE)
View(v15)

#Let's load tract data in Georgia about median household income
tract_income<-get_acs(state="GA",geography="tract",variable="B19013_001E",year=2016)
hist(tract_income$estimate)

#You can load data on multiple variables. 
#Let's load data on those spending more than 30% of their household income on housing
vars<-c("B25070_001E","B25070_007E","B25070_008E","B25070_009E","B25070_010E")
tract_housing<-get_acs(state="GA",geography="tract",variable=vars,year=2016)

#We can use a little tidyverse magic to add these up.
tract_housing_total<-tract_housing %>%
  select(-moe) %>% #Delete the margin of error for now
  spread(variable,estimate) %>% #"Spread out" the variables
  mutate(house30_rt=(B25070_007+B25070_008+B25070_009+B25070_010)/B25070_001*100) #Create a rate using the 001 variable (total housing units)

#Which counties have the highest number of tracts with distressed housing?  

#tidycensus also allows us to download geographic data
tract_income<-get_acs(state="GA",geography="tract",variable="B19013_001E",year=2016,geometry=TRUE)
plot(tract_income)
ggplot()+geom_sf(data=tract_income, aes(fill=estimate), color=NA)

#We will do more work with tidycensus later in the semester.
#If you want to do more work with tidycensus, you can get your own API key here: 
#https://api.census.gov/data/key_signup.html



###Daymet data####
#The Daymet dataset provides gridded climate data going back to 1980 for the whole US.
#Here's their website: https://daymet.ornl.gov/
#They provide an API service where you can query their database directly.
#Directions here: https://daymet.ornl.gov/web_services.html

#For instance, the following uRL gives you data on the Geography/Geology building
#https://daymet.ornl.gov/data/send/query?lat=33.948693&lon=-83.375475&year=2016

#The daymetr package allows you to access these data directly
#We'll use this dataset in your first lab.

#install.packages("devtools") #This package allows installation from Github
#devtools::install_github("khufkens/daymetr") #Installing the package directly from Github
library(daymetr) # load the package

#Load 10 years of data on Athens
#The value for site will be the name of the new file
athens<-download_daymet(site="athens",lat=33.948693,lon=-83.375475,start=2005,end=2015,internal=TRUE)

#This returns a list! Let's extract the data file
athens_data<-athens$data

###You try it!
###Download 10 years of climate data for a point of your choosing.
