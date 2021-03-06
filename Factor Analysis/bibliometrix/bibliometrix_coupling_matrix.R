library(bibliometrix)
library(dplyr)
library(nFactors)
library(psych)
library(Matrix)
library(igraph)
library(tidygraph)
library(ggraph)
library(network)
library(intergraph)
set.seed(123)

M <- readRDS("data/all_records.rds")


# Coupling ----------------------------------------------------------------

# Coupling Matrix
coup <- biblioNetwork(M, analysis = "coupling",
                      network = "references", sep = ";")
dim(coup)

# fix the diagonal to zero
diag(coup) <- 0

assertthat::are_equal(colnames(coup), rownames(coup))

# Subset Matrix
# where coupling > threshold is the number of references in common
threshold <- 6
coupling_subset <- coup[rowSums(coup >= threshold) >= 1,
                        colSums(coup >= threshold) >= 1]
coup <- as.data.frame(as.matrix(coupling_subset))
assertthat::are_equal(names(coup), rownames(coup))

# Export CSV
write.csv2(coup, "tables/coup_matrix.csv")


# PCA ---------------------------------------------------------------------

# How Many Components?
ev <- eigen(cor(coup)) # get eigenvalues
ap <- parallel(subject = nrow(coup),
               var = ncol(coup),
               rep = 10000,
               quantile = 0.05)
nS <- nScree(x = ev$values, aparallel = ap$eigen$qevpea)
png("images/coup_scree-plot.png", width = 14, height = 7, units = "in", res = 300,
    type = "cairo-png", bg = "transparent")
plotnScree(nS)
dev.off()

# PCA
pca_coup <- principal(cor(coup), nfactors = 4, scores = T,
                      rotate = "varimax")
print(pca_coup, digits = 2, cut = 0.4)
# Export PCA to CSV
write.csv2(pca_coup$loadings, "tables/pca_coup.csv")
write.csv2(pca_coup$Vaccounted, "tables/variance_accounted_coup.csv")


# Network Analysis --------------------------------------------------------

# Export Factor ID for every variable
# It is important to use absolute values because of negative loadings
df <- data.frame(unclass(pca_coup$loadings), stringsAsFactors = F)
factors <- data.frame(
  "ID" = rownames(df),
  "factor" = apply(df[1:ncol(df)], 1, function(x) colnames(df)[which.max(abs(x))]),
  stringsAsFactors = F)

# Creating network using igraph
coup <- read.csv2("tables/coup_matrix.csv", row.names = 1) # if you need to load network
g <- graph_from_adjacency_matrix(as.matrix(coup), mode = "undirected",
                                 weighted = T, diag = F)
summary(g) #check graph
V(g)$name # check vertex

# Vertex Attributes
V(g)$ID <- rownames(factors)
V(g)$factor <- factors$factor
V(g)$degree <- degree(g, normalized = F)
V(g)$Ndegree <- degree(g, normalized = T)
V(g)$eigen_centrality <- eigen_centrality(g, directed = F)
V(g)$betweeness <- betweenness(g, directed = F)
V(g)$Nbetweeness <- betweenness(g, directed = F, normalized = T)
V(g)$closeness <- closeness(g)

write.csv2(as.data.frame(vertex_attr(g)), "tables/coup_vertex_attributes.csv")

# Subnetworks
sub_df <- data.frame()
ties_between_group <- mixingmatrix(asNetwork(g), "factor")
for (i in unique(na.omit(V(g)$factor))){
  new_g <- induced_subgraph(g, which(V(g)$factor==as.character(i)))
  total_size <- length(V(g))
  size <- length(V(new_g))
  centralization_degree <- centr_degree(new_g)$centralization
  sub_density <- edge_density(new_g, loops = F)
  sub_cohesion_igraph <- cohesion(new_g)
  total_ties_between_factors <-  sum(ties_between_group$matrix[which(rownames(ties_between_group$matrix) %in% as.character(i)),
                                                               -which(colnames(ties_between_group$matrix) %in% as.character(i))])
  possible_ties_between_factors <- size * (total_size - size)
  cohesion_manual <- total_ties_between_factors / possible_ties_between_factors
  transitivity <- transitivity(new_g) # clustering coefficient
  dat <- data.frame("factor" = as.factor(i),
                    "total_size_network" = total_size,
                    "size"= size,
                    "centralization_degree" = centralization_degree,
                    "cohesion" = sub_cohesion_igraph,
                    "total_ties_between_factors" = total_ties_between_factors,
                    "possible_ties_between_factors" = possible_ties_between_factors,
                    "cohesion_manual" = cohesion_manual,
                    "density" = sub_density,
                    "transitivity" = transitivity)
  sub_df <- rbind(sub_df, dat)
}
write.csv2(sub_df, "tables/coup_subnetwork_stats.csv")

# Exporting to DOT (This is the best to Gephi)
write_graph(g, "data/coup_network.dot", format = "dot")


# Plot Network ------------------------------------------------------------

# Weighted Distance
dist <- distances(g, algorithm = "dijkstra")

# Plot MDS
as_tbl_graph(g) %>% 
  ggraph(layout = "mds", dist = dist) +
  geom_edge_link(aes(alpha = stat(index)),show.legend = F, check_overlap = T) +
  geom_node_point(aes(size = degree, shape = as.factor(factor))) +
  geom_node_label(aes(label = ID, size = 8), repel = T, show.legend = F, label.size = 0.1, ) +
  theme_graph() +
  theme(legend.position = "bottom") + 
  scale_shape_manual(name = "factor", 
                     labels = c("RC1" = "1", "RC2" = "2", "RC3" = "3", "RC4" = "4"),
                     values = c(0, 1, 2, 3))
ggsave("images/coup_ggraph_mds.png", dpi = 300, 
       width = 20, height = 14, limitsize = F)

# Plot KK
as_tbl_graph(g) %>% 
  ggraph(layout = "kk") +
  geom_edge_link(aes(alpha = stat(index)),show.legend = F, check_overlap = T) +
  geom_node_point(aes(size = degree, shape = as.factor(factor))) +
  geom_node_label(aes(label = ID, size = 8), repel = T, show.legend = F, label.size = 0.1, ) +
  theme_graph() +
  theme(legend.position = "bottom") + 
  scale_shape_manual(name = "factor", 
                     labels = c("RC1" = "1", "RC2" = "2", "RC3" = "3", "RC4" = "4"),
                     values = c(0, 1, 2, 3))
ggsave("images/coup_ggraph_kk.png", dpi = 300, 
       width = 20, height = 14, limitsize = F)

# Plot FR
as_tbl_graph(g) %>% 
  ggraph(layout = "fr") +
  geom_edge_link(aes(alpha = stat(index)),show.legend = F, check_overlap = T) +
  geom_node_point(aes(size = degree, shape = as.factor(factor))) +
  geom_node_label(aes(label = ID, size = 8), repel = T, show.legend = F, label.size = 0.1, ) +
  theme_graph() +
  theme(legend.position = "bottom") + 
  scale_shape_manual(name = "factor", 
                     labels = c("RC1" = "1", "RC2" = "2", "RC3" = "3", "RC4" = "4"),
                     values = c(0, 1, 2, 3))
ggsave("images/coup_ggraph_fr.png", dpi = 300, 
       width = 20, height = 14, limitsize = F)
