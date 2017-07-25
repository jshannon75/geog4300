##Summarizing census data

#Import census data on household dynamics
census_cty<-read.csv("ACSCtyData_2014ACS.csv")

#Examine these data in the table view in R. You can sort columns by values
#You can also ask for a list of variable names and types
names(census_cty) #Names for each column
str(census_cty) #Data types (string/text, numeric, factor, etc.)

#What's the distribution of the total county population?
summary(census_cty$totpop_rac)
hist(census_cty$totpop_rac)
boxplot(census_cty$totpop_rac)

#Calculate the % of the population whose highest
#educational attainment is HS or less
census_cty$HS_pct<-(census_cty$HSGrad+census_cty$LessHS)/census_cty$totpop_ed

#What's the distribution of this population?
summary(census_cty$HS_pct)
hist(census_cty$HS_pct)
boxplot(census_cty$HS_pct)

#Compare pct finishing HS to total population
plot(census_cty$totpop_ed,census_cty$HS_pct)
#Change x axis to a log scale--controls for outliers
plot(census_cty$totpop_ed,census_cty$HS_pct,log="x") 


###Summarizing your introductory survey

#Import the survey csv as a data frame called IntroSurvey
View(IntroSurvey)

#Use the dollar sign to select variables within datasets
IntroSurvey$excite

#Use the "summary" command to see a breakdown of 
summary(IntroSurvey$stats_course)
summary(IntroSurvey$excite)
#How are these different? Type of data/way summary is reported

#Tables help organize responses
acad.table<-data.frame(table(IntroSurvey$academic)) #Combines these values into a table and then converts to a data frame
acad.table #View the data frame

#The hist function creates a histogram of numeric data
#Notice how the number of breaks changes the way the data look
hist(IntroSurvey$athens_yr, breaks=4)
hist(IntroSurvey$athens_yr, breaks=10)
hist(IntroSurvey$athens_yr, breaks=20)

#Use a summary and histogram to analyze the number of football games attended by members of our class
#The variable name is "football"
#How would you describe the distribution of this variable?

##Subsetting data

#There are multiple ways of subsetting data in R. The easiest is the subset command:
IntroSurvey.physical<-subset(IntroSurvey,academic=="Physical geographer") #Select by variable value
IntroSurvey.statspeople<-subset(IntroSurvey,stats_course=="One" | stats_course=="Two" | stats_course=="Three or more") #Select using multiple values
IntroSurvey.statspeople1<-subset(IntroSurvey,stats_course!="None") #Same as above, just using "does not equal" 
IntroSurvey.academic<-subset(IntroSurvey,select="academic") #Select just certain columns. 
IntroSurvey.multiple<-subset(IntroSurvey,select=c("academic","excite")) #Use "c()" to group multiple values

#You can also use square brackets to select rows or columns you'd like to subset
#The brackets can include row criteria or column numbers (see the names command)
#So the format is dataframe[row criteria, column criteria]
#If you're not using criteria for a row or column, just leave it blank
IntroSurvey.physical1<-IntroSurvey[IntroSurvey$academic=="Physical geographer",] #Same as l. 32 above
IntroSurvey.academic1<-IntroSurvey[,"academic"] #Same as line 35 above. Notice that this isn't a data frame, though. Just a factor.
IntroSurvey.multiple1<-IntroSurvey[,2:4] #Selecting columns 2-4 (use the names function to identify)
IntroSurvey.multiple2<-IntroSurvey[,c(2,4,6:7)] #Selecting non-consecutive columns

#Load the county data we used last time. Do three tasks
#(1) Subset the list of counties to just a single state using the GISJn_St column.
#(2) Compute a new variable called "nat_noins_pct" that shows the percent of native born individuals without health insurance
#(3) List summary statistics and create a histogram for that new variable