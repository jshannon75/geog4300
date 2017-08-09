##Geography 4300/6300 Lab week 1

#These hash tags create comments in the code. 
#R won't read anything on this line.

#First things first--let's make R talk
#The command below just returns the text
print("Hello, World!")

#R can do math
3 + 8
2 ^ 5
108973478643 * 1289737829468




#Like most programming languages, R allows you to create variables.
#In R these are called objects. Think of them as boxes. You can store lots of stuff in them.
#Objects can be numeric, string (characters/text), dates, or logical (true/false)
#Both "<-" and "=" can be used to *assign* a value to any object.
Text<-"Hello, World!"
Text

A<-1
A

#You can do math with objects
A<-3
B<-8
A+B
A*B
A^2

#Objects can interact with each other
A<-1
B<-2
C<-A+B
C

#Objects can't mix, though
A<-1
B<-"2"
A+B

B<-as.numeric(B)
A+B




#A group of objects is called a vector. Each vector can have only one type of object
#Use "c()" to group objects together into a vector
A<-c(1,2,3,4,5)
A

B<-c(20,25,30,35,40)
B

C<-c("Red","Blue","Green","Purple","Yellow")
C

#You can apply functions to vectors.
#Functions are specific operations
A1<-A+4
A1

Aexp<-exp(A) #Shows the value of each number as an exponent of the natural log (e)
Aexp

nchar(C) #The number of letters in each item in the vector

#Vectors can also interact with each other
AB<-A+B
AB




#Vectors can also be grouped together.
#The most common way to do this with a data frame.
#These are very similar to an Excel spreadsheet.
#Each column in a data frame is like a single vector--a group of values all of the same type.
#You can also mix data types in a data frame.
#Most of the analysis we do this semester will use data frames
test_df<-data.frame(A,B,C)
test_df
summary(test_df)

#There are other data structures such as matrices or lists in R.
#Most of what we cover in this course, though, uses data frames



#Let's try this with data from the census

#Import census data on household dynamics from Github
census_cty<-read_csv("https://raw.githubusercontent.com/jshannon75/geog4300/master/Data/ACSCtyData_2014ACS.csv")

#Examine these data in the table view in R. You can sort columns by values
#You can also ask for a list of variable names and types
names(census_cty) #Names for each column
str(census_cty) #Data types (string/text, numeric, factor, etc.)
 
#What's the distribution of the total county population?
summary(census_cty$totpop_rac)
hist(census_cty$totpop_rac)
boxplot(census_cty$totpop_rac)

#Calculate the % of the population whose highest educational attainment is HS or less
census_cty$HS_pct<-(census_cty$HSGrad+census_cty$LessHS)/census_cty$totpop_ed

#What's the distribution of this population?
summary(census_cty$HS_pct)
hist(census_cty$HS_pct)
boxplot(census_cty$HS_pct)

#Compare pct finishing HS to total population
plot(census_cty$totpop_ed,census_cty$HS_pct)
#Change x axis to a log scale--controls for outliers
plot(census_cty$totpop_ed,census_cty$HS_pct,log="x") 
