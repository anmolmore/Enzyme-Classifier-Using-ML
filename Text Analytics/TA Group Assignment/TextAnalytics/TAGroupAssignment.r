#Deriving the Annotated Data from a Document

#Installing the required packages
if (!require(udpipe)){install.packages("udpipe")}
if (!require(textrank)){install.packages("textrank")}
if (!require(lattice)){install.packages("lattice")}
if (!require(igraph)){install.packages("igraph")}
if (!require(ggraph)){install.packages("ggraph")}
if (!require(wordcloud)){install.packages("wordcloud")}

library(udpipe)
library(textrank)
library(lattice)
library(igraph)
library(ggraph)
library(ggplot2)
library(wordcloud)
library(stringr)

require(stringr)
InputDocument = readLines("C:\\Users\\Dharani Kiran\\OneDrive - Indian School of Business\\ISB\\Term 1\\Text Analytics\\Group Assignment\\Donald Trump.txt")
CleanDocument  =  str_replace_all(InputDocument, "<.*?>", "")  
str(CleanDocument)

# load english model for annotation from working dir
english_model = udpipe_load_model("C:\\Users\\Dharani Kiran\\OneDrive - Indian School of Business\\ISB\\Term 1\\Text Analytics\\Group Assignment\\english-ewt-ud-2.4-190531.udpipe")  # file_model only needed

# now annotate text dataset using ud_model above
x <- udpipe_annotate(english_model, x = CleanDocument)
Annotated_Data <- as.data.frame(x)
print(Annotated_Data)
#	})  # 13.76 secs

head(Annotated_Data, 4)

table(Annotated_Data$xpos)  # std penn treebank based POStags
table(Annotated_Data$upos)  # UD based postags


# So what're the most common nouns? verbs?
all_nouns = Annotated_Data %>% subset(., upos %in% "NOUN") 
top_nouns = txt_freq(all_nouns$lemma)  # txt_freq() calcs noun freqs in desc order
head(top_nouns, 10)	

all_verbs = Annotated_Data %>% subset(., upos %in% "VERB") 
top_verbs = txt_freq(all_verbs$lemma)
head(top_verbs, 10)

all_propn = Annotated_Data %>% subset(., upos %in% "PROPN") 
top_propn = txt_freq(all_propn$lemma)
head(top_propn, 10)

all_adverb = Annotated_Data %>% subset(., upos %in% "ADV") 
top_adverb = txt_freq(all_adverb$lemma)
head(top_adverb, 10)

all_verb = Annotated_Data %>% subset(., upos %in% "VERB") 
top_verb = txt_freq(all_verb$lemma)
head(top_verb, 10)

wordcloud(words = all_nouns$key, 
          freq = all_nouns$freq, 
          min.freq = 2, 
          max.words = 100,
          random.order = FALSE, 
          colors = brewer.pal(6, "Dark2"))

wordcloud(words = all_verbs$key, 
          freq = all_verbs$freq, 
          min.freq = 2, 
          max.words = 100,
          random.order = FALSE, 
          colors = brewer.pal(6, "Dark2"))

# Collocation (words following one another)
document_colloc <- keywords_collocation(x = Annotated_Data,   # try ?keywords_collocation
                                     term = "token", 
                                     group = c("doc_id", "paragraph_id", "sentence_id"),
                                     ngram_max = 4)  # 0.42 secs

str(document_colloc)
document_colloc %>% head()

# Co-occurrences based on selection this has to change
document_cooc <- cooccurrence(   	
  x = subset(Annotated_Data, upos %in% c("NOUN", "ADJ")), #IF condition has to be added for selection
  term = "lemma", 
  group = c("doc_id", "paragraph_id", "sentence_id"))  # 0.02 secs
head(document_cooc)

# general (non-sentence based) Co-occurrences
document_cooc_gen <- cooccurrence(x = Annotated_Data$lemma, 
                               relevant = x$upos %in% c("NOUN", "ADJ")) # 0.00 secs

head(document_cooc_gen)

# Skipgram based Co-occurrences: How frequent do words follow one another within skipgram number of words
document_cooc_skipgm <- cooccurrence(x = x$lemma, 
                                  relevant = x$upos %in% c("NOUN", "ADJ"), 
                                  skipgram = 4)  # 0.05 secs


head(document_cooc_skipgm)  # sorted in descending order

wordnetwork <- head(document_cooc, 30)
wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.

ggraph(wordnetwork, layout = "fr") +  
  
  geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
  geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
  
  theme_graph(base_family = "Arial Narrow") +  
  theme(legend.position = "none") +
  
  labs(title = "Cooccurrences within 3 words distance", subtitle = "Nouns & Adjective")

