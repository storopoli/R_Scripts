# This scripts depends on curl and 7zip

library(dplyr)
library(arrow)
library(curl)
library(utils)
library(glue)
library(stringr)



# Get Data ----------------------------------------------------------------
# create data directory if doesn't exist
ifelse(!dir.exists(file.path("data")), dir.create(file.path("data")), F)
urls <- c("https://download.inep.gov.br/microdados/Enade_Microdados/microdados_enade_2019.zip",
          "https://download.inep.gov.br/microdados/Enade_Microdados/microdados_enade_2018.zip",
          "https://download.inep.gov.br/microdados/Enade_Microdados/microdados_Enade_2017_portal_2018.10.09.zip",
          "https://download.inep.gov.br/microdados/Enade_Microdados/microdados_enade_2016_versao_28052018.zip",
          "https://download.inep.gov.br/microdados/Enade_Microdados/microdados_enade_2015.zip")
for (url in urls) {
  # download and unzip file
  dest_file <- glue("data/{year}.zip")
  curl::curl_download(url, dest_file, quiet = F)
  system2("7z", glue("e {dest_file} *.txt -odata/ -r")) #-l list
  system2("rm", dest_file)
}


# Arrow -------------------------------------------------------------------
files <- list.files(pattern = "*.txt", recursive = T)
ifelse(!dir.exists(file.path("data/parquet")), dir.create(file.path("data/parquet")), F)

for (file in files) {
  year <- str_extract(file, "\\d{4}")
  ifelse(!dir.exists(file.path(glue("data/parquet/{year}"))), dir.create(file.path(glue("data/parquet/{year}"))), F)
  temp <- read_delim_arrow(file, ";")
  write_parquet(temp, glue("data/parquet/{year}/data.parquet"))
  rm(temp)
  gc()
}


# Clean Files -------------------------------------------------------------
system2("rm", paste(files))
