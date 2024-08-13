##Geography 4300/6300: Reading in data using CSVs and basic manipulation

#Before you start this script, create a new project on your computer/flash drive for the course.
#Projects make working with and sharing research a lot easier--always a good practice.
#Move this script and all other data for the course into that folder.

#You should have already installed the tidyverse package on your computer.
#Now we just need to call it.
library(tidyverse)

#Next download some county level data from GitHub
#There's several ways to read these data into R.
#You could use the "Import dataset" button on the Environment tab.
#Better to use "read_csv". If you've saved to a folder called "data" in your project, this should work:

census_data<-read_csv("data/ACSCtyData_2022ACS.csv")

#Now open the data to look at it. Click on it in the Environment tab.
#Or use this:

View(census_data)

#That was a lot of work--why not just load it from GitHub?
#Click on the Download button and then copy the URL. 
#See what this looks like below:

census_data<-read_csv("https://github.com/jshannon75/geog4300/raw/master/data/ACSCtyData_2022ACS.csv")

#Let's take a look at this file.

#"names" lists just the field
names(census_data)

#The "str" command gives you field names and types
str(census_data)

#"head" and "tail" give you the first and last rows
head(census_data)
tail(census_data)

#What if you only want data for some states, like the Southeast?
#Or counties with >30% poverty?
#You can use "filter" (part of the tidyverse).
#Remember that the tidyverse uses the pipe, which looks like this: %>%

census_data_se<-census_data %>%
  filter(region=="SE")

#What states are in our new data?
table(census_data_se$st_name)

#You can use multiple filters using & (and) or | (or)
#Counties in the Northeast with high educational attainment:
census_data_elites<-census_data %>%
  filter(region=="NE" & BADeg_pct > 25)

#Counties in the Southeast or Northeast with high poverty rates:
census_data_elites1<-census_data %>%
  filter(region=="NE" | region=="SE") %>%
  filter(BADeg_pct > 25)
table(census_data_elites1$St_name)

#You try it!!
##Filter all counties with a poverty rate (pov_pop_pct) > 20% (BADeg_pct)
#Call this census_data_pov





#Build a tally of "elite" counties by state 
#We're using the tidyverse function "count" here to count rows by a categorical variable.
census_data_elites_tbl<-census_data_elites %>%
  count(st_name)

#The "select" command allows you to reduce the number of variables
#You can select by column names or numbers
names(census_data)

census_data_pov<-census_data %>%
  select(GEOID,st_name,region,pov_pop_pct)

#Use a : to select a range of variable names.
#Let's select just educational variables
census_data_ed<-census_data %>%
  select(GEOID,st_name,region,LessHS_pct:GradDeg_pct)

#What does that dataset look like?
head(census_data_ed)

#Lastly, you can use mutate to create new variables
census_data_ed<-census_data_ed %>%
  mutate(LessBA_pct=HSGrad_pct+SomeCol_pct)
hist(census_data_ed$LessBA_pct)
boxplot(census_data_ed$LessBA_pct)

## You try it! 
#Information about Taylor Swift and Beyonce songs on 
# Spotify is available in the data folder: swift_beyonce_spotify.csv
# Load the data into R. Then try the following
# * Filter the dataset to look at only songs in A major (key_mode)
# * Count the number of songs by key AND artist name (hint: the `count` function can take multiple variables)
# * Create a histogram for the danceability variable for an artist of your choosing
# * Create a new variable using mutate that sums danceability, energy, and loudness
# * Calculate which artist has the highest mean value for your new variable
