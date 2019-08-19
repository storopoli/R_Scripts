library(igraph)
library(rgexf)

# Importing Data
df <- read.csv2("coup-min-3-nodes.csv", row.names = 1)
df <- read.csv2("coup-min-3-nodes.csv", row.names = 1)
factor <- read.csv2("node-factor.csv", stringsAsFactors = F)

# Creating a adjacency matrix
g <- graph_from_adjacency_matrix(as.matrix(df), mode = "undirected")
g <- igraph::simplify(g)
summary(g)
V(g)$name # vertex
E(g)  # edges

# Adding node (vertex) attributes
g <- set_vertex_attr(g, "factor", index = factor$ID, value = factor$Factor)
get.vertex.attribute(g)
V(g)$factor # vertex atrribute

# Removing Vertex with empty Factor (maybe removed by KMO procedure)
g <- induced.subgraph(g, which(V(g)$factor!="NA"))
V(g)$factor #check if it worked
 
# Vertex more Attributes
get.graph.attribute(g)
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
graph.density(igraph::simplify(g),loop=FALSE)

# Plot
plot(g, vertex.color=V(g)$factor, vertex.size=V(g)$degree) # vertex plots as attribute 

# Exporting Edge List to TXT/CSV
write_graph(g, "network.txt", format = "edgelist")
csv <- get.edgelist(g)
write.csv(csv, "network.csv")

# Exporting to DOT (This is the best to Gephi)
write_graph(g, "network.dot", format = "dot")

# Exporting to Pajek
write_graph(g, "network.net", format = "pajek")

# Exporting to Gephi
nodes_df <- data.frame(ID = c(1:vcount(g)), NAME = V(g)$name)
edges_df <- as.data.frame(get.edges(g, c(1:ecount(g))))
nodes_att <- data.frame(degree = V(g)$degree,
                        betweenness = V(g)$betweenness, 
                        clustering_coefficient = V(g)$closeness,
                        factor = V(g)$factor) 
write.gexf(nodes = nodes_df,
           edges = edges_df,
           nodesAtt = nodes_att,
           defaultedgetype = "undirected",
           output = "network.gexf")

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
  #cat(sprintf("Centralization Degree Factor %d: %.3f\n", i, centrality_degree))
  #cat(sprintf("Centralization Eigen Factor %d: %.3f\n", i, centrality_eigen))
  #cat(sprintf("Cohesion Factor %d: %.3f\n", i, sub_cohesion))
  #cat(sprintf("Density Factor %d: %.3f\n", i, sub_density))
}

# Exporting to CSV
write.csv(sub_df, "sub_networks.csv")
