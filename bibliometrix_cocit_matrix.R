library(bibliometrix)
library(xlsx)
# Voce precisa reimportar o dataset limpo CSV para o R
M <- read.csv('Bruto_Bibliometrix_limpo.csv', colClasses = rep('character', 62))

# Para gerar a matriz quadrada de cocit
cocit <-biblioNetwork(M, analysis = "co-citation", network = "references",
                      shortlabel = F)
cocit <- as.data.frame(as.matrix(cocit))

# Exportar para xlsx ou CSV
write.csv(cocit,"cocit_matrix.csv")
write.xlsx2(cocit,"cocit_matrix.xlsx")
