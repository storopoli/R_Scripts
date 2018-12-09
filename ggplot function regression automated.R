##https://sejohnston.com/2012/08/09/a-quick-and-easy-function-to-plot-lm-results-in-r/


################# mudar o x=names para ordem da indep da formula que você quer
################# no caso o [2] aponta para a segunda var do modelo lm(DEP ~ INDEP1 + INDEP2 + INDEP3)
################# Aqui seria mudar [2]INDEP1 ou [3]INDEP2 ou [4]INDEP3
################# digite names(lm.fit$coefficients) para ver qual indep enfiar no ggplot

library(ggplot2)
ggplotRegression <- function (fit) {
  
  require(ggplot2)
  
  ggplot(fit$model, aes_string(x = names(fit$model)[2], y = names(fit$model)[1])) + 
    geom_point() +
    stat_smooth(method = "lm", col = "red") +
    labs(title = paste("Adj R2 = ",signif(summary(fit)$adj.r.squared, 5),
                       "Intercept =",signif(fit$coef[[1]],5 ),
                       " Slope =",signif(fit$coef[[2]], 5),
                       " P =",signif(summary(fit)$coef[2,4], 5)))
}

#once you loaded the function you could simply
fit <- lm( y ~ x + z + Q, data)
ggplotRegression(modelogeral)


#you can also go for
ggplotregression( y ~ x + z + Q, data)

################# function for standarized coeff #################
library(lm.beta)
lm.fitbeta <- lm.beta(lm.fit)
ggplotRegression <- function (fit) {
  require(ggplot2)
  ggplot(fit$model, aes_string(x = names(fit$model)[11], y = names(fit$model)[1])) +
    geom_point() +
    stat_smooth(method = "lm", col = "red") +
    labs(title = paste("Adj R2 = ",signif(summary(fit)$adj.r.squared, 5),
                       "Intercept =",signif(fit$coef[[1]],5 ),
                       " Slope =",signif(fit$standardized.coefficients[[11]], 5),
                       " P =",signif(summary(fit)$coef[11,4], 5)))
}
ggplotRegression(lm.fitbeta)

