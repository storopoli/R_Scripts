library(bibliometrix)

# se for usar direto da Scopus
D <- readFiles("Google Drive/Artigos/Bibliométrico - GeAS /brutos/GeAS-special-ed.bib")
M <- convert2df(D, format = "bibtex", dbsource = "scopus")
write.csv2(M, "Bruto_Bibliometrix.csv")

# Citation Matrix
M$CR<- stringr::str_replace_all(as.character(M$CR),"DOI;","DOI ")
Fi<-strsplit(M[,"CR"],";")
#Fi<-lapply(Fi,trim.leading)
#Fi<-lapply(Fi,function(l) l<-l[nchar(l)>10])  ## delete not congruent references
uniqueField<-unique(unlist(Fi))
#uniqueField<-uniqueField[!is.na(uniqueField)]
#S<-gsub("\\).*",")",uniqueField)
#S<-gsub(","," ",S)
#S<-gsub(";"," ",S)
#S<-reduceRefs(S)
#uniqueField<-unique(trimES(S))
# Fi<-lapply(Fi, function(l){
#   l<-gsub("\\).*",")",l)
#   l<-gsub(","," ",l)
#   l<-gsub(";"," ",l)
#   l<-l[nchar(l)>0]
#   l<-reduceRefs(l)
#   l<-trimES(l)
#   return(l)
# })

# Cocitation Matrix - WF is Work vs Field
size<-dim(M)
WF<-matrix(0,size[1],length(uniqueField))
colnames(WF)<-uniqueField
rownames(WF)<-rownames(M)
for (i in 1:size[1]){
    ## full counting
    tab=table(Fi[[i]])
    name=names(tab)
    WF[i,name[nchar(name)>0]] = tab[nchar(name)>0]
}

#WF=WF[,!is.na(uniqueField)]

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
WF <- Matrix::Matrix(WF)
cocit <- Matrix::crossprod(WF, WF)
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

# auxiliary functions
reduceRefs<- function(A){
  
  ind=unlist(regexec("*V[0-9]", A))
  A[ind>-1]=substr(A[ind>-1],1,(ind[ind>-1]-1))
  ind=unlist(regexec("*DOI ", A))
  A[ind>-1]=substr(A[ind>-1],1,(ind[ind>-1]-1))
  return(A)
}
