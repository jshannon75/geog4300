#Confidence intervals can be easily computed in R
#You need to know three things: sample mean, standard error, and t-score
#Suppose you have a sample (n=174) with a mean of 43 and a sample sd of 6.2
#For a 95% CI, do the following:
mean<-43
se<-(6.2/sqrt(174))
z.score<-qnorm(.975)
moe=(se*z.score)
CI.lower<-mean-moe
CI.upper<-mean+moe
#What happens to the CI as the sample size goes up and down?

#Confidence intervals for proportions would require a different standard error calculation.
#If 64.75% of geographers (n=400) voted to hold the next AAG in Maui:
p<-.6475
se<-sqrt((.6475*(1-.6475))/399)
z.score<-qnorm(.975)
moe<-se*z.score
CI.lower<-p-moe
CI.upper<-p+moe
