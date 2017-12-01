Final project
================

Overview
--------

In this final project, your team will analyze the relationship between three demographic variables and the congressional vote in the 1992 and 2016 elections in one of the four major census regions. Those three variables will be percentage of the population NOT classified as white, non-Hispanic, percentage with a bachelor's degree or higher, and median household income. In each time period, the district value for these variables is the median tract value from the 1990 decennial census and 2011-15 ACS.

Within your group, each person will choose one variable to analyze. You'll look at the statistical and spatial distribution of this variable by state and use regression to analyze the association between it and the House election in each year.

Together, your group will also create models using all your variables to analyze their association with elections results. At the state level, you'll look at the association between demographics and the efficiency gap.

The data for this project are all available on a project Github repository: <https://github.com/jshannon75/district_change>. We'll load data directly from there.

``` r
library(tidyverse)
library(sf)

proj_region="Midwest Region" #Adjust to fit your group

district_data<-read_csv("https://github.com/jshannon75/geog4300/raw/master/Labs/Final_assignment/districts_data_all.csv") %>%
  mutate(year=as.character(year))
```

This file includes political districts in both 1992 and 2016 (1990 and 2015 in the year field), a variety of demographic variables, and results for the U.S. House elections in both years. There's also some dummy variables for elections that were uncontested (uncon\_r and uncon\_d), elections with no vote totals (missing), and states with 2 or less districts (dist\_omit).

The three demographic variables you're interested in are % not classifed as white, non-hispanic (nonwht\_pct), median household income (medhhinc), and % with a BA degree or higher (badeg\_pct).

You'll be completing a single document as a group, but each of you will be responsible for individual sections: descriptive analysis and modeling for your independent variables. You should collarboate on the overview, multivariate model, and summary sections. Directions for the individual sections are below.

### Descriptive analysis

First, you should look at the statistical and spatial distribution of your specific variable. As an example, plotting the percent voting for the democratic candidate in the South Region on a ridge plot would look like this. (Note that you'll first need to install the ggridges package. Find more about it (<https://cran.r-project.org/web/packages/ggridges/vignettes/introduction.html>)\[in this vignette\]). We'll also add a line showing the median value across the region.

Before plotting these data, we will remove all districts with missing data, which have -99 as the vote total. We will also top and bottom code uncontested races, using the figure from Stephanopoulis and McGhee (2015) of 66% of the vote being Democractic in uncontested Democratic races and 36% of the vote being Democratic in uncontested Republican races.

``` r
library(ggridges)
districts_select<-district_data %>%
  filter(Region==proj_region) %>%
  group_by(year) %>%
  mutate(median_dem=mean(pct_dem),
         pct_dem_adj=ifelse(uncontest_r==1,66,ifelse(uncontest_d==1,36,pct_dem))) %>%
  filter(total_vote!=-99)

ggplot(districts_select,aes(x=pct_dem_adj,y=st_abbr))+
  geom_density_ridges(scale=3)+
  theme_ridges()+
  geom_vline(aes(xintercept = median_dem),col="red")+
  facet_wrap(~year)+
  xlab("Pct. voting Democractic")+
  ylab("")
```

![](assignment_files/figure-markdown_github/unnamed-chunk-2-1.png)

You can also map the data by year using tmap, also filtering out districts with missing data. We will add in state boundaries as well from the shapes statefile, removing the border lines for individual districts.

``` r
library(tmap)

districts<-st_read("https://github.com/jshannon75/geog4300/raw/master/Labs/Final_assignment/districts_all.geojson",stringsAsFactors=FALSE) 
```

    ## Reading layer `districts_all' from data source `https://github.com/jshannon75/geog4300/raw/master/Labs/Final_assignment/districts_all.geojson' using driver `GeoJSON'
    ## Simple feature collection with 877 features and 2 fields
    ## geometry type:  MULTIPOLYGON
    ## dimension:      XY
    ## bbox:           xmin: -179.1489 ymin: -14.5487 xmax: 179.7785 ymax: 71.36516
    ## epsg (SRID):    4326
    ## proj4string:    +proj=longlat +datum=WGS84 +no_defs

``` r
districts_join<-left_join(districts,districts_select) %>%
  filter(st_abbr!="AK" & st_abbr!="HI")

states<-st_read("https://github.com/jshannon75/geog4300/raw/master/Labs/Final_assignment/USstates_48.geojson") %>% filter(Region==proj_region)
```

    ## Reading layer `USstates_48' from data source `https://github.com/jshannon75/geog4300/raw/master/Labs/Final_assignment/USstates_48.geojson' using driver `GeoJSON'
    ## Simple feature collection with 48 features and 8 fields
    ## geometry type:  MULTIPOLYGON
    ## dimension:      XY
    ## bbox:           xmin: -124.7328 ymin: 24.95638 xmax: -66.96927 ymax: 49.37173
    ## epsg (SRID):    4326
    ## proj4string:    +proj=longlat +datum=WGS84 +no_defs

``` r
districts_1990<-districts_join %>% filter(year=="1990" & Region==proj_region)
districts_2015<-districts_join %>% filter(year=="2015" & Region==proj_region)

map1<-tm_shape(districts_1990,projection="2163") +
  tm_polygons("pct_dem_adj", breaks=c(0,40,45,50,55,70,100),border.alpha=0)+
  tm_shape(states) + tm_borders()

map2<-tm_shape(districts_2015,projection="2163") +
  tm_polygons("pct_dem_adj", breaks=c(0,40,45,50,55,70,100),border.alpha=0)+
  tm_shape(states) + tm_borders()

tmap_arrange(map1,map2)
```

![](assignment_files/figure-markdown_github/unnamed-chunk-3-1.png)

### Modeling

Now that we've done some descriptive analysis, let's model the relationship between our variable and the democratic vote, adjusted to account for uncontested races.

``` r
model1990<-lm(pct_dem_adj~hisp_pct,data=districts_1990)
model2015<-lm(pct_dem_adj~hisp_pct,data=districts_2015)
```

The model results can be summarized with stargazer:

<table style="text-align:center">
<tr>
<td colspan="3" style="border-bottom: 1px solid black">
</td>
</tr>
<tr>
<td style="text-align:left">
</td>
<td colspan="2">
Model results
</td>
</tr>
<tr>
<td>
</td>
<td colspan="2" style="border-bottom: 1px solid black">
</td>
</tr>
<tr>
<td style="text-align:left">
</td>
<td colspan="2">
Pct. voting democratic
</td>
</tr>
<tr>
<td style="text-align:left">
</td>
<td>
1992
</td>
<td>
2016
</td>
</tr>
<tr>
<td style="text-align:left">
</td>
<td>
(1)
</td>
<td>
(2)
</td>
</tr>
<tr>
<td colspan="3" style="border-bottom: 1px solid black">
</td>
</tr>
<tr>
<td style="text-align:left">
hisp\_pct
</td>
<td>
0.648<sup>\*</sup>
</td>
<td>
0.532<sup>\*\*\*</sup>
</td>
</tr>
<tr>
<td style="text-align:left">
</td>
<td>
(0.347)
</td>
<td>
(0.200)
</td>
</tr>
<tr>
<td style="text-align:left">
</td>
<td>
</td>
<td>
</td>
</tr>
<tr>
<td style="text-align:left">
Constant
</td>
<td>
50.676<sup>\*\*\*</sup>
</td>
<td>
42.552<sup>\*\*\*</sup>
</td>
</tr>
<tr>
<td style="text-align:left">
</td>
<td>
(1.586)
</td>
<td>
(1.911)
</td>
</tr>
<tr>
<td style="text-align:left">
</td>
<td>
</td>
<td>
</td>
</tr>
<tr>
<td colspan="3" style="border-bottom: 1px solid black">
</td>
</tr>
<tr>
<td style="text-align:left">
Observations
</td>
<td>
105
</td>
<td>
94
</td>
</tr>
<tr>
<td style="text-align:left">
R<sup>2</sup>
</td>
<td>
0.033
</td>
<td>
0.072
</td>
</tr>
<tr>
<td style="text-align:left">
Adjusted R<sup>2</sup>
</td>
<td>
0.023
</td>
<td>
0.062
</td>
</tr>
<tr>
<td style="text-align:left">
Residual Std. Error
</td>
<td>
15.092 (df = 103)
</td>
<td>
15.852 (df = 92)
</td>
</tr>
<tr>
<td style="text-align:left">
F Statistic
</td>
<td>
3.490<sup>\*</sup> (df = 1; 103)
</td>
<td>
7.107<sup>\*\*\*</sup> (df = 1; 92)
</td>
</tr>
<tr>
<td colspan="3" style="border-bottom: 1px solid black">
</td>
</tr>
<tr>
<td style="text-align:left">
<em>Note:</em>
</td>
<td colspan="2" style="text-align:right">
<sup>*</sup>p&lt;0.1; <sup>**</sup>p&lt;0.05; <sup>***</sup>p&lt;0.01
</td>
</tr>
</table>
We can also plot each model with ggplot.

``` r
ggplot(districts_select,aes(x=pct_dem_adj,y=hisp_pct)) + 
  geom_point()+
  geom_smooth(method = "lm", se = FALSE)+
  facet_wrap(~year)
```

![](assignment_files/figure-markdown_github/unnamed-chunk-5-1.png)

Use both the models and scatterplot to assess the relationship between your variable and voting behavior.

### List of requirements for each individual section (20 points total)

1.  **Descriptive analysis:** Ridge plots and maps of your variable, along with your interpretation. You are free to calculate additional analysis (e.g., state median values) as needed. (10 points)
2.  **Models:** Linear regression models with a scatterplot and fit line as shown above. Interpret the strength of your models based on the regression output, the scatterplot, and any needed additional information you can get from the data frame itself. Focus on the magnitude, direction, and significance of your model output. (10 points)

### Group sections: summary, and multivariate model (20 points total, applied equally to each group member)

In addition to your individual sections, you'll collaborate on an overview and summary section and run a model with all three of your variables. The overview and summary sections are summarized below:

1.  **Overview:** Write briefly about this region, listing the states included within it, the range of seats/districts for each state, and the general partisan landscape (lean Republican vs. Democratic). (5 points)
2.  **Multivariate models:** Create two models (one each for 1992 and 2016) with all three of your variables included. Summarise these two models using stargazer as shown above. Look at the spatial and statistical distribution of residuals. Check for multicollinearity using VIF, creating a correlation matrix if there are issues to diagnose the problem. Also check for evidence of heterosketasticity. (10 points)
3.  **Summary:** Summarise what you learned about the relationship between your variables and the voting patterns in the state across time periods. (5 points)

To assess the distribution of residuals, the following code can serve as a guide:

We can map out the location of residuals to better understand the model results. To help interpret the residual values, we will use the scale function to convert them to a z score.

![](assignment_files/figure-markdown_github/unnamed-chunk-6-1.png)![](assignment_files/figure-markdown_github/unnamed-chunk-6-2.png)
