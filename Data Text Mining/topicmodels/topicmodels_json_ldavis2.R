# Top 10 terms per topic
Terms <- terms(ldaOut, 10)

#' Convert the output of a topicmodels Latent Dirichlet Allocation to JSON
#' for use with LDAvis. After you just call it with serVis()
#'
#' @param fitted Output from a topicmodels \code{LDA} model.
#' @param doc_term The document term matrix used in the \code{LDA}
#' model. This should have been created with the tm package's
#' \code{DocumentTermMatrix} function.
#'
#' @seealso \link{LDAvis}.
#' @export

topicmodels_json_ldavis2 <- function(fitted, doc_term){
  require(LDAvis)
  require(slam)
  
  # Find required quantities
  phi <- as.matrix(posterior(fitted)$terms)
  theta <- as.matrix(posterior(fitted)$topics)
  vocab <- colnames(phi)
  term_freq <- slam::col_sums(doc_term)
  
  # Convert to json
  json_lda <- LDAvis::createJSON(phi = phi, theta = theta,
                                 vocab = vocab,
                                 doc.length = as.vector(table(doc_term$i)),
                                 term.frequency = term_freq)
  
  return(json_lda)
}


json_res <- topicmodels_json_ldavis(ldaOut, docs, dtm)

serVis(json_res)
