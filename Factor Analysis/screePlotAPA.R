screePlotAPA <- function(data, rep=1000, cent=.05) {
  library(nFactors)
  library(ggplot2)
  ev <- eigen(cor(data)) # get eigenvalues
  eig <- ev$values # eigenvalues
  ap <- parallel(subject = nrow(data), var = ncol(data), rep = rep, cent = cent)
  eig_pa <- ap$eigen$qevpea # The 95 centile
  nS <- nScree(x=ev$values, aparallel=eig_pa, model = "components") 
  xlab = "Components"
  ylab = "Eigenvalues"
  main = "Parallel Scree Test"
  df <- data.frame(eig, eig_pa)
  k <- 1:length(eig)
  # Only plotting Factors to 25% of the sample size
  n <- round(length(eig)/4)
  #APA theme
  apatheme = theme_bw() +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          panel.border = element_blank(),
          text = element_text(family='Arial'),
          legend.title = element_blank(),
          legend.position = c(.7, .8),
          axis.line.x = element_line(color = 'black'),
          axis.line.y = element_line(color = 'black'))
  # Plot
  par(col = 1, pch = 1)
  par(mfrow = c(1, 1))
#Use data from eigendat. Map number of factors to x-axis, eigenvalue to y-axis, and give different data point shapes depending on whether eigenvalue is observed or simulated
  p <- ggplot(df[1:n,], aes(x=k[1:n])) +
    #Add lines connecting data points
    geom_line(mapping = aes(y=eig[1:n]), size=1) +
    geom_point(mapping = aes(y=eig[1:n]), size=3, shape=16) +
    geom_line(mapping = aes(y=eig_pa[1:n]), size=1, linetype = "dotdash") +
    geom_point(mapping = aes(y=eig_pa[1:n]), size=3, shape=1) +
    #Label the y-axis 'Eigenvalue'
    ylab('Eigenvalue') +
    #Label the x-axis 'Factor Number', and ensure that it ranges from 1-max # of factors, increasing by one with each 'tick' mark.
    xlab('Factor/Component Number') +
    #Add vertical line indicating parallel analysis suggested max # of factors to retain
    geom_vline(xintercept = nS$Components$nparallel, linetype = 'dashed') +
    #Add X limit to 25% of number of factors
    xlim(1, n) +
    #Apply our apa-formatting theme
    apatheme
  # How many Factors?
  cat("Parallel Analysis (n = ", nS$Components$nparallel, ")", sep = "")
  return(p)
}
