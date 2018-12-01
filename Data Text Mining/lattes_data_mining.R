library(dplyr)
library(stringr)
library(rvest)

#insert LATTES URL
url <- 'http://lattes.cnpq.br/2281909649311607'
webpage <- read_html(url)

#only complete articles
prod_html <- html_nodes(webpage, '#artigos-completos')
prod <- html_text(prod_html)
#remove first duplicate author
prod <- gsub("\n","",prod)

#spliting as generting a df
prod_data <- as.data.frame(str_split(prod, "\\s\\d{1,2}\\.\\s"))
prod_data <- as.data.frame(prod_data[-1,])
write.csv(prod_data, file='prod_data.csv')

#removing first line duplicates
prod_data <- data.frame(lapply(prod_data, function(x){
  gsub(".*\\.\\d{4}", "", x)
}))
prod_data <- data.frame(lapply(prod_data, function(x){
  gsub("\\w*\\,\\s\\w*\\s\\w*\\d{4}", "", x)
}))
