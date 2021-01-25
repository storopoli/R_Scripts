library(rstan)
library(brms)
library(rstanarm)
mpg <- ggplot2::mpg

dat <- list(
  N = nrow(mpg),
  J = length(unique(mpg$class)),
  K = 2,
  id = as.numeric(as.factor(mpg$class)),
  X = cbind(mpg$displ, mpg$year),
  y = mpg$hwy
)

model_rstan <- stan("stanmodel.stan",
                    data = dat)
summary(model_rstan)$summary

model_rstanarm <- stan_glmer(hwy ~ 1 + (1 | class) + displ + year,
                             data = mpg,
                             family = gaussian)
summary(model_rstanarm)

model_brms <- brm(hwy ~ 1 + (1 | class) + displ + year,
                  data = mpg,
                  family = gaussian,
                  save_pars = save_pars(all = TRUE))
stancode(model_brms)
summary(model_brms, priors = TRUE)
prior_summary(model_brms)
ranef(model_brms, robust = TRUE)



