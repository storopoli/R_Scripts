################ DATA PREP ################ 
# Data is mydata
# Regression model is lm.fit
# Also take a loot at package olsrr

################ CORRELATION ################ 
cor_matrix <- cor(mydata) #correlation matrix
cor_matrix <- cor(mydata[, sapply(mydata, is.numeric)]) #If you have factors with numeric vars in data
corrplot::corrplot(cor_matrix, order="original",tl.col="black",tl.cex=.75) #Original Order
corrplot::corrplot(cor_matrix, order="alphabet",tl.col="black",tl.cex=.75) #Alphabetic Order
corrplot::corrplot(cor_matrix, order="hclus",tl.col="black",tl.cex=.75) #Hierarchical Clustering Order
corrplot::corrplot(cor_matrix, order="FPC",tl.col="black",tl.cex=.75) #First Principal Component Order
corrplot::corrplot(cor_matrix, order="AOE",tl.col="black",tl.cex=.75) #Angular Order of Eigenvectors
pairs(mydata[, sapply(mydata, is.numeric)])


################ SIX ASSUMPTIONS ###############
#1. Non-linearity of data
#2. Correlation of Error Terms (Autocorrelation of residuals)
#3. Non-constant Variance of Error Terms
#4. Outliers
#5. High Leverage Points
#6. Collinearity

## Assumptions in Linear Regression ##
library(gvlma)
gvlma(lm.fit)

## 1. Non-linearity of data
par(mfrow = c(2, 2))
plot(lm.fit)
#Ideally, the residual plot will show no fitted discernible pattern. 
#The presence of a pattern may indicate a problem with some aspect of the linear model.
#The shape of the !Residuals vs Fitted! should be near to an horizontal line indicating that they have no pattern
#The shape of the !Normal Q-Q! should be a straight line indicating a normal distribution
par(mfrow = c(1, 1))
car::qqPlot(lm.fit) #The qqPlot() function of the car package automatically provides these confidence interval
#Histogram of Residuals
sresid <- MASS::studres(lm.fit)
hist(sresid, freq=FALSE,
     main="Distribution of Studentized Residuals")
xlm.fit<-seq(min(sresid),max(sresid),length=40)
ylm.fit<-dnorm(xlm.fit)
lines(xlm.fit, ylm.fit)


## 2. Correlation of Error Terms (Autocorrelation of residuals)
# Non-time series
car::durbinWatsonTest(lm.fit)
#The null hypothesis is that there is no autocorrelation. 
#If p under 0.05 then, null is rejected, so there is evidence for autocorrelation.
# Time series
acf(lm.fit$residuals) #Time-series
Box.test(lm.fit$residuals, lag=23, type="Ljung-Box")
plot.ts(lm.fit$residuals)

## 3. Non-constant Variance of Error Terms
par(mfrow = c(2, 2))
plot(lm.fit)
#Scale-Location shows if residuals are spread equally along the ranges of predictors
#This is how you can check the assumption of equal variance (homoscedasticity) 
#It's good if you see a horizontal line with equally (randomly) spread points
car::ncvTest(lm.fit) #non-constant error variance test #Breusch-Pagan Test
leveneTest(lm.fit) #Levene Test
#pvalue must be over 0.05 for homoscedasticity
par(mfrow = c(1, 1))
car::spreadLevelPlot(lm.fit) #plot studentized residuals vs. fitted values
#When faced with this problem, one possible solution is to transform
#the Y using a concave function such as log Y or sqroot of Y
#You can also do a box-cox transformation of the Y
varBCMod = caret::BoxCoxTrans (mydata$oldvar) #create a model for BC Transformation
print(varBCMod)
mydata <- cbind(mydata, newvar=predict(varBCMod, mydata$oldvar)) # append the transformed variable to dataset

## 4. Outliers
#Studentized residuals are greater than 3 in absolute value are possible outliers
#Square root of studentized residuals larger than 1.732 are outliets (square root of 3)
par(mfrow = c(1, 1))
car::qqPlot(lm.fit)
#This shows the Student Standarized Residuals by observation
#also prints in the console the observations that violate the greater than 3 value in absolute ##
###############################################################################
## If we believe that an outlier has occurred due to an error in data collection ##
## or recording, then one solution is to simply remove the observation.          ##
## However, care should be taken, since an outlier may instead indicate a        ##
## deficiency with the model, such as a missing predictor.                       ##
###############################################################################

## 5. High Leverage Points
par(mfrow = c(2, 2))
plot(lm.fit)
#removing the high leverage observation has a much more substantial
#impact on the least squares line than removing the outlier
par(mfrow = c(1, 1))
car::influenceIndexPlot(lm.fit)
#Bonferroni Test
car::outlierTest(lm.fit) #Bonferonni p-value for most extreme obs

## 6. Collinearity
#compute the variance inflation factor (VIF). 
#The VIF is the ratio of the variance of Bj when fitting the full model divided by the
#variance of Bj if fit on its own. 
#The smallest possible value for VIF is 1, which indicates the complete absence of collinearity
#As a rule of thumb, a VIF value that exceeds 5 or 10 indicates a problematic amount of collinearity.
car::vif(lm.fit)
DAAG::vif(lm.fit)