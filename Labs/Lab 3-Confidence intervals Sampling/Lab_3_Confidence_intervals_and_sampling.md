Geog 4/6300: Lab 3
================

Confidence Intervals and Sampling
---------------------------------

**Due:** Monday, Oct. 16

**Value:** 30 points

**Overview:** This lab covers two main topics: basic spatial statistics and probability distributions. We will be using individual level “microdata” from the Current Population Survey (CPS). It is designed as an ongoing (collected monthly) set of data on financial and demographic characteristics. One main use of the CPS is to calculate national levels of food insecurity. Each December, a food security supplement is added to the regular survey, and data from the supplement is included here.

To load these data, load the csv file:

``` r
library(tidyverse)
cps_data<-read_csv("https://github.com/jshannon75/geog4300/raw/master/Labs/Lab%203-Confidence%20intervals%20Sampling/IPUMS_CPS_FoodSec.csv")
```

This contains a csv file with microdata from the CPS that is de-identified and publically available through the Minnesota Population Center (<https://cps.ipums.org/cps/index.shtml>). There is also a [codebook available on Github](https://github.com/jshannon75/geog4300/raw/master/Labs/Lab%203-Confidence%20intervals%20Sampling/IPUMS_CPS_Codebook.pdf) describing each of those variables.

### Part 1: Summarizing immigration data

Look at the information on the YRIMMIG variable in the codebook, which describes when foreign born respondents arrived in the U.S. Much statistical data comes with a “missing variable” identifier, which in this case you want to leave out of your analysis. In this case, those are records marked with a 0, labeled in the codebook as "NIU" (or "not in universe").

**Question 1 (3 points)** *Create a script that subsets this data so that only records with meaningful responses are included. Then create a histogram (using either base R or ggplot) of the resulting subset to show the distribution. Also calculate the mean, median, standard deviation, and IQR (see lab 1) of this variable.*

**Question 2 (1 point)** *Lastly, describe what the histogram and summary statistics tell you about the central tendancy and distribution of the YRIMMIG variable.*

### Part 2: Calculating food insecurity

The n() function can be used to count records in a group. See this example for immigration:

``` r
cps_data %>%
  group_by(YRIMMIG) %>%
  summarise(count=n())
```

    ## # A tibble: 23 x 2
    ##    YRIMMIG  count
    ##      <int>  <int>
    ##  1       0 466161
    ##  2    1949    743
    ##  3    1959   2071
    ##  4    1964   1815
    ##  5    1969   2147
    ##  6    1974   2981
    ##  7    1979   3682
    ##  8    1981   2634
    ##  9    1983   1660
    ## 10    1985   2264
    ## # ... with 13 more rows

For this response, look at the FSSTATUS variable, which describes the food security of respondents. While food security status is often grouped into “low” and “very low” food security, these two are often just combined to a single measure: food insecure.

**Question 3 (3 points)** *Using the information on this variable in the codebook (p. 12), create a subset of records without the NIU or missing response records. Then use group\_by and summarise to calculate the number of individuals grouped in each status as shown above. Use the resulting data frame to calculate an estimate of the national food insecurity rate.*

**Question 4 (2 points)** *Using the formula for confidence intervals for proportions shown in class, calculate a confidence interval for the rate you identified in question 3.*

**Question 5 (4 points)** *Now use filter with the STATE variable to select records with food security data from Georgia and from Colorado. Compute the same confidence interval as you did above for just these records. Then do the same for Colorado. Calculate an estimated food insecurity rate for both states along with a related confidence interval.*

**Question 6 (2 points)** *Is the size of confidence interval different between the states and national data? If so, why?*

### Part 3: Sampling

A new study is being developed to determine whether new food shelves in the Atlanta metropolitan area are reducing rates of food insecurity. The research question is whether living within a mile of a food pantry lowers food insecurity for households.

**Question 7 (4 points)** *Pick a probabilistic sampling strategy (or combination of strategies) discussed in our text or in lecture that would be appropriate for this research question: random, systemic, stratified, and cluster. Describe how this strategy could be used to create a sample for use in this proposed study. Describe one strength and weakness of this approach.*

**Question 8 (3 points)** *Health officials would like to do a related survey of household food insecurity with enough responses to allow for margins of error under 2% (with 95% confidence). Assume that the rate is similar to the one you identified for Georgia in question 5. Use R to compute how big a sample they would need.*
