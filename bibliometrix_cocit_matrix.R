library(bibliometrix)

# se for usar direto da Scopus
D <- readFiles("Google Drive/Artigos/Bibliométrico - GeAS /brutos/GeAS-special-ed.bib")
M <- convert2df(D, format = "bibtex", dbsource = "scopus")

# top-cited da amostra
CR <- citations(M, field = "article", sep = ";")
cbind(CR$Cited[1:20]) #ver os tops 20
write.csv2(CR, file = "CR.csv")

cited <- Matrix::diag(cocit_subset)
cited2 <- as.data.frame(cbind(rownames(cocit_subset), cited))[order(-cited),]

# voce precisa reimportar o dataset limpo CSV para o R
M <- read.csv2("Bruto_Bibliometrix_limpo.csv", colClasses = rep('character', 62))

# Para gerar a matriz quadrada de cocit
WA = cocMatrix(M, Field = "CR", type = "sparse", binary = F)
# delete empty vertices
cocit <- Matrix::crossprod(WA, WA)
cocit <- cocit[nchar(colnames(cocit)) != 0, nchar(colnames(cocit)) != 0]


# Subset Matrix
# where cocit > X is the number of citations
cocit_subset <- cocit[Matrix::rowSums(cocit > 10) >= 1, Matrix::colSums(cocit > 10) >= 1]
dimcocit <- as.data.frame(as.matrix(cocit_subset))

# top-cited da amostra
cited <- Matrix::diag(cocit_subset)
cited <- as.data.frame(cbind(rownames(cocit_subset), cited))[order(-cited),]

# Exportar para CSV
write.csv2(dimcocit,"cocit_matrix.csv")
