#Chi-square
#Using the Thanksgiving.chisquare dataset (from lecture)
white<-c(15, 25)
dark<-c(25, 10)
tofurkey<-c(3, 7)
thanksgiving<-cbind(white, dark, tofurkey)

#Run the test
chisq.test(thanksgiving)

#Using the in-class problem
car<-c(58, 199, 205)
transit<-c(21, 49, 32)
walk<-c(36, 64, 29)
survey<-cbind(car, transit, walk)
chisq.test(survey)

#In class challenge: Look at the "tornado_points" data from earlier in the semester
#Is there a difference in the severity of tornados (MAG) across states (ST)?
#You will have to create a table of counts for each MAG category
#Then run the chi-squared test
