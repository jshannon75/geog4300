##One sample parametric tests

#We will start by generating a sample population of 20 individuals.
sample<-rnorm(20, mean=24, sd=3)

#Is this sample significantly different from a population mean of 25?
#In this case, "t.test" is the function you want.
t.test(sample,mu=25)

#How are the results different with with n>30? 
sample<-rnorm(50, mean=24, sd=3)
t.test(sample,mu=25)

#You can change the p value with "conf.level"
#This will change the reported confidence interval
t.test(sample,mu=25,conf.level=.99)
t.test(sample,mu=25,conf.level=.90)

#Run a one tailed t.test using ""alternative"
t.test(sample,mu=25,alternative="less") #Is the sample mean *less* than 25?
t.test(sample,mu=25,alternative="greater") #Is the sample mean *greater* than 25?

#What if you rolled your dice 100 times and 
#came up with snake eyes 5 times? Are you abnorallly lucky? 
#Do you have loaded dice?

#The probability of snake eyes is .027
prop.test(x=5, n=100, p=.027)
#What about 50 snake eyes in 1,000 rolls?
prop.test(x=50, n=1000, p=.027)

#Import our 200 student UGA test dataset.
#What's the probability that the scores on this test are higher than 21?