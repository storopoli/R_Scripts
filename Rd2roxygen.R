library(Rd2roxygen)

# we can specify the roxygen comments prefix (#' by default)
rd.file <- "~/Desktop/nFactors/man/corFA.rd"
options(roxygen.comment = "#' ")
str(info <- parse_file(rd.file))

# parse_and_save() combines these two steps
cat(create_roxygen(info), sep = "\n")
