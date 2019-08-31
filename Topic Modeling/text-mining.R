library(readxl)
library(dplyr)
library(tidytext)
library(stringr)
library(quanteda)
library(ggplot2)
library(tidyr)
library(igraph)
library(ggraph)
library(widyr)

# Stop words
stop_words <- stopwords("en")

# importing data
data <- read_excel("~/Google Drive/Artigos/Bib-Retencao/amostra-374.xlsx", col_names = T)
rownames(data) <- data$...1
data$...1 <- NULL

# Do the preprocessing in quanteda
corpus <- corpus(data$AB, docnames = rownames(data), docvars = data,
                 metacorpus = NULL, compress = FALSE)

dfm <- dfm(corpus, remove = stopwords("en"), tolower = TRUE, remove_punct = TRUE)
dfm <- dfm_wordstem(dfm, language = "english")

# Convert to tidytext format
tidy_text <- tidy(dfm)

# tf-idf stuff
dtm_tidy_tf_idf <- tidy_text %>%
  bind_tf_idf(term, document, count)
# plot terms-tf_idf
dtm_tidy_tf_idf %>%
  arrange(desc(tf_idf)) %>%
  mutate(term = factor(term, levels = rev(unique(term)))) %>% 
  #group_by(document) %>% 
  top_n(15) %>% 
  ungroup() %>%
  ggplot(aes(term, tf_idf)) + #, fill = document)) +
  geom_col(show.legend = FALSE) +
  labs(x = NULL, y = "tf-idf") +
  #facet_wrap(~document, ncol = 2, scales = "free") +
  coord_flip()

# Bigrams
bigrams <- tidy_text %>%
  unnest_tokens(bigram, term, token = "ngrams", n = 2) %>%
  filter(!bigram %in% stop_words)
# see the top frequent
bigrams %>%
  count(bigram, sort = TRUE)
# separate bigrams
bigrams_separated <- bigrams %>%
  tidyr::separate(bigram, c("word1", "word2"), sep = " ")
bigram_counts <- bigrams_separated %>% 
  count(word1, word2, sort = TRUE)
bigrams_united <- bigrams_separated %>%
  unite(bigram, word1, word2, sep = " ")
# bigram tf_idf
bigram_tf_idf <- bigrams_united %>%
  count(document, bigram) %>%
  bind_tf_idf(bigram, document, n) %>%
  arrange(desc(tf_idf))
# plot bigrams-tf_idf
bigram_tf_idf %>%
  arrange(desc(tf_idf)) %>%
  mutate(bigram = factor(bigram, levels = rev(unique(bigram)))) %>% 
  #group_by(document) %>% 
  top_n(20) %>% 
  ungroup() %>%
  ggplot(aes(bigram, tf_idf)) + #, fill = document)) +
  geom_col(show.legend = FALSE) +
  labs(x = NULL, y = "tf-idf") +
  #facet_wrap(~document, ncol = 2, scales = "free") +
  coord_flip()

# Network of Bigrams
bigram_graph <- bigram_counts %>%
  filter(n > 20) %>%
  graph_from_data_frame()
# plot undirected
ggraph(bigram_graph, layout = "fr") +
  geom_edge_link() +
  geom_node_point() +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1)
# plot directed
a <- grid::arrow(type = "closed", length = unit(.15, "inches"))
ggraph(bigram_graph, layout = "fr") +
  geom_edge_link(aes(edge_alpha = n), show.legend = FALSE,
                 arrow = a, end_cap = circle(.07, 'inches')) +
  geom_node_point(color = "lightblue", size = 5) +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1) +
  theme_void()

# Word correlation
words <- tidy_text %>%
  unnest_tokens(word, term) %>%
  filter(!word %in% stop_words)
word_pairs <- words %>%
  pairwise_count(word, document, sort = TRUE)
word_cors <- words %>%
  group_by(word) %>%
  filter(n() >= 20) %>%
  pairwise_cor(word, document, sort = TRUE)
# plot word correlation
word_cors %>%
  filter(item1 %in% c("retent", "student", "improv", "campus")) %>%
  group_by(item1) %>%
  top_n(6) %>%
  ungroup() %>%
  mutate(item2 = reorder(item2, correlation)) %>%
  ggplot(aes(item2, correlation)) +
  geom_bar(stat = "identity") +
  facet_wrap(~ item1, scales = "free") +
  coord_flip()
# network of word correlation
word_cors %>%
  filter(correlation > .15) %>%
  graph_from_data_frame() %>%
  ggraph(layout = "fr") +
  geom_edge_link(aes(edge_alpha = correlation), show.legend = FALSE) +
  geom_node_point(color = "lightblue", size = 5) +
  geom_node_text(aes(label = name), repel = TRUE) +
  theme_void()
