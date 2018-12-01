################## CORRELATIONS ########################
attach(mydata)
myvars = c("VAR1", "VAR2",
           "VAR3")
library(psych)
options(scipen = 999)
cormydata <- corr.test(mydata,alpha = .05, method = "pearson")
write.csv2(cormydata$r, file = "cormydata.csv") #CSV Correlations
write.csv2(cormydata$p, file = "cormydatap.csv") #CSV Correlations p-value
sink("lowerCor.txt")
lowerCor(mydata[myvars], digits = 3, method = "pearson") #lowermatrix
sink()
corr.test(mydata[myvars], use = "pairwise.complete.obs")$p #p-value

###Plots###
library(corrplot)
#order can be original alphabet hcust FPC AOE
corrplot(cor(mydata), order="alphabet",tl.col="black",tl.cex=.75)

attach(mydata)
png('pairspanels.jpeg', res = 300, width = 10000, height = 10000)
pairs.panels(mydata[myvars], bg=c("yellow","blue")[mydata$VAR1], pch = 21, digits = 3,
             smoother = T, method = "pearson", alpha = 0.05)
