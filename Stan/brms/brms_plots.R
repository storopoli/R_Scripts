library(brms)

fit <- brm(
    bf(mpg ~ 1 + (1 | cyl) + hp + wt, decomp = "QR"),
    data = mtcars,
    family = gaussian
)

plot(fit) + bayesplot::theme_default()
plot(fit, combo = c("dens_overlay", "trace"))
mcmc_plot(fit)
mcmc_plot(fit, type = "hist")
mcmc_plot(fit, type = "neff")
mcmc_plot(fit, type = "rhat")
mcmc_plot(fit, type = "nuts_acceptance")
mcmc_plot(fit, type = "nuts_divergence")

plot(conditional_effects(fit))
plot(hypothesis(fit, "wt = 0"))
