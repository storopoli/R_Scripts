data {
   int N;
   int failures[N];
   int o_rings; // 6 orings
   vector[N] temp;
}
parameters {
   real alpha;
   real beta;
}
model {
   alpha ~ student_t(3, 0, 1);
   beta ~ student_t(3, 0, 1);
   for (n in 1:N) {
       failures[n] ~ binomial_logit(o_rings, alpha + temp[n] * beta);
   }
}
generated quantities {
   vector[N] log_lik;
   for (n in 1:N) {
    log_lik[n] = binomial_logit_lpmf(failures[n] | o_rings, alpha + temp * beta);
  }
   real y_rep[N] = bernoulli_logit_rng(alpha + temp * beta);
}
