#Correlation

#Data from lecture
MHI<-c(40000, 59000, 61000, 66000, 68000, 71000, 78000, 82000, 89000, 103000, 104000,113000, 129000, 141000,156000)
VCR<-c(45.2, 44.6, 39.2, 42.4, 37.4, 29.4, 38.1, 28.5, 21.4, 19.4, 25.1, 28.5, 22.5, 17.3, 13.5)

#A simple scatterpot shows possible correlation
plot(MHI, VCR)

#Correlate the two
cor(MHI, VCR)

#Correlations are often shown as a matrix
#Here, we can use the Pollen Data
#The rcorr function in the Hmisc package does this well.
library(Hmisc)
pollen<-Midwest_Pollen_Data[,c(6:15,21)] #Take just the first 10 species
names(pollen)
rcorr(as.matrix(pollen))#The data must be formatted as a matrix
#Note that this shows both the correlation coefficient and its p value

#You can easily visualize the relationship using the built-in pairs function.
#This creates scatterplots for every variable pair
pairs(pollen)

#The corrgram function in the corrgram package has more options.
library(corrgram)
M<-cor(pollen)
corrgram(M, panel=panel.shade)
corrgram(M, order=FALSE, lower.panel=panel.conf,
         upper.panel=panel.shade, text.panel=panel.txt,
         main="Census correlations")
?corrgram #See the documentation for the various options

#For non-parametric data, specify spearman's rho in the rcorr package
rcorr(as.matrix(pollen), type="spearman")

#You can also specify for the cor command
M<-cor(pollen.pct,method="spearman")
corrgram(M, panel=panel.shade)

