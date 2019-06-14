library(pdftools)

# Listing Files
files <- list.files(pattern = "pdf$")

# Applying pfd_text function to all listed files
documents <- lapply(files, pdf_text)

# Converting to a sigle list
documents <- ifelse(is.na(documents), NA, sapply(documents, toString))

# Getting all together in a dataframe
corpus_raw <- data.frame("document" = c(),"text" = c())

for (text in 1:length(documents)){
  document_df <- data.frame("document" = paste(gsub(x = files[text], pattern = ".pdf", replacement = "")), "text" = documents[text], stringsAsFactors = FALSE)
  colnames(document_df) <- c("document", "text")
  corpus_raw <- rbind(corpus_raw,document_df)
  rm(document_df)
}

# Saving csv
write.csv(corpus_raw, 'corpus_raw.csv')