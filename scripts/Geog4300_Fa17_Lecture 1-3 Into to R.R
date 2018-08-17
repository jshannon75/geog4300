##Geography 4300/6300 Lab week 1

#These hash tags create comments in the code. 
#R won't read anything on this line.

#First things first--let's make R talk
#The command below just returns the text listed.
print("Hello, world!")

#R can do math
3 + 8
2 ^ 5
108973478643 * 1289737829468




#Like most programming languages, R allows you to create variables.
#In R these are called objects. Think of them as boxes. You can store lots of stuff in them.
#Objects can be numeric, string (characters/text), dates, or logical (true/false)
#Both "<-" and "=" can be used to *assign* a value to any object.
Text<-"Hello, world!"
Text

Text1="Hello, world!"
Text1

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
A<-c(1,1,3,5,6)
A

B<-c(20,25,30,35,40)
B

C<-c("Red","Blue","Green","Purple","Yellow")
C

D<-c(1,"Map",2,"Globe",3,"Atlas")
D

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
View(test_df)

#You can refer to specific variables in a data frame by using a dollar sign
test_df$A
test_df$B

#There are other data structures such as matrices or lists in R.
#Most of what we cover in this course, though, uses data frames

#There's also lots of functions in R for mathematical calculation
A<-c(1,1,3,5,6)

sum(A)
sum_A<-sum(A)
sum_A

mean(A)
median(A)
sd(A)
summary(A)

#You can do the same when a vector is part of a data frame
mean(test_df$A)
summary(test_df$A)

#You try it! Use the card decks provided to deal three poker hands (5 cards).
#Count Jacks as 11, Queens as 12, Kings as 13, and Aces as 1
#Create vectors for each hand, then combine them into a single data frame
#Calculate the mean value and standard deviation of each of your hands


#######

#R also often uses packages--custom extensions that add functionality. 
#One of the most common is the tidyverse, authored by Hadley Wickham and others. Let's install it.

install.packages("tidyverse")

#We then can "call" the package when we want to use it.

library(tidyverse)

#The tidyverse is a kind of dialect for R, an alternative to "base R." 
#We'll talk about how we use it in future weeks. But compare the following:

plot(test_df$A,test_df$B) #Plot in base R
ggplot(test_df,aes(x=A,y=B)) + #Plot using ggplot, a part of the tidyverse
  geom_point() 
