data {
  int<lower=1> N; //the number of observations
  int<lower=1> J; //the number of groups
  int<lower=1> K; //number of columns in the model matrix
  int<lower=1,upper=J> id[N]; //vector of group indeces
  matrix[N,K] X; //the model matrix
  vector[N] y; //the response variable
}
parameters {
  vector[K] beta; //population-level regression coefficients
  vector[J] varying_a; //group-level regression intercepts
  real<lower=0> sigma; //residual error
  real<lower=0> sigma_a; //hierarchical intercept residual error
}
model {
  //priors
  beta ~ normal(0,5); //weakly informative priors on the regression coefficients
  varying_a ~ normal(0, sigma_a); //prior on the group-level intercepts
  sigma_a ~ normal(0, 20); // hierarchical prior on intercepts
  sigma ~ gamma(2,0.1); //weakly informative priors, see section 6.9 in STAN user guide
  
  //likelihood
  y ~ normal(varying_a[id] + X * beta, sigma);
}
