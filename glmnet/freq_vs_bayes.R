library(glmnet)
library(glmnetUtils)
library(brms)
library(broom)
library(tidyverse)
set.seed(123)

freq_model <- lm(mpg ~ hp + wt + cyl + vs + disp, data = mtcars)

# best lambda = 0.38
cvfit <- cv.glmnet(mpg ~ hp + wt + cyl + vs + disp, data = mtcars)
glmnet_model <- glmnet(mpg ~ hp + wt + cyl + vs + disp, data = mtcars, lambda = 0.38)


bayes_model <- brm(mpg ~ hp + wt + cyl + vs + disp, data = mtcars)
bayes_reg_model <- brm(mpg ~ hp + wt + cyl + vs + disp, data = mtcars, prior = prior(horseshoe(df = 1)))

freq_models <- list(freq_model, glmnet_model)
bayes_models <- list(bayes_model, bayes_reg_model)

all_models <- freq_models %>% map_dfr( ~ {
  tidy(.x) %>% select(term, estimate) %>% filter(term != "(Intercept)")
}) %>%
  mutate(model = c(rep("linear_reg", 5), rep("regularized_reg", 3))) %>% 
  bind_rows(
    bayes_models %>% map_dfr(~ {
      as_tibble(summary(.x)$fixed) %>%
        mutate(rownames = str_remove(names(.x$fit)[1:6], "b_")) %>%
        select(term = rownames,
               estimate = Estimate) %>%
        filter(term != "Intercept")}) %>%
      mutate(model = c(rep("bayes_linear_reg", 5), rep("bayes_regularized_reg", 5))))

all_models %>% 
  mutate(reg = if_else(str_detect(model, "regularized"), "regularized", "normal"),
         paradigm = if_else(str_detect(model, "bayes"), "bayesian", "frequentist")) %>% 
  ggplot(aes(term, estimate, fill = reg)) +
  geom_col(position = "dodge2") +
  facet_wrap(~paradigm)

