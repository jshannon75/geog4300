##Probability distributions

#For binomial distribution there are two options:
#dbinom povides the probability of an exact number:
#What is the probability of getting *exactly* one two pair hand of cards over five deals. 
#The probability of two pair is .048. http://www.math.hawaii.edu/~ramsey/Probability/PokerHands.html
dbinom(1,size=5,prob=.048)
#What is the probability of NO two pair hands?
dbinom(0,size=5,prob=.048)

#pbinom provides the *cumulative probability* of an outcome--from no occurance to a given maximum.
#What is the probability of getting one or LESS two pair hand of cards of five deals?
pbinom(1,size=5,prob=.048)
#What is the probability of 2 or more two pair hands in five deals?
1-pbinom(1,size=5,prob=.048)

#The same options can be used for a Poisson distibution: dpois and ppois
#If Georgia has 21 tornadoes every year, what is the probability of exactly 18 tornadoes in a year?
dpois(18,21)
#What is the probability of 18 or less tornadoes?
ppois(18,21)
#What is the probability of more than 18 tornadoes?
1-ppois(18,21)

#You can visualize these distributions using the "visualize" package
install.packages("visualize")
library(visualize)

visualize.binom(stat=1,size=5,prob=.048,section="upper")  #Probability of 1 or more two pair hands in 5 draws.
visualize.pois(stat=18,lambda=21,section="lower") #Probability of 15 or less tornadoes
visualize.pois(stat=19,lambda=21,section="upper") #Probability of more than 16 tornadoes

#You try it!
#If the there are 12 rainy days in the average September in Athens,
#what's the chance of getting more than 15 rainy days this month?