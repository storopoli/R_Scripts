# This scripts depends on curl and 7zip

library(dplyr)
library(arrow)
library(curl)
library(utils)
library(glue)
library(stringr)


# Censo 2019 --------------------------------------------------------------
year <- "2019"

url <- glue("http://download.inep.gov.br/microdados/microdados_educacao_superior_{year}.zip")

# create data directory if doesn't exist
ifelse(!dir.exists(file.path("data")), dir.create(file.path("data")), F)
ifelse(!dir.exists(file.path(glue("data/{year}"))), dir.create(file.path(glue("data/{year}"))), F)

# download and unzip file
dest_file <- glue("data/{year}.zip")
curl::curl_download(url, dest_file, quiet = F)
system2("7z", glue("e {dest_file} *.CSV -odata/{year} -r")) #-l list
system2("rm", dest_file)


# Censo 2018 --------------------------------------------------------------
year <- "2018"

url <- glue("http://download.inep.gov.br/microdados/microdados_educacao_superior_{year}.zip")

# create data directory if doesn't exist
ifelse(!dir.exists(file.path("data")), dir.create(file.path("data")), F)
ifelse(!dir.exists(file.path(glue("data/{year}"))), dir.create(file.path(glue("data/{year}"))), F)

# download and unzip file
dest_file <- glue("data/{year}.zip")
curl::curl_download(url, dest_file, quiet = F)
system2("7z", glue("e {dest_file} *.CSV -odata/{year} -r")) #-l list
system2("rm", dest_file)


# Censo 2017 --------------------------------------------------------------
year <- "2017"

url <- glue("http://download.inep.gov.br/microdados/microdados_educacao_superior_{year}.zip")

# create data directory if doesn't exist
ifelse(!dir.exists(file.path("data")), dir.create(file.path("data")), F)
ifelse(!dir.exists(file.path(glue("data/{year}"))), dir.create(file.path(glue("data/{year}"))), F)

# download and unzip file
dest_file <- glue("data/{year}.zip")
curl::curl_download(url, dest_file, quiet = F)
system2("7z", glue("e {dest_file} *.zip -odata/{year} -r")) #-l list

for (file in list.files(glue("data/{year}"))) {
  system2("7z", paste0("x ", glue("data/{year}/"), file, glue(" -odata/{year}")))
  system2("rm", glue("data/{year}/{file}"))
}

system2("rm", dest_file)


# Censo 2016 --------------------------------------------------------------
year <- "2016"
url <- glue("http://download.inep.gov.br/microdados/microdados_censo_superior_{year}.zip")

# create data directory if doesn't exist
ifelse(!dir.exists(file.path("data")), dir.create(file.path("data")), F)
ifelse(!dir.exists(file.path(glue("data/{year}"))), dir.create(file.path(glue("data/{year}"))), F)

# download and unzip file
dest_file <- glue("data/{year}.zip")
curl::curl_download(url, dest_file, quiet = F)
system2("7z", glue("e {dest_file} *.rar -odata/{year} -r")) #-l list

for (file in list.files(glue("data/{year}"))) {
  system2("7z", paste0("x ", glue("data/{year}/"), file, glue(" -odata/{year}")))
  system2("rm", glue("data/{year}/{file}")) 
}

system2("rm", dest_file)


# Censo 2015 --------------------------------------------------------------
year <- "2015"
url <- glue("http://download.inep.gov.br/microdados/microdados_censo_superior_{year}.zip")

# create data directory if doesn't exist
ifelse(!dir.exists(file.path("data")), dir.create(file.path("data")), F)
ifelse(!dir.exists(file.path(glue("data/{year}"))), dir.create(file.path(glue("data/{year}"))), F)

# download and unzip file
dest_file <- glue("data/{year}.zip")
curl::curl_download(url, dest_file, quiet = F)
system2("7z", glue("e {dest_file} *.rar -odata/{year} -r")) #-l list

for (file in list.files(glue("data/{year}"))) {
  system2("7z", paste0("x ", glue("data/{year}/"), file, glue(" -odata/{year}")))
  system2("rm", glue("data/{year}/{file}"))
}

system2("rm", dest_file)


# Arrow -------------------------------------------------------------------
ifelse(!dir.exists(file.path("data/parquet")), dir.create(file.path("data/parquet")), F)

# alunos
data_type <- "aluno"
ifelse(!dir.exists(file.path(glue("data/parquet/{data_type}"))), dir.create(file.path(glue("data/parquet/{data_type}"))), F)
files <- list.files(pattern = glob2rx(paste0("*", str_to_upper(data_type), "*")), recursive = T)
for (file in files) {
  year <- str_extract(file, "\\d{4}")
  ifelse(!dir.exists(file.path(glue("data/parquet/{data_type}/{year}"))), dir.create(file.path(glue("data/parquet/{data_type}/{year}"))), F)
  temp <- read_delim_arrow(file, "|")
  write_parquet(temp, glue("data/parquet/{data_type}/{year}/data.parquet"))
  rm(temp)
  gc()
}

# cursos
data_type <- "curso"
ifelse(!dir.exists(file.path(glue("data/parquet/{data_type}"))), dir.create(file.path(glue("data/parquet/{data_type}"))), F)
files <- list.files(pattern = glob2rx(paste0("*", str_to_upper(data_type), "*")), recursive = T)
for (file in files) {
  year <- str_extract(file, "\\d{4}")
  ifelse(!dir.exists(file.path(glue("data/parquet/{data_type}/{year}"))), dir.create(file.path(glue("data/parquet/{data_type}/{year}"))), F)
  temp <- read_delim_arrow(file, "|")
  write_parquet(temp, glue("data/parquet/{data_type}/{year}/data.parquet"))
  rm(temp)
  gc()
}

# docentes
data_type <- "docente"
ifelse(!dir.exists(file.path(glue("data/parquet/{data_type}"))), dir.create(file.path(glue("data/parquet/{data_type}"))), F)
files <- list.files(pattern = glob2rx(paste0("*", str_to_upper(data_type), "*")), recursive = T)
for (file in files) {
  year <- str_extract(file, "\\d{4}")
  ifelse(!dir.exists(file.path(glue("data/parquet/{data_type}/{year}"))), dir.create(file.path(glue("data/parquet/{data_type}/{year}"))), F)
  temp <- read_delim_arrow(file, "|")
  write_parquet(temp, glue("data/parquet/{data_type}/{year}/data.parquet"))
  rm(temp)
  gc()
}

# local de oferta
data_type <- "local_oferta"
ifelse(!dir.exists(file.path(glue("data/parquet/{data_type}"))), dir.create(file.path(glue("data/parquet/{data_type}"))), F)
files <- list.files(pattern = glob2rx(paste0("*", str_to_upper(data_type), "*")), recursive = T)
for (file in files) {
  year <- str_extract(file, "\\d{4}")
  ifelse(!dir.exists(file.path(glue("data/parquet/{data_type}/{year}"))), dir.create(file.path(glue("data/parquet/{data_type}/{year}"))), F)
  temp <- read_delim_arrow(file, "|")
  write_parquet(temp, glue("data/parquet/{data_type}/{year}/data.parquet"))
  rm(temp)
  gc()
}

# ies
data_type <- "ies"
ifelse(!dir.exists(file.path(glue("data/parquet/{data_type}"))), dir.create(file.path(glue("data/parquet/{data_type}"))), F)
files <- list.files(pattern = glob2rx(paste0("*", str_to_upper(data_type), "*")), recursive = T)
for (file in files) {
  year <- str_extract(file, "\\d{4}")
  ifelse(!dir.exists(file.path(glue("data/parquet/{data_type}/{year}"))), dir.create(file.path(glue("data/parquet/{data_type}/{year}"))), F)
  temp <- read_delim_arrow(file, "|")
  write_parquet(temp, glue("data/parquet/{data_type}/{year}/data.parquet"))
  rm(temp)
  gc()
}

# Clean Files -------------------------------------------------------------
rm_files <- grep("parquet", list.dirs("data/"), value = T, invert = T)
system2("rm", paste("-rf", rm_files[2:length(rm_files)]))
