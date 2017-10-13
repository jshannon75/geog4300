Geog 4/6300: Lab 4
================

One and two sample difference tests; ANOVA; Goodness of fit tests
-----------------------------------------------------------------

**Due:** Monday, Nov. 6

**Value:** 30 points

**Overview:** This lab continues work with the CPS dataset you used in Lab 3. You'll be conducting normality tests, two sample t tests, chi square tests, and ANOVA to test for differences within these data.

### Part 1: Testing the normality of the EARNWEEK variable

First, load the CPS data:

``` r
library(tidyverse)
cps_data<-read_csv("https://github.com/jshannon75/geog4300/raw/master/Labs/Lab%203-Confidence%20intervals%20Sampling/IPUMS_CPS_FoodSec.csv")
```

We're going to look at the variable for average weekly income: EARNWEEK. Filter these data so you have only valid responses, removing any observations with a value of 9999.99. Then filter for only those responses from the states of New York and New Jersey. Now let's test the normality of this variable.

**Question 1 (3 points)** *To assess the normality of the EARNWEEK variable, do the following: 1) Perform a Shapiro-Wilk normality test on the data. 2) Create a Q-Q plot with a line showing the normal distribution. 3) Create a histogram using ggplot or the base R function.*

**Question 2 (3 points)** *Based on the results you saw in question 1, is this variable normally distributed? How do each of those three tests inform your decision?*

### Part 2: Testing the differences between states

Based on the results of question one, test whether the incomes of survey respondents in these two states were equal or different.

**Question 3 (3 points)** *Based on the normality of the data, what is the appropriate test for determining if actual household incomes between these two states are significantly different (p=0.05)? Explain why this test is appropriate and give a null and alternative hypothesis for this test*

**Question 4 (3 points)** *Create separate data frames for each state and calculate the median or mean (whichever is appropriate) for weekly income in each. Then run the test you identified in question 3.*

**Question 5 (3 points)** *Interpret the results of the analysis you did in question 4. Do you reject the null hypothesis? Why or why not? What can we say about household incomes in these two states?*

### Part 3: Testing income across multiple states using ANOVA

Go back to the CPS data and select data for just the states in the Midwest Region (the "Region" variable). Using ANOVA test, we can test for differences across these states. For the purposes of this section, we will assume these data are normally distributed.

**Question 6 (2 points)** *Go back to the original CPS dataset and filter for records with valid responses for the weekly earnings variable that are in the Midwest region (see the "Region" variable). Using group\_by and summarise, calculate the mean and median income for each state.*

**Question 7 (2 points)** *What are your null and alternative hypotheses for this ANOVA test?*

**Question 8 (3 points)** *Conduct your test. Then use pairwise.t.test for post hoc testing using the Bonferroni correction.*

**Question 9 (4 points)** *Using your responses from question 6 through 8, summarise the results of this analysis. Can you reject the null hypothesis? Why or why not? What else can you say about differences between states in this region?*

### Part 4: Analyzing different in accessing food assistance

While the U.S. Census regularly provides data on use of SNAP/Food stamp benefits, the CPS provides data on other emergency food sources. Here, you will look at use of emergency food from a church, food pantry, or food bank over the last year (FSFDBNK) in the Northeast.

**Question 10 (2 points)** *Go back to the original CPS dataset and filter for records with valid responses to FSFDBNK (&lt;6 on the scale) that are in the Northeast region (see the "Region" variable).*

**Question 11 (3 points)** *Create a table of responses to the FSFDBNK variable against the state given for each response. Conduct a chi square test on this table.*

**Question 12 (3 points)** *Using a procedure similar to Lab 3, convert the table from question 7 to a data frame, and spread it out based on the household response (e.g., separate columns for 1, 2, 3, 4, and 5). Create new columns for total responses and the percentage of all responses showing some use of emergency food assistance (categories 2-5). Call the data frame when done.*

**Question 13 (3 points)** *Looking at your results from questions 7 and 8, what conclusions can you make? What were your null and alternative hypotheses for this study? Did you reject or confirm the null hypothesis and why? What else can you say about the differences between these states?*
