options(shiny.maxRequestSize=40*1024^2) #max allowed file size is 40MB

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  dataset <- reactive({
    if (is.null(input$text_file)) {return(NULL)}
    else {
      doc = readLines(input$text_file$datapath)
      
      if (lang_select()==2)
      {
        temp <- doc
      }
      else
      {
        temp <- sapply(doc, tolower)
        temp <- stringr::str_replace_all(temp, "<.*?>", "") # get rid of html junk
        temp <- stringr::str_replace_all(temp,"[?.!,():;'-<>\"|\\s]+", " ") # anything not alphabetical followed by a space, replace!   
        temp <- stringr::str_replace_all(temp,"[\\s]+", " ") # collapse one or more spaces into one space.   
      }
      
      return(temp)}
  })
  
  lang_select<-reactive({
    
    language=input$lang
    return(language)
    
  })
  
  
  pos_vector<-reactive({
    
    names_vec = character()
    
    pos.vector <- as.vector(input$pos_tags)
    
    if (lang_select()==1) {
      for (i in 1:length(pos.vector)){
        if(pos.vector[i]==1){names_vec[i]<-'JJ'}
        else if (pos.vector[i]==2) {names_vec[i]<-'NN'}
        else if (pos.vector[i]==3) {names_vec[i]<-'NNP'}
        else if (pos.vector[i]==4) {names_vec[i]<-'RB'}
        else if (pos.vector[i]==5) {names_vec[i]<-'VB'}
        
      }}
    else
    {
      for (i in 1:length(pos.vector)){
        if(pos.vector[i]==1){names_vec[i]<-'ADJ'}
        else if (pos.vector[i]==2) {names_vec[i]<-'NOUN'}
        else if (pos.vector[i]==3) {names_vec[i]<-'PROPN'}
        else if (pos.vector[i]==4) {names_vec[i]<-'ADV'}
        else if (pos.vector[i]==5) {names_vec[i]<-'VERB'}
        
      }}
    
    
    
    return(names_vec)
    
  })
  
  
  value <- renderPrint({ input$checkGroup })
  
  annote_txt<-reactive({
    
    model = udpipe_load_model(input$udpipe_file$datapath)  # Load the model uploaded
    
    # now annotate text dataset using ud_model above
    x <- udpipe_annotate(model, x = dataset()) #%>% as.data.frame() %>% head()
    x <- as.data.frame(x)
    
    return(x)
    
  })
  
  doc_cooc<-reactive({
    if (lang_select()==1) {
      
      cooc_txt <- cooccurrence( 
        x = subset(annote_txt(), xpos %in% pos_vector()), 
        term = "lemma", 
        group = c("doc_id", "paragraph_id", "sentence_id"))}
    else{
      cooc_txt <- cooccurrence( 
        x = subset(annote_txt(), upos %in% pos_vector()), 
        term = "lemma", 
        group = c("doc_id", "paragraph_id", "sentence_id"))
    }
    
    return(cooc_txt)
    
  })
  windowsFonts(devanew=windowsFont("Devanagari New Normal"))
  output$coocrplots <- renderPlot({
    
    wordnetwork <- head(doc_cooc(), 30)
    wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.
    
    ggraph(wordnetwork, layout = "fr") +  
      
      geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "green") +  
      geom_node_text(aes(label = name), col = "red", size = 4) +
      
      theme_graph(base_family = "Arial Narrow") +  
      theme(legend.position = "none") +
      
      labs(title = "Co-occurrences within 3 words distance", subtitle = paste(pos_vector(),collapse=",") )
  })
  
  word_cloud1 <- reactive({
    if (lang_select()==1)
    {
      x = subset(annote_txt(), xpos %in% pos_vector())
    }
    else
    {
      x = subset(annote_txt(), upos %in% pos_vector())
    }
    top_words = txt_freq(x$lemma)
    return(top_words)
    
  })
  
  output$word_cloud <- renderPlot({
    top_word <- head(word_cloud1(), 30)
    #library(wordcloud)
    wordcloud(words = top_word$key, 
              freq = top_word$freq, 
              min.freq = 2, 
              max.words = 30,
              random.order = FALSE, 
              colors = brewer.pal(6, "Dark2"))
    
  })
  
  output$downloadData1 <- downloadHandler(
    filename = function() { "ISB_english_sample.txt" },
    content = function(file) {
      writeLines(readLines("data/ISB_english_sample.txt"), file)
    }
  )
  
  output$downloadData2 <- downloadHandler(
    filename = function() { "ISB_hindi_sample.txt" },
    content = function(file) {
      writeLines(readLines("data/ISB_hindi_sample.txt"), file)
    }
  )
  
  output$downloadData3 <- downloadHandler(
    filename = function() { "ISB_spanish_sample.txt" },
    content = function(file) {
      writeLines(readLines("data/ISB_spanish_sample.txt"), file)
    }
  )
  
})
getwd()
