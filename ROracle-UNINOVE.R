library(DBI)
library(ROracle)
library(dplyr)
library(dbplyr)


# dbplyr ------------------------------------------------------------------

#below are required to make the translation done by dbplyr to SQL produce working Oracle SQL
sql_translate_env.OraConnection <- dbplyr:::sql_translate_env.Oracle
sql_select.OraConnection <- dbplyr:::sql_select.Oracle
sql_subquery.OraConnection <- dbplyr:::sql_subquery.Oracle

# Connection Details ------------------------------------------------------
drv <- dbDriver("Oracle")
host <- '10.113.0.227'
port <- 1536
sid <- 'DB1'  # dev
user <- 'josees'
pass <- Sys.getenv("UNINOVE_PASS")

connect.string <- paste(
  "(DESCRIPTION=",
  "(ADDRESS=(PROTOCOL=tcp)(HOST=", host, ")(PORT=", port, "))",
  "(CONNECT_DATA=(SID=", sid, ")))", sep = "")

con <- dbConnect(drv, username = user,
                 password = pass,
                 dbname = connect.string)

# Query -------------------------------------------------------------------

rs <- dbSendQuery(con, "SELECT * FROM SEU.SEUAAB")
data <- fetch(rs)
data <- as.tbl(data)
