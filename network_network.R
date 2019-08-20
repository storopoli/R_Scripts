###### WORK IN PROGRESS ######

# Importing Data
df <- read.csv2("coup-min-3-nodes.csv", row.names = 1)
factor <- read.csv2("node-factor.csv", stringsAsFactors = F)

# Creating a adjacency matrix
g <- network(df, matrix.type = "adjacency", directed = F, loops = F)
print(g) # summary
network.vertex.names(g)
plot(g)

# Adding node (vertex) attributes
set.vertex.attribute(g, "factor", value = factor$Factor)
get.vertex.attribute(g, "factor")
g <- set_vertex_attr(g, "factor", index = factor$ID, value = factor$Factor)

E(g)  # edges

g$gal
