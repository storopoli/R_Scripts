library(bibliometrix)

# se for usar direto da Scopus
D <- readFiles("~/Google Drive/Academic/Orientações/Jefferson da Costa/RSL/BibTeX_Scopus/158_stakeholder.bib")
M <- convert2df(D, format = "bibtex", dbsource = "scopus")
write.csv2(M, "Bruto_Bibliometrix.csv")

# import the clean dataset to R
M <- read.csv2("Bruto_Bibliometrix_limpo.csv",
               colClasses = rep('character', 62))

# Citation Matrix
M$CR<- stringr::str_replace_all(as.character(M$CR),"DOI;","DOI ")

# Bibliographic Coupling
coupling <- biblioNetwork(M, analysis = "coupling",
                          network = "references", sep = ";")
coupling <- coupling[nchar(colnames(coupling)) != 0,
                     nchar(colnames(coupling)) != 0]
dim(coupling)
# fix the diagonal to zero
Matrix::diag(coupling) <- 0

# Subset Matrix
# where coupling > threshold is the number of references in common
threshold <- 3
coupling_subset <- coupling[Matrix::rowSums(coupling >= threshold) >= 1,
                            Matrix::colSums(coupling >= threshold) >= 1]
coupling_matrix <- as.data.frame(as.matrix(coupling_subset))
assertthat::are_equal(names(coupling_matrix), rownames(coupling_matrix))

# Export CSV
write.csv2(coupling_matrix, "coupling_matrix.csv")
