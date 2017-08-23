#Geog4/6300 Fall 17
#Using APIs to import data

#While CSVs can be convenient ways to import data, 
#APIs (application program interfaces) provide another way to access data directly from the source.
#Many orgs provide APIs for those using their data. 
#Here's two examples:

###Star Wars API (SWAPI)
#See their website: https://swapi.co/
#See also this presentation from Amanda Gadrow about using SWAPI: https://www.rstudio.com/resources/videos/using-web-apis-from-r/
#And this one by Charlotte Wickham: https://www.rstudio.com/resources/videos/happy-r-users-purrr-tutorial/

#You can search for data directly on their site. For example, see results for Dagobah
#Search for planets/5 on the site
#These results are in JSON. Efficient way to store data, but not easy to look at in a table.
#Let's load some helpful packages and access the data through R.

#install.packages("httr")
#install.packages("jsonlite")
#install.packages("magrittr")

#library(httr)
library(tidyverse)
library(jsonlite)
library(magrittr)

dagobah <- GET("http://swapi.co/api/planets/?search=dagobah") #retrieve content
dagobah$headers$`content-type` #look at the format
names(dagobah) #see what's in this object. We'll eventually want just "content".

text_content <- content(dagobah, as = "text", encoding = "UTF-8")
text_content #The content function gets us closer, but still not there.

#The jsonlite package changes this to a dataframe--parsing the data
json_content <- text_content %>% fromJSON
json_content
planetary_data <- json_content$results
names(planetary_data)

#We can even download multiple planets at once.
planets <- GET("http://swapi.co/api/planets") %>% stop_for_status()

#The code below creates a function that parses all results
json_parse <- function(req) {
  text <- content(req, as = "text", encoding = "UTF-8")
  if (identical(text, "")) warn("No output to parse.")
  fromJSON(text)
}

#Now we get data on the first 10 planets and parse it using our function
planets <- GET("http://swapi.co/api/planets") %>% stop_for_status()
json_planets <- json_parse(planets)
swapi_planets <- json_planets$results

#The videos above go into more detail and in greater depth.
#There's also a package called rwars built just for this API: https://github.com/Ironholds/rwars



###Daymet data
#The Daymet dataset provides gridded climate data going back to 1980 for the whole US.
#Here's their website: https://daymet.ornl.gov/
#They provide an API service where you can query their database directly.
#Directions here: https://daymet.ornl.gov/web_services.html

#For instance, the following uRL gives you data on the Geography/Geology building
#https://daymet.ornl.gov/data/send/query?lat=33.948693&lon=-83.375475&year=2016

#The daymetr package allows you to access these data directly
#We'll use this dataset in your first lab.

#install.packages("devtools")
#devtools::install_github("khufkens/daymetr") #Installing the package directly from github
library(daymetr) # load the package

#Load 10 years of data on Athens
download_daymet(site="athens",lat=33.948693,lon=-83.375475,start=2005,end=2015,internal=TRUE)

#The file will show up in your working directory. We can load it from there.
athens_2005_2015 <- read_csv("athens_2005_2015.csv", skip = 7) #The skip command here skips the first few rows which have metadata.


###Add mutate and summarise