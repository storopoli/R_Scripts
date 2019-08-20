library(dplyr)
library(tidyr)
library(purrr)
library(readr)
library(tidyverse)
library(tidytext)
library(rvest)
library(xlsx)
library(ggplot2)
library(igraph)
library(ggraph)
library(widyr)

#grafico de frequencia bem bonito
bruto_word %>%
  count(word, sort = TRUE) %>%
  filter(n > 100) %>% #filtrar para a frequencia minima do gráfico
  filter(word !="NA") %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
  labs(title = "Abstract word frequency")

#Gráfico de Bigram
bruto_bigram_graph <- bruto_bigrams %>%
  filter(n > 1) %>% #filtrar frequencia mínima
  graph_from_data_frame()
bruto_bigram_graph
set.seed(2017)
ggraph(bruto_bigram_graph, layout = "fr") +
  geom_edge_link() +
  geom_node_point() +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1) +
  labs(title = "Abstract Bigrams with frequency higher than 5")

#Gráfico de Trigram
bruto_trigram_graph <- bruto_trigrams %>%
  filter(n > 1) %>% #filtrar frequencia mínima
  graph_from_data_frame()
bruto_trigram_graph
set.seed(2017)
ggraph(bruto_trigram_graph, layout = "fr") +
  geom_edge_link() +
  geom_node_point() +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1) +
  labs(title = "Title Trigrams with frequency higher than 1")

#Gráfico de Bigram com sombreamento e flecha
set.seed(2016)
a <- grid::arrow(type = "closed", length = unit(.15, "inches"))

ggraph(bruto_bigram_graph, layout = "fr") +
  geom_edge_link(aes(edge_alpha = n), show.legend = FALSE,
                 arrow = a, end_cap = circle(.07, 'inches')) +
  geom_node_point(color = "lightblue", size = 5) +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1) +
  theme_void() +
  labs(title = "Title Bigrams with frequency higher than 5")
rm(a)

#gráficos legais escolhendo palavras para correlacionar
bruto_word_cors %>%
  filter(item1 %in% c("institutional", "strategy", "research", "education", "teaching")) %>% #escolher as palavras
  group_by(item1) %>%
  top_n(6) %>% #escolher o topN
  ungroup() %>%
  mutate(item2 = reorder(item2, correlation)) %>%
  ggplot(aes(item2, correlation)) +
  geom_bar(stat = "identity") +
  facet_wrap(~ item1, scales = "free") +
  coord_flip() +
  labs(title = "Abstract word correlation (top 6)")

#diagrama neural das palavras para correlacionar
set.seed(2016)
bruto_word_cors %>%
  filter(correlation > .9) %>% #filtrar a correlacao minima
  graph_from_data_frame() %>%
  ggraph(layout = "fr") +
  geom_edge_link(aes(edge_alpha = correlation), show.legend = FALSE) +
  geom_node_point(color = "lightblue", size = 5) +
  geom_node_text(aes(label = name), repel = TRUE) +
  theme_void() +
  labs(title = "Abstract word network with frequency higher than 0.9")
