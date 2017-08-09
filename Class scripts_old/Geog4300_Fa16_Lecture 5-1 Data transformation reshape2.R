##Melting and casting with reshape 2

install.packages("reshape2")
library(reshape2)

##Select Georgia counties and variables related to race
GAcounties<-subset(ACSCtyData_2014ACS,GISJn_St=="G13")
GAcounties_race<-GAcounties[,c(2,33:39)] 
#Columns 2 (county ID) and 33-39 (race variables) are selected above

##Melt the data
GAcounties_race_long<-melt(GAcounties_race,id.vars="GISJn_Cty")

##One main reason to do this is to be able to use mult. variables in ggplot/graphing
library(ggplot2)
ggplot(GAcounties_race_long,aes(x=variable,y=value))+geom_boxplot()

##We can then use dcast to reform the variables
##Here, we end up switching rows and columns
GGcounties_race_flip<-dcast(GAcounties_race_long,variable~GISJn_Cty)
