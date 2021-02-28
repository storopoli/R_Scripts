library(brms)
library(tidybayes)
library(magrittr)

fit <- brm(
    bf(mpg ~ 1 + (1 | cyl) + hp + wt, decomp = "QR"),
    data = mtcars,
    family = gaussian
)

# using {brms} implicit call to {bayesplot}
plot(fit) + bayesplot::theme_default()
plot(fit, combo = c("dens_overlay", "trace"))
mcmc_plot(fit)
mcmc_plot(fit, type = "hist")
mcmc_plot(fit, type = "neff")
mcmc_plot(fit, type = "rhat")
mcmc_plot(fit, type = "nuts_acceptance")
mcmc_plot(fit, type = "nuts_divergence")

# unsing {brms}
plot(conditional_effects(fit))
plot(hypothesis(fit, "wt = 0"))
