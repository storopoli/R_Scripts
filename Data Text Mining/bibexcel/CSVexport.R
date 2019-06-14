
#CSV das Frequencias das palavras no rotulo de dados
write.csv(freq_word,file="freq_word.csv")

#CSV dos Bigramas
write.csv(bruto_bigrams, file= "bigrams.csv")

#CSV dos Trigramas
write.csv(bruto_trigrams, file= "trigrams.csv")

#CSV da frequencia count words co-occuring within sections
write.csv(bruto_word_pairs, file="freq_cooccurence.csv")

#CSV das correlacoes das frequencias de co-ocorrencia, não esquecer de alterar o limite no dataprep
write.csv(bruto_word_cors, file="corr_cooccurence.csv")