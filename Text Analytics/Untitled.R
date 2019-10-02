#Ref : https://gist.github.com/stevenworthington/3178163

# ipak function: install and load multiple R packages.
# check to see if packages are installed. Install them if they are not, then load them into the R session.

ipak <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  else
    print("All required packages are installed !")
  sapply(pkg, require, character.only = TRUE)
}

# session 1
session1.packages <- c("tm", "wordcloud", "igraph", "ggraph", "stringr", "tidyverse", "tidytext")
ipak(session1.packages)

#session 2
session2.packages <- c("qdap", "tidyr", "dplyr", "ggplot2", "tibble")
ipak(session2.packages)

#session 3
session3.packages <- c("widyr", "data.table", "gutenbergr", "topicmodels", "RWeka", "slam")
ipak(session3.packages)

#session 4
session4.packages <- c("magrittr", "reticulate", "udpipe", "textrank", "lattice", "rvest", "tokenizers", "maptpx", "text2vec")
ipak(session4.packages)

#session 5
session5.packages <- c("shiny", "openNLP", "NLP", "stringi", "Unicode", "twitteR", "textrank")
ipak(session5.packages)

list.of.packages <- session1.packages
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
print(length(new.packages))