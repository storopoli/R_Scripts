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
# > 3.2 GB

bench::mark(
  filter_dplyr = df %>% filter(var_1 < 0),
  mutate_dplyr = df %>% mutate(var_1 = var_1 * 2, var_2 = var_2^2, var_3 = exp(var_3)),
  summarize_dplyr = df %>% group_by(group) %>% summarize(mean_var_1 = mean(var_1), mean_var_2 = mean(var_2), mean_var_3 = mean(var_3)),
  filter_dtplyr = df %>% lazy_dt() %>% filter(var_1 < 0) %>% as_tibble(),
  mutate_dtplyr = df %>% lazy_dt() %>% mutate(var_1 = var_1 * 2, var_2 = var_2^2, var_3 = exp(var_3)) %>% as_tibble(),
  summarize_dtplyr = df %>% lazy_dt() %>% group_by(group) %>% summarize(mean_var_1 = mean(var_1), mean_var_2 = mean(var_2), mean_var_3 = mean(var_3)) %>% as_tibble(),
  check = F
)

# Mac Mini
# # A tibble: 6 x 13
#   expression            min   median `itr/sec` mem_alloc `gc/sec` n_itr  n_gc total_time result memory                   time         gc
#   <bch:expr>       <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl> <int> <dbl>   <bch:tm> <list> <list>                   <list>       <list>
# 1 filter_dplyr        1.48s    1.48s     0.677    3.17GB    0.677     1     1      1.48s <NULL> <Rprofmem[,3] [579 × 3]> <bch:tm [1]> <tibble [1 × 3]>
# 2 mutate_dplyr        1.56s    1.56s     0.639    2.24GB    0.639     1     1      1.56s <NULL> <Rprofmem[,3] [507 × 3]> <bch:tm [1]> <tibble [1 × 3]>
# 3 summarize_dplyr     4.77s    4.77s     0.210    3.85GB    0.210     1     1      4.77s <NULL> <Rprofmem[,3] [839 × 3]> <bch:tm [1]> <tibble [1 × 3]>
# 4 filter_dtplyr        4.6s     4.6s     0.218    5.41GB    0.435     1     2       4.6s <NULL> <Rprofmem[,3] [990 × 3]> <bch:tm [1]> <tibble [1 × 3]>
# 5 mutate_dtplyr       5.75s    5.75s     0.174     8.2GB    0.348     1     2      5.75s <NULL> <Rprofmem[,3] [147 × 3]> <bch:tm [1]> <tibble [1 × 3]>
# 6 summarize_dtplyr    4.34s    4.34s     0.230    6.11GB    0.230     1     1      4.34s <NULL> <Rprofmem[,3] [160 × 3]> <bch:tm [1]> <tibble [1 × 3]>

library(multidplyr)
cluster <- new_cluster(6)
cluster_library(cluster, "dplyr")

bench::mark(
  filter_multidplyr = df %>% partition(cluster) %>% filter(var_1 < 0) %>% collect(),
  mutate_multidplyr = df %>% partition(cluster) %>% mutate(var_1 = var_1 * 2, var_2 = var_2^2, var_3 = exp(var_3)) %>% collect(),
  summarize_multidplyr = df %>% group_by(group) %>% partition(cluster) %>% summarize(mean_var_1 = mean(var_1), mean_var_2 = mean(var_2), mean_var_3 = mean(var_3)) %>% collect(),
  check = F
)

# # A tibble: 3 x 13
#   expression                min   median `itr/sec` mem_alloc `gc/sec` n_itr  n_gc total_time result memory                  time         gc
#   <bch:expr>           <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl> <int> <dbl>   <bch:tm> <list> <list>                  <list>       <list>
# 1 filter_multidplyr       2.18s    2.18s     0.459    3.17GB    0.459     1     1      2.18s <NULL> <Rprofmem[,3] [14 × 3]> <bch:tm [1]> <tibble [1 × 3]>
# 2 mutate_multidplyr       1.39s    1.39s     0.718    2.23GB    0         1     0      1.39s <NULL> <Rprofmem[,3] [7 × 3]>  <bch:tm [1]> <tibble [1 × 3]>
# 3 summarize_multidplyr    3.33s    3.33s     0.300    3.85GB    0.300     1     1      3.33s <NULL> <Rprofmem[,3] [30 × 3]> <bch:tm [1]> <tibble [1 × 3]>


### Julia ### v. 1.5.3
# using BenchmarkTools, DataFrames, Distributions


# n = 10^8

# df = DataFrame(
#   group = sample(["A", "B", "C", "D", "E"], n),
#   var_1 = rand(Normal(),n),
#   var_2 = rand(TDist(1), n,
#   var_3 = runif(n)
# )

# Base.summarysize(df) / 1e9
# # 3.2GB

# @benchmark filter(:var_1 => <(0), df) # 868 ms
# @benchmark transform(df, :var_1 => x -> x.*2, :var_2 => x -> x.^2, :var_3 => x -> exp.(x)) # 3.593 s
# @benchmark combine(groupby(df, :group), :var_1 => mean, :var_2 => mean, :var_3 => mean) # 2.753 s
