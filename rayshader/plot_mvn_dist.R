library(rayshader)
library(ggplot2)
library(mnormt)
library(MASS)
library(hexbin)

set.seed(123)

mus <- c(0, 0)
sigmas <- c(1, 1)
r <- 0.8
Sigma <- diag(sigmas)
Sigma[1, 2] <- r
Sigma[2, 1] <- r

# Vanilla Solution
dft <- data.frame(mvrnorm(1e5, mus, Sigma))
gg <- ggplot(dft, aes(X1, X2)) +
    stat_density_2d(
        aes(fill = stat(nlevel)),
        geom = "polygon", n = 100, bins = 10, contour = TRUE,
        show.legend = FALSE
    )
plot_gg(gg, triangulate = TRUE, width = 3, height = 3, scale = 250)

# hexbin Solution
gg <- ggplot(dft, aes(X1, X2)) +
    stat_binhex(show.legend = FALSE)
plot_gg(gg, triangulate = TRUE, width = 3, height = 3, scale = 250)
