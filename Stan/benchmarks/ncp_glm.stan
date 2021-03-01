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
  //vector[J] varying_alpha; // group-level regression intercepts
  vector[J] z_j; // non centered group-level regression intercepts
  real<lower=0> sigma; // model residual error
  real<lower=0> sigma_alpha; //standard error for the group-level regression intercepts
}
model {
  //priors
  alpha ~ normal(mean(y), 2.5 * sd(y));
  theta ~ student_t(3, 0, 1);
  //varying_alpha ~ normal(0, sigma_alpha);
  z_j ~ normal(0, 1);
  sigma ~ exponential(1 / sd(y));
  sigma_alpha ~ cauchy(0, 2.5);

  //likelihood
  y ~ normal_id_glm(Q_ast, alpha + z_j[id] * sigma_alpha, theta, sigma);
}
generated quantities {
  vector[K] beta; // reconstructed population-level regression coefficients
  beta = R_ast_inverse * theta; // coefficients on X
  vector[J] varying_alpha; // reconstructed group-level regression intercepts
  varying_alpha = z_j * sigma_alpha; // varying intercepts
  real y_rep[N] = normal_rng(alpha + z_j[id] * sigma_alpha + X * beta, sigma);
}
