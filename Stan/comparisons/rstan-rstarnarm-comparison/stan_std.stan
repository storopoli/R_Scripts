data {
  int<lower=0> N;   // number of data items
  int<lower=0> K;   // number of predictors
  matrix[N, K] X;   // predictor matrix
  vector[N] y;      // outcome vector
}
transformed data {
  matrix[N, K] X_std;
  vector[N] y_std;
  X_std = (X - mean(X)) / sd(X);
  y_std = (y - mean(y)) / sd(y);
}
parameters {
  real alpha_std;           // intercept
  vector[K] theta_std;      // coefficients standardized
  real<lower=0> sigma_std;  // error scale
}
model {
  y ~ normal(X * theta_std + alpha_std, sigma_std);  // likelihood
}
generated quantities {
  vector[N] log_lik;
  for (n in 1:N) {
    log_lik[n] = normal_lpdf(y[n] | X[n] * theta_std + alpha_std, sigma_std);
  } 
}
