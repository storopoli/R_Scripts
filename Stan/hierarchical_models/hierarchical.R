# install.packages("cmdstanr", repos = c("https://mc-stan.org/r-packages/", getOption("repos")))

library(cmdstanr)
# install_cmdstan() # if necessary
library(brms)

mpg <- ggplot2::mpg

dat <- list(
  N = nrow(mpg),
  J = length(unique(mpg$class)),
  K = 2,
  id = as.numeric(as.factor(mpg$class)),
  X = cbind(mpg$displ, mpg$year),
  y = mpg$hwy
)

# Vanilla Hierarchical Model
# 11.7s Total / 8.5 M1 (89 divergences)
vanilla <- cmdstan_model(here::here("Stan", "hierarchical_models", "hierarchical.stan"))
vanilla_fit <- vanilla$sample(data = dat)
vanilla_fit$summary()

# Standardized Predictors (QR) Hierarchical model
# 2.5s Total / 1.3s M1
standard <- cmdstan_model(here::here("Stan", "hierarchical_models", "standard.stan"))
standard_fit <- standard$sample(data = dat)
print(standard_fit$summary(), n = 15)

# 2.2s M1
# Non-Centered Parameterization Standardized Predictors (QR) Hierarchical model
standard_ncp <- cmdstan_model(here::here("Stan", "hierarchical_models", "ncp_standard.stan"))
standard_ncp_fit <- standard_ncp$sample(data = dat)
print(standard_ncp_fit$summary(), n = 22)

# brms
# 0.7s M1
brms_fit <- brm(bf(hwy ~ 1 + (1 | class) + displ + year, decomp = "QR"), data = mpg)
summary(brms_fit)
ranef(brms_fit)
