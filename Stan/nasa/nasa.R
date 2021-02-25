# http://sherrytowers.com/2018/03/07/logistic-binomial-regression/
library(cmdstanr)
library(posterior)
library(rstanarm)
library(dplyr)
library(ggplot2)
library(latex2exp)
df <- vroom::vroom("http://www.sherrytowers.com/oring.csv", skip = 1)

dat <- list(
    N = nrow(df),
    o_rings = 6,
    failures = df$num_failure,
    temp = df$temp
)

model <- cmdstan_model(here::here("Stan", "nasa", "model.stan"))

fit <- model$sample(data = dat)
summ <- fit$summary(NULL, c("mean", "sd"))

fit_rstanarm <- stan_glm(cbind(num_failure, 6 - num_failure) ~ temp, family = "binomial", data = df)

logit2prob <- function(logit) {
    odds <- exp(logit)
    prob <- odds / (1 + odds)
    return(prob)
}

alpha <- summ %>%
    filter(variable == "alpha") %>%
    pull(mean)
alpha_sd <- summ %>%
    filter(variable == "alpha") %>%
    pull(sd)
beta <- summ %>%
    filter(variable == "beta") %>%
    pull(mean)
beta_sd <- summ %>%
    filter(variable == "beta") %>%
    pull(sd)

df_plot <- tibble(
    temp = seq(20, 80, by = 0.01),
    estimates = logit2prob(alpha + beta * temp) * 6,
    estimates_lower = logit2prob((alpha - alpha_sd) + (beta - beta_sd) * temp) * 6,
    estimates_upper = logit2prob((alpha + alpha_sd) + (beta + beta_sd) * temp) * 6
)
df_plot %>%
    ggplot(aes(temp, estimates)) +
    geom_line(aes(color = "Mean Estimate"), size = 1.5) +
    geom_ribbon(
        aes(
            temp,
            ymin = estimates_lower,
            ymax = estimates_upper,
            fill = "Estimates +/- 1 SD"
        ),
        alpha = 0.2
    ) +
    geom_point(
        data = df,
        aes(temp, num_failure, color = "Observed"),
        size = 1.5
    ) +
    ylim(0, 6) +
    labs(
        title = "Nasa Challengeder Disaster",
        x = "Temperature",
        y = "O-rings Failures",
        color = "Estimates vs Observed",
        fill = NULL
    ) +
    scale_y_continuous(breaks = c(1:6)) +
    scale_x_continuous(labels = scales::label_number(suffix = "\u00b0 F")) +
    scale_color_brewer(palette = "Set1") +
    scale_fill_brewer(palette = "Set1") +
    theme_bw() +
    theme(
        legend.position = "bottom",
        legend.direction = "vertical",
        legend.box = "horizontal"
    )
