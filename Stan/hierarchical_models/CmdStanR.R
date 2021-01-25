#remotes::install_github("stan-dev/cmdstanr")

library(cmdstanr)
#install_cmdstan() # if necessary

mpg <- ggplot2::mpg

dat <- list(
  N = nrow(mpg),
  J = length(unique(mpg$class)),
  K = 2,
  id = as.numeric(as.factor(mpg$class)),
  X = cbind(mpg$displ, mpg$year),
  y = mpg$hwyo
)

# Vanilla Hierarchical Model
# 11.7s Total
vanilla <- cmdstan_model("hierarchical.stan")
vanilla_fit <- vanilla$sample(data = dat)
vanilla_fit$summary()

# Standardized Predictors (QR) Hierarchical model
# 2.5s Total
standard <- cmdstan_model("standard.stan")
standard_fit <- standard$sample(data = dat)
standard_fit$summary()
