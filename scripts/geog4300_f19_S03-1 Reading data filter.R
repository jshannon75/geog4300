##Geography 4300/6300: Reading in data using CSVs and basic manipulation

#Before you start this script, create a new project on your computer/flash drive for the course.
#Projects make working with and sharing research a lot easier--always a good practice.
#Move this script and all other data for the course into that folder.

#You should have already installed the tidyverse package on your computer.
#Now we just need to call it.
library(tidyverse)

#Next download some county level data from GitHub
#This data is stored in a csv and is available at this URL:
#https://github.com/jshannon75/geog4300/raw/master/data/ACSCtyData_2014ACS.csv
#Right click (or ctrl-click on Mac) on the Download button and save the file.
#Best for you to have a flash drive if you're not on your computer.
 
#There's several ways to read these data into R.
#You could use the "Import dataset" button on the Environment tab.
#Better to use "read_csv". If you've saved to a folder called "data" in your project, this should work:

census_data<-read_csv("data/ACSCtyData_2014ACS.csv")

#Now open the data to look at it. Click on it in the Environment tab.
#Or use this:

View(census_data)

#That was a lot of work--why not just load it from GitHub?
#Click on the Download button and then copy the URL. 
#See what this looks like below:

census_data<-read_csv("https://github.com/jshannon75/geog4300/raw/master/data/ACSCtyData_2014ACS.csv")

#Let's take a look at this file.

#"names" lists just the field
names(census_data)

#The "str" command gives you field names and types
str(census_data)

#"head" and "tail" give you the first and last rows
head(census_data)
tail(census_data)

#Table gives you the number of times a value shows up.
#It's good for character fields
table(census_data$St_name,census_data$Region)

#You can also look at a histogram or boxplot of particular variables.
#We'll use the ggplot package to do so (part of tidyverse)
#ggplot first defines the variables you're graphing, then adds "geom" or visualization type.
#Here's a histogram
ggplot(census_data,aes(x=pov_pop_pct))+
  geom_histogram()

#Here's a boxplot:
ggplot(census_data,aes(y=pov_pop_pct))+
  geom_boxplot()

#Here's a boxplot by region
ggplot(census_data,aes(x=Region,y=pov_pop_pct))+
  geom_boxplot()

#Here's a scaterplot with % of citizens having health insurance
ggplot(census_data,aes(x=nat_ins_pct,y=pov_pop_pct))+
  geom_point()

#You can also color these by a variable. Here's that scatterplot colored by region
ggplot(census_data,aes(x=nat_ins_pct,y=pov_pop_pct,color=Region))+
  geom_point()

#What if you only want data for some states, like the Southeast?
#Or counties with >30% poverty?
#You can use "filter" (part of the tidyverse).
#Remember that the tidyverse uses the pipe, which looks like this: %>%

census_data_se<-census_data %>%
  filter(Region=="SE")

#What states are in our new data?
table(census_data_se$St_name)

#You can use multiple filters using & (and) or | (or)
#Counties in the Northeast with high educational attainment:
census_data_elites<-census_data %>%
  filter(Region=="NE" & BADeg_pct > 25)

#Counties in the Southeast or Northeast with high poverty rates:
census_data_elites1<-census_data %>%
  filter(Region=="NE" | Region=="SE") %>%
  filter(BADeg_pct > 25)
table(census_data_elites1$St_name)

#You try it!!
##Filter all counties with a poverty rate (pov_pop_pct) > 20% (BADeg_pct)
#Call this census_data_pov

#Build a tally of high poverty counties by state 
#We're using base R to create and plot this table. 
table(census_data_pov$St_name)
state_pov<-data.frame(table(census_data_pov$St_name))

#The "select" command allows you to reduce the number of variables
#You can select by column names or numbers
names(census_data)

census_data_pov<-census_data %>%
  select(GEOID,St_name,Region,pov_pop_pct)

#Use a : to select a range of variable names.
#Let's select just educational variables
census_data_pov<-census_data %>%
  select(GEOID,St_name,Region,LessHS_pct:GradDeg_pct)

#Lastly, you can use mutate to create new variables
census_data<-census_data %>%
  mutate(LessBA_pct=HSGrad_pct+SomeCol_pct)
hist(census_data$LessBA_pct)
boxplot(census_data$LessBA_pct)

#You try it! Information about REM songs on Spotify is available at this link
#https://github.com/jshannon75/geog4300/raw/master/data/rem_songs.csv
#Load the data into R. Then do the following
# *Filter the dataset to look at only songs in A major (key_mode)
# *Create a histogram for the danceability variable
# *Create a new variable using mutate that combines danceability, energy, and loudness.
