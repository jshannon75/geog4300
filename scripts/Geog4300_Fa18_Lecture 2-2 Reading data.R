##Geography 4300/6300: Reading in data using CSVs and basic manipulation

#Before starting this script, make sure that you've created a new Project in RStudio.
#You can do so using the Project dropdown menu in the upper right.
#Put this script file inside the folder for this project.

#Much of R's functionality comes from add-ons created by developers. 
#These are called libraries or packages. You can install them several ways. Here's one:
install.packages("tidyverse")

#Then "call" the library to activate
library(tidyverse)

#Tidyverse has LOTS of tools that make working with data easier

#Next download some county level data from GitHub
#This data is stored in a csv and is available at this URL:
#https://github.com/jshannon75/geog4300/blob/master/Data/ACSCtyData_2014ACS.csv
#Right click (or ctrl-click on Mac) on the Download button and save the file.
#Best for you to have a flash drive if you're not on your computer.

#You should also save this script and all class files in a project, which will make accessing data easier.
#We'll go over this in class.
 
#There's several ways to read these data into R.
#You could use the "Import dataset" button on the Environment tab.
#Better to use "read_csv". If you've saved to your project folder, this should work:

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

#You can also look at a histogram or boxplot of particular variables
hist(census_data$pov_pop_pct)
boxplot(census_data$pov_pop_pct)
boxplot(pov_pop_pct~Region,data=census_data)

#What if you only want data for some states, like the Southeast?
#Or counties with >30% poverty?
#You can use "filter" (part of the tidyverse).
#The tidyverse uses the pipe, which looks like this: %>%
#It separates parts of a command. Kind of like a period.

census_data_se<-census_data %>%
  filter(Region=="SE")
table(census_data_se$St_name)

census_data_pov<-census_data %>%
  filter(pov_pop_pct>20)

#You try it!!
##Filter all counties in the Northeast with a BA rate > 30% (BADeg_pct)

census_data_elites<-census_data %>%
  filter(Region=="NE" & BADeg_pct > 30)

#Build a tally of high poverty counties by state 
#(Tidyverse has a better way that we'll discuss later)
table(census_data_pov$St_name)
state_pov<-data.frame(table(census_data_pov$St_name))
boxplot(state_pov$Freq) #Box plot
hist(state_pov$Freq) #Histogram
stem(state_pov$Freq) #Stem and leaf plot

#Do the same tally by region and make a bar plot
barplot(table(census_data_pov$Region))

#You can also combine commands using pipes
census_data_sepov<-census_data %>%
  filter(Region=="SE") %>%
  filter(pov_pop_pct>30)
table(census_data_sepov$St_name)

#The "select" command allows you to reduce the number of variables
#You can select by column names or numbers
names(census_data)

census_data_pov<-census_data %>%
  select(GEOID,St_name,Region,pov_pop_pct)

#Use a : to select a range of variable names.
census_data_pov<-census_data %>%
  select(GEOID,St_name,Region,LessHS_pct:GradDeg_pct)

census_data_pov<-census_data %>%
  select(1,5,6,47)

#Lastly, you can use mutate to create new variables
census_data1<-census_data %>%
  mutate(LessBA_pct=HSGrad_pct+SomeCol_pct)
hist(census_data$LessBA_pct)
boxplot(census_data$LessBA_pct)

#You try it! Our survey responses are online at 
#https://github.com/jshannon75/geog4300/raw/master/data/Geog4300_survey.csv
#Load the data into R. Then do the following
# *Figure out how many people have used R before using table (used_r)
# *Create a histogram for the athens_year variable (years lived in Athens)
# *Filter for only those records where the person has attended a college football game (the football variable)
