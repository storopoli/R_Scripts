#https://avehtari.github.io/modelselection/collinear.html
library(brms)
library(rstanarm)
library(dplyr)
library(projpred)
library(loo)
library(bayesplot)

model <- lm(mpg ~ ., data = mtcars)

car::vif(model)

summary(model)

bmodel1 <- brm(bf(mpg ~ .), data = mtcars)
summary(bmodel1)

bmodel2 <- brm(bf(mpg ~ ., decomp = "QR"), data = mtcars)
summary(bmodel2)

bmodel3 <- brm(bf(mpg ~ ., decomp = "QR"),
    data = mtcars,
    prior = set_prior("horseshoe(df = 3, par_ratio = 0.1)")
)

summary(bmodel3)

bmodel4 <- stan_lm(mpg ~ ., data = mtcars, prior = R2(0.8))

summary(bmodel4)

loo_b1 <- loo(bmodel1)
loo_b2 <- loo(bmodel2)
loo_b3 <- loo(bmodel3)
loo_b4 <- rstanarm::loo(bmodel4)


loo_compare(
    loo_b1,
    loo_b2,
    loo_b3,
    loo_b4
)

broom::tidy(model, conf.int = TRUE) %>%
    mutate(term = case_when(
        term == "(Intercept)" ~ "Intercept",
        TRUE ~ term
    )) %>%
    select(term, estimate, conf.low, conf.high) %>%
    left_join(broom.mixed::tidyMCMC(bmodel3, conf.int = TRUE) %>%
        filter(!(term %in% c("b_Intercept", "sigma"))) %>%
        mutate(term = stringr::str_remove(term, "b_")) %>%
        select(term, estimate, conf.low, conf.high) %>%
        rename_with(~ stringr::str_glue("bayes_{ . }")),
    by = c("term" = "bayes_term")
    )

mcmc_areas(as.matrix(bmodel3),
    prob_outer = .99,
    regex_pars = "^b_.*"
)

fit_cv <- cv_varsel(bmodel3, method = "forward", cv_method = "LOO")

plot(fit_cv, stats = c("elpd", "rmse"))

nv <- suggest_size(fit_cv, alpha = 0.1)

proj <- project(fit_cv, nv = nv, ndraws = 4000)
round(colMeans(as.matrix(proj)), 1)


mcmc_areas(as.matrix(proj))
vars_cv <- fit_cv$solution_terms[1:2]

bmodel5 <- update(bmodel3, formula. = ~  cyl + wt)
loo_b5 <- loo(bmodel5)
loo_compare(
    loo_b3,
    loo_b5
)
