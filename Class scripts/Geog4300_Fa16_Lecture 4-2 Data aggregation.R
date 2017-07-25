##Aggregating in R using the "aggregate" function is straightforward.
asn_pct_region_sd<-aggregate(asn_pop_pct~Region,ACSCtyData_2014ACS,"sd")
asn_pct_region_mean<-aggregate(asn_pop_pct~Region,ACSCtyData_2014ACS,"mean")
asn_pct_region_median<-aggregate(asn_pop_pct~Region,ACSCtyData_2014ACS,"median")

##You can also aggregate multiple varaibles, using "cbind" to bind the columns together
asn_afam_region_sd<-aggregate(cbind(asn_pop_pct,afam_pop_pct)~Region,ACSCtyData_2014ACS,"sd")
asn_afam_region_IQR<-aggregate(cbind(asn_pop_pct,afam_pop_pct)~Region,ACSCtyData_2014ACS,"IQR")
asn_afam_region_mean<-aggregate(cbind(asn_pop_pct,afam_pop_pct)~Region,ACSCtyData_2014ACS,"mean")
asn_afam_region_median<-aggregate(cbind(asn_pop_pct,afam_pop_pct)~Region,ACSCtyData_2014ACS,"median")

##You can rename the column headings using "names"
names(asn_afam_region_sd)<-c("Region","asn_sd","afam_sd")
names(asn_afam_region_IQR)<-c("Region","asn_IQR","afam_IQR")
names(asn_afam_region_mean)<-c("Region","asn_mean","afam_mean")
names(asn_afam_region_median)<-c("Region","asn_median","afam_median")

##Those tables can be combined using the "merge" function. 
##The "by" parameter specifies a key variable that's the same in both data frames.
acn_pct_region<-merge(asn_afam_region_sd,asn_afam_region_mean,by="Region")

##The plyr package has a "join_all" function that can join more than two dfs.
install.packages("plyr")
library(plyr)
asn_afam_region<-join_all(list(asn_afam_region_sd,asn_afam_region_IQR,asn_afam_region_mean,asn_afam_region_median),"Region")
