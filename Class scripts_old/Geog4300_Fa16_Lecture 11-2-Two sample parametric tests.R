#Two sample difference tests
library(reshape2)
library(ggplot2)

#Let's create two samples that we know are (slightly) different
sample1<-rnorm(50, mean=51.7, sd=4)
sample2<-rnorm(50, mean=53.4, sd=3)

#Do they look different?
sample<-data.frame(nrow=50,ncol=2)#Create blank data frame
sample<-cbind(sample1,sample2) #Combine the two variables
sampleA<-melt(sample) #Reshape the dataset so all values are in one column (so we can graph it)
    #melt is part of the Reshape2 package
ggplot(sampleA,aes(y=value,x=Var2)) + geom_boxplot() #Need to use the ggplot2 package
ggplot(sampleA,aes(x=value, fill=Var2)) + geom_histogram()

#The "t.test" function allows us to test them
t.test(sample1, sample2, var.equal=FALSE) #Unequal variance
t.test(sample1, sample2, var.equal=TRUE) #Equal variance

#What if the variance is really unequal?
sample2<-rnorm(50, mean=60, sd=20)
t.test(sample1, sample2, var.equal=FALSE) #Unequal variance
t.test(sample1, sample2, var.equal=TRUE) #Equal variance
#Notice the difference in degrees of freedom here

#You can also specify 1 or 2 tailed tests
t.test(sample1, sample2, var.equal=FALSE, alternative="two.sided")
t.test(sample1, sample2, var.equal=FALSE, alternative="greater")
t.test(sample1, sample2, var.equal=FALSE, alternative="less")

#Proportions can be tested using "prop.test"
#Let's check to see if we can detect a "weighted" coin
prop1<-rbinom(100, 1 , .5) #Regular coin
prop2<-rbinom(100, 1 ,.75) #Altered coin
sample<-data.frame(cbind(prop1,prop2)) #Combine the two variables
sampleA<-melt(sample) #Reshape the dataset so all values are in one column
sample.table<-table(sampleA$value,sampleA$variable) #Create a table summarizing the data
sample.table #show the table
prop.test(sample.table) #Run prop.test on the table

#Paired two sample test also uses t.test
stream.1990<-c(334, 231, 261, 215, 209, 336, 393, 141, 185, 242, 122, 195, 421, 226)
stream.2010<-c(316, 217, 226, 176, 215, 327, 335, 155, 128, 244, 129, 175, 379, 196)
t.test(stream.1990, stream.2010, paired=TRUE) 
#How does this compare to a regular t.test?
t.test(stream.1990, stream.2010)

