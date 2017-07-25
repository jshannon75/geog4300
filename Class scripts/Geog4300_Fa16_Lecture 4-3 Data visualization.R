##Stem and leaf plots are easy in r--just use "stem"
GActy<-subset(ACSCtyData_2014ACS,GISJn_St=="G13") #Select just Georgia counties
stem(GActy$BADeg_pct)

##The ggplot2 package allows you to do more elegant looking graphs
##See this cheat sheet: https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf

install.packages("ggplot2")
library(ggplot2)

##In this example, "ggplot" identifies the variables to be used.
##The second function, "geom_point," identifies which graph you want to use.
##In this case, we're creating a point scatterplot
ggplot(ACSCtyData_2014ACS, aes(x=afam_pop_pct,y=BADeg_pct))+geom_point()

##In this example, the function is a histogram. Only one variable is needed.
##Remember that typing ? + the function will always bring up a help file.
ggplot(ACSCtyData_2014ACS, aes(x=afam_pop_pct)) + geom_histogram()
ggplot(ACSCtyData_2014ACS, aes(x=BADeg_pct)) + geom_histogram()

##Additional variables can be added to the histogram and variable function to change the transparency and breakdown of the graph 
ggplot(ACSCtyData_2014ACS, aes(x=BADeg_pct)) +geom_histogram(binwidth=.5, alpha=.5)
ggplot(ACSCtyData_2014ACS, aes(x=BADeg_pct)) +geom_histogram(binwidth=1, alpha=.5)
ggplot(ACSCtyData_2014ACS, aes(x=BADeg_pct)) +geom_histogram(binwidth=5, alpha=.5)
ggplot(ACSCtyData_2014ACS, aes(x=BADeg_pct)) +geom_histogram(binwidth=.5, alpha=.25)

##Density graphs smooth histograms
ggplot(ACSCtyData_2014ACS, aes(x=BADeg_pct)) + geom_density(fill="#0072B2")

##You can also change the graph color
ggplot(ACSCtyData_2014ACS, aes(x=BADeg_pct))+geom_histogram(colour="black")
ggplot(ACSCtyData_2014ACS, aes(x=BADeg_pct))+geom_histogram(colour="#01B340")
ggplot(ACSCtyData_2014ACS, aes(x=BADeg_pct))+geom_histogram(fill="#771199", colour="black")

##ColorBrewer color schemes can be used with variables. Load the RColorBrewer package.
##See also the ColorBrewer site: http://colorbrewer2.org/
##See the RColorBrewer documentation for palette names.
ggplot(ACSCtyData_2014ACS, aes(x=BADeg_pct, fill=Region)) + geom_histogram() + scale_fill_brewer(palette="Set1")
ggplot(ACSCtyData_2014ACS, aes(x=BADeg_pct, fill=Region)) + geom_histogram() + scale_fill_brewer(palette="RdGy")

##Adding a second variable allows you to break a boxplot (or violin plot) into parts
ggplot(ACSCtyData_2014ACS, aes(y=BADeg_pct, x=1))+geom_boxplot()
ggplot(ACSCtyData_2014ACS, aes(y=BADeg_pct, x=Region))+geom_boxplot()
ggplot(ACSCtyData_2014ACS, aes(y=BADeg_pct, x=Region))+geom_violin()

##You can also use the "facet_wrap" and "facet_grid" commands to create separate plots
two.regions<-subset(ACSCtyData_2014ACS, Region=="SW" | Region=="SE")
ggplot(two.regions, aes(x=afam_pop_pct,y=BADeg_pct))+geom_point()
ggplot(two.regions, aes(x=afam_pop_pct,y=BADeg_pct))+geom_point(aes(color=Region))
ggplot(two.regions, aes(x=afam_pop_pct,y=BADeg_pct))+geom_point(aes(color=Region))+facet_grid(Region~.)
south<-subset(ACSCtyData_2014ACS, Region=="SE")
ggplot(south, aes(x=afam_pop_pct,y=BADeg_pct))+geom_point()+facet_wrap(~St_name)

##You can also create base plots and export them to Adobe Illustrator as PDFs. 
ggplot(ACSCtyData_2014ACS, aes(y=BADeg_pct, x=Region))+geom_boxplot()