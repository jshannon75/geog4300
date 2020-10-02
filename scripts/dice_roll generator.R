library(tidyverse)

dice<-data.frame(rnorm(100000,mean=7,sd=2.45))
names(dice)="rolls"
dice<-dice %>%
  mutate(rolls=round(rolls,0)) %>%
  filter(rolls>1 & rolls <13)

ggplot(dice,aes(x=rolls))+geom_histogram()

dice<-data.frame(rnorm(30,mean=7,sd=2.45))
names(dice)="rolls"
dice<-dice %>%
  mutate(rolls=round(rolls,0)) %>%
  filter(rolls>1 & rolls <13)
ggplot(dice,aes(x=rolls))+geom_histogram()
mean(dice$rolls)
sd(dice$rolls)

dice_roll<-function(countn){
  dice<-data.frame(rnorm(20,mean=7,sd=2.45))
  names(dice)="rolls"
  dice<-dice %>%
    mutate(rolls=round(rolls,0)) %>%
    filter(rolls>1 & rolls <13)
  data.frame(dice=mean(dice$rolls))
}

values<-1:100

df<-map_df(values,dice_roll)
ggplot(df %>% mutate(dice1=dice/max(dice)),aes(x=dice1))+
  geom_histogram(bins=50)+
  geom_density(col="red")
mean(df$dice)
sd(df$dice)
