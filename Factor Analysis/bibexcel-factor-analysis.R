library(readr)
library(FactorAssumptions)
library(psych)
library(ggplot2)
library(igraph)
options(scipen = 999)

# Load the data
data <- read_tsv("pareamento-1-node.ma2")
data <- data[,1:(length(data)-1)] #removing the last column
data <- as.data.frame(data)
rownames(data) <- colnames(data)
# If you want to do a coupling
cols_coupling <- c()
for (name in names(data)) {
  cols_coupling_individual <- paste0("bc", name)
  cols_coupling <- c(cols_coupling, cols_coupling_individual)
}
colnames(data) <- cols_coupling
rownames(data) <- colnames(data)

# Removing KMO
factor_analysis <- kmo_optimal_solution(data, squared = T)
sink("removed_kmo.txt")
factor_analysis$removed
sink()
data <- factor_analysis$df
length(factor_analysis$removed)


# removing zero std_dev variables
sd_zero <- names(data[,sapply(data, function(x) { sd(x) == 0} )])
sink("removed_sd_zero.txt")
sd_zero
sink()
data <- data[!sapply(data, function(x) { sd(x) == 0} ), !sapply(data, function(x) { sd(x) == 0} ), drop = FALSE]

# How Many Factors?
screePlotAPA(data)
ggsave("scree-plot.png", dpi = 300)

# PCA
results <- principal(cor(data), nfactors = 3, scores = T, rotate = "varimax")
results$Vaccounted
# numero de fatores
for (factor in colnames(results$Vaccounted)) {
  print(factor)
}
write.csv2(results$Vaccounted, "variance_accounted.csv")
write.csv2(results$loadings, "loadings_bruto.csv")
loadings <- as.table(printLoadings(results$loadings))
write.csv2(loadings, "loadings.csv")
fa.diagram(results, digits = 3, cut = 0.4, sort = T)

# Export Tables and Loadings
df <- data.frame(unclass(loadings)) # this one is better
#df <- data.frame(unclass(results$loadings),communalities = results$communalities, uniqueness = results$uniqueness,complexity = results$complexity)
#round(df,2)

# Export Factor ID for every variable
# It is important to use absolute values because of negative loadings
df <- data.frame(unclass(results$loadings), stringsAsFactors = F)
factors <- data.frame(
  "ID" = rownames(df),
  "factor" = apply(df[1:ncol(df)], 1, function(x) colnames(df)[which.max(abs(x))]),
  stringsAsFactors = F)

# Export to adjacency matrix
write.csv(data, "adjacency_matrix.csv")

# Creating network using igraph
g <- graph_from_adjacency_matrix(as.matrix(data), mode = "undirected", weighted = T, diag = F)
summary(g) #check graph
V(g)$name # check vertex
E(g)

# Adding node (vertex) attributes
g <- set_vertex_attr(g, "factor", index = factors$ID, value = factors$factor)
names(get.vertex.attribute(g))
V(g)$factor # vertex atrribute

# Vertex more Attributes
names(get.vertex.attribute(g))
V(g)$degree <- degree(g)
V(g)$betweenness <- betweenness(g)
V(g)$closeness <- closeness(g)
V(g)$transitivity <- transitivity(g) # clustering coefficient

# Network Attributes
# Centrality
centr_degree(g)$centralization # degrees of vertices
centr_eigen(g, directed = F)$centralization #closeness of vertices
# Cohesion
mean(degree(g))/(vcount(g)-1)
# Density
# Make sure to always simplify an undirected graph to remove loops and multiple edges 
# before calculating its density
# network.density(asNetwork(igraph::simplify(g)))
graph.density(igraph::simplify(g),loop=FALSE)

# Exporting to DOT (This is the best to Gephi)
write_graph(g, "network.dot", format = "dot")

# Getting Network Attributes for each Factor
sub_df <- data.frame()
for (i in unique(na.omit(V(g)$factor))){
  new_g <- induced.subgraph(g, which(V(g)$factor==as.character(i)))
  centrality_degree <- centr_degree(new_g)$centralization
  centrality_eigen <- centr_eigen(new_g, directed = F)$centralization
  sub_cohesion <- mean(degree(new_g))/(vcount(new_g)-1)
  sub_density <- graph.density(igraph::simplify(new_g),loop=FALSE)
  
  dat <- data.frame("factor" = as.factor(i),
                    "centrality_degree" = centrality_degree,
                    "centrality_eigen" = centrality_eigen,
                    "cohesion" = sub_cohesion,
                    "density" = sub_density)
  sub_df <- rbind(sub_df, dat)
  cat(sprintf("Centralization Degree Factor %s: %.3f\n", i, centrality_degree))
  cat(sprintf("Centralization Eigen Factor %s: %.3f\n", i, centrality_eigen))
  cat(sprintf("Cohesion Factor %s: %.3f\n", i, sub_cohesion))
  cat(sprintf("Density Factor %s: %.3f\n", i, sub_density))
}
# Exporting to CSV
write.csv(sub_df, "sub_networks.csv")

# LaTeX export
df2latex(cor(data), short.names = T, apa = T, rowlabels = T,
         caption = "Correlation Matrix")
fa2latex(results, digits = 2, rowlabels = T, apa = T, short.names = T, cut = 0.4,
         heading = "Rotated Component Matrix - Varimax")
