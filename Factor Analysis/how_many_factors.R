how_many_factors <- function(df, rep=1000, cent=0.05){
  # Determining the Number of Factors to Extract
  library(nFactors)
  ev <- eigen(cor(df)) # get eigenvalues
  ap <- parallel(subject=nrow(df),var=ncol(df),
                 rep=rep,cent=cent)
  nS <- nScree(x = ev$values, aparallel = ap$eigen$qevpea)
  plotnScree(nS)
}
