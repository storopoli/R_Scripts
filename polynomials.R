x <- 1:100
par(mfrow=c(1, 2))
matplot(x, poly(x, 4), type='l', main="poly(x, 4)")
matplot(x, poly(x, 4, raw=TRUE), type='l', main="poly(x, 4, raw=TRUE)")

head(poly(x, 4, raw=TRUE))
head(poly(x, 4, raw=FALSE))
