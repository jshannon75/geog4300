##Classification using census data
##This requires that the classInt package be installed, as well as the RColorBrewer package

##The classIntervals function in the classInt package provides data classification
##Several styles are available: "fixed", "sd", "equal", "pretty", "quantile", "kmeans", "hclust", "bclust", "fisher", or "jenks".
##For more on this function:
?classIntervals

##To install classInt and call the package
install.packages("classInt")
library(classInt)

##Look at a histogram for the % in poverty variable. How would you describe it?
##How should it be classified?
hist(ACSCtyData_2014ACS$pov_pop_pct)

##Quantile distributions create equally sized groups
q4<-classIntervals(ACSCtyData_2014ACS$pov_pop_pct,n=4,style="quantile")
q6<-classIntervals(ACSCtyData_2014ACS$pov_pop_pct,n=6,style="quantile")

##You can call these variables to see their break points
q4
q6

##You can also create cumulative frequency plots to see the classification.
##These plots show the % of all observations under a certain value.
##The x axis in the plot has the range of all values for the variable.
##The y axis is the % (0 to 1) of observations under the value on the x axis.

##First you have to define a color scheme using RColorBrewer (install and call the package)
install.packages("RColorBrewer")
library(RColorBrewer)
pal4<-brewer.pal(4, "Greens")
pal6<-brewer.pal(6, "Greens")
plot(q4,pal=pal4)
plot(q6,pal=pal6)

##Create a cumulative frequency plot for several other variables and compare to a histogram
##What does this graph tell you about the distribution of the variable?

##You can generate and plot different classification styles
q5<-classIntervals(ACSCtyData_2014ACS$BADeg_pct,n=5,style="quantile")
s5<-classIntervals(ACSCtyData_2014ACS$BADeg_pct,n=5,style="sd")
p5<-classIntervals(ACSCtyData_2014ACS$BADeg_pct,n=5,style="pretty") 
pal5<-brewer.pal(5,"Blues")
plot(q5,pal=pal5)
plot(s5,pal=pal5)
plot(p5,pal=pal5)

##Central tendancy can be identified using mean, median, and mode. The first two are easy to calculate in R.
HSrate<-ACSCtyData_2014ACS$HSGrad_pct
mean(HSrate)
median(HSrate)

##Mode is more difficult. You have to calculate the number of occurances of each unique value. 
##Mode can also be easily calculated in Excel.
HStable<-table(HSrate)
HStable ##View that table. The first line is the variable value. The second is the # of occurances.
names(HStable)[HStable==max(HStable)] ##This returns the value with the highest number of occurances.

##You can use the aggregate function to summarize variables by region
table.mean<-aggregate(HSGrad_pct~St_name,ACSCtyData_2014ACS,"mean")
table.median<-aggregate(HSGrad_pct~St_name,ACSCtyData_2014ACS,"median")

##You can also subset data to look at just one state
GA.data<-subset(ACSCtyData_2014ACS,St_name=="Georgia")
hist(GA.data$HSGrad_pct)
hist(GA.data$GradDeg_pct)

HStable<-table(GA.data$HSGrad_pct)
names(HStable)[HStable==max(HStable)] #Notice that all values are listed. Why would that be? How could we address this?

##Summarize asn_pop_pct by state, looking at mean, median, and mode. 
##Which states' counties have the highest mean/median % Asian? Which are lowest? (see line 62)


