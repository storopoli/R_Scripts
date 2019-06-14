library(tm)
library(ggplot2)
library(wordcloud)

# Data Pre-Processing
# https://eight2late.wordpress.com/2015/05/27/a-gentle-introduction-to-text-mining-using-r/ #

# Create Corpus
docs <- Corpus(DirSource(getwd()))

# To inspect any text type this in the console
writeLines(as.character(docs[[1]]))

# Pre-processing
getTransformations()

# Create the toSpace content transformer
toSpace <- content_transformer(function(x, pattern) {return (gsub(pattern, " ", x))})

# Remove html
removeURL <- function(x) gsub("http[^[:space:]]*", "", x)

# Removing “non-standard” punctuation marks
docs <- tm_map(docs, toSpace, "-")
docs <- tm_map(docs, toSpace, ":")
docs <- tm_map(docs, toSpace, "’")
docs <- tm_map(docs, toSpace, "‘")
docs <- tm_map(docs, toSpace, " -")

# Remove punctuation – replace punctuation marks with " "
docs <- tm_map(docs, removePunctuation)

# Transform to lower case (need to wrap in content_transformer)
docs <- tm_map(docs,content_transformer(tolower))

# Strip digits (std transformation, so no need for content_transformer)
docs <- tm_map(docs, removeNumbers)

# Remove stopwords using the standard list in tm
docs <- tm_map(docs, removeWords, stopwords("english"))

# Strip whitespace (cosmetic?)
docs <- tm_map(docs, stripWhitespace)

# Stemming
docs <- tm_map(docs, stemDocument)

# Creating Document-term Matrix
dtm <- DocumentTermMatrix(docs)
inspect(dtm)

# frequency of occurrence of each word in the corpus
freq <- colSums(as.matrix(dtm))
#create sort order (descending)
ord <- order(freq,decreasing=TRUE)

#inspect most frequently occurring terms
freq[head(ord)]

#inspect least frequently occurring terms
freq[tail(ord)]   

#Finding frequent terms
findFreqTerms(dtm,lowfreq=80)

# Frequency Histogram
wf <- data.frame(term=names(freq),occurrences=freq)
p <- ggplot(subset(wf, freq>500), aes(term, occurrences))
p <- p + geom_bar(stat="identity")
p <- p + ggtitle("Frequency in Documents over 500 occurrences")
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))
p

#wordcloud
#setting the same seed each time ensures consistent look across clouds
set.seed(42)
#limit words by specifying min frequency
wordcloud(names(freq),freq, min.freq=100)
#…add color
wordcloud(names(freq),freq,min.freq=200,colors=brewer.pal(6,"Dark2"))