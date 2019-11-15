################## CORRELATIONS ########################
library(psych)
options(scipen = 999)
cormydata <- corr.test(mydata,alpha = .05, method = "pearson")
write.csv2(cormydata$r, file = "cormydata.csv") #CSV Correlations
write.csv2(cormydata$p, file = "cormydatap.csv") #CSV Correlations p-value
###Plots###
library(corrplot)
#order can be original alphabet hcust FPC AOE
corrplot(cor(mydata), order="alphabet",tl.col="black",tl.cex=.75)

################## COMMON METHOD BIAS - CMB ################## 

cmb <- principal(mydata, nfactors = 1, rotate = "varimax", scores = T)
cmb$Vaccounted #Proportion var has to be below 0.5 (50%)
         
########################### FACTOR ANALYSIS ######################

### Determining the Number of Factors to Extract ####
library(nFactors)
ev <- eigen(cor(mydata)) # get eigenvalues
ap <- parallel(subject=nrow(mydata),var=ncol(mydata),
               rep=100,cent=.05)
nS <- nScree(x=ev$values, aparallel=ap$eigen$qevpea)
plotnScree(nS)

# PCA Variable Factor Map 
library(FactoMineR)

result <- PCA(mydata)
summary(result) # call results
plot(result)    # plot graphs

  ################## UNROTATED PRINCIPAL COMPONENT ANALYSIS ################## 
# Pricipal Components Analysis
# entering raw data and extracting PCs 
# from the correlation matrix 
fit <- princomp(mydata, cor=TRUE)
summary(fit) # print variance accounted for 
loadings(fit) # pc loadings 
plot(fit,type="lines") # scree plot 
fit$scores # the principal components
biplot(fit)


#################### EXPLORATORY FACTOR ANALYSIS ###########################

#################### IMPORTANT missing = T ####################

#Pincipal Componens Analysis
library(psych)
fit <- principal(mydata, nfactors = 9, rotate = "varimax", scores = T)
print(fit, digits = 3, cut = 0.4, sort = T) # print results
fa.diagram(fit, digits = 3, cut = 0.4, sort = T) #Diagram of Factors, items and loadings
plot(fit)    # plot graphs

# Principal Axis Factor Analysis
library(psych)
fit <- fa(mydata, nfactors = 9, rotate  = "varimax", fm = "pa", n.iter = 50) #Bootstrap 50
print(fit, digits = 3, cut = 0.4, sort = T) # print results
print(fit$loadings, digits =3 , cut = 0.4, sort = T)
fa.diagram(fit, digits = 3, cut = 0.4, sort = T) #Diagram of Factors, items and loadings
plot(fit)    # plot graphs

# Maximum Likelihood Factor Analysis
library(psych)
fit <- fa(mydata, nfactors = 2, rotate = "varimax", fm = "ml", n.iter = 50) #Bootstrap 50
print(fit, digits = 3, cut = 0.4, sort = T) # print results
fa.diagram(fit, digits = 3, cut = 0.4, sort = T) #Diagram of Factors, items and loadings
plot(fit)    # plot graphs

# Minimum Residual Factor Analysis
library(psych)
fit <- fa(mydata, nfactors = 2, rotate = "varimax", fm = "minres", n.iter = 50) #Bootstrap 50
print(fit, digits = 3, cut = 0.4, sort = T) # print results
fa.diagram(fit, digits = 3, cut = 0.4, sort = T) #Diagram of Factors, items and loadings
plot(fit)    # plot graphs

# OLS Factor Analysis
library(psych)
fit <- fa(mydata, nfactors = 9, rotate  = "varimax", fm = "ols", n.iter = 50) #Bootstrap 50
print(fit, digits = 3, cut = 0.4, sort = T) # print results
print(fit$loadings, digits =3 , cut = 0.4, sort = T)
fa.diagram(fit, digits = 3, cut = 0.4, sort = T) #Diagram of Factors, items and loadings
plot(fit)    # plot graphs

##################### BIBEXCEL CO-OCCURENCE FACTOR ANALYSIS ##################### 
### Determining the Number of Factors to Extract ####
library(nFactors)
ev <- eigen(cor(mydata)) # get eigenvalues
ap <- parallel(subject=nrow(mydata),var=ncol(mydata),
               rep=100,cent=.05)
nS <- nScree(x=ev$values, aparallel=ap$eigen$qevpea)
plotnScree(nS)

#Principal Componentes Analysis
library(dplyr)
prc <- prcomp(mydata, center=T, scale=T, retx=T)
varimax <- varimax(prc$rotation[,1:9], normalize = TRUE)  #number of factors to extract
results_rotated <-  as.data.frame(unclass(varimax$loadings)) #Rotated Matrix
results_unrotated <-  as.data.frame(unclass(prc$rotation)) #Unrotated Matrix

# Sorting Loadings
sorted <- fa.sort(fit)
write.csv2(sorted$loadings, "sorte_loadings.csv")
