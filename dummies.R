################## UNDERSTAND YOUR FACTOR VARIABLE BEFORE CREATE DUMMIES ################## 
install.packages("prettyR")
library(prettyR)
describe.factor(dataset$var,varname="varname",horizontal=FALSE,decr.order=TRUE) #frequency count
barplot(prop.table(table(dataset$var))) #histogram


#### SOMETIMES YOU NEED TO CONVERT VARIABLES TO FACTOR #############
dataset$newvar <- as.factor(dataset$oldvar)


##FAST DUMMIES https://www.rdocumentation.org/packages/fastDummies/versions/0.1.2
#### INSTRUCTIONS ####

#Replace datasetoriginal and datasetdummy
#Assign which columns to be dummy in select_columns
#You may find it easier to assign if you attach the datasetoriginal


install.packages("fastDummies")
library(fastDummies)
dummy_rows()
datasetdummy <- dummy_cols(datasetoriginal,select_columns = c("VAR1","VAR2"))

################## COBALT PACKAGE ################## 
install.packages("cobalt")
library(cobalt)
splitfactor(dataset, varname, replace = F, sep = "_", drop.first = F)

## replace 
# Whether to replace the original variable(s) with the new variable(s) 
# (TRUE) or the append the newly created variable(s) to the end of the data set (FALSE).

## drop.first
# Whether to drop the first dummy created for each factor. 
# If "if2", will only drop the first category if the factor has exactly two levels. 
# The default is to always drop the first dummy (TRUE).

## drop.na
# if NAs are present in the variable, how to handle them. 
# If TRUE, no new dummy will be created for NA values, 
# but all created dummies will have NA where the original variable was NA. 
# If FALSE, NA will be treated like any other factor level, given its own column, 
# and the other dummies will have a value of 0 where the original variable is NA.