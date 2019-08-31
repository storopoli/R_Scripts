# remotes::install_github("juba/rainette")
library(quanteda)
library(rainette)
library(readxl)

# importing data
data <- read_excel("~/Google Drive/Artigos/Bib-Retencao/amostra-374.xlsx", col_names = T)
rownames(data) <- data$...1
data$...1 <- NULL

corpus <- data$AB
dtm <- dfm(corpus, remove = stopwords("en"), tolower = TRUE, remove_punct = TRUE)
dtm <- dfm_wordstem(dtm, language = "english")
dtm <- dfm_trim(dtm, min_termfreq = 3)
res <- rainette(dtm, k = 6, min_uc_size = 15, min_members = 20)

rainette_explor(res, dtm)
