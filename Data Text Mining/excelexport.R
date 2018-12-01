library(xlsx)


#XLS das Frequencias das palavras no rotulo de dados
write.xlsx(freq_word,file="freq_word.xlsx")

#XLS dos Bigramas
write.xlsx(bruto_bigrams, file= "bigrams.xlsx")

#XLS dos Trigramas
write.xlsx(bruto_trigrams, file= "trigrams.xlsx")

#XLS da frequencia count words co-occuring within sections
write.xlsx(bruto_word_pairs, file="freq_cooccurence.xlsx")

#XLS das correlacoes das frequencias de co-ocorrencia, não esquecer de alterar o limite no dataprep
write.xlsx(bruto_word_cors, file="corr_cooccurence.xlsx")