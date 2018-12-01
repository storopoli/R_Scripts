############### RECODING #####################
dataset$newvar <- ifelse(dataset$var==150, 100, ifelse(dataset$var==350, 300, NA))

dataset$newvar <- ifelse(dataset$var==1, "branco",
                            ifelse(dataset$var<=2 | dataset$var>=5 , "preto",
                                   NA))
dataset$newvar <- ifelse(dataset$var==1, "branco",
                         ifelse(dataset$var<=2 & dataset$var>=5 , "preto",
                                NA))

############ ASSIGN NA ##########################
dataset$var[dataset$var==0] <- NA

############### ASSIGN FACTORS ############### 
myfactors <- c("VAR1", "VAR2", "VAR3")
mydata[myfactors] <- lapply(mydata[myfactors], factor)