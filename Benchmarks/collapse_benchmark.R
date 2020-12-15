library(dplyr)
library(collapse)
library(microbenchmark)

n <- 10^8

df <- data.frame(
  group = sample(letters[1:5], n, replace = T),
  var_1 = rnorm(n),
  var_2 = rt(n, df = 1),
  var_3 = runif(n)
)

df <- as_tibble(df)

pryr::object_size(df)
#> 3.2 GB

microbenchmark(
  filter_dplyr = df %>% filter(var_1 < 0),
  mutate_dplyr = df %>% mutate(var_1 = var_1 * 2, var_2 = var_2 ^ 2, var_3 = exp(var_3)),
  summarize_dplyr = df %>% group_by(group) %>% summarize_all(mean),
  filter_collapse = df %>% fsubset(var_1 < 0),
  mutate_collapse = df %>% ftransform(var_1 = var_1 * 2, var_2 = var_2 ^ 2, var_3 = exp(var_3)),
  summarize_collapse = df %>% fgroup_by(group) %>% fmean(),
  times = 10
)
