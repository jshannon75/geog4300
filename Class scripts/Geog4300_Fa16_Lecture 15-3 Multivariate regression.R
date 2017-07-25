##Multivariate regression
#It uses the same command as simple regression. Just add more variables.
#Install required packages for this script
install.packages(c("car","corrgram","Hmisc","lmtest","stargazer"))

#Data from lecture
pop<-c(5, 2.1, 4.2, 3.9, 4.1, 4.2, 9.4, 3.6, 7.6, 8.5, 7.5, 4.1, 4.6, 7.2, 13.4)
child<-c(13.6, 18.3, 21.3, 33.1, 38.3, 36.9, 22.4, 19.6, 29.1, 32.8, 26.5, 41.5, 39, 20.2, 20.4)
lunch<-c(17.4, 34.4, 64.9, 82, 83.3, 61.8, 22.2, 8.6, 62.8, 86.2, 18.7, 78.6, 14.6, 41.4, 13.9)
crime<-c(132.1, 179.9, 139.9, 108.7, 123.2, 104.7, 61.5, 68.2, 96.9, 258, 32, 127, 27.1, 70.7, 38.3)
ppt.data<-as.data.frame(cbind(pop, child, lunch, crime))

#Regression
model<-lm(crime~pop+child+lunch, data=ppt.data)
summary(model)

#You can check for multicollinearity using the vif test (variance inflation factor)
#TRUE means that there's multicollinearity involving this variable
library("car")
sqrt(vif(model)) > 2

#Also just make a correlogram/correlation matrix
library("corrgram")
library("Hmisc")
rcorr(as.matrix(ppt.data))
corrgram(ppt.data)

#Check for heterosketasticity
library("lmtest")
bptest(model)

#Remove outliers/extreme values using the outlier test in the car package
outlierTest(model) #This shows that row 10 is the most extreme. Let's remove it.
ppt.data.1<-ppt.data[-10,] #subtracts the 10th row
model1<-lm(crime~pop+child+lunch, data=ppt.data.1) #runs a new model
summary(model1) #summary of the new model
summary(model) #compare to the old
#There are many ways to identify and deal with outliers.
#If you know you have them, 
#be sure to run the model without them to see the effect. 

#You can also the anova command to compare model strength using ANOVA
#A significant finding shows that one model is significantly different from the other
model1<-lm(crime~lunch, data=ppt.data)
model2<-lm(crime~child+lunch, data=ppt.data)
model3<-lm(crime~child+lunch+pop,data=ppt.data)
anova(model1,model2)
anova(model1,model3)
anova(model2,model3)

#The stargazer package allows you to compare/list model results
library(stargazer)
stargazer(model1,model2,model3,title="Comparison",type="text")
stargazer(model1,model2,model3,title="Comparison",
          type="text", #Sets type to text output,
          no.space=TRUE,
          out="models.txt") #Saves the file in your working folder

#See this page for more information on customizing stargazer: 
#http://jakeruss.com/cheatsheets/stargazer.html