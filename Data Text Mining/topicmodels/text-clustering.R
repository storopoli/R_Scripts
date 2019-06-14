library(cluster)

# Clustering 
# https://eight2late.wordpress.com/2015/07/22/a-gentle-introduction-to-cluster-analysis-using-r/ #

# Convert dtm to matrix
m <- as.matrix(dtm)

# Write as csv file (optional)
write.csv(m,file="dtmdocs.csv")

# Shorten rownames for display purposes
rownames(m) <- paste(substring(rownames(m),1,3),rep("..",nrow(m)),
                     substring(rownames(m), nchar(rownames(m))-12,nchar(rownames(m))-4))

# Compute distance between document vectors
d <- dist(m)

# Run hierarchical clustering using Ward’s method
groups <- hclust(d,method="ward.D")

# Plot dendogram, use hang to ensure that labels fall below tree
plot(groups, hang=-1)

# Cut into 2 subtrees – try 3 and 5
rect.hclust(groups,2)

# K means algorithm, 2 clusters, 100 starting configurations
kfit <- kmeans(d, 2, nstart=100)

# Plot – need library cluster
clusplot(as.matrix(d), kfit$cluster, color=T, shade=T, labels=2, lines=0)

# K-means – determine the optimum number of clusters (elbow method)
# look for “elbow” in plot of summed intra-cluster distances (withinss) as fn of k
wss <- 2:29
for (i in 2:29) wss[i] <- sum(kmeans(d,centers=i,nstart=25)$withinss)
plot(2:29, wss[2:29], type="b", xlab="Number of Clusters",ylab="Within groups sum of squares")