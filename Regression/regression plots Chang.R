library(ggplot2)
library(dplyr)
attach(dataset)
#DATASET = dataset
#INDEP = AGE_SS
#DEP = RUF

# The base plot
sp <- ggplot(dataset, aes(x=AGE_SS, y=RUF))
sp + geom_point() + stat_smooth(method=lm)

# 99% confidence region
sp + geom_point() + stat_smooth(method=lm, level=0.99)
# No confidence region
sp + geom_point() + stat_smooth(method=lm, se=FALSE)

#locally weighted polynomial
sp + geom_point(colour="grey60") + stat_smooth(method=loess)

###ADDING FITTED LINES FROM AN EXISTING MODEL
#MODEL = modelogeral

# Create a data frame with INDEP column, interpolating across range
xmin <- min(dataset$AGE_SS)
xmax <- max(dataset$AGE_SS)
ymax <- max(dataset$RUF)

###DECISION!!!!
#Se a INDEP for maior de rows que a DEP
predicted <- data.frame(AGE_SS=seq(xmin, xmax, length.out=xmax))
#Se a DEP for maior de rows que a INDEP
predicted <- data.frame(AGE_SS=seq(xmin, xmax, length.out=ymax))


# Calculate predicted values of DEP
predicted$RUF <- predict(modelogeral, predicted)
predicted

# We can now plot the data points along with the values predicted from the model
sp <- ggplot(dataset, aes(x=AGE_SS, y=RUF)) +
  geom_point(colour="grey40")
sp + geom_line(data=predicted, size=1)
