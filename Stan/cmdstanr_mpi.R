# Conclusions 09/02
# So MPI is nice but it is the same performance as cmdstan vanilla
# Also the Adapted Warmup works in vanilla cmdstan and is set to default TRUE

library(cmdstanr)

schools_dat <- list(J = 8,
                    y = c(28,  8, -3,  7, -1,  1, 18, 12),
                    sigma = c(15, 10, 16, 11,  9, 11, 10, 18))

mpi_options <- list(STAN_MPI = TRUE, CXX = "mpicxx", TBB_CXX_TYPE = "clang", MPI_ADAPTED_WARMUP = 1)

model <- cmdstan_model(here::here("Stan", "8_schools.stan"), quiet = FALSE)
model$sample(data = schools_dat, chains = 4, adapt_engaged = TRUE)
# Total execution time: 0.1 seconds.

model_mpi <- cmdstan_model(here::here("Stan", "8_schools.stan"), quiet = FALSE, cpp_options = mpi_options)
model_mpi$sample_mpi(data = schools_dat, chains = 4, mpi_args = list("n" = 4))
# Total execution time: 1.3 seconds.
