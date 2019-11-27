### Team Members :
#### Anmol More : 11915043
#### Dharani Kiran Kavuri : 11915033
#### Shubhendu Vimal : 11915067

library(shiny)
library(shinythemes)

ui <- (fluidPage(
  # Application title
  theme = shinytheme("united"),
  titlePanel(title = div(
    img(
      src = "isb.png",
      height = "5%",
      width = "5%",
      align = "right"
    ),
    "Q3 : NLP Workflow"
  )),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      fileInput("text_file", label = "Upload text file (english only)"),
      
      hr(),
      
      checkboxGroupInput(
        "pos_tags",
        label = "Select part-of-speech tags :",
        choices = list(
          "adjective (ADJ)" = 1,
          "noun (NOUN)" = 2,
          "proper noun (PROPN)" = 3,
          "adverb (ADV)" = 4,
          "verb (VERB)" = 5
        ),
        selected = list(1, 2, 3)
      ),
      br(),
      
      sliderInput(
        "min_freq",
        label = "Minimum Frequency of words for Wordcloud :",
        min = 0,
        max = 50,
        value = 5
      ),
      
      sliderInput(
        "max_words",
        label = "Maximum Number of Words in Wordcloud :",
        min = 10,
        max = 200,
        value = 100
      )
      
    ),
    
    mainPanel(
      tabsetPanel(
        type = "tabs",
        
        tabPanel(
          "About the App",
          h3(p("How to use this App")),
          
          p(
            "To use this app you need a document corpus in txt file format. Document needs to be plain text with multiple lines. To do basic Text Analysis in your text corpus, click on Browse in left-sidebar panel and upload the txt file. Once the file is uploaded it will do the computations in
            back-end with default inputs and accordingly results will be displayed in various tabs.",
            align = "justify"
          ),
          p(
            "If you wish to change the input, modify the input in left side-bar panel and click on Apply changes. Accordingly results in other tab will be refreshed
            ",
            align = "Justify"
          ),
          h4("Note"),
          p(
            "You might observe no change in the outputs after clicking 'Apply Changes' for big files. Wait for few seconds. As soon as all the computations are over in back-end results will be refreshed",
            align = "justify"
          ),
          br(),
          br(),
          p(
            "App created by - Anmol More (11915043), Dharani Kiran Kavuri (11915033) & Shubhendu Vimal (11915067)",
            align = "justify"
          )
        ),
        
        tabPanel(
          "Annotated Document", tableOutput("annotated_table"),
          h2("Download Data"),
          downloadButton('download_df', 'Download Annotated document')
          ),
        
        tabPanel(
          "Word Cloud",
          h2("Word Cloud for Nouns in Corpus"),
          imageOutput("word_cloud_noun", width = "100%"),
          
          h2("Word Cloud for Verbs in Corpus"),
          plotOutput("word_cloud_verb", width = "100%")
        ),
        
        tabPanel("Top 30 Co-occurrences", plotOutput("co_occurance_plot"))
        
          )
  )
)
))