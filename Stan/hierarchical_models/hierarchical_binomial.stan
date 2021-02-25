data {
  int<lower=1> N;             // the number of observations
  int<lower=1> J;             // the number of groups
  int<lower=1> K;             // number of columns in the model matrix
  int<lower=1,upper=J> id[N]; // vector of group indeces
  matrix[N, K] X;             // the model matrix
  int<lower=0, upper=1> y[N]; // outcome vector
  //int<lower=0> successes[N];  // number of successes
  //int<lower=1> trials[N];     // number of trials
}
parameters {
  real alpha;                 // population-level intercept
  vector[K] beta;             // population-level regression coefficients
  vector[J] varying_alpha;    // group-level regression intercepts
  real<lower=0> sigma_alpha;  // standard error for the group-level regression intercepts
}
model {
  // priors
  alpha ~ student_t(3, 0, 1);
  beta ~ student_t(3, 0, 1);
  varying_alpha ~ normal(0, sigma_alpha);
  sigma_alpha ~ cauchy(0, 2.5);

  // likelihood
  y ~ bernoulli_logit(alpha + varying_alpha[id] + X * beta);
  // or
  //successes ~ binomial_logit(trials, alpha + varying_alpha[id] + X * beta);
}
