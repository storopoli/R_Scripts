library(rstanarm)
library(rstan)
library(microbenchmark)

# All simulations are Stan's standard
# 4 parallel chains with 2,000 iter

data(mtcars)

# Using rstnarm
fit_arm <- stan_glm(mpg ~ hp + wt, data=mtcars)

# using stan
data <-  list(
  N = nrow(mtcars),
  K = 2,
  X = matrix(data = c(mtcars$hp, mtcars$wt), ncol = 2),
  y = mtcars$mpg)

model <- stan_model("mtcars.stan")
model_std <- stan_model("mtcars_std.stan")
model_qr <- stan_model("mtcars_qr.stan")

fit <- sampling(model, data = data)

fit_std <- sampling(model_std, data = data)

fit_qr <- sampling(model_qr, data = data)

benchmark <- microbenchmark(
  sampling(model, data = data),      # 12s
  sampling(model_std, data = data),  # 12s
  sampling(model_qr, data = data),   # 11s
  times = 1
)

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
  y = y
)

benchmark <- microbenchmark(
  sampling(model, data = data_sim),                   # 993s
  sampling(model_std, data = data_sim),               # 970s
  sampling(model_qr, data = data_sim),                # 856s
  stan_glm(y ~ ., data = as.data.frame(cbind(X,y))),  # 13s
  times = 1
)
