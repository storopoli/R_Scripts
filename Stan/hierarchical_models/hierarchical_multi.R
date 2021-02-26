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
    t() %>%
    as.matrix() %>%
    unname()

dat <- list(
    N = nrow(X),
    J = length(unique(mpg$class)),
    K = ncol(X),
    jj = as.numeric(as.factor(mpg$class)),
    X = X,
    L = 3,
    u = u,
    y = mpg$hwy
)

# Vanilla Multivariate Hierarchical Model
# 8.5 M1 (89 divergences)
vanilla <- cmdstan_model(here::here("Stan", "hierarchical_models", "hierarchical_multi.stan"))
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
# 7.7s M1 (49 divergences)
brms_fit <- brm(
    bf(hwy ~ 1 + (1 + displ + year | class), decomp = "QR"),
    data = mpg,
    prior = c(
        set_prior("normal(0, 20)", class = "intercept"),
        set_prior("lkj(2)", class = "cor"),
        set_prior("cauchy(0,2)", class = "sd")
    )
)
summary(brms_fit)
ranef(brms_fit)
stancode(brms_fit)
