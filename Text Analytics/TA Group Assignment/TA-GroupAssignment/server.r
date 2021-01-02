### Team Members :
#### Anmol More : 11915043
#### Dharani Kiran Kavuri : 11915033
#### Shubhendu Vimal : 11915067

#Ref : https://bnosac.github.io/udpipe/docs/doc7.html

shinyServer(function(input, output) {
  options(shiny.maxRequestSize = 30 * 1024 ^ 2)
  
  dataset <- reactive({
    if (is.null(input$text_file)) {
      return(NULL)
    }
    else {
      doc = readLines(input$text_file$datapath)
      
      temp <- tolower(doc) #convert to lowercase
      temp <-
        stringr::str_replace_all(temp, "[^a-zA-Z\\s]", " ") #remove all non alphabets
      temp <-
        stringr::str_replace_all(temp, "[\\s]+", " ")  #strip extra spaces
      return(temp)
    }
  })
  
  pos_tags <- reactive({
    pos_tag_names = list()
    input_pos_tags <- as.vector(input$pos_tags)
    for (i in 1:length(input_pos_tags)) {
      if (input_pos_tags[i] == 1) {
        pos_tag_names[i] <- 'ADJ'
      }
      else if (input_pos_tags[i] == 2) {
        pos_tag_names[i] <- 'NOUN'
      }
      else if (input_pos_tags[i] == 3) {
        pos_tag_names[i] <- 'PROPN'
      }
      else if (input_pos_tags[i] == 4) {
        pos_tag_names[i] <- 'ADV'
      }
      else if (input_pos_tags[i] == 5) {
        pos_tag_names[i] <- 'VERB'
      }
    }
    return(pos_tag_names)
  })
  
  #cols in annotated df :
  #"doc_id", "paragraph_id", "sentence_id", "sentence", "token_id", "token", "lemma", "upos"
  #"xpos", "feats", "head_token_id", "dep_rel", "deps", "misc"
  annotated_df <- reactive({
    model = udpipe_load_model("english-ewt-ud-2.4-190531.udpipe")
    annotated_text <-
      udpipe_annotate(model, x = dataset())
    annotated_df <- as.data.frame(annotated_text)
    write.csv(annotated_df, 'annotated_doc.csv')
    return(annotated_df)
  })
  
  #file for download
  output$download_df <- downloadHandler(
    filename = function() {
      "annotated_doc.csv"
    },
    content = function(fname) {
      write.csv(subset(annotated_df(), select = -c(sentence)), fname)
    }
  )
  
  #select top 100 rows to display
  output$annotated_table <- renderTable({  
    head(annotated_df(), 100)
  })
  
  cooccurance_df <- reactive({
    cooccurance_text <- cooccurrence(
      x = subset(annotated_df(), upos %in% pos_tags()),
      term = "lemma",
      group = c("doc_id", "paragraph_id", "sentence_id")
    )
    return(cooccurance_text)
  })
  
  #select top 30 from at doc level
  output$co_occurance_plot <- renderPlot({
    wordnetwork <- head(cooccurance_df(), 30)
    wordnetwork <-
      igraph::graph_from_data_frame(wordnetwork)
    
    ggraph(wordnetwork, layout = "fr") +
      
      geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "blue") +
      geom_node_text(aes(label = name), col = "black", size = 4) +
      
      theme_graph(base_family = "Arial Narrow") +
    
    labs(title = "Top 30 Cooccurrence graph",
         subtitle = paste(pos_tags(), collapse = ","))
  })
  
  #filter annotated doc by Noun
  nouns_by_freq <- reactive({
    noun_doc = subset(annotated_df(), upos == 'NOUN')
    nouns_by_freq = txt_freq(noun_doc$lemma)   #contains key, freq, freq_pct sorted by freq
    return(nouns_by_freq)
  })
  
  #get top 100 nouns plot
  output$word_cloud_noun <- renderPlot({
    top_words <-
      head(nouns_by_freq(), 200)  #take 200 words, limit same in UI
    wordcloud(
      words = top_words$key,
      freq = top_words$freq,
      min.freq = input$min_freq,
      max.words = input$max_words
    )
  })
  
  #filter annotated doc by verb
  verbs_by_freq <- reactive({
    verb_doc = subset(annotated_df(),  upos == 'VERB')
    verbs_by_freq = txt_freq(verb_doc$lemma)  #contains key, freq, freq_pct sorted by freq
    return(verbs_by_freq)
  })
  
  #get top 100 verbs plot
  output$word_cloud_verb <- renderPlot({
    top_words <-
      head(verbs_by_freq(), 200) #take 200 words, limit same in UI
    wordcloud(
      words = top_words$key,
      freq = top_words$freq,
      min.freq = input$min_freq,
      max.words = input$max_words
    )
  })
})
