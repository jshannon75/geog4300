Geog4/6300: Lab 1
================

Loading data into R, data transformation, and summary statistics
----------------------------------------------------------------

**Due:** Monday, Sept. 18

**Value:** 30 points

**Overview:**

This lab is intended to assess your ability to use R to load data and to generate basic descriptive statistics. You'll be using monthly weather data from the Daymet climate database (<http://daymet.ornl.gov>) for all counties in the United States over a 10 year period (2005-2015). These data are available on the Github repo for our course. The following variables are provided:

-   gisjn\_cty: Code for joining to census data
-   year: Year of observation
-   month: Month of observation
-   dayl: Mean length of daylight (in seconds)
-   srad: Mean solar radiation per day
-   tmax: Mean maximum recorded temperature (Celsius)
-   tmin: Mean minimum recorded temperature (Celsius)
-   vap\_pres: Mean vapor pressure (indicative of humidity)
-   prcp: Total recorded prcpitation (mm)
-   cty\_name: Name of the county
-   state: state of the county
-   region: Census region (map: <https://www2.census.gov/geo/pdfs/maps-data/maps/reference/us_regdiv.pdf>)
-   division: Census division
-   lon: Longitude of the point
-   lat: Latitude of the point

These labs are meant to be done collaboratively, but your final submission should demonstrate your own original thought (don’t just copy your classmate’s work or turn in identical assignments). Your answers to the lab questions should be typed in the provided RMarkdown template. You'll then "knit" this to an HTML document and upload it to your class Github repo.

### Procedure:

Load the tidyverse package and import the data from GitHub:

``` r
library(tidyverse)
daymet_cty_2005_2015 <- read_csv("https://github.com/jshannon75/geog4300/raw/master/labs/lab1_%20descriptive_stats/Daymet_Cty_Summary_2005_2015.csv")
```

    ## Parsed with column specification:
    ## cols(
    ##   gisjn_cty = col_character(),
    ##   year = col_integer(),
    ##   month = col_character(),
    ##   dayl = col_double(),
    ##   srad = col_double(),
    ##   tmax = col_double(),
    ##   tmin = col_double(),
    ##   vap_pres = col_double(),
    ##   prcp = col_integer(),
    ##   CTY_NAME = col_character(),
    ##   State = col_character(),
    ##   Region = col_character(),
    ##   Division = col_character(),
    ##   Lon = col_double(),
    ##   Lat = col_double()
    ## )

After loading the file into R, closely examine each variable.

***Question 1 task (4 points):** Provide an example of nominal, ordinal, interval, and ratio data within this dataset. Explain why each fits in the level of measurement you chose in a sentence or two . If you cannot find an example for one of these four data types (no nominal variables, for example), given an example of climate data that would fit this type.*

### Question 2

There are a lot of observations here, 413,820 to be exact. To get a better grasp on it, we can use group\_by and summarise in the tidyverse package. Here's an example.

``` r
cty_summary<-daymet_cty_2005_2015 %>% 
  group_by(Region) %>% 
  summarise(mean_srad=mean(srad))
kable(cty_summary)
```

| Region           |  mean\_srad|
|:-----------------|-----------:|
| Midwest Region   |    319.4705|
| Northeast Region |    312.1818|
| South Region     |    344.1628|
| West Region      |    342.4914|

This command returns the mean value of solar radiation received by counties in each census region during our study period. You could replace “mean” with “sd” to get a similar summary of standard deviation. You may want to change the new variable name ("mean\_srad") above as well.

We can also create new variables. For example, the following script creates a new variable showing maximum temperature in degrees Fahrenheit.

``` r
daymet_climatechg<-daymet_cty_2005_2015 %>% 
  mutate(tmax_f=(tmax*1.8)+32)
```

    ## Warning: package 'bindrcpp' was built under R version 3.4.4

``` r
kable(head(daymet_climatechg))
```

| gisjn\_cty |  year| month |      dayl|      srad|      tmax|        tmin|  vap\_pres|  prcp| CTY\_NAME | State   | Region       | Division                    |        Lon|     Lat|   tmax\_f|
|:-----------|-----:|:------|---------:|---------:|---------:|-----------:|----------:|-----:|:----------|:--------|:-------------|:----------------------------|----------:|-------:|---------:|
| G01001     |  2005| Apr   |  46137.60|  420.6933|  23.13333|   9.4666667|  1210.6667|   195| Autauga   | Alabama | South Region | East South Central Division |  -86.64257|  32.535|  73.64000|
| G01001     |  2005| Aug   |  47380.65|  364.3871|  31.58065|  22.0322581|  2649.0323|   150| Autauga   | Alabama | South Region | East South Central Division |  -86.64257|  32.535|  88.84516|
| G01001     |  2005| Dec   |  35663.77|  258.5806|  13.33871|   0.1774194|   637.4194|    69| Autauga   | Alabama | South Region | East South Central Division |  -86.64257|  32.535|  56.00968|
| G01001     |  2005| Feb   |  39028.11|  297.2571|  16.60714|   5.4107143|   935.7143|   152| Autauga   | Alabama | South Region | East South Central Division |  -86.64257|  32.535|  61.89286|
| G01001     |  2005| Jan   |  36444.06|  261.5742|  15.75806|   3.5483871|   855.4839|    75| Autauga   | Alabama | South Region | East South Central Division |  -86.64257|  32.535|  60.36452|
| G01001     |  2005| July  |  50045.13|  350.2452|  31.37097|  22.0483871|  2649.0323|   284| Autauga   | Alabama | South Region | East South Central Division |  -86.64257|  32.535|  88.46774|

\***Question 2 task (4 points):** Let's make a very basic climate change model. Create a new variable (tmax\_new), that adds two degrees Celsius to the existing maximum temperature for each county. Calculate the mean and standard deviation for the original maximum temperature variable and a new one two degrees higher, grouping these by each census region as shown above. How do these compare? Explain any similarities or differences you find.

### Question 3-4

You can also create a table showing summary statistics for each variable. For example, if you wanted to know the mean, median, standard deviation coefficient of variation (CV), and IQR for the tmax variable, you can use group\_by and summarise:

``` r
daymet_summarystats<-daymet_cty_2005_2015 %>% 
  group_by(Region) %>%
  summarise(tmax_mean=mean(tmax),
            tmax_med=median(tmax),
            tmax_sd=sd(tmax),
            tmax_cv=tmax_sd/tmax_mean,
            tmax_iqr=IQR(tmax))
kable(daymet_summarystats)
```

| Region           |  tmax\_mean|  tmax\_med|   tmax\_sd|   tmax\_cv|  tmax\_iqr|
|:-----------------|-----------:|----------:|----------:|----------:|----------:|
| Midwest Region   |    15.74354|   17.26667|  11.236738|  0.7137364|   19.37500|
| Northeast Region |    14.64101|   15.51613|   9.991482|  0.6824312|   18.10000|
| South Region     |    22.78074|   23.75806|   8.338996|  0.3660547|   13.48387|
| West Region      |    16.11225|   16.12500|  10.504552|  0.6519604|   16.38602|

***Question 3 task (4 points):** Adapting the script above, create a data frame that shows the mean, median, standard deviation, CV, and IQR for the ***prcp*** variable. Based on these data, are these data skewed or roughly normal in distribution? Which measures of central tendency and dispersion should you use as a result?*

***Question 4 task (3 points):** Explain the code you used to calculate statistics for question 3 in plain English. What is happening in each function?*

### Questions 5-9

We can also look at variables over time. For instance, we can use facet\_wrap with boxplot to see how the distribution of maximum temperatures varies by region:

``` r
ggplot(daymet_cty_2005_2015, aes(x=year,y=tmax,group=year))+
  geom_boxplot()+
  facet_wrap(~Region)
```

![](Lab1_Loading_data_and_basic_stats_files/figure-markdown_github/unnamed-chunk-5-1.png)

***Question 5 task (3 points):** Create a box plot similar to the one above for the **tmin** variable. Identify two notable patterns evident in this plot.*

We can use the filter command to further specify things, selecting only a single month for comparison over this timeframe.

``` r
daymet_month<-daymet_cty_2005_2015 %>% 
     filter(month=="Mar")
daymet_month
```

    ## # A tibble: 34,485 x 15
    ##    gisjn_cty  year month   dayl  srad  tmax  tmin vap_pres  prcp CTY_NAME
    ##    <chr>     <int> <chr>  <dbl> <dbl> <dbl> <dbl>    <dbl> <int> <chr>   
    ##  1 G01001     2005 Mar   42464.  383.  18.7  5.56     946.   225 Autauga 
    ##  2 G01001     2006 Mar   42464.  402.  20.9  6.92    1044.   122 Autauga 
    ##  3 G01001     2007 Mar   42464.  407.  23.7  7.42    1080.    41 Autauga 
    ##  4 G01001     2008 Mar   42464.  400.  20.9  4.95     916.   156 Autauga 
    ##  5 G01001     2009 Mar   42464.  353.  20.7  7.84    1116.   288 Autauga 
    ##  6 G01001     2010 Mar   42464.  376.  17.3  4.37     862.   137 Autauga 
    ##  7 G01001     2011 Mar   42464.  351.  21.3  7.39    1062.   272 Autauga 
    ##  8 G01001     2012 Mar   42464.  378.  24.5 11.7     1426.   187 Autauga 
    ##  9 G01001     2013 Mar   42464.  402.  17.0  3.24     804.    88 Autauga 
    ## 10 G01001     2014 Mar   42464.  375.  18.8  5.03     897.   199 Autauga 
    ## # ... with 34,475 more rows, and 5 more variables: State <chr>,
    ## #   Region <chr>, Division <chr>, Lon <dbl>, Lat <dbl>

***Question 6 task (2 points):** Adapt the above command to create a new data frame, changing "Mar" to a month of your choosing and using **tmin** (rather than tmax) as your variable of interest. You'll need two commands--one to create the data frame and another to "call" it, just like you see above.*

Suppose we are just interested in the median. We would then want to create a dataset where the value of tmax is summarized by each year for each census division. You can do so using the combination of group\_by and summarise, similar to the command above. Remember, this command summarises our data in the month of March.

``` r
daymet_summary_region<-daymet_month %>% 
  group_by(Region, year) %>% 
  summarise(tmax_med=median(tmax))
kable(head(daymet_summary_region))
```

| Region         |  year|  tmax\_med|
|:---------------|-----:|----------:|
| Midwest Region |  2005|   8.435484|
| Midwest Region |  2006|   8.435484|
| Midwest Region |  2007|  12.483871|
| Midwest Region |  2008|   7.225807|
| Midwest Region |  2009|  10.419355|
| Midwest Region |  2010|  10.370968|

Notice how much smaller this dataset is already. Plot it out using ggplot:

``` r
ggplot(daymet_summary_region, aes(x=year,y=tmax_med, group=Region, colour=Region))+
  geom_line()
```

![](Lab1_Loading_data_and_basic_stats_files/figure-markdown_github/unnamed-chunk-8-1.png)

***Question 7 task (3 points):** Create a line plot similar to the one above for the **tmin** variable in the month you have chosen.*

Suppose you wanted to see the distribution of the mean maximum temperatures of all counties by region in March, rather than the median. You can summarise that in this way:

``` r
daymet_summary_county <- daymet_month %>% 
  group_by(Region,gisjn_cty) %>% 
  summarise(tmax_mean=mean(tmax))
kable(head(daymet_summary_county))
```

| Region         | gisjn\_cty |  tmax\_mean|
|:---------------|:-----------|-----------:|
| Midwest Region | G17001     |   11.010264|
| Midwest Region | G17003     |   14.875367|
| Midwest Region | G17005     |   12.617302|
| Midwest Region | G17007     |    7.068915|
| Midwest Region | G17009     |   10.966276|
| Midwest Region | G17011     |    8.888563|

You can then create a density plot of these mean values by region, again using facet\_wrap to separate them.

``` r
ggplot(daymet_summary_county, aes(x=tmax_mean))+
  geom_density()+
  facet_wrap(~Region)
```

![](Lab1_Loading_data_and_basic_stats_files/figure-markdown_github/unnamed-chunk-10-1.png)

***Question 8 task (3 points):** Create a density plot similar to the one above for the **tmin** variable in the month you have chosen.*

***Question 9 task (4 points):** Explain in your own words what the line and density plots you created tell us about the data. How are they different from one another? In what ways, if any, do they tell similar stories?*
