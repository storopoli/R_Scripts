library(readr)
library(FactorAssumptions)
library(psych)
library(nFactors)
library(ggplot2)
options(scipen = 999)

# Load the data
data <- read_tsv("co-cit.ma2")
data <- data[,1:(length(data)-1)] #removing the last column
rownames(data) <- colnames(data)

# Removing KMO
factor_analysis <- kmo_optimal_solution(data)
sink("removed_kmo.txt")
factor_analysis$removed
sink()
data <- factor_analysis$df
length(factor_analysis$removed)

# How Many Factors?
ev <- eigen(cor(data)) # get eigenvalues
ap <- parallel(subject=nrow(data),var=ncol(data),
               rep=1000,cent=.05)
nS <- nScree(x=ev$values, aparallel=ap$eigen$qevpea)
plotnScree(nS)

# PCA
results <- principal(data, nfactors = 3, scores = T, rotate = "varimax")
results$Vaccounted
# numero de fatores
for (factor in colnames(results$Vaccounted)) {
  print(factor)
}
write.csv2(results$Vaccounted, "variance_accounted.csv")
loadings <- as.table(printLoadings(results$loadings))
write.csv2(loadings, "loadings.csv")
fa.diagram(results, digits = 3, cut = 0.4, sort = T)

# Export Tables and Loadings
df <- data.frame(unclass(results$loadings), 
                 communalities = results$communalities, 
                 uniqueness = results$uniqueness,
                 complexity = results$complexity)
round(df,2)

# LaTeX export
df2latex(cor(data), short.names = T, apa = T, rowlabels = T,
         caption = "Correlation Matrix")
fa2latex(results, digits = 2, rowlabels = T, apa = T, short.names = T, cut = 0.4,
         heading = "Rotated Component Matrix - Varimax")
