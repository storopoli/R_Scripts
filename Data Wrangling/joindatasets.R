############### JOIN DATASET #####################
#### INSTRUCTIONS ####
# you can use the pipe %>% to select variables to copy from the dataset2
# if you want to copy the whole dataset remove the pipe %>% from the dataset2 and insert a comma ,
# If you need to match one variable use just by VARCOMMON
# If you need to match more than one variable use c()


install.packages(dplyr)
library(dplyr)
datasetnew <- dplyr::left_join(dataset1, dataset2 %>% select(VAR1, VAR2, VAR3, VAR4, VAR5),
                               by=c("VARCOMMON1","VARCOMMON2"),
                               copy=TRUE)