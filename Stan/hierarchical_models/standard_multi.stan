data {
  int<lower=1> N;               // the number of observations
  int<lower=1> K;               // number of columns in the model matrix
  int<lower=1> J;               // the number of groups
  int<lower=1> L;               // num group predictors
  int<lower=1,upper=J> jj[N];   // vector of group indeces
  matrix[N, K] X;               // the model matrix
  matrix[L, J] u;               // group predictors transposed
  vector[N] y;                  // the response variable
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
  real alpha;                                // Population-level Intercept
  matrix[K, J] z;                            // Non-centered Correlation Matrix
  cholesky_factor_corr[K] L_Omega;           // Correlation Sigma = LL^T
  vector<lower=0,upper=pi()/2>[K] tau_unif;  // Non-centered scale implies tau_unif ~ uniform(0,pi()/2)
  matrix[K, L] gamma;                        // group coeffs
  real<lower=0> sigma;                       // error SD
}
transformed parameters {
  // computing the group-level error SD, based on non-centered parameterization
  vector<lower=0>[K] tau = 2.5 * tan(tau_unif);
  // computing the group-level coefficient, based on non-centered parameterization
  matrix[K, J] theta = gamma * u + diag_pre_multiply(tau, L_Omega) * z;
}
model {
  // priors
  alpha ~ normal(mean(y), 2.5 * sd(y));
  to_vector(z) ~ std_normal();         // Z ~ N(0, 1)
  L_Omega ~ lkj_corr_cholesky(2);      // Correlation Sigma = LL^T
  to_vector(gamma) ~ normal(0, 5);     // Priors on Group Coeffs

  // likelihood
  vector[N] mu;
  for(n in 1:N) {
    mu[n] = X[n, ] * theta[, jj[n]];
  }
  y ~ normal(mu, sigma);
}
generated quantities {
  matrix[K, J] beta; //reconstructed population-level regression coefficients
  beta = R_ast_inverse * theta; // coefficients on X
}
