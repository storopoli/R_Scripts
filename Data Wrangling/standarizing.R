####################### STANDARDZING VALUES IF NUMERIC ####################
library(dplyr)

dataset %>%
  mutate_if(is.numeric, scale)