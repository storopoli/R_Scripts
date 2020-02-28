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

# Cocitation
cocit <- biblioNetwork(M, analysis = "co-citation",
                          network = "references", sep = ";", shortlabel = T)
cocit <- cocit[nchar(colnames(cocit)) != 0,
                     nchar(colnames(cocit)) != 0]
dim(cocit)

# top-cited 
CR <- citations(M, field = "article", sep = ";")
topcited <-rownames(cbind(CR$Cited[1:1300])) # escolher top-cited para cortar na co-cit
cited <- Matrix::diag(cocit)
cited <- as.data.frame(cbind(rownames(cocit), cited))[order(-cited),]
# Export top-cited to CSV
write.csv2(cited, "top-cited.csv")

# fix the diagonal to zero
Matrix::diag(cocit) <- 0

# Subset Matrix
# where cocit > threshold is the number of references in common
threshold <- 14
cocit_subset <- cocit[Matrix::rowSums(cocit >= threshold) >= 1,
                            Matrix::colSums(cocit >= threshold) >= 1]
cocit_matrix <- as.data.frame(as.matrix(cocit_subset))
assertthat::are_equal(names(cocit_matrix), rownames(cocit_matrix))

# Export CSV
write.csv2(cocit_matrix, "cocit_matrix.csv")
