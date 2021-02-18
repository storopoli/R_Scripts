metropolis <- function(S, width,
                       mu_X = 0, mu_Y = 0,
                       sigma_X = 1, sigma_Y = 1,
                       rho,
                       seed = 123) {
   set.seed(seed)
   Sigma <- diag(2)
   Sigma[1, 2] <- rho
   Sigma[2, 1] <- rho
   draws <- matrix(nrow = S, ncol = 2)
   x <- rnorm(1)
   y <- rnorm(1)
   accepted <- 0
   for (s in 1:S) {
      x_ <- runif(1, x - width, x + width)
      y_ <- runif(1, y - width, y + width)
      r <- exp(mnormt::dmnorm(c(x_, y_), mean = c(mu_X, mu_Y), varcov = Sigma, log = TRUE) -
                        mnormt::dmnorm(c(x, y), mean = c(mu_X, mu_Y), varcov = Sigma, log = TRUE))
      if (r > runif(1, 0, 1)) {
        x <- x_
        y <- y_
        accepted <- accepted + 1
      }
      draws[s, 1] <- x
      draws[s, 2] <- y
   }
   print(paste0("Acceptance rate is ", accepted / S))
   return(draws)
}
