data {
  int<lower=1> N; //the number of observations
  int<lower=1> J; //the number of groups
  int<lower=1> K; //number of columns in the model matrix
  int<lower=1,upper=J> id[N]; //vector of group indeces
  matrix[N,K] X; //the model matrix
  vector[N] y; //the response variable
}
parameters {
  real alpha; //population-level intercept
  vector[K] beta; //population-level regression coefficients
  vector[J] varying_alpha; //group-level regression intercepts
  real<lower=0> sigma; //model residual error
  real<lower=0> sigma_alpha; //standard error for the group-level regression intercepts
}
model {
  //priors
  alpha ~ normal(mean(y), 2.5 * sd(y));
  beta ~ student_t(3,0,1);
  varying_alpha ~ normal(0, sigma_alpha);
  sigma ~ exponential(1/sd(y));
  sigma_alpha ~ exponential(0.1);
  
  //likelihood
  y ~ normal(alpha + varying_alpha[id] + X * beta, sigma);
}
