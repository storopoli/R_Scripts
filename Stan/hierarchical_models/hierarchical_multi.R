library(cmdstanr)
library(brms)
library(dplyr)

mpg <- ggplot2::mpg

X <- unname(model.matrix(~ 1 + displ + year, mpg))
u <- mpg %>%
    group_by(class) %>%
    select(displ, year) %>%
    summarise_all(mean) %>%
    select(-class) %>%
    bind_cols(1, .) %>%
    mutate_all(function(x) 1 / x) %>%
    t() %>%
    as.matrix() %>%
    unname()

dat <- list(
    N = nrow(X),
    J = length(unique(mpg$class)),
    K = ncol(X),
    jj = as.numeric(as.factor(mpg$class)),
    X = X,
    L = ncol(X),
    u = u,
    y = mpg$hwy
)

# Vanilla Multivariate Hierarchical Model
# Total 15.4s (3 divergences)
vanilla <- cmdstan_model(here::here("Stan", "hierarchical_models", "hierarchical_multi.stan"))
vanilla_fit <- vanilla$sample(data = dat)
print(vanilla_fit$summary(), n = 90)

# Standardized Predictors (QR) Hierarchical model
# 32.7s Total (3 divergences))
standard <- cmdstan_model(here::here("Stan", "hierarchical_models", "standard_multi.stan"))
standard_fit <- standard$sample(data = dat)
print(standard_fit$summary(), n = 100)

# brms
# Total 5.6s M1 (32 divergences)
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
