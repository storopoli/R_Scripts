library(Rcpp)
sourceCpp(sourceCpp(here::here("Benchmarks", "mandelbrot", "mandelbrot.cpp")))

mandelbrot <- function(c, iterate_max = 500) {
    z <- 0i
    for (i in 1:iterate_max) {
        z <- z ^ 2 + c
        if (abs(z) > 2.0) {
            return(i)
        }
    }
    iterate_max
}

mandelbrotImage <- function(xs, ys, iterate_max = 500) {
    sapply(ys, function(y) sapply(xs, function(x) mandelbrot(x + y * 1i, iterate_max = iterate_max))) / iterate_max
}

iterate_max <- 1000L
center_x <- 0.37522 #0.3750001200618655
center_y <- -0.22 #-0.2166393884377127
step <- 0.000002
size <- 125
xs <- seq(-step * size, step * size, step) + center_x
ys <- seq(-step * size, step * size, step) + center_y

# Julia
# first run 0.16s
# second run 0.13s

# 10.13s
system.time(zR <- mandelbrotImage(xs, ys, iterate_max))

# 0.03s
system.time(zCpp <- mandelRcpp(
    center_x - step, center_x + step,
    center_y - step, center_y + step,
    251, 251,
    iterate_max
))

# 0.03s
system.time(zCppEigen <- mandelRcppEigen(
    center_x - step, center_x + step,
    center_y - step, center_y + step,
    251, 251,
    iterate_max
))
