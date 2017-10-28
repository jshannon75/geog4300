#Post-hoc ANOVA analysis

#Load data
part_id<-c(4,5,6,13,14,15,8,9,16,17,18,7,1,2,3,10,11,12)
drug<-c("anxifree","anxifree","anxifree","anxifree","anxifree","anxifree","joyzepam","joyzepam","joyzepam","joyzepam","joyzepam","joyzepam","placebo","placebo","placebo","placebo","placebo","placebo")
therapy<-c("no.therapy","no.therapy","no.therapy","CBT","CBT","CBT","no.therapy","no.therapy","CBT","CBT","CBT","no.therapy","no.therapy","no.therapy","no.therapy","CBT","CBT","CBT")
result<-data.frame(c(0.6,0.4,0.2,1.1,0.8,1.2,1.7,1.3,1.8,1.3,1.4,1.4,0.5,0.3,0.1,0.6,0.9,0.3))
anova_data_navarro<-data.frame(cbind(part_id,drug,therapy,result))
names(anova_data_navarro)<-c("part_id","drug","therapy","result")

#Create ANOVA objest
drugtest<-aov(result~drug,anova_data_navarro)
summary(drugtest)

#Follow up t-tests
placebo<-subset(anova_data_navarro,drug=="placebo")[,4]
anxifree<-subset(anova_data_navarro,drug=="anxifree")[,4]
joyzepam<-subset(anova_data_navarro,drug=="joyzepam")[,4]
t.test(placebo,anxifree, var.equal=TRUE)
t.test(placebo,joyzepam, var.equal=TRUE)
t.test(anxifree,joyzepam, var.equal=TRUE)

#pairwise t test without and with Bonferroni correction
pairwise.t.test(x=anova_data_navarro$result, 
                g=anova_data_navarro$drug,
                var.equal=TRUE,
                pool.sd=FALSE) 

pairwise.t.test(x=anova_data_navarro$result, 
                g=anova_data_navarro$drug,
                var.equal=TRUE,
                pool.sd=FALSE,
                p.adjust.method="bonferroni")

#Tukey HSD test is a more sophisticated test with correction. We use the ANOVA object for it.
TukeyHSD(drugtest)

#Testing residuals for normality--just use the "residuals" function on the ANOVA object.
drugtest.resid<-residuals(drugtest)
qqnorm(drugtest.resid);qqline(drugtest.resid)
hist(drugtest.resid)

#Running a Fligner-Killeen test to test for equal variances
fligner.test(result~drug,data=anova_data_navarro)

#You could also treat the drug trial data as non-parametric.
#kruskal.test is the non-parametric version
kruskal.test(anova_data_navarro$result~anova_data_navarro$drug)

#In class challenge: Test for differences in pollen levels across regions 
#Region variable: Region_fac
#See the "Midwest Pollen Data" spreadsheet on Google Drive




#Chi-square
#Using the Thanksgiving.chisquare dataset (from lecture)
white<-c(15, 25)
dark<-c(25, 10)
tofurkey<-c(3, 7)
thanksgiving<-cbind(white, dark, tofurkey)

#Run the test
chisq.test(thanksgiving)

#Using the in-class problem
car<-c(58, 199, 205)
transit<-c(21, 49, 32)
walk<-c(36, 64, 29)
survey<-cbind(car, transit, walk)
chisq.test(survey)

#In class challenge: Look at the "tornado_points" data from earlier in the semester
#Is there a difference in the severity of tornados (MAG) across states (ST)?
#You will have to create a table of counts for each MAG category
#Then run the chi-squared test
