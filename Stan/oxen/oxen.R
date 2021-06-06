# Example taken from
# https://elevanth.org/blog/2018/01/29/algebra-and-missingness/
library(cmdstanr)
library(here)

set.seed(1)

N_children <- 51
s <- rbinom( N_children , size=1 , prob=0.75 )
s_obs <- s
s_obs[sample(1:N_children, size = 21)] <- -1
tea <- rbinom(N_children, size = 1, prob = s * 1 + (1 - s) * 0.5)

data_list <- list(
  N_children = N_children,
  tea = tea,
  s = s_obs)

model <- cmdstan_model(here("Stan", "oxen", "oxen.stan"))
fit <- model$sample(data = data_list)
fit$summary()
# A tibble: 55 x 10
#    variable       mean  median     sd    mad       q5     q95  rhat ess_bulk ess_tail
#    <chr>         <dbl>   <dbl>  <dbl>  <dbl>    <dbl>   <dbl> <dbl>    <dbl>    <dbl>
#  1 lp__        -40.2   -39.9   1.17   0.969  -42.5    -38.9    1.00    1183.    1466.
#  2 p_cheat       0.524   0.525 0.126  0.135    0.315    0.724  1.00    1720.    1794.
#  3 p_drink       0.940   0.947 0.0386 0.0361   0.867    0.988  1.00    1187.    1439.
#  4 sigma         0.706   0.711 0.0742 0.0757   0.576    0.820  1.00    1458.    1383.
