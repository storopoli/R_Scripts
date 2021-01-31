library(brms)

fit <- brm(mpg ~ hp + vs,
    data = mtcars, sample_prior = TRUE, backend = "cmdstanr",
    prior = set_prior("normal(0, 10)", class = "b")
)

prior_summary(fit)

plot(hypothesis(fit, "vs = 0"))

prior <- get_prior(count ~ zAge + zBase * Trt + (1 | patient) + (1 | obs),
                    data = epilepsy, family = poisson())

fit2 <- brm(count ~ zAge + zBase * Trt + (1 | patient) + (1 | obs),
    data = epilepsy, family = poisson(),
    sample_prior = TRUE, backend = "cmdstanr"
)

plot(hypothesis(fit2, "Intercept = 0", class = NULL))
plot(hypothesis(fit2, "Intercept = 0", class = "sd", group = "obs"))

fit3 <- brm(count ~ (1 + zAge | patient),
    data = epilepsy, family = poisson(),
    sample_prior = TRUE, backend = "cmdstanr"
)

plot(hypothesis(fit3, "cor_patient__Intercept__zAge = 0", class = NULL))
