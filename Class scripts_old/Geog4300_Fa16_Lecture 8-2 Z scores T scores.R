#R can generate random distributions and also calculate z scores
#rnorm creates a random number distribution with a specified size, mean and standard deviation
ACT.scores<-data.frame(rnorm(100, mean=21, sd=5.3)) #simulates random population of 100 taking the ACT in 2011
ACT.scores
names(ACT.scores)<-"scores"
hist(ACT.scores)
summary(ACT.scores)
sd(ACT.scores)
#You can run this again and get a different distribution

#pnorm gives you the cumulative probability of receiving less than a certain statistic
pnorm(29,mean=21, sd=5.3) #What's the probability of getting a 29 or less on the ACT?
#You can also read this as a percentile ranking. A score of 29 is the 93rd percentile on the exam.
#29 is also the average ACT score for UGA first-years in 2015.
pnorm(29,mean=21, sd=5.3, lower.tail=FALSE) #Tells you the probability of getting a score GREATER than 29.

#qnorm provides the z score matching a specified probability.
#What's the 75th percentile on the ACT?
qnorm(.75, mean=21, sd=5.3)
qnorm(.75, mean=0, sd=1)

#To calculate z scores, simply input the formula into R
#What's the z score for an ACT score of 29?
z.score<-(29-21)/5.3
z.score

#You could even convert the whole dataset to z scores
ACT.scores$z_score<-(ACT.scores$scores-21)/5.3

#T scores follow a similar logic.
#Create a dataset of 10 variables with the t-distribution when df=10 (mean=0 and sd=1)
t.sample<-rt(10, df=10)
hist(t.sample)
t.sample<-rt(10, df=15)
hist(t.sample)

#You will have to convert your value to a t score manually if you want to look at its probability.
#What's the t score associated with 5 when you have a 20 observation sample with mean of 6 and sample sd of 1.5?
SE<-1.5/sqrt(20-1)
t<-(5-6)/SE
t

#What's the probability of a t-score of 1 or less when df=10?
pt(1, df=10)
pt(1, df=20) #When df=20

#What t score is associated with a .8 probability when df=10?
qt(.8, df=10)
qt(.8, df=20)