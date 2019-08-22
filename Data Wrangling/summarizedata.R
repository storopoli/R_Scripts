############### SUMMARIZE DATA  #####################

####INSTRUCTIONS####
#group by choose which variables match you will choose to sum observations
#you can use mean sum sd min max n_distinct

#you can also insert arrange(desc(var)) to arrange by the more var to the less var values

library(tidyverse)
library(dplyr)
summdataset <- dataset %>%
  group_by(VAR1, VAR2,VAR3) %>%
  dplyr::summarize(count = n(),
                   # average VAR4:
                   AVG_VAR4 = mean(VAR4, na.rm = TRUE),
                   AVG_VAR5 = mean(VAR5, na.rm = TRUE)#,
                   #arrange(desc(VAR))
  )

## Using Skim Package to see database
library(skimr)
skim(dataset) %>% skimr::kable()

##Using Summary Tools
library(summarytools)
write.csv2(summarytools::descr(dataset, transpose = TRUE), file = "summary.csv")
