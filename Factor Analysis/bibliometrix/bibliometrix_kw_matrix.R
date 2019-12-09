library(bibliometrix)

# se for usar direto da Scopus
D <- readFiles("~/Google Drive/Academic/Orientações/Jefferson da Costa/RSL/BibTeX_Scopus/158_stakeholder.bib")
M <- convert2df(D, format = "bibtex", dbsource = "scopus")
write.csv2(M, "Bruto_Bibliometrix.csv")

# import the clean dataset to R
M <- read.csv2("Bruto_Bibliometrix_limpo.csv",
               colClasses = rep('character', 62))

# Keywords Co-occurrences
keywords <- biblioNetwork(M, analysis = "co-occurrences",
                       network = "keywords", sep = ";")
keywords <- keywords[nchar(colnames(keywords)) != 0,
               nchar(colnames(keywords)) != 0]
dim(keywords)

# fix the diagonal to zero
#Matrix::diag(keywords) <- 0

# Subset Matrix
# where keywords > threshold is the number of references in common
threshold <- 10
keywords_subset <- keywords[Matrix::rowSums(keywords >= threshold) >= 1,
                      Matrix::colSums(keywords >= threshold) >= 1]
keywords_matrix <- as.data.frame(as.matrix(keywords_subset))
assertthat::are_equal(names(keywords_matrix), rownames(keywords_matrix))

# Export CSV
write.csv2(keywords_matrix, "keywords_matrix.csv")
