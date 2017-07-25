##Geography 4300/6300 Lab week 1

#These hash tags create comments in the code. 
#R won't read anything on this line.

#Like most programming languages, R allows you to create variables.
Text<-"Hello World!"
Text

A<-1
A

#R can do math
A<-3
B<-8
A+B
A*B
A^2

#Variables can interact with each other
A<-1
B<-2
C<-A+B
C

#Variables can be numbers or text, but those can't mix
A<-1
B<-"2"
A+B

B<-as.numeric(B)
A+B

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




