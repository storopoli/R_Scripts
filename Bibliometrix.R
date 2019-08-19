########################### BIBLIOMETRIA USANDO BIBLIOMETRIX####################### 
# __________._____.  .__  .__                       __         .__                #
# \______   \__\_ |__|  | |__| ____   _____   _____/  |________|__|__  ___        #
# |    |  _/  || __ \|  | |  |/  _ \ /     \_/ __ \   __\_  __ \  \  \/  /        #
# |    |   \  || \_\ \  |_|  (  <_> )  Y Y  \  ___/|  |  |  | \/  |>    <         #
# |______  /__||___  /____/__|\____/|__|_|  /\___  >__|  |__|  |__/__/\_ \        #
#        \/        \/                     \/     \/                     \/        #
###################################################################################

# Autor: Jose Storopoli, UNINOVE
# Versao 2
# 1 de Dezembro de 2018

# !!! SCOPUS APENAS ACEITA BibTeX(.bib) !!!
# !!! WEB OF SCIENCE ACEITA BibTeX E PLAINTEXT(.txt)!!!


########################### INSTALA??O ###########################
install.packages("bibliometrix", dependencies = T)
library(bibliometrix)
library(data.table)
library(xlsx)

########################### Designar Pasta do Arquivo Exportado das Bases de Dados ###########################
file <- "C:/Users/storo/Desktop/Bib Carol/savedrecs.txt"
# se tiver mais de 1 arquivo saved recs (WoS somente permite 500 de cada vez)
file2 <- "C:/Users/storo/Documents/lucas scopus2.bib"
file3 <- "C:/Users/storo/Documents/lucas scopus3.bib"

########################### Carregar o Arquivo ###########################
D <- readFiles(file)

########################### Convertendo o Arquivo para um dataframe R bibliografico ###########################
#Designar dbsource "isi" ou "scopus" e format "bibtex" ou "plaintext"
M <- convert2df(D, dbsource="isi",format="plaintext")

########################### Remover Duplicados da Base ###########################
#tol eh valor numerico minimo da similaridade relativa para combinar dois manuscritos
M <- duplicatedMatching(M, Field = "TI", tol = 0.95)
dim(M) #o primeiro numero corresponde ao seu N final apos filtragem

########################### Principais resultados ########################### 
# k eh o numero de detalhamento dos top autores/artigos/paises/palavras-chave
results <- biblioAnalysis(M)
summary(results, k=10, pause=F, width=160)
plot(x=results, k=10, pause=F)

########################### Referencias mais Citadas da Amostra  ########################### 
CR <- citations(M, field = "article", sep = ";")
cbind(CR$Cited[1:20]) #ver os tops 20
write.xlsx(CR, file = "CR.xlsx")

########################### Limpeza as Referencias Citadas  ########################### 
# pegar o CR.xlsx
# abrir o arquivo BibTeX bruto e abrir no word
# procurar pela referencia faltante e substituir
# Boa sorte e Bom Trabalho!
# Pode-se usar as seguintes opcoes do word de busca avancada
# Ignorar pontuacao, usar wildcards etc

########################### Autores mais Citadas da Amostra  ########################### 
CitAut <- citations(M, field = "author", sep = ";")
cbind(CitAut$Cited[1:20]) #ver os tops 20
fwrite(CitAut$Cited, file = "CitAut.csv")

########################## Matriz de Co-Cit   ###########################
A <- cocMatrix(M, Field = "CR", sep = ";")
################## Ver quais sao os journals mais co-citados ###################
AA <- cocMatrix(M, Field = "SO", sep = ";")
sort(Matrix::colSums(AA), decreasing = TRUE)[1:10]  #ver os top10
################## Ver quais sao os autores mais co-citados ###################
BB <- cocMatrix(M, Field = "AU", sep = ";")
sort(Matrix::colSums(BB), decreasing = TRUE)[1:10]  #ver os top10

#################### EXTRACAO DE TAGS EXTRAS PARA AS ANALISES BIPARTITES ################
metatagSO <- metaTagExtraction(M, Field = "CR_SO", sep = ";") #Journal das Referencias Citadas
metatagAU <- metaTagExtraction(M, Field = "CR_AU", sep = ";") #Autor das Referencias Citadas
metatagCO <- metaTagExtraction(M, Field = "AU_CO", sep = ";") #Country dos Autores
metatagAU_UN <- metaTagExtraction(M, Field = "AU_UN", sep = ";", aff.disamb = TRUE) #Affialiation dos Autores

#Algoritmo de de reducao dos termos (Porter's Stemming Algorithm)
metatagTI_TM <- termExtraction(M, Field = "TI",
                               remove.numbers=TRUE, remove.terms=NULL, verbose=TRUE, stemming = TRUE)
                              #Extracao dos termos do Titulo
metatagTI_TM$TI <- metatagTI_TM$TI_TM #forcar os metatags para a coluna TI do metatag_TI_TM
metatagAB_TM <- termExtraction(M, Field = "AB",
                               remove.numbers=TRUE, remove.terms=NULL, verbose=TRUE, stemming = TRUE)
                              #Extracao dos termos do Abstract
metatagAB_TM$AB <- metatagAB_TM$AB_TM #forcar os metatags para a coluna AB do metatag_AB_TM
metatagDE_TM <- termExtraction(M, Field = "DE",
                               remove.numbers=TRUE, remove.terms=NULL, verbose=TRUE, stemming = TRUE)
                              #Extracao dos termos das Palavras=chave
metatagDE_TM$DE <- metatagDE_TM$DE_TM #forcar os metatags para a coluna AB do metatag_AB_TM
metatagCR_TM <- metaTagExtraction(M, Field = "CR",
                                  remove.numbers=FALSE, remove.terms=NULL, stemming = FALSE,
                                  sep = ";")
                              #Extracao dos termos das Referencias
#################### REDE BIPARTITE DE COCITACAO ###################
#OBS voce pode usar o type="vosviewer" para exportar a rede para VOSVIEWER

#Artigos
NetMatrix <- biblioNetwork(M, analysis = "co-citation", network = "references", sep = ";")
net=networkPlot(NetMatrix,  normalize = "salton", weighted=NULL, n = 20, #n= 20
                Title = "Reference co-citation", type = "fruchterman", size=5,size.cex=T, 
                remove.multiple=TRUE,labelsize=0.8,label.n=10,label.cex=F)
netstat <- networkStat(NetMatrix)
summary(netstat)

#Journals
NetMatrix <- biblioNetwork(metatagSO, analysis = "co-citation", network = "sources", sep = ";")
net=networkPlot(NetMatrix,  normalize = "salton", weighted=NULL, n = 10, #n= 10
                Title = "Source co-citation", type = "fruchterman", size=5,size.cex=T, 
                remove.multiple=TRUE,labelsize=0.8,label.n=10,label.cex=F)
netstat <- networkStat(NetMatrix)
summary(netstat)

#Autores
NetMatrix <- biblioNetwork(metatagAU, analysis = "co-citation", network = "authors", sep = ";")
net=networkPlot(NetMatrix,  normalize = "salton", weighted=NULL, n = 10, #n= 10
                Title = "Authors co-citation", type = "fruchterman", size=5,size.cex=T, 
                remove.multiple=TRUE,labelsize=0.8,label.n=10,label.cex=F)
netstat <- networkStat(NetMatrix)
summary(netstat)

#################### REDE BIPARTITE DE PAREAMENTO BIBLIOGRAFICO ###################
#Autores
NetMatrix <- biblioNetwork(M, analysis = "coupling", network = "authors", sep = ";")
net=networkPlot(NetMatrix,  normalize = "salton", weighted=NULL, n = 20, #n= 20
                Title = "Authors' Coupling", type = "fruchterman", size=5,size.cex=T, 
                remove.multiple=TRUE,labelsize=0.8,label.n=10,label.cex=F)
netstat <- networkStat(NetMatrix)
summary(netstat)

#Journals
NetMatrix <- biblioNetwork(M, analysis = "coupling", network = "sources", sep = ";")
net=networkPlot(NetMatrix,  normalize = "salton", weighted=NULL, n = 10, #n= 10
                Title = "Source's Coupling", type = "fruchterman", size=5,size.cex=T, 
                remove.multiple=TRUE,labelsize=0.8,label.n=10,label.cex=F)
netstat <- networkStat(NetMatrix)
summary(netstat)

#Artigos
NetMatrix <- biblioNetwork(M, analysis = "coupling", network = "references", sep = ";")
net=networkPlot(NetMatrix,  normalize = "salton", weighted=NULL, n = 20, #n= 20
                Title = "Manuscript's Coupling", type = "fruchterman", size=5,size.cex=T, 
                remove.multiple=TRUE,labelsize=0.8,label.n=10,label.cex=F)
netstat <- networkStat(NetMatrix)
summary(netstat)

#Country
NetMatrix <- biblioNetwork(metatagCO, analysis = "coupling", network = "countries", sep = ";")
net=networkPlot(NetMatrix,  normalize = "salton", weighted=NULL, n = 10, #n= 10
                Title = "Country Coupling", type = "fruchterman", size=5,size.cex=T, 
                remove.multiple=TRUE,labelsize=0.8,label.n=10,label.cex=F)
netstat <- networkStat(NetMatrix)
summary(netstat)

#################### REDE BIPARTITE DE CO-OCORRENCIA ###################
#Autores
NetMatrix <- biblioNetwork(M, analysis = "co-occurrences", network = "authors", sep = ";")
net=networkPlot(NetMatrix,  normalize = "salton", weighted=NULL, n = 20, #n= 20
                Title = "Authors Co-occurrences", type = "fruchterman", size=5,size.cex=T, 
                remove.multiple=TRUE,labelsize=0.8,label.n=10,label.cex=F)
netstat <- networkStat(NetMatrix)
summary(netstat)

#Journals
NetMatrix <- biblioNetwork(M, analysis = "co-occurrences", network = "sources", sep = ";")
net=networkPlot(NetMatrix,  normalize = "salton", weighted=NULL, n = 10, #n= 10
                Title = "Source's Co-occurrences", type = "fruchterman", size=5,size.cex=T, 
                remove.multiple=TRUE,labelsize=0.8,label.n=10,label.cex=F)
netstat <- networkStat(NetMatrix)
summary(netstat)

#Keywords
NetMatrix <- biblioNetwork(metatagDE_TM, analysis = "co-occurrences", network = "keywords", sep = ";")
net=networkPlot(NetMatrix,  normalize = "salton", weighted=NULL, n = 25, #n= 20
                Title = "Keyword Co-occurrences", type = "fruchterman", size=5,size.cex=T, 
                remove.multiple=TRUE,labelsize=0.8,label.n=10,label.cex=F)
netstat <- networkStat(NetMatrix)
summary(netstat)

#Title content
NetMatrix <- biblioNetwork(metatagTI_TM, analysis = "co-occurrences", network = "titles", sep = ";")
net=networkPlot(NetMatrix,  normalize = "salton", weighted=NULL, n = 10, #n= 10
                Title = "Title content Co-occurrences", type = "fruchterman", size=5,size.cex=T, 
                remove.multiple=TRUE,labelsize=0.8,label.n=10,label.cex=F)
netstat <- networkStat(NetMatrix)
summary(netstat)

#Abstract content
NetMatrix <- biblioNetwork(metatagAB_TM, analysis = "co-occurrences", network = "abstracts", sep = ";")
net=networkPlot(NetMatrix,  normalize = "salton", weighted=NULL, n = 10, #n= 10
                Title = "Abstract content Co-occurrences", type = "fruchterman", size=5,size.cex=T, 
                remove.multiple=TRUE,labelsize=0.8,label.n=10,label.cex=F)
netstat <- networkStat(NetMatrix)

summary(netstat)
#################### REDE BIPARTITE DE COLABORACAO ###################
#Autores
NetMatrix <- biblioNetwork(M, analysis = "collaboration", network = "authors", sep = ";")
net=networkPlot(NetMatrix,  normalize = "salton", weighted=NULL, n = 20, #n= 20
                Title = "Authors' Collaboration", type = "fruchterman", size=5,size.cex=T, 
                remove.multiple=TRUE,labelsize=0.8,label.n=10,label.cex=F)
netstat <- networkStat(NetMatrix)
summary(netstat)

#Universities
NetMatrix <- biblioNetwork(M, analysis = "collaboration", network = "universities", sep = ";")
net=networkPlot(NetMatrix,  normalize = "salton", weighted=NULL, n = 10, #n= 10
                Title = "University's Collaboration", type = "fruchterman", size=5,size.cex=T, 
                remove.multiple=TRUE,labelsize=0.8,label.n=10,label.cex=F)
netstat <- networkStat(NetMatrix)
summary(netstat)

#Country
NetMatrix <- biblioNetwork(metatagCO, analysis = "collaboration", network = "countries", sep = ";")
net=networkPlot(NetMatrix,  normalize = "salton", weighted=NULL, n = 10, #n= 10
                Title = "Country Collaboration", type = "fruchterman", size=5,size.cex=T, 
                remove.multiple=TRUE,labelsize=0.8,label.n=10,label.cex=F)
netstat <- networkStat(NetMatrix)
summary(netstat)

#################### ESTRUTURA CONCEITUAL #################### 
# ATENCAO!! RStudio gera 3 plots
#Plot 1 - Mapa da Estrutura Conceitual do Rotulo
#Plot 2 - Mapa Fatorial dos documentos com maiores contribuicoes
#Plot 3 - Mapa Fatorial dos documentos mais citados
#Se atentar ao especificador minDegree que fala o numero de co-ocorrencias para serem analisadas e plotadas
#Se atentar tambem ao especificador stemming de reducao das palavras
#OBS Da para tambem usar o method MCA que eh multivariada
#com uma qualificante quali.supp ou quanti.supp
#OBS2 se der erro infinite or missing values in 'x' voce deve aumentar o minDegree

#Titulos
CS_TI <- conceptualStructure(M,field="TI", method="CA", minDegree=12,
                             k.max=8, stemming=TRUE, labelsize=10, 
                             documents=10)
#Listagem dos Clusters Autores
CS_TI_cluster <- data.frame(CS_TI$km.res$cluster)

#Keywords especificadas pelos autores
CS_DE <- conceptualStructure(M,field="DE", method="CA", minDegree=15,
                             k.max=8, stemming=TRUE, labelsize=10, 
                             documents=10)
#Listagem dos Clusters Keywords
CS_DE_cluster <- data.frame(CS_DE$km.res$cluster)

#Abstracts
CS_AB <- conceptualStructure(M,field="AB", method="CA", minDegree=70,
                             k.max=8, stemming=TRUE, labelsize=10, 
                             documents=10)
#Listagem dos Clusters Autores
CS_AB_cluster <- data.frame(CS_AB$km.res$cluster)

#################### ESTRUTURA CONCEITUAL #################### 
#Representa uma mapa de rede cronologico das citacoes mais relevantes da amostra
#Se atentar ao min.citations
histResults <- histNetwork(M, min.citations = 3, sep = ";")
#Se atentar ao label size (vai testando os numeros)
net <- histPlot(histResults, n=10, size = 10, labelsize=8, 
                size.cex=TRUE, arrowsize = 0.5, color = TRUE)
#Legenda do Mapa Cronologico esta no fim do console apos o comando de cima

