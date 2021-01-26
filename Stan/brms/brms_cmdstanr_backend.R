library(brms)
library(dplyr)
library(cmdstanr)
mtcars <- mtcars %>% mutate(gear = gear %>% factor)

#36s
system.time(brm(data=mtcars, formula=bf(mpg~gear, sigma ~ gear), cores = 4))
# 13s
system.time(brm(data=mtcars, formula=bf(mpg~gear, sigma ~ gear), cores = 4, backend="cmdstanr"))
