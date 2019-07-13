communalities_optimal_solution <- function(data, nfactors){
  library(psych)
  df <- read.csv(data)
  results <- principal(df, nfactors = nfactors)
  results$communality <- as.data.frame(results$communality)
  while (any(results$communality < 0.5)){
    message(sprintf("There is still an individual communality value below 0.5: "), 
            rownames(results$communality)[which.min(apply(results$communality,MARGIN=1,min))]," - ",
            min(results$communality))
    column <- sprintf(rownames(results$communality)[which.min(apply(results$communality,MARGIN=1,min))])
    #row <- match(column,names(df))
    #row <- as.numeric(gsub("([0-9]+).*$", "\\1", row))
    df <- df[, !(colnames(df) %in% column), drop=FALSE]
    #df <- df[-row, ]
    #rownames(df) <- NULL 
    results <- principal(df, nfactors = nfactors)
    results$communality <- as.data.frame(results$communality)
  }
  
  #write.csv(results$communality, "communalities_individual.csv")
  
  return(list(
    df = df,
    results = results))
  
}
