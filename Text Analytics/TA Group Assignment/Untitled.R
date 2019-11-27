
doc <- readLines("Donald Trump.txt")

temp <- tolower(doc) #convert to lowercase
temp <- stringr::str_replace_all(temp,"[^a-zA-Z\\s]", " ") #remove all non alphabets
temp <- stringr::str_replace_all(temp,"[\\s]+", " ")  #strip extra spaces


model <- udpipe_load_model("english-ewt-ud-2.4-190531.udpipe")
annotated_text <-
  udpipe_annotate(model, x = temp)
annotated_df <- as.data.frame(annotated_text)