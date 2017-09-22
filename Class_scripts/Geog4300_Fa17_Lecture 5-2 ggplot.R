#The ggplot2 package allows you to do more elegant looking graphs
#See this cheat sheet: https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf
#It's a standalone package, but also part of the tidyverse

library(tidyverse)

#Let's load the census dataset we've been using.
census_data<-read_csv("https://github.com/jshannon75/geog4300/raw/master/Data/ACSCtyData_2014ACS.csv")

#ggplot is structured in a particular way:
#"ggplot(data,aes(x=variable...))" says what data you want to plot. 
#Different "geoms" specify you want to plot those data.
#See this list of available geoms: http://sape.inf.usi.ch/quick-reference/ggplot2/geom

#In this example, the second function, "geom_point," says you want a point scatterplot.
ggplot(census_data, aes(x=afam_pop_pct,y=BADeg_pct))+geom_point()

#In this example, the function is a histogram. Only one variable is needed.
#Remember that typing ? + the function will always bring up a help file.
ggplot(census_data, aes(x=afam_pop_pct)) + geom_histogram()
ggplot(census_data, aes(x=BADeg_pct)) + geom_histogram()

#Additional parameters can be added to the histogram and variable function to change the transparency and breakdown of the graph 
ggplot(census_data, aes(x=BADeg_pct)) +geom_histogram(binwidth=.5, alpha=.5)
ggplot(census_data, aes(x=BADeg_pct)) +geom_histogram(binwidth=1, alpha=.5)
ggplot(census_data, aes(x=BADeg_pct)) +geom_histogram(binwidth=5, alpha=.5)
ggplot(census_data, aes(x=BADeg_pct)) +geom_histogram(binwidth=.5, alpha=.25)

#Density graphs smooth histograms
ggplot(census_data, aes(x=BADeg_pct)) + geom_density(fill="#0072B2")

#You can also change the graph color
ggplot(census_data, aes(x=BADeg_pct))+geom_histogram(colour="black")
ggplot(census_data, aes(x=BADeg_pct))+geom_histogram(colour="#01B340")
ggplot(census_data, aes(x=BADeg_pct))+geom_histogram(fill="#771199", colour="black")

#ColorBrewer color schemes can be used with variables. Load the RColorBrewer package.
#See also the ColorBrewer site: http://colorbrewer2.org/
#See the RColorBrewer documentation for palette names.
ggplot(census_data, aes(x=BADeg_pct, fill=Region)) + geom_histogram() + scale_fill_brewer(palette="Set1")
ggplot(census_data, aes(x=BADeg_pct, fill=Region)) + geom_histogram() + scale_fill_brewer(palette="RdGy")

#geom_boxplot provides boxplots
ggplot(census_data, aes(y=BADeg_pct, x=1))+geom_boxplot()

#Adding a second categorical y variable allows you to break a boxplot into parts
ggplot(census_data, aes(y=BADeg_pct, x=Region))+geom_boxplot()

#You can also use the "facet_wrap" and "facet_grid" commands to create separate plots
#Let's get data for just the southwest and southeast
two.regions<-census_data %>% filter(Region=="SW" | Region=="SE")

#Here's a scatterplot for all those counties together.
ggplot(two.regions, aes(x=afam_pop_pct,y=BADeg_pct))+geom_point()

#We can also add a smoothed trendline
ggplot(two.regions, aes(x=afam_pop_pct,y=BADeg_pct))+
  geom_point()+
  geom_smooth()

#Now color those points by region
ggplot(two.regions, aes(x=afam_pop_pct,y=BADeg_pct))+geom_point(aes(color=Region))

#Now create separate graphs for each region
ggplot(two.regions, aes(x=afam_pop_pct,y=BADeg_pct))+
  geom_point(aes(color=Region))+
  geom_smooth()+
  facet_grid(Region~.)

#Do the same thing for states in the south
south<-census_data %>% filter(Region=="SE")
ggplot(south, aes(x=afam_pop_pct,y=BADeg_pct))+
  geom_point()+
  geom_smooth()+
  facet_wrap(~St_name)

#We can also look at data over time using line graphs.
#For example, let's look at the Daymet data from lab 1
Daymet_Cty_Summary_2005_2015 <- read_csv("https://github.com/jshannon75/geog4300/raw/master/Labs/Lab%201_%20Descriptive%20stats/Daymet_Cty_Summary_2005_2015.csv")

#Summarise these data by year and region
daymet_summary_region<-Daymet_Cty_Summary_2005_2015 %>% 
  group_by(Region, year) %>% 
  summarise(tmax_med=median(tmax))

#Create a line graph with geom_line
ggplot(daymet_summary_region, aes(x=year,y=tmax_med, group=Region, colour=Region))+
  geom_line()

#Let's get better year breaks on the x axis
ggplot(daymet_summary_region, aes(x=year,y=tmax_med, group=Region, colour=Region))+
  geom_line()+
  scale_x_continuous(breaks=pretty(daymet_summary_region$year, n=10))

#Let's take a look at the Lab 1 graphing tasks...