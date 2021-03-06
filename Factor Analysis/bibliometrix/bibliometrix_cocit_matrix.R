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
library(openxlsx)
set.seed(123)

M <- readRDS("data/all_records.rds")

# Citation Analysis  ---------------------------------------------
# top-cited 
CR <- as_tibble(citations(M, field = "article", sep = ";")$Cited)

total_cit <- sum(CR$n) # total citations (8,775)
lotka <- 0.05 * total_cit # Lotka threshold (439)

CR %>%
  mutate(cum_sum = cumsum(n)) %>% 
  filter(cum_sum <= 439) %>% 
  tail()

top_cited <- CR %>% # 57 top-cited (min 4 citations)
  mutate(cum_sum = cumsum(n)) %>% 
  filter(n >= 4)


write.xlsx(CR, file = "tables/cited_references.xlsx")


# Co-citation -------------------------------------------------------------

# Normalize top-cited to be equal as cocMatrix
reduceRefs<- function(A){
  
  ind=unlist(regexec("*V[0-9]", A))
  A[ind>-1]=substr(A[ind>-1],1,(ind[ind>-1]-1))
  ind=unlist(regexec("*DOI ", A))
  A[ind>-1]=substr(A[ind>-1],1,(ind[ind>-1]-1))
  return(A)
}

Fi <-gsub("DOI;","DOI ",as.character(top_cited$CR))
sep <- ";"
Fi <- strsplit(Fi,sep)
Fi <- lapply(Fi,trim.leading)
Fi <- lapply(Fi,function(l) l<-l[nchar(l)>10])

uniqueField <- unique(unlist(Fi))
uniqueField <- uniqueField[!is.na(uniqueField)]


S <- gsub("\\).*",")",uniqueField)
S <- gsub(","," ",S)
S <- gsub(";"," ",S)
S <- reduceRefs(S)
uniqueField <- unique(trimES(S))
Fi <- lapply(Fi, function(l){
  l <- gsub("\\).*",")",l)
  l <- gsub(","," ",l)
  l <- gsub(";"," ",l)
  l <- l[nchar(l)>0]
  l <- reduceRefs(l)
  l <- trimES(l)
  return(l)
})

# Co-citation Matrix
cocit <- cocMatrix(M, Field = "CR", sep = ";", binary = F)
cocit <- crossprod(cocit, cocit)
dim(cocit)

cocit <- cocit[rownames(cocit) %in% Fi,
               colnames(cocit) %in% Fi]

# fix the diagonal to zero
diag(cocit) <- 0


assertthat::are_equal(colnames(cocit), rownames(cocit))

# Export CSV
write.csv2(as.matrix(cocit), "tables/cocit_matrix.csv")


# PCA ---------------------------------------------------------------------

# How Many Components?
cocit <- as.matrix(cocit)
ev <- eigen(cor(cocit)) # get eigenvalues
ap <- parallel(subject = nrow(cocit),
               var = ncol(cocit),
               rep = 10000,
               quantile = 0.05)
nS <- nScree(x = ev$values, aparallel = ap$eigen$qevpea)
png("images/cocit_scree-plot.png", width = 14, height = 7, units = "in", res = 300,
    type = "cairo-png", bg = "transparent")
plotnScree(nS)
dev.off()

# PCA
pca_cocit <- principal(cor(cocit), nfactors = 3, scores = T,
                       rotate = "varimax")
print(pca_cocit, digits = 2, cut = 0.4)
# Export PCA to CSV
write.csv2(pca_cocit$loadings, "tables/pca_cocit.csv")
write.csv2(pca_cocit$Vaccounted, "tables/variance_accounted_cocit.csv")


# Network Analysis --------------------------------------------------------

# Export Factor ID for every variable
# It is important to use absolute values because of negative loadings
df <- data.frame(unclass(pca_cocit$loadings), stringsAsFactors = F)
factors <- data.frame(
  "ID" = rownames(df),
  "factor" = apply(df[1:ncol(df)], 1, function(x) colnames(df)[which.max(abs(x))]),
  stringsAsFactors = F)



# Creating network using igraph
cocit <- read.csv2("tables/cocit_matrix.csv", row.names = 1) # if you need to load network
g <- graph_from_adjacency_matrix(as.matrix(cocit), mode = "undirected",
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

write.csv2(as.data.frame(vertex_attr(g)), "tables/cocit_vertex_attributes.csv")

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
write.csv2(sub_df, "tables/cocit_subnetwork_stats.csv")

# Exporting to DOT (This is the best to Gephi)
write_graph(g, "data/cocit_network.dot", format = "dot")


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
ggsave("images/cocit_ggraph_mds.png", dpi = 300, 
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
ggsave("images/cocit_ggraph_kk.png", dpi = 300, 
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
ggsave("images/cocit_ggraph_fr.png", dpi = 300, 
       width = 20, height = 14, limitsize = F)
