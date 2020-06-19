library(igraph)
library(rgexf)

# Importing Data
df <- read.csv2("coup-min-3-nodes.csv", row.names = 1)

# Creating a adjacency matrix
gg <- graph_from_adjacency_matrix(as.matrix(data), mode = "undirected", weighted = T, diag = F)
# Importing from Pajek .net file
g <- read.graph(".net", format = "pajek")
summary(g)
V(g)$name # vertex
E(g)  # edges

# Filtering by edge attribute
# Find out how many Vertices per Edge weight
for (i in seq_along(1:15)) {
  cat(sprintf("Total vertices for %d or more weights: %d\n",i, 
                length(V(subgraph.edges(g, E(g)[E(g)$weight>=i], del=T)))))
}

# Create a subgraph
g.copy <- subgraph.edges(g, E(g)[E(g)$weight>=8], del=T)

# Vertex Attributes
V(g)$degree <- degree(g, normalized = F)
V(g)$Ndegree <- degree(g, normalized = T)
V(g)$eigen_centrality <- eigen_centrality(g, directed = F)
V(g)$betweeness <- betweenness(g, directed = F)
V(g)$Nbetweeness <- betweenness(g, directed = F, normalized = T)
V(g)$closeness <- closeness(g)
# Export Node Attributes
write.csv2(as.data.frame(vertex_attr(g)), "vertex_attributes.csv")

# Network Attributes
# Centrality
centr_degree(g)$centralization # degrees of vertices
centr_eigen(g, directed = F)$centralization #closeness of vertices
# Cohesion
cohesion(g)
# Density
# Make sure to always simplify an undirected graph to remove loops and multiple edges 
# before calculating its density
# network.density(asNetwork(igraph::simplify(g)))
graph.density(igraph::simplify(g),loop=FALSE)
# Transitivity
transitivity(g)

# Plot
plot(g,
     #vertex.color=V(g)$factor,
     vertex.size=V(g)$degree) # vertex plots as attribute 

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
                        Ndegree = V(g)$Ndegree,
                        betweenness = V(g)$betweenness,
                        Nbetweeness = V(g)$Nbetweeness,
                        clustering_coefficient = V(g)$closeness) 
write.gexf(nodes = nodes_df,
           edges = edges_df,
           nodesAtt = nodes_att,
           defaultedgetype = "undirected",
           output = "network.gexf")

# Getting Network Attributes for each Something
sub_df <- data.frame()
for (i in unique(na.omit(V(g)$something))){
  new_g <- induced.subgraph(g, which(V(g)$something==as.character(i)))
  total_size <- length(V(g))
  size <- length(V(new_g))
  centrality_degree <- centr_degree(new_g)$centralization
  centrality_eigen <- centr_eigen(new_g, directed = F)$centralization
  sub_cohesion <- cohesion(new_g)
  sub_density <- graph.density(igraph::simplify(new_g),loop=FALSE)
  transitivity <- transitivity(new_g) # clustering coefficient
  
  dat <- data.frame("something" = as.factor(i),
                    "total_size_network" = total_size,
                    "size"= size,
                    "centrality_degree" = centrality_degree,
                    "centrality_eigen" = centrality_eigen,
                    "cohesion" = sub_cohesion,
                    "density" = sub_density,
                    "transitivity" = transitivity)
  sub_df <- rbind(sub_df, dat)
  #cat(sprintf("Centralization Degree Factor %d: %.3f\n", i, centrality_degree))
  #cat(sprintf("Centralization Eigen Factor %d: %.3f\n", i, centrality_eigen))
  #cat(sprintf("Cohesion Factor %d: %.3f\n", i, sub_cohesion))
  #cat(sprintf("Density Factor %d: %.3f\n", i, sub_density))
}

# Exporting to CSV
write.csv(sub_df, "sub_networks.csv")
