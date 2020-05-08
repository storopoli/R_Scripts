# https://tomaztsql.wordpress.com/2020/04/27/essential-list-of-useful-r-packages-for-data-scientists/

# Loading and importing  data ---------------------------------------------

# Importing from binary files
# Reading from SAS and SPSS
install.packages("Hmisc", dependencies = TRUE)
# Reading from Stata, Systat and Weka
install.packages("foreign", dependencies = TRUE)
# Reading from KNIME
install.packages(c("protr","foreign"), dependencies = TRUE)
# Reading from EXCEL
install.packages(c("readxl","xlsx"), dependencies = TRUE)
# Reading from TXT, CSV
install.packages(c("csv","readr","tidyverse"), dependencies = TRUE)
# Reading from JSON
install.packages(c("jsonLite","rjson","RJSONIO","jsonvalidate"), dependencies = TRUE)
# Reading from AVRO
install.packages("sparkavro", dependencies = TRUE)
# Reading from Parquet file
install.packages("arrow", dependencies = TRUE)
devtools::install_github("apache/arrow/r")
# Reading from XML
install.packages("XML", dependencies = TRUE)

# Importing from ODBC
install.packages(c("odbc", "RODBC"), dependencies = TRUE)

# Importing from SQL Databases 
#Microsoft MSSQL Server
install.packages(c("mssqlR", "RODBC"), dependencies = TRUE)
#MySQL 
install.packages(c("RMySQL","dbConnect"), dependencies = TRUE)
#PostgreSQL
install.packages(c("postGIStools","RPostgreSQL"), dependencies = TRUE)
#Oracle
install.packages(c("ODBC"), dependencies = TRUE)
#Amazon
install.packages(c("RRedshiftSQL"), dependencies = TRUE)
#SQL Lite
install.packages(c("RSQLite","sqliter","dbflobr"), dependencies = TRUE)
#General SQL packages
install.packages(c("RSQL","sqldf","poplite","queryparser"), dependencies = TRUE)


# Manipulating Data -------------------------------------------------------

# Cleaning data
install.packages(c("janitor","outliers","missForest","frequency","Amelia",
                   "diffobj","mice","VIM","Bioconductor","mi",
                   "wrangle"), dependencies = TRUE)
# Dealing with R data types and formats
install.packages(c("stringr","lubridate","glue",
                   "scales","hablar","readr"), dependencies = TRUE)
# Wrangling, subseting and aggregating data
install.packages(c("dplyr","tidyverse","purr","magrittr",
                   "data.table","plyr","tidyr","tibble",
                   "reshape2"), dependencies = TRUE)


# Statistical tests and Sampling Data -------------------------------------

# Statistical tests
install.packages(c("stats","ggpubr","lme4","MASS","car"), 
                 dependencies = TRUE)
# Data Sampling
install.packages(c("sampling","icarus","sampler","SamplingStrata",
                   "survey","laeken","stratification","simPop"), 
                 dependencies = TRUE)


# Statistical Analysis ----------------------------------------------------

# Regression Analysis
install.packages(c("stats","Lars","caret","survival","gam","glmnet",
                   "quantreg","sgd","BLR","MASS","car","mlogit","earth",
                   "faraway","nortest","lmtest","nlme","splines",
                   "sem","WLS","OLS","pls","2SLS","3SLS","tree","rpart"), 
                 dependencies = TRUE)
# Analysis of variance
install.packages(c("caret","rio","car","MASS","FuzzyNumbers",
                   "stats","ez"), dependencies = TRUE)

# Multivariate analysis
install.packages(c("psych","CCA","CCP","MASS","icapca","gvlma","smacof",
                   "MVN","rpca","gpca","EFA.MRFA","MFAg","MVar","fabMix",
                   "fad","spBFA","cate","mnlfa","CSFA","GFA","lmds","SPCALDA",
                   "semds", "superMDS", "vcd", "vcdExtra"), 
                 dependencies = TRUE)
# Classification and Clustering
install.packages(c("fpc","cluster","treeClust","e1071","NbClust","skmeans",
                   "kml","compHclust","protoclust","pvclust","genie", "tclust",
                   "ClusterR","dbscan","CEC","GMCM","EMCluster","randomLCA",
                   "MOCCA","factoextra","poLCA", "tree", "e1071"), dependencies = TRUE)
# Analysis of Time-series
install.packages(c("ts","zoo","xts","timeSeries","tsModel", "TSMining",
                  "TSA","fma","fpp2","fpp3","tsfa","TSdist","TSclust","feasts",
                  "MTS", "dse","sazedR","kza","fable","forecast","tseries",
                  "nnfor","quantmod"), dependencies = TRUE)
# Network analysis
install.packages(c("fastnet","tsna","sna","networkR","InteractiveIGraph",
                   "SemNeT","igraph","NetworkToolbox","dyads", 
                   "staTools","CINNA"), dependencies = TRUE)
# Analysis of Text
install.packages(c("tm","tau","koRpus","lexicon","sylly","textir",
                   "textmineR","MediaNews", "lsa","SemNeT","ngram","ngramrr",
                   "corpustools","udpipe","textstem", "tidytext","text2vec"), 
                 dependencies = TRUE)
# Bayesian Analysis
install.packages(c("rstan","rstanarm","brms"), dependencies = TRUE)

# Machine Learning --------------------------------------------------------

# Building and validating  the models
install.packages(c("tree", "e1071","crossval","caret","rpart","bcv",
                   "klaR","EnsembleCV","gencve","cvAUC","CVThresh",
                   "cvTools","dcv","cvms","blockCV"), dependencies = TRUE)
# Random forests packages
install.packages(c("randomForest","grf","ipred","party","randomForestSRC",
                   "grf","BART","Boruta","LTRCtrees","REEMtree","refr",
                   "binomialRF","superml"), dependencies = TRUE)
# Regression type (regression, boosting, Gradient descent) algoritms packages
install.packages(c("earth", "gbm","GAMBoost", "GMMBoost", "bst","superml",
                   "sboost"), dependencies = TRUE)
# Classification algorithms
install.packages(c("rpart", "tree", "C50", "RWeka","klar", "e1071",
                   "kernlab","svmpath","superml","sboost"), 
                 dependencies = TRUE)
# Neural Networks
install.packages(c("nnet","gnn","rnn","spnn","brnn","RSNNS","AMORE",
                   "simpleNeural","ANN2","yap","yager","deep","neuralnet",
                   "nnfor","TeachNet"), dependencies = TRUE)
# Deep Learning
install.packages(c("deepnet","RcppDL","tensorflow","h2o","kerasR",
                   "deepNN", "Buddle","automl"), dependencies = TRUE)
# Reinforcement Learning
devtools::install_github("nproellochs/ReinforcementLearning")
install.packages(c("RLT","ReinforcementLearning","MDPtoolbox"), 
                 dependencies = TRUE)
#  Model interpretability and explainability
install.packages(c("lime","localModel","iml","EIX","flashlight",
                   "interpret","outliertree","breakDown"), 
                 dependencies = TRUE)


# Visualization -----------------------------------------------------------
install.packages(c("ggvis","htmlwidgets","maps","sunburstR", "lattice",
                   "predict3d","rgl","rglwidget","plot3Drgl","ggmap","ggplot2","plotly",
                   "RColorBrewer","dygraphs","canvasXpress","qgraph","moveVis","ggcharts",
                   "igraph","visNetwork","visreg", "VIM", "sjPlot", "plotKML", "squash",
                   "statVisual", "mlr3viz", "klaR","DiagrammeR","pavo","rasterVis",
                   "timelineR","DataViz","d3r","d3heatmap","dashboard","highcharter",
                   "rbokeh"), dependencies = TRUE)

# Web Scraping ------------------------------------------------------------
install.packages(c("rvest","Rcrawler","ralger","scrapeR"), 
                 dependencies = TRUE)


# Documents and books organization ----------------------------------------
install.packages(c("devtools","usethis","roxygen2","knitr",
                   "rmarkdown","flexdashboard","Shiny",
                   "xtable","httr","profvis"), dependencies = TRUE)


# Wrap-up -----------------------------------------------------------------
# You can also run the following command to install all of the packages in a single run
install.packages(c("Hmisc","foreign","protr","readxl","xlsx",
                   "csv","readr","tidyverse","jsonLite","rjson",
                   "RJSONIO","jsonvalidate","sparkavro","arrow","feather",
                   "XML","odbc","RODBC","mssqlR","RMySQL",
                   "dbConnect","postGIStools","RPostgreSQL","ODBC",
                   "RSQLite","sqliter","dbflobr","RSQL","sqldf",
                   "poplite","queryparser","influxdbr","janitor","outliers",
                   "missForest","frequency","Amelia","diffobj","mice",
                   "VIM","Bioconductor","mi","wrangle","mitools",
                   "stringr","lubridate","glue","scales","hablar",
                   "dplyr","purr","magrittr","data.table","plyr",
                   "tidyr","tibble","reshape2","stats","Lars",
                   "caret","survival","gam","glmnet","quantreg",
                   "sgd","BLR","MASS","car","mlogit","RRedshiftSQL",
                   "earth","faraway","nortest","lmtest","nlme",
                   "splines","sem","WLS","OLS","pls",
                   "2SLS","3SLS","tree","rpart","rio",
                   "FuzzyNumbers","ez","psych","CCA","CCP",
                   "icapca","gvlma","smacof","MVN","rpca",
                   "gpca","EFA.MRFA","MFAg","MVar","fabMix",
                   "fad","spBFA","cate","mnlfa","CSFA",
                   "GFA","lmds","SPCALDA","semds","superMDS",
                   "vcd","vcdExtra","ks","rrcov","eRm",
                   "MNP","bayesm","ltm","fpc","cluster",
                   "treeClust","e1071","NbClust","skmeans","kml",
                   "compHclust","protoclust","pvclust","genie","tclust",
                   "ClusterR","dbscan","CEC","GMCM","EMCluster",
                   "randomLCA","MOCCA","factoextra","poLCA","ts",
                   "zoo","xts","timeSeries","tsModel","TSMining",
                   "TSA","fma","fpp2","fpp3","tsfa",
                   "TSdist","TSclust","feasts","MTS","dse",
                   "sazedR","kza","fable","forecast","tseries",
                   "nnfor","quantmod","fastnet","tsna","sna",
                   "networkR","InteractiveIGraph","SemNeT","igraph",
                   "dyads","staTools","CINNA","tm","tau","NetworkToolbox",
                   "koRpus","lexicon","sylly","textir","textmineR",
                   "MediaNews","lsa","ngram","ngramrr","corpustools",
                   "udpipe","textstem","tidytext","text2vec","crossval",
                   "bcv","klaR","EnsembleCV","gencve","cvAUC",
                   "CVThresh","cvTools","dcv","cvms","blockCV",
                   "randomForest","grf","ipred","party","randomForestSRC",
                   "BART","Boruta","LTRCtrees","REEMtree","refr",
                   "binomialRF","superml","gbm","GAMBoost","GMMBoost",
                   "bst","sboost","C50","RWeka","klar",
                   "kernlab","svmpath","nnet","gnn","rnn",
                   "spnn","brnn","RSNNS","AMORE","simpleNeural",
                   "ANN2","yap","yager","deep","neuralnet",
                   "TeachNet","deepnet","RcppDL","tensorflow","h2o",
                   "kerasR","deepNN","Buddle","automl","RLT",
                   "ReinforcementLearning","MDPtoolbox","lime","localModel",
                   "iml","EIX","flashlight","interpret","outliertree",
                   "dockerfiler","azuremlsdk","sparklyr","cloudml","ggvis",
                   "htmlwidgets","maps","sunburstR","lattice","predict3d",
                   "rgl","rglwidget","plot3Drgl","ggmap","ggplot2",
                   "plotly","RColorBrewer","dygraphs","canvasXpress","qgraph",
                   "moveVis","ggcharts","visNetwork","visreg","sjPlot",
                   "plotKML","squash","statVisual","mlr3viz","DiagrammeR",
                   "pavo","rasterVis","timelineR","DataViz","d3r","breakDown",
                   "d3heatmap","dashboard","highcharter","rbokeh","rvest",
                   "Rcrawler","ralger","scrapeR","devtools","usethis",
                   "roxygen2","knitr","rmarkdown","flexdashboard","Shiny",
                   "xtable","httr","profvis","rstan","rstanarm","bmrs"), dependencies = TRUE)
