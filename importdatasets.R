############### IMPORT DATASET #####################

install.packages("readr")
library(readr)
help("read.csv")
help("read.csv2")
help("read_csv")
help("read_csv2")

#DECIDE WHICH READ.CSV OR READ.CSV2 TO APPLY (ALSO READ_CSV AND READ_CSV2)
dataset <- read_csv2(file="file.csv",sep=",")

## DIFERENCES BETWEEN READ.CSV AND READ.CSV2 (ALSO READ_CSV AND READ_CSV2) ##
##### read.csv
# function (file, header = TRUE, sep = ",", quote = "\"", dec = ".", 
#          fill = TRUE, comment.char = "", ...) 
##### read.csv2
# function (file, header = TRUE, sep = ";", quote = "\"", dec = ",", 
#          fill = TRUE, comment.char = "", ...) 


## Another option is to read in the whole file, but keep only two of the columns, e.g.:
#  read.csv(file = "result1", sep = " ")[ ,1:2]

## skipping the last 3 columns after read
dataset <- dataset[,-3:-1]

#### READ FASTER WITH DATA.TABLE #############
install.packages(data.table)
library(data.table)
help("fread")
dataset <- fread (file="file.csv", sep = ",", dec = ".")

####################### OPTIONS #########################

## sep - The separator between columns.

## dec - The decimal separator as in base

## quote - By default ("\"")

## header - Defaults according to whether every non-empty field on the first data line is type character. 
# If TRUE is supplied, any empty column names are given a default name.

## select - Vector of column names or numbers to keep, drop the rest.

## drop- Vector of column names or numbers to drop, keep the rest.
# =[=

## showProgress - TRUE displays progress on the console if the ETA is greater than 3 seconds.

## stringsAsFactors - Convert all character columns to factors?

## colClasses - colClasses is intended for rare overrides, not for routine use

## na.strings - By default, ",,"

## nrows - 'nrows=0' returns the column names and typed empty columns determined by the large sample
# useful for a dry run of a large file or to quickly check format consistency of a set of files 
# before starting to read any of them

## skip -  the number of lines of the data file to skip before beginning to read data
# useful with nrows for subsetting and them joining together

## key - Character vector of one or more column names which is passed to setkey. 
# It may be a single comma separated string such as key="x,y,z",
# or a vector of names such as key=c("x","y","z"). Only valid when argument data.table=TRUE.
# Where applicable, this should refer to column names given in col.names.

##################### COMBINE ROWS OR COLUMNS #################
help ("cbind")
####  COMBINE COLUMNS ####
cbind(dataset1, dataset2 )
#The row number of the two datasets must be equal
####  COMBINE ROWS ####
Rbind(dataset1, dataset2 )
#The column of the two datasets must be same

##################### READ FROM ZIP OR RAR #################
dataset <- read.table(unz("filename.zip", "filename.txt"), nrows=10, header=T, quote="\"", sep=",", dec = ".")

####### RAR ############
install.packages("readr")
install.packages("devtools")
devtools::install_github("jimhester/archive")
library(archive)
library(readr)
# Read the data back from archive
read_csv(archive_read("filename.zip"), col_types = cols())
# Read a specific file from the archive
read_csv(archive_read(archive("filname.tar.xz"), "specificfile.csv"), col_types = cols())


########################## EXPORT TO CSV ########################## 
install.packages(data.table)
library(data.table)
help("fwrite")
fwrite(dataset, file="file.csv", sep = ",", dec = ".")

########################## EXPORT TO ZIP or RAR ########################## 
install.packages("readr")
install.packages("devtools")
devtools::install_github("jimhester/archive")
library(archive)
library(readr)
write_csv(dataset, archive_write("filename.tar.gz", "filename.csv"))


## Archive file sizes
file.size(c("filename.zip", "filename.tar.gz"))

## Write a few files to the temp directory
write_csv(dataset1, "filename1.csv")
write_csv(dataset2, "filename2.csv")
write_csv(dataset3, "filename3.csv")
# Add them to a new archive
archive_write_files("filenametotal.tar.xz", c("filename1.csv", "filename2.csv", "filename3.csv"))
# View archive contents
a <- archive("filenametotal.tar.xz")
a
#> # A tibble: 3 x 3
#>             path  size                date
#>            <chr> <dbl>              <dttm>
#> 1  filename1.csv  3716 2017-07-28 10:02:12
#> 2  filename2.csv  1281 2017-07-28 10:02:12
#> 3  filename3.csv  2890 2017-07-28 10:02:12
