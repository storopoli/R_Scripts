library(cmdstanr)
data(mtcars)

mtcars$Intercep <- 1
dat <- list(
    N = 32,
    Y = mtcars$mpg,
    K = 11,
    X = mtcars[, c(12, 2:11)],
    prior_only = FALSE
)

# 12s to Compile
# 0.3s sampling (Turing 2.4s)
system.time(model <- cmdstan_model(
    here::here(
        "Stan",
        "comparisons",
        "cmdstanr-vs-turing.jl",
        "linear_regression.stan"
    )
))
fit <- model$sample(data = dat)
fit$cmdstan_summary()
