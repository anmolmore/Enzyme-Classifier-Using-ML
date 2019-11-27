
doc <- readLines("Donald Trump.txt")

temp <- tolower(doc) #convert to lowercase
temp <- stringr::str_replace_all(temp,"[^a-zA-Z\\s]", " ") #remove all non alphabets
temp <- stringr::str_replace_all(temp,"[\\s]+", " ")  #strip extra spaces

ud_model <- udpipe_download_model(language = "english")
ud_model <- udpipe_load_model(ud_model$file_model)
#model <- udpipe_load_model("english-ewt-ud-2.4-190531.udpipe")
annotated_text <-
  udpipe_annotate(ud_model, x = temp)
annotated_df <- as.data.frame(annotated_text)

noun_doc = subset(annotated_df, upos = 'NOUN')
top_nouns = txt_freq(noun_doc$lemma)
colnames(annotated_df)

drop_sentence <- c("sentence")
display_df <- subset(annotated_df, select=-c(sentence))
display_top_100 <- head(display_df, 100)
write.csv(display_top_100,'display_top_100.csv')
