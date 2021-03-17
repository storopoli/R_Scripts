# sudo apt install opencl-dev
# It seems that `g++` 9.3.0 does not like something about our OpenCL backend
# in 2.26.1.
# cmdstan_make_local(cpp_options = "CXXFLAGS += -fpermissive")
# rebuild_cmdstan(cores = 4)

library(cmdstanr)

mpg <- ggplot2::mpg

dat <- list(
    N = nrow(mpg),
    J = length(unique(mpg$class)),
    K = 2,
    id = as.numeric(as.factor(mpg$class)),
    X = cbind(mpg$displ, mpg$year),
    y = mpg$hwy
)

# 2.2s Dell / M1
# Non-Centered Parameterization Standardized Predictors (QR) Hierarchical model
standard_ncp <- cmdstan_model(here::here("Stan", "hierarchical_models", "ncp_standard.stan"))
standard_ncp_fit <- standard_ncp$sample(data = dat)
print(standard_ncp_fit$summary(), n = 22)

# 586s RTX 2060
# Non-Centered Parameterization Standardized Predictors (QR) Hierarchical model
standard_ncp_cl <- cmdstan_model(here::here("Stan", "hierarchical_models", "ncp_standard.stan"),
    cpp_options = list(stan_opencl = TRUE)
)
standard_ncp_cl_fit <- standard_ncp_cl$sample(data = dat, chains = 4, parallel_chains = 4)
print(standard_ncp_fit$summary(), n = 22)
