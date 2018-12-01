####você pode pegar um bruto limpo do bibexcel e mandar ele fazer um out de algum rotulo
####ai voce pega esse out abre no excel e separa por textos por colunas e importa pro R Studio
### use esta função para ter o bruto bruto <- data_frame(txt = arquivoout$X2)




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
library(xlsx)
library(tm)

#Pegar o bruto savedrecs do WoS formatado no Excel
savedrecs <- read_excel("savedrecs.xlsx",
col_types = c("text", "text", "blank",
"blank", "blank", "text", "blank",
"blank", "text", "text", "blank",
"blank", "text", "text", "blank",
"blank", "blank", "blank", "blank",
"text", "text", "text", "text", "text",
"text", "text", "text", "text", "text",
"text", "numeric", "numeric", "numeric",
"numeric", "numeric", "text", "text",
"text", "text", "text", "blank",
"text", "text", "text", "numeric",
"numeric", "text", "blank", "numeric",
"text", "numeric", "numeric", "text",
"text", "text", "blank", "blank",
"blank", "numeric", "text", "text",
"text", "text", "numeric", "text",
"blank", "blank", "numeric"))
View(savedrecs)

#separar as palavras dos rotulo de dados
bruto <- data_frame(txt = savedrecs$TI) #usar rotulos do WoS
bruto_word <- bruto %>%
  unnest_tokens(word, txt)

#remover stop words
data(stop_words)

bruto_word <- bruto_word %>%
  anti_join(stop_words)

#contar frequencia das palavras do rotulo de dados
freq_word <- bruto_word %>%
  count(word, sort = TRUE)

#relaÃ§Ã£o de bigramas do rotulo de dados removendo stop words e gerando frequencia
bruto_bigrams <- bruto %>%
    unnest_tokens(bigram, txt, token = "ngrams", n = 2) %>%
    separate(bigram, c("word1", "word2"), sep = " ") %>%
    filter(!word1 %in% stop_words$word,
           !word2 %in% stop_words$word) %>%
    count(word1, word2, sort = TRUE)

#relaÃ§Ã£o de trigramas do rotulo de dados removendo stop words e gerando frequencia
bruto_trigrams <- bruto %>%
  unnest_tokens(trigram, txt, token = "ngrams", n = 3) %>%
  separate(trigram, c("word1", "word2", "word3"), sep = " ") %>%
  filter(!word1 %in% stop_words$word,
         !word2 %in% stop_words$word,
         !word3 %in% stop_words$word) %>%
  count(word1, word2, word3, sort = TRUE)

#pairwise correlation das palavras do rotulo de dados removendo stop words
bruto_section_words <- bruto %>%
  mutate(section = row_number() %/% 10) %>%
  filter(section > 0) %>%
  unnest_tokens(word, txt) %>%
  filter(!word %in% stop_words$word)
# count words co-occuring within sections
bruto_word_pairs <- bruto_section_words %>%
  pairwise_count(word, section, sort = TRUE)

# we need to filter for at least relatively common words first
bruto_word_cors <- bruto_section_words %>%
  group_by(word) %>%
  filter(n() >= 8) %>% #filtrar para frequencia minima
  pairwise_cor(word, section, sort = TRUE)

