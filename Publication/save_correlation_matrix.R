#' save_correlation_matrix
#' Creates and save to file a fully formatted correlation matrix, using `correlation_matrix` and `Hmisc::rcorr` in the backend
#' @param df dataframe; passed to `correlation_matrix`
#' @param filename either a character string naming a file or a connection open for writing. "" indicates output to the console; passed to `write.csv`
#' @param ... any other arguments passed to `correlation_matrix`
#'
#' @return NULL
#'
#' @examples
#' `save_correlation_matrix(df = iris, filename = 'iris-correlation-matrix.csv')`
#' `save_correlation_matrix(df = mtcars, filename = 'mtcars-correlation-matrix.csv', digits = 3, use = 'lower')`
save_correlation_matrix = function(df, filename, ...) {
  return(write.csv2(correlation_matrix(df, ...), file = filename))
}
