library(benchmarkme)


# Standard Benchmarks -----------------------------------------------------
benchmark_std(runs = 1)
benchmark_std(runs = 1, cores = 1)


# I/O Benchmarks ----------------------------------------------------------
benchmark_io(runs = 1)
benchmark_io(runs = 1, cores = 1)
