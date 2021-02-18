library(cmdstanr)
data(mtcars)

mtcars$Intercep <- 1
dat  <- list(
    N = 32,
    Y = mtcars$mpg,
    K = 11,
    X = mtcars[, c(12, 2:11)],
    prior_only = FALSE
)

# 0.4s sampling (Turing 2.4s)
model <- cmdstan_model(here::here("Stan", "comparisons", "cmdstanr-vs-turing.jl", "linear_regression.stan"))
model$sample(data = dat)
