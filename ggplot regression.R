library(ggplot2)
attach(dataset)

##https://stackoverflow.com/questions/15633714/adding-a-regression-line-on-a-ggplot

# create multiple linear model
lm_fit <- lm(mpg ~ cyl + hp, data=df)
summary(lm_fit)

# save predictions of the model in the new data frame 
# together with variable you want to plot against
predicted_df <- data.frame(model_pred = predict(modelo1, dataset), PUBLICA=dataset$PUBLICA)

# this is the predicted line of multiple linear regression
ggplot(data = dataset, aes(x = MEDICINA, y = CAPITAL)) + 
  geom_point(color='blue') +
  geom_line(color='red',data = predicted_df, aes(x= model_pred, y= CAPITAL))

# this is predicted line comparing only chosen variables
ggplot(data = dataset, aes(x = MEDICINA, y = CAPITAL)) +
  geom_point(color='blue') +
  geom_smooth(method = "lm", se = FALSE)