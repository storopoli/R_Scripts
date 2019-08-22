kmo_optimal_solution <- function(df){
  source("kmo_function.R")
  removed <- c()
  results <- kmo(df)
  while (any(results$individual < 0.5)){
    column <- sprintf(rownames(results$individual)[which.min(apply(results$individual,MARGIN=1,min))])
    #row <- match(column,names(df))
    #row <- as.numeric(gsub("([0-9]+).*$", "\\1", row))
    removed <- c(removed, column)
    df <- df[, !(colnames(df) %in% column), drop=FALSE]
    #df <- df[-row, ]
    #rownames(df) <- NULL 
    results <- kmo(df)
  }
  
  #write.csv(results$individual, "kmo_individual.csv")
  
  return(list(
    df = df,
    removed = removed,
    results = results))

}

