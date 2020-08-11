library(RcppSimdJson)

json_file <- fload("data.json")

df <- as.data.frame(json_file)
