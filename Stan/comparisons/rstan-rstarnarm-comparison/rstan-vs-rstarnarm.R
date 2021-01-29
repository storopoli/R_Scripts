library(rstan)
library(cmdstanr)
library(brms)
library(rstanarm)
library(microbenchmark)
library(magrittr)

# All simulations are Stan's standard
# 4 parallel chains with 2,000 iter

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

# Compile Models

model <- stan_model("stan.stan")
model_std <- stan_model("stan_std.stan")
model_qr <- stan_model("stan_qr.stan")

cmdmodel <- cmdstan_model("stan.stan")
cmdmodel_std <- cmdstan_model("stan_std.stan")
cmdmodel_qr <- cmdstan_model("stan_qr.stan")

brmmodel <- make_stancode(bf(y ~ .), data = as.data.frame(cbind(X,y))) %>% stan_model(model_code = .)
brmmodel_qr <- make_stancode(bf(y ~ ., decomp = "QR"), data = as.data.frame(cbind(X,y))) %>% stan_model(model_code = .)

benchmark <- microbenchmark(
  sampling(model, data = data_sim),                              # 993s
  sampling(model_std, data = data_sim),                          # 970s
  sampling(model_qr, data = data_sim),                           # 856s
  cmdmodel$sample(data = data_sim),                              #
  cmdmodel_std$sample(data = data_sim),                          #
  cmdmodel_qr$sample(data = data_sim),                           #
  sampling(brmmodel, data = data_sim),                           #
  sampling(brmmodel_qr, data = data_sim),                        # 993s
  stan_glm(y ~ ., data = as.data.frame(cbind(X,y))),             # 13s
  stan_glm(y ~ ., data = as.data.frame(cbind(X,y)), QR = TRUE),  # 13s
  times = 1
)
print(benchmark, unit = "s")
