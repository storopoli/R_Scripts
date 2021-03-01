library(cmdstanr)
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

# Vanilla NCP Hierarchical Model
# 2.4s Total
vanilla <- cmdstan_model(here::here("Stan", "benchmarks", "ncp_vanilla.stan"))
vanilla_fit <- vanilla$sample(data = dat, seed = 123)
print(vanilla_fit$summary(), n = 20)

# std NCP Hierarchical Model (~5% faster)
# 2.3s Total
std <- cmdstan_model(here::here("Stan", "benchmarks", "ncp_std.stan"))
std_fit <- std$sample(data = dat, seed = 123)
print(std_fit$summary(), n = 20)

# GLM NCP Hierarchical Model (~30% faster)
# 1.6s Total
glm <- cmdstan_model(here::here("Stan", "benchmarks", "ncp_glm.stan"))
glm_fit <- glm$sample(data = dat, seed = 123)
print(glm_fit$summary(), n = 20)

# brms
# 1.4s
brms_fit <- brm(bf(hwy ~ 1 + (1 | class) + displ + year, decomp = "QR"), data = mpg)
summary(brms_fit)
