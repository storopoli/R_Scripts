data {
  int<lower=1> N; //the number of observations
  int<lower=1> J; //the number of groups
  int<lower=1> K; //number of columns in the model matrix
  int<lower=1,upper=J> id[N]; //vector of group indeces
  matrix[N,K] X; //the model matrix
  vector[N] y; //the response variable
}
parameters {
  real alpha; // population-level intercept
  vector[K] beta; //population-level regression coefficients
  vector[J] varying_alpha; //group-level regression intercepts
  real<lower=0> sigma; //residual error
}
model {
  //priors
  alpha ~ normal(mean(y), 2.5 * sd(y)); // prior population-level intercept
  beta ~ student_t(3,0,1); //weakly informative priors on the regression coefficients
  varying_alpha ~ normal(0, 10); //weakly informative prior on the group-level intercepts
  sigma ~ exponential(1/sd(y)); //weakly informative priors
  
  //likelihood
  y ~ normal(alpha + varying_alpha[id] + X * beta, sigma);
}
