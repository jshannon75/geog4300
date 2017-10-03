#Z and T scores in R

#Let's start with our random distribution of ACT scores
ACT.scores<-data.frame(rnorm(100, mean=21, sd=5.3)) #simulates random population of 100 taking the ACT in 2011
names(ACT.scores)<-"scores"

#To calculate z scores, simply input the formula into R
#What's the z score for an ACT score of 29?
#mean is 21 and sd is 5.3.
z.score<-(29-21)/5.3
z.score

#You could even convert the whole dataset to z scores
ACT.scores$z_score<-(ACT.scores$scores-21)/5.3 #Do it manually
ACT.scores$z_score2<-scale(ACT.scores$scores) #Use the scale function

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

#Do 15 rolls of your dice and enter the data into R as an object.
#What's the mean and sd? 
#Calculate a t score for each roll