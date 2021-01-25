data {
  int<lower=1> N; //the number of observations
  int<lower=1> J; //the number of groups
  int<lower=1> K; //number of columns in the model matrix
  int<lower=1,upper=J> id[N]; //vector of group indeces
  matrix[N,K] X; //the model matrix
  vector[N] y; //the response variable
}
transformed data {
  matrix[N, K] Q_ast;
  matrix[K, K] R_ast;
  matrix[K, K] R_ast_inverse;
  
  // thin and scale the QR decomposition
  Q_ast = qr_thin_Q(X) * sqrt(N - 1);
  R_ast = qr_thin_R(X) / sqrt(N - 1);
  R_ast_inverse = inverse(R_ast);
}
parameters {
  real alpha; // population-level intercept
  vector[K] theta; // coefficients on Q_ast
  vector[J] varying_alpha; //group-level regression intercepts
  real<lower=0> sigma; //residual error
}
model {
  //priors
  alpha ~ normal(mean(y), 2.5 * sd(y)); // prior population-level intercept
  theta ~ student_t(3,0,1); //weakly informative priors on the regression coefficients
  varying_alpha ~ normal(0, 10); //weakly informative prior on the group-level intercepts
  sigma ~ exponential(1/sd(y)); //weakly informative priors
  
  //likelihood
  y ~ normal(alpha + varying_alpha[id] + Q_ast * theta, sigma);
}
generated quantities {
  vector[K] beta; //reconstructed population-level regression coefficients
  beta = R_ast_inverse * theta; // coefficients on X
}