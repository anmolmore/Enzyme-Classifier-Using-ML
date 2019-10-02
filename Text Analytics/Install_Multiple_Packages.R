#Multiple packages install ref :https://gist.github.com/stevenworthington/3178163

install_packg <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    # check to see if packages are installed. Install them if they are not, then load them into the R session
    install.packages(new.pkg, dependencies = TRUE)
  else
    print("All required packages are installed !")
  #Check installation
  sapply(pkg, require, character.only = TRUE)
}

# session 1 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
session1.packages <- c("tm", "wordcloud", "igraph", "ggraph", "stringr", "tidyverse", "tidytext")
install_packg(session1.packages)

#session 2 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
session2.packages <- c("qdap", "tidyr", "dplyr", "ggplot2", "tibble")
install_packg(session2.packages)

#session 3 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
session3.packages <- c("widyr", "data.table", "gutenbergr", "topicmodels", "RWeka", "slam")
install_packg(session3.packages)

#session 4 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
session4.packages <- c("magrittr", "reticulate", "udpipe", "textrank", "lattice", "rvest", "tokenizers", "maptpx", "text2vec")
install_packg(session4.packages)

#session 5 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
session5.packages <- c("shiny", "openNLP", "NLP", "stringi", "Unicode", "twitteR", "textrank")
install_packg(session5.packages)