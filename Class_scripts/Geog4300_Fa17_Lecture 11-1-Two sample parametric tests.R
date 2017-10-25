#Two sample difference tests
library(tidyverse)

#Let's create two samples that we know are (slightly) different
sample1<-rnorm(50, mean=51.7, sd=4)
sample2<-rnorm(50, mean=53.4, sd=3)

#Do they look different?
sample<-data.frame(cbind(sample1,sample2)) #Combine the two variables
sample_long<-sample %>% gather(key="sample",value="value")
ggplot(sample_long,aes(y=value,x=sample)) + geom_boxplot() 
ggplot(sample_long,aes(x=value, fill=sample)) + 
  geom_histogram() + 
  facet_wrap(~sample)

#The "t.test" function allows us to test them
t.test(sample1, sample2, var.equal=TRUE) #Equal variance
t.test(sample1, sample2, var.equal=FALSE) #Unequal variance
#Notice the difference in degrees of freedom 

#What if the variance is really unequal?
sample2<-rnorm(50, mean=53.4, sd=30)
t.test(sample1, sample2, var.equal=FALSE)

#You can also specify 1 or 2 tailed tests
sample1<-rnorm(50, mean=51.7, sd=4)
sample2<-rnorm(50, mean=53.4, sd=3)
t.test(sample1, sample2, var.equal=FALSE, alternative="two.sided")
t.test(sample1, sample2, var.equal=FALSE, alternative="greater")
t.test(sample1, sample2, var.equal=FALSE, alternative="less")

#Proportions can be tested using "prop.test"
#Let's check to see if we can detect a "weighted" coin
prop1<-rbinom(100, 1 , .5) #Regular coin
prop2<-rbinom(100, 1 ,.75) #Altered coin
prop_sample<-data.frame(cbind(prop1,prop2)) #Combine the two variables
prop_samplelong<-prop_sample %>% gather(key="coin",value="result") #Reshape the dataset so all values are in one column
prop_sample.table<-table(prop_samplelong$result,prop_samplelong$coin) #Create a table summarizing the data
prop_sample.table #show the table
prop.test(prop_sample.table) #Run prop.test on the table

#Paired two sample test also uses t.test
stream.1990<-c(334, 231, 261, 215, 209, 336, 393, 141, 185, 242, 122, 195, 421, 226)
stream.2010<-c(316, 217, 226, 176, 215, 327, 335, 155, 128, 244, 129, 175, 379, 196)
t.test(stream.1990, stream.2010, paired=TRUE) 
#How does this compare to a regular t.test?
t.test(stream.1990, stream.2010)


##Let's try it!

#Let's compare liters of coffee sold on campus per 100 students each day.
#Assume the data is normal. Is there a difference?

uga<-c(12.4, 13.9, 14.6, 11.3, 18.1, 15.2, 13.9)
tech<-c(10.7, 11.1, 16.2, 12.5, 10.8, 16.7, 12.7)

#Pollution levels in multiple California towns were measured before and after new guidlines. 
#These levels are normally distributed at the state level. #Did pollution go down?

prepolicy<-c(398,413,521,645,513,310)
postpolicy<-c(375,403,410,552,406,308)