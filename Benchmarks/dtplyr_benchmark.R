library(dplyr)
library(dtplyr)

n <- 10^8

df <- data.frame(
  group = sample(letters[1:5], n, replace = T),
  var_1 = rnorm(n),
  var_2 = rt(n, df = 1),
  var_3 = runif(n)
)

pryr::object_size(df)
#> 3.2 GB

bench::mark(
  filter_dplyr = df %>% filter(var_1 < 0),
  mutate_dplyr = df %>% mutate(var_1 = var_1 * 2, var_2 = var_2 ^ 2, var_3 = exp(var_3)),
  summarize_dplyr = df %>% group_by(group) %>% summarize(mean_var_1 = mean(var_1), mean_var_2 = mean(var_2), mean_var_3 = mean(var_3)),
  filter_dtplyr = df %>% lazy_dt() %>% filter(var_1 < 0) %>% as_tibble(),
  mutate_dtplyr = df %>% lazy_dt() %>% mutate(var_1 = var_1 * 2, var_2 = var_2 ^ 2, var_3 = exp(var_3)) %>% as_tibble(),
  summarize_dtplyr = df %>% lazy_dt() %>% group_by(group) %>% summarize(mean_var_1 = mean(var_1), mean_var_2 = mean(var_2), mean_var_3 = mean(var_3)) %>% as_tibble(),
  check = F
)
