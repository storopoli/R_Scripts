# https://paul-buerkner.github.io/brms/articles/brms_threading.html
library(brms)

# Fake Data
# https://github.com/paul-buerkner/brms/blob/bfb310d8aabb9c9645888f5203e2106c55c07795/vignettes/brms_threading.Rmd#L37-L71
set.seed(54647)
# number of observations
N <- 1e4
# number of group levels
G <- round(N / 10)
# number of predictors
P <- 3
# regression coefficients
beta <- rnorm(P)
# sampled covariates, group means and fake data
fake <- matrix(rnorm(N * P), ncol = P)
dimnames(fake) <- list(NULL, paste0("x", 1:P))
# fixed effect part and sampled group membership
fake <- transform(
  as.data.frame(fake),
  theta = fake %*% beta,
  g = sample.int(G, N, replace = TRUE)
)
# add random intercept by group
fake  <- merge(fake, data.frame(g = 1:G, eta = rnorm(G)), by = "g")
# linear predictor
fake  <- transform(fake, mu = theta + eta)
# sample Poisson data
fake  <- transform(fake, y = rpois(N, exp(mu)))
# shuffle order of data rows to ensure even distribution of computational effort
fake <- fake[sample.int(N, N), ]
# drop not needed row names
rownames(fake) <- NULL

# 25.5s
fit_serial <- brm(
  y ~ 1 + x1 + x2 + (1 | g),
  data = fake,
  family = poisson(),
  iter = 500, # short sampling to speedup example
  chains = 4,
  prior = prior(normal(0, 1), class = b) +
    prior(constant(1), class = sd, group = g),
  backend = "cmdstanr"
)

# 17.1s
fit_unnormalized  <- update(
  fit_serial,
  normalize = FALSE,
  backend = "cmdstanr"
)

# reduce_sum only work as sudo
# 18.2s
fit_parallel <- update(
    fit_serial,
    chains = 2, cores = 2, threads = threading(2),
    backend = "cmdstanr"
)

# reduce_sum only work as sudo
# brms 2.11 not working for unnormalized reduce_sum
# 18.2s
fit_parallel_unnormalized <- update(
    fit_serial,
    chains = 2, cores = 2, threads = threading(2),
    backend = "cmdstanr",
    normalize = TRUE
)
