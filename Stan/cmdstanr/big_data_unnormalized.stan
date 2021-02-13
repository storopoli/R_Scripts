// generated with brms 2.14.4
functions {
}
data {
  int<lower=1> N;  // total number of observations
  vector[N] Y;  // response variable
  int<lower=1> K;  // number of population-level effects
  matrix[N, K] X;  // population-level design matrix
  int prior_only;  // should the likelihood be ignored?
}
transformed data {
  int Kc = K - 1;
  matrix[N, Kc] Xc;  // centered version of X without an intercept
  vector[Kc] means_X;  // column means of X before centering
  // matrices for QR decomposition
  matrix[N, Kc] XQ;
  matrix[Kc, Kc] XR;
  matrix[Kc, Kc] XR_inv;
  for (i in 2:K) {
    means_X[i - 1] = mean(X[, i]);
    Xc[, i - 1] = X[, i] - means_X[i - 1];
  }
  // compute and scale QR decomposition
  XQ = qr_thin_Q(Xc) * sqrt(N - 1);
  XR = qr_thin_R(Xc) / sqrt(N - 1);
  XR_inv = inverse(XR);
}
parameters {
  vector[Kc] bQ;  // regression coefficients at QR scale
  real Intercept;  // temporary intercept for centered predictors
  real<lower=0> sigma;  // residual SD
}
transformed parameters {
}
model {
  // likelihood including all constants
  if (!prior_only) {
    target += normal_id_glm_lupdf(Y | XQ, Intercept, bQ, sigma);
  }
  // priors including all constants
  target += student_t_lupdf(Intercept | 3, -44.9, 74.1);
  target += student_t_lupdf(sigma | 3, 0, 74.1);
}
generated quantities {
  // obtain the actual coefficients
  vector[Kc] b = XR_inv * bQ;
  // actual population-level intercept
  real b_Intercept = Intercept - dot_product(means_X, b);
}
