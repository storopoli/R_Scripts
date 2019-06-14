library(tidyverse)
library(tidytext)

# Tokenization - break text into individual tokens and transform it intoa tidy data structure
data(stop_words)
corpus_separated <- corpus_raw %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) # removing stop_words

# Word Frequency
freq_word <- corpus_separated %>%
  count(word, sort = TRUE)

#relação de bigramas do rotulo de dados removendo stop words e gerando frequencia
bigrams <- bruto %>%
    unnest_tokens(bigram, text, token = "ngrams", n = 2) %>%
    separate(bigram, c("word1", "word2"), sep = " ") %>%
    filter(!word1 %in% stop_words$word,
           !word2 %in% stop_words$word) %>%
    count(word1, word2, sort = TRUE)

#relação de trigramas do rotulo de dados removendo stop words e gerando frequencia
trigrams <- bruto %>%
  unnest_tokens(trigram, text, token = "ngrams", n = 3) %>%
  separate(trigram, c("word1", "word2", "word3"), sep = " ") %>%
  filter(!word1 %in% stop_words$word,
         !word2 %in% stop_words$word,
         !word3 %in% stop_words$word) %>%
  count(word1, word2, word3, sort = TRUE)

#pairwise correlation das palavras do rotulo de dados removendo stop words
section_words <- bruto %>%
  mutate(section = row_number() %/% 10) %>%
  filter(section > 0) %>%
  unnest_tokens(word, text) %>%
  filter(!word %in% stop_words$word)
# count words co-occuring within sections
word_pairs <- section_words %>%
  pairwise_count(word, section, sort = TRUE)

# we need to filter for at least relatively common words first
word_cors <- section_words %>%
  group_by(word) %>%
  filter(n() >= 8) %>% #filtrar para frequencia minima
  pairwise_cor(word, section, sort = TRUE)

