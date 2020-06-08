# Load rstan
library(rstan)

# Set seed
set.seed(13)

# Make data
stan_data <- list(y = rnorm(500, 0, 1),
                  N = 500)

# Define model
stan_code <- "
/*
  This model is just for testing.
*/
functions {
    real times_two(real x) { // Custom function test.
        return(x*2);
    }
}
data {
    int N; // Data length
    vector[N] y; // Data
}
transformed data {
    real a = 2.0; // Constant Test
}
parameters {
    real<lower = 0> sigma; // Constraint test; residual SD
    real mu; // Mean
}
transformed parameters {
    real mu_over_sigma = mu / sigma; // Transformed param test.
}
model {
    mu ~ normal(0, 1); // ~ syntax test.
    target += student_t_lpdf(sigma | 5, 0, 1); // Increment test.

    y ~ normal(mu, sigma); // Likelihood
}
generated quantities {
    real b = normal_rng(0, 1); // RNG test
    real c = times_two(a*b); // Custom Function test.
}
"

# Compile model
sm <- stan_model(model_code = stan_code)

# Run model on single core.
stanOut <- sampling(sm, data = stan_data, chains = 1, cores = 1, iter = 2000)
round(summary(stanOut)$summary, 5)

# Run model on multiple cores
stanOut <- sampling(sm, data = stan_data, chains = 4, cores = 4, iter = 2000)
round(summary(stanOut)$summary, 5)
