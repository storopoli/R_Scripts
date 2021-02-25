library(cmdstanr)
library(brms)
library(rstanarm)
library(dplyr)
data(wells)

wells <- wells %>%
    mutate(assoc = case_when(
        assoc == 0 ~ 1,
        assoc == 1 ~ 2
    ))

dat <- list(
    N = nrow(wells),
    J = length(unique(wells$assoc)),
    y = wells$switch,
    id = wells$assoc,
    X = cbind(
        wells$arsenic,
        wells$dist,
        wells$educ
    ),
    K = 3
)

# Vanilla Hierarchical Model
# 15.5s Total (11 divergences)
vanilla <- cmdstan_model(here::here("Stan", "hierarchical_models", "hierarchical_binomial.stan"))
vanilla_fit <- vanilla$sample(data = dat)
vanilla_fit$summary()

# QR Decomposition
# 12.9 Total (7 divergences)
standard <- cmdstan_model(here::here("Stan", "hierarchical_models", "standard_binomial.stan"))
standard_fit <- standard$sample(data = dat)
standard_fit$summary()


# 13.9s
brms_fit <- brm(switch ~ 1 + (1 | assoc) + arsenic + dist + educ, family = bernoulli, data = wells)
# 11.7s
brms_fit <- brm(bf(switch ~ 1 + (1 | assoc) + arsenic + dist + educ, decomp = "QR"), family = bernoulli, data = wells)
summary(brms_fit)
ranef(brms_fit)
