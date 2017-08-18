##Geography 4300/6300: Reading in data using CSVs

#Most scripts this semester will start by loading the tidyverse package.
library(tidyverse)

#Start by downloading some county level data from GitHub
#This data is stored in a csv and is available at this URL:
#https://github.com/jshannon75/geog4300/blob/master/Data/ACSCtyData_2014ACS.csv
#Right click (or ctrl-click on Mac) on the Download button and save the file.
#Best for you to have a flash drive if you're not on your computer.

#You should also save this script and all class files in a project, which will make accessing data easier.
#We'll go over this in class.
 
#There's several ways to read these data into R.
#You could use the "Import dataset" button on the Environment tab.
#Better to use "read_csv". If you've saved to your project folder, this should work:

census_data<-read_csv("ACSCtyData_2014ACS.csv")

#Now open the data to look at it. Click on it in the Environment tab.
#Or use this:

View(census_data)

#That was a lot of work--why not just load it from GitHub?
#Click on the Download button and then copy the URL. 
#See what this looks like below:

census_data<-read_csv("https://github.com/jshannon75/geog4300/raw/master/Data/ACSCtyData_2014ACS.csv")

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
table(census_data$St_name)

#You can also look at a histogram or boxplot of particular variables
hist(census_data$pov_pop_pct)
boxplot(census_data$pov_pop_pct)

#What if you only want data for some states, like the Southeast?
#Or counties with >30% poverty?
#You can use "filter" (part of the tidyverse).
#The tidyverse uses the pipe, which looks like this: %>%
#It separates parts of a command. Kind of like a period.

census_data_se<-census_data %>%
  filter(Region=="SE")
View(census_data_se)

census_data_pov<-census_data %>%
  filter(pov_pop_pct>30)
View(census_data_pov)

#Look at which states those high poverty counties are in
table(census_data_pov$St_name)

#You can also combine commands using pipes
census_data_sepov<-census_data %>%
  filter(Region=="SE") %>%
  filter(pov_pop_pct>30)
View(census_data_sepov)

#The "select" command allows you to reduce your dataset.
#You can select by column names or numbers

names(census_data)

census_data_pov<-census_data %>%
  select(GEOID,St_name,Region,pov_pop_pct)

census_data_pov<-census_data %>%
  select(1,5,6,47)

#You try it! Our survey responses are online at 
#https://github.com/jshannon75/geog4300/raw/master/Data/geog4300_survey.csv
#Load the data into R. Then do the following
# *Figure out how many people have used R before using table
# *Create a histogram for the athens_year variable (years lived in Athens)
# *Filter for only those records where the person has attended a college football game (the football variable)
