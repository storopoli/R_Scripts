communalities_optimal_solution <- function(df, nfactors, rotate="varimax"){
  library(psych)
  source("how_many_factors.R")
  source("printLoadings.R")
  removed <- c()
  results <- principal(df, nfactors = nfactors, rotate = rotate, scores = T)
  #results$communality <- as.data.frame(results$communality)
  while (any(as.data.frame(as.data.frame(results$communality)) < 0.5)){
    message(sprintf("There is still an individual communality value below 0.5: "), 
            rownames(as.data.frame(results$communality))[which.min(apply(as.data.frame(results$communality),MARGIN=1,min))]," - ",
            min(as.data.frame(results$communality)))
    column <- sprintf(rownames(as.data.frame(results$communality))[which.min(apply(as.data.frame(results$communality),MARGIN=1,min))])
    removed <- c(removed, column)
    #row <- match(column,names(df))
    #row <- as.numeric(gsub("([0-9]+).*$", "\\1", row))
    df <- df[, !(colnames(df) %in% column), drop=FALSE]
    #df <- df[-row, ]
    #rownames(df) <- NULL 
    results <- principal(df, nfactors = nfactors, scores = T)
  }
  
  #write.csv(results$communality, "communalities_individual.csv")
  how_many_factors(df)
  
  loadings <- as.table(printLoadings(results$loadings))
  
  fa.diagram(results, digits = 3, cut = 0.4, sort = T) # Diagram of Factors, items and loadings
  
  plot(results)
  
  return(list(
    df = df,
    removed = removed,
    loadings = loadings,
    results = results))
}
