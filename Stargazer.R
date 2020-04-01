##https://www.jakeruss.com/cheatsheets/stargazer/##

library(stargazer)

#Descriptive Statistics####
head(Base_195[myvars])
stargazer(as.data.frame(Base_195[myvars]), type="html", out = "sum.html", summary = T, digits = 2,
          align = T)

#Regression Model####

stargazer(lm.fitcontrole, lm.fit, title="Resultados da Regress?o", 
          align=TRUE, type = "html", out = "reg.html",
          dep.var.labels   = "Nota RUF",
          covariate.labels = c("Docentes Mestres", "Docentes Especialistas",
                               "Docentes Tempo Parcial", "Docentes Horistas",
                               "Alunos", "Tradi??o", "Voca??o de Pesquisa",
                               "Cursos de Stricto", "Cursos EAD", "Receita",
                               "P?blica", "Capital", "Medicina", "Regi?o CO", "Regi?o N",
                               "Regi?o NE", "Regi?o S", "Regi?o SE", "Constante"),
          column.labels = c("Modelo 1", "Modelo 2"), model.names = F, initial.zero = F,
          coef = list(lmfitbetacontrole$standardized.coefficients, lmfitbeta$standardized.coefficients),
          report = "vc*", apply.coef = exp  # log odds
)

#Correlation Matrix####
library(psych)
lowerCor(Base_195[myvars])
correlation.matrix <- cor(Base_195[myvars])
stargazer(correlation.matrix, type="html", out = "cor.html")

#Correlation Matrix v2
mcor<-round(cor(Base_195[myvars]),2)
# Hide upper triangle
upper<-mcor
upper[upper.tri(mcor)]<-""
upper<-as.data.frame(upper)
upper
#Using xtable
library(xtable)
print(xtable(upper), type="html", file = "cor.html")
#Combine matrix of correlation coefficients and significance levels
# x is a matrix containing the data
# method : correlation method. "pearson"" or "spearman"" is supported
# removeTriangle : remove upper or lower triangle
# results :  if "html" or "latex"
# the results will be displayed in html or latex format
corstars <-function(x, method=c("pearson", "spearman"), removeTriangle=c("upper", "lower"),
                    result=c("none", "html", "latex")){
  #Compute correlation matrix
  require(Hmisc)
  require(xtable)
  x <- as.matrix(x)
  correlation_matrix<-rcorr(x, type=method[1])
  R <- correlation_matrix$r # Matrix of correlation coeficients
  p <- correlation_matrix$P # Matrix of p-value 
  
  ## Define notions for significance levels; spacing is important.
  mystars <- ifelse(p < .0001, "****", ifelse(p < .001, "*** ", ifelse(p < .01, "**  ", ifelse(p < .05, "*   ", "    "))))
  
  ## trunctuate the correlation matrix to two decimal
  R <- format(round(cbind(rep(-1.11, ncol(x)), R), 2))[,-1]
  
  ## build a new matrix that includes the correlations with their apropriate stars
  Rnew <- matrix(paste(R, mystars, sep=""), ncol=ncol(x))
  diag(Rnew) <- paste(diag(R), " ", sep="")
  rownames(Rnew) <- colnames(x)
  colnames(Rnew) <- paste(colnames(x), "", sep="")
  
  ## remove upper triangle of correlation matrix
  if(removeTriangle[1]=="upper"){
    Rnew <- as.matrix(Rnew)
    Rnew[upper.tri(Rnew, diag = TRUE)] <- ""
    Rnew <- as.data.frame(Rnew)
  }
  
  ## remove lower triangle of correlation matrix
  else if(removeTriangle[1]=="lower"){
    Rnew <- as.matrix(Rnew)
    Rnew[lower.tri(Rnew, diag = TRUE)] <- ""
    Rnew <- as.data.frame(Rnew)
  }
  
  ## remove last column and return the correlation matrix
  Rnew <- cbind(Rnew[1:length(Rnew)-1])
  if (result[1]=="none") return(Rnew)
  else{
    if(result[1]=="html") print(xtable(Rnew), type="html")
    else print(xtable(Rnew), type="latex") 
  }
} 
corstars(Base_195[myvars], result="html")



