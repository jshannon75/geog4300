##Javascript interactive visualization in R

##Several R packages can create interactive graphs. 
##One of most popular is plotly.
##You can use plotly on its own or with ggplot
##Function for the latter is "ggplotly" 
install.packages("plotly")
library(plotly)
library(ggplot2)
library(RColorBrewer)

#Let's try it out using the ACS data

#Basic histogram
ggplot(ACSCtyData_2014ACS, aes(x=BADeg_pct, fill=Region)) + geom_histogram() + scale_fill_brewer(palette="Set1")

#Save the graph as an object and then pass it to plotly.
plot<-ggplot(ACSCtyData_2014ACS, aes(x=BADeg_pct, fill=Region)) + geom_histogram() + scale_fill_brewer(palette="Set1")
ggplotly(plot)

#Try with other variables/graphs w/o creating an object
ggplotly(ggplot(ACSCtyData_2014ACS, aes(y=BADeg_pct, x=Region))+geom_boxplot())

south<-subset(ACSCtyData_2014ACS, Region=="SE")
ggplotly(ggplot(south, aes(x=afam_pop_pct,y=BADeg_pct,text=cty_name))+geom_point()+facet_wrap(~St_name))

##Try it out: Create a plotly graph with a visualization you made in our last class

##Leaflet is another javascript library that can plot spatial data
install.packages("leaflet")
library(leaflet)

#The function itself just shows a blank map
#The %>% separator is often used to divide commands within functions
leaflet() %>% addTiles()

#You can specify coordinates for the basemap
leaflet() %>% 
  addTiles() %>% 
  setView(-83.375,33.95,zoom=15)

#Create a point for Sanford Stadium
x<--83.373227
y<-33.949785

#Use those coordinates for a map
leaflet() %>% 
  addTiles() %>% 
  setView(-83.375,33.95,zoom=15) %>%
  addMarkers(x,y)

#You can also load Athens Crime Data and show it on this map
leaflet() %>% 
  addTiles() %>% 
  setView(-83.375,33.95,zoom=13) %>%
  addCircles(Athens_Crimes_2012_2014_aggassault$X,
             Athens_Crimes_2012_2014_aggassault$Y)

#You can even define and add popups
Crime_popup <- paste0("<strong>Crime </strong>", 
                      Atrhens_Crimes_2012_2014_aggassault$GA_charge, 
                      "<br><strong>Date: </strong>", 
                      Atrhens_Crimes_2012_2014_aggassault$Date)

leaflet() %>% 
  addTiles() %>% 
  setView(-83.375,33.95,zoom=13) %>%
  addCircles(Athens_Crimes_2012_2014_aggassault$X,
             Athens_Crimes_2012_2014_aggassault$Y,
             popup=Crime_popup)

##You try it! Make a map using the tornado data on Google Drive


