library(broom)
lm(stars ~ brand + country + style, ramen_ratings_processed) %>%
  tidy(conf.int = TRUE) %>%
  filter(term != "(Intercept)") %>%
  arrange(desc(estimate)) %>%
  extract(term, c("category", "term"), "^([a-z]+)([A-Z].*)") %>%
  mutate(term = fct_reorder(term, estimate)) %>%
  ggplot(aes(estimate, term, color = category)) +
  geom_point() +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high)) +
  geom_vline(lty = 2, xintercept = 0) +
  facet_wrap(~ category, ncol = 1, scales = "free_y") +
  theme(legend.position = "none") +
  labs(x = "Estimated effect on ramen rating",
       y = "",
       title = "Coefficients that predict ramen ratings",
       subtitle = "Less common brands and countries were lumped together as the reference level")
