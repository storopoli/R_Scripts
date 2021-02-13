library(cmdstanr)

# Big Dataset
N <- 10000  # 10,000 obs
K <- 7      # 7 predictors
X <- matrix(nrow = N, ncol = K)  # initialize an empty Matrix with N, K dim
for (k in 1:K) {
  X[, k] <- rnorm(N, mean = runif(1, min = 0, max = 100))
}
y <- as.vector(runif(N, min = -100, max = 100) + X %*% rnorm(7))  # y as a constant plus a linear combination of K and X

data_sim <- list(
    N = N,
    K = K,
    X = X,
    Y = y,
    prior_only = FALSE
)

vanilla <- cmdstan_model(here::here("Stan", "cmdstanr", "big_data.stan"))
unnormalized <- cmdstan_model(here::here("Stan", "cmdstanr", "big_data_unnormalized.stan"))

vanilla$sample(data = data_sim, seed = 123) # 1.7s lp__ -54776.20\
unnormalized$sample(data = data_sim, seed = 123) # 1.7s lp__ -54776.20
