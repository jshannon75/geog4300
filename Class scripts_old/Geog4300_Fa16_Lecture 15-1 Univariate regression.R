#Regression

#Enter the garden data
med.age<-c(43, 21, 25, 42, 56, 59)
garden<-c(99, 65, 79, 75, 87, 81)
data<-data.frame(cbind(med.age, garden))

#Create a linear model
lm(garden~med.age, data=data) #This doesn't tell you much
model<-lm(garden~med.age, data=data)
summary(model)

#You can also plot this model
plot(garden~med.age, data=data)
abline(model) ##plots the regression line created by the model

#There's several diagnostics that can be used for regression
#Plot/test the residuals to see if they're normal
data$residuals<-residuals(model)
hist(data$residuals)
qqnorm(data$residuals)
shapiro.test(data$residuals)

#Testing for heteroskedasticity using the Breusch-Pagan test (significant=heteroskedastic). 
#Requires the lmtest package
#Null hypothesis is that the data is NOT heterosketastic
install.packages("lmtest")
library(lmtest)
bptest(model)
