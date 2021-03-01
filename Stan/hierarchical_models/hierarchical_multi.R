library(cmdstanr)
library(brms)
library(dplyr)

mpg <- ggplot2::mpg

X <- unname(model.matrix(~ 1 + displ + year, mpg))

dat <- list(
    N = nrow(X),
    J = length(unique(mpg$class)),
    K = ncol(X),
    jj = as.numeric(as.factor(mpg$class)),
    X = X,
    L = 1,
    u = t(as.matrix(rep(1, length(unique(mpg$class))))),
    y = mpg$hwy
)

# Vanilla Multivariate Hierarchical Model
# Total 20.4s M1 (7 divergences)
vanilla <- cmdstan_model(here::here("Stan", "hierarchical_models", "hierarchical_multi.stan"))
vanilla_fit <- vanilla$sample(data = dat)
print(vanilla_fit$summary(), n = 90)

# Standardized Predictors (QR) Hierarchical model
# 32.7s Total (3 divergences))
standard <- cmdstan_model(here::here("Stan", "hierarchical_models", "standard_multi.stan"))
standard_fit <- standard$sample(data = dat)
print(standard_fit$summary(), n = 100)

# brms
# Total 5.6s M1 (53 divergences)
brms_fit <- brm(
    bf(hwy ~ 1 + displ + year + (1 + displ + year | class), decomp = "QR"),
    data = mpg,
    prior = c(
        set_prior("lkj(2)", class = "cor"),
        set_prior("cauchy(0,2)", class = "sd")
    )
)
summary(brms_fit)
ranef(brms_fit)
stancode(brms_fit)
