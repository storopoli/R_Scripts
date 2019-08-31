library(stm)
library(quanteda)
library(tidyr)
library(dplyr)
library(ggplot2)
library(tidytext)

# convert quanteda dfm to stm dtm
dtm_stm <- convert(dfm, to = "stm")

# how many K?
how_many_k <- searchK(dtm_stm$documents,
                      vocab = dtm_stm$vocab,
                      K = c(2:20),
                      init.type = "Spectral",
                      cores = 4)
plot(how_many_k)


# train the topic model with K models
topic_model <- stm(dtm_stm$documents,
                   vocab = dtm_stm$vocab,
                   data = dtm_stm$meta,
                   K = 6,
                   prevalence =~ PY ,
                   verbose = TRUE, 
                   init.type = "Spectral")

# Topic Correlation
mod.out.corr <- topicCorr(topic_model)
plot(mod.out.corr)

# Plots using tidytext
# beta per-topic-per-word probabilities
td_beta <- tidy(topic_model)
td_beta %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  mutate(topic = paste0("Topic ", topic),
         term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(term, beta, fill = as.factor(topic))) +
  geom_col(alpha = 0.8, show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free_y") +
  coord_flip() +
  scale_x_reordered() +
  labs(x = NULL, y = expression(beta),
       title = "Highest word probabilities for each topic",
       subtitle = "Different words are associated with different topics")
# gamma per-document-per-topic probabilities
td_gamma <- tidy(topic_model, matrix = "gamma",                    
                 document_names = rownames(dtm_stm))
ggplot(td_gamma, aes(gamma, fill = as.factor(topic))) +
  geom_histogram(alpha = 0.8, show.legend = FALSE) +
  facet_wrap(~ topic, ncol = 3) +
  labs(title = "Distribution of document probabilities for each topic",
       y = "Number of documents", x = expression(gamma))
