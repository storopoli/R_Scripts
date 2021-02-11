library(brms)
library(dplyr)
library(cmdstanr)
mtcars <- mtcars %>% mutate(gear = gear %>% factor)

# 30.4s (0.4s)
system.time(brm(
    data = mtcars, formula = bf(mpg ~ gear, sigma ~ gear), cores = 4, backend = "rstan"
))

# 8.71s (0.2s)
system.time(brm(
    data = mtcars, formula = bf(mpg ~ gear, sigma ~ gear), cores = 4, backend = "cmdstanr"
))

# 7.9s (0.2s)
system.time(brm(
    data = mtcars, formula = bf(mpg ~ gear, sigma ~ gear), cores = 4, backend = "cmdstanr", normalize = FALSE
))
