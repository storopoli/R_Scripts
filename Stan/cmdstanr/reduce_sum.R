# https://mc-stan.org/users/documentation/case-studies/reduce_sum_tutorial.html
library(cmdstanr)

d <- read.csv("https://github.com/bbbales2/cmdstan_map_rect_tutorial/blob/reduce_sum/RedcardData.csv?raw=TRUE")

d2 <- d[!is.na(d$rater1), ]

redcard_data <- list(n_redcards = d2$redCards, n_games = d2$games, rating = d2$rater1)
redcard_data$N <- nrow(d2)

vanilla <- cmdstan_model(here::here("Stan", "cmdstanr", "logistic_vanilla.stan"))

# 74.4s
fit <- vanilla$sample(redcard_data,
    chains = 4,
    parallel_chains = 4,
    refresh = 1000
)

redcard_data$grainsize <- 1

reduce_sum <- cmdstan_model(here::here("Stan", "cmdstanr", "logistic_reduce_sum.stan"),
    cpp_options = list(stan_threads = TRUE)
)

# 43.7s
fit <- reduce_sum$sample(redcard_data,
    chains = 4,
    parallel_chains = 4,
    threads_per_chain = 2,
    refresh = 1000
)
