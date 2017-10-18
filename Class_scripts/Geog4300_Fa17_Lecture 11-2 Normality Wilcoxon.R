#Normality tests and Wilcoxon non-parametric tests

test1<-rbeta(5000,7,2) #generate a skewed dataset
hist(test1) 
qqnorm(test1) #qqplot of the skewed dataset

test2<-rnorm(5000,0,1) #generate a normal dataset
hist(test2) 
qqnorm(test2) #qqplot of the normal dataset

##Shapiro-Wilk test: the null hypothesis is that the data IS normal.
shapiro.test(test1)
shapiro.test(test2)

##qqline can also add in a line showing normal distribution
qqnorm(test1); qqline(test1)
qqnorm(test2); qqline(test2)

##Go back to our census data (ACSCtyData_2014_ACS)
##What's the most normal variable you can find?
acsdata<-read_csv("https://github.com/jshannon75/geog4300/raw/master/Data/ACSCtyData_2014ACS.csv") %>%
  select(c(cty_name,St_name,wht_pop_pct:nat_ins_pct))

#The wilcox.test command does both Wilcoxon tests.
#Here's the rank sum example using lecture data
el.nino<-c(0, 5,1,3, 4, 1, 2, 2, 0, 2, 4)
la.nina<-c(4, 4,12, 2, 17, 7, 6, 10, 4, 8, 6)
wilcox.test(el.nino, la.nina)
#The wilcox.test command results in a slightly different statistic than the formula used in the text/in class.
#It's actually computing an equivalent test called the Mann-Whitney
#The p-value can still be used in this case, and in both the finding is significant.

#Wilcox.test can also compute signed rank tests
data2000<-c(3, 11, 9, 14, 17, 7, 21, 13, 19, 5)
data2010<-c(6, 12, 8, 18, 15, 13, 25, 9, 24, 10)
wilcox.test(data2000, data2010, paired=TRUE)
#Here again, the Mann-Whitney test is used so the output is slightly different.

