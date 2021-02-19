# Setup
library(rstan)
library(Rcpp)
source(here::here("Benchmarks", "metropolis", "metropolis.R"))
expose_stan_functions(here::here("Benchmarks", "metropolis", "metropolis.stan"))
sourceCpp(here::here("Benchmarks", "metropolis", "metropolis_rcpp.cpp"))

n_sim <- 1e4
rho <- 0.8
width <- 2.75

# Eigen C++ is 583ms +/- 16ms
# Stan is 3.6ms
# Rcpp is 20ms
# R is 1.35s
# Julia is 6.3ms
# Julia is RELATIVE than R and RELATIVE than Stan
bench::mark(
  metropolis(n_sim, width, rho = rho),
  metropolis_rng(n_sim, width, 0, 0, 1, 1, 0.8),
  metropolis_rcpp(n_sim, width, 0, 0, 1, 1, 0.8),
  check = FALSE
)
