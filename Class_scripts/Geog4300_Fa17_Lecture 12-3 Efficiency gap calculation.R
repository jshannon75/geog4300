#Efficiency gap memo

library(tidyverse)

#Demo based on this document: https://www.brennancenter.org/sites/default/files/legal-work/How_the_Efficiency_Gap_Standard_Works.pdf
district<-data.frame(c(1:5))
dvotes<-data.frame(c(75,60,43,48,49))
rvotes<-data.frame(c(25,40,57,52,51))

election<-bind_cols(district,dvotes,rvotes)
names(election)<-c("district","dvotes","rvotes")

#Calculate wasted votes
#If a party wins the election, wasted votes are any more than 50% + 1 of all votes
#If a party loses the election, all votes are wasted votes

election_waste<-election %>%
  mutate(totalvotes=dvotes+rvotes,
         dwaste=ifelse(dvotes>rvotes,dvotes-(totalvotes/2+1),dvotes),
         rwaste=ifelse(rvotes>dvotes,rvotes-(totalvotes/2+1),rvotes),
         netwasted=dwaste-rwaste,
         party=ifelse(netwasted>0,"D",ifelse(netwasted<0,"R","T")))

#Sum the wasted votes and calculate the efficiency gap
election_totals<-election_waste %>%
  summarise(total_votes=sum(totalvotes),
            dwaste_all=sum(dwaste),
            rwaste_all=sum(rwaste),
            total_waste=dwaste_all-rwaste_all,
            party=ifelse(dwaste_all>rwaste_all,"D","R"),
            eff_gap=total_waste/total_votes)
