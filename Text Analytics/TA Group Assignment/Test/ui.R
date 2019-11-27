# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
getwd()

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Shiny app using UDPipe NLP Workflow"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      
      fileInput("text_file", label = "Upload text file:"),
      radioButtons("lang", label = "Select the language of the text uploaded:",
                   choices = list("English" = 1, "Hindi" = 2, "Spanish" = 3), 
                   selected = 1),
      hr(),
      fluidRow(column(3, verbatimTextOutput("value"))),
      fileInput("udpipe_file", label = "Upload trained udpipe model of the selected language:"),
      checkboxGroupInput("pos_tags", label = "Select list of part-of-speech tags :", 
                         choices = list("adjective (JJ)" = 1, "noun (NN)" = 2, "proper noun (NNP)" = 3,
                                        "adverb (RB)" = 4, "verb (VB)" = 5),
                         selected = list(1,2,3))
      
    ),   # end of sidebar panel
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(type = "tabs",
                  
                  tabPanel("Overview",
                           h4('How to use this App?'),
                           p('To use this app, first click on', span(strong("Upload text file:")),
                             'and upload the input text file.'),
                           p('Now specify the language of the text file uploaded, by using the list provided under', 
                             span(strong("Select the language of the text uploaded:"))),
                           p('Then you need to upload the trained udpipe model of the specified language by clicking on',
                             span(strong("Upload trained udpipe model of the selected language:"))),
                           p('You can also select the part-of-speech tags from the given list of checkboxes'),
                           br(),br(),
                           h4(p("Download Sample text files here:")), 
                           downloadButton('downloadData1', 'Download Sample English file'), 
                           downloadButton('downloadData2', 'Download Sample Hindi file'), 
                           downloadButton('downloadData3', 'Download Sample Spanish file'),
                           br(),br(),
                           p("Please note that download will not work with RStudio interface. Download will work only in web-browsers. So open this app in a web-browser and then download the example file. For opening this app in web-browser click on \"Open in Browser\" as shown below -"),
                           img(src = "example1.png")),
                  
                  tabPanel("Wordcloud",plotOutput("word_cloud",height = "400px", width = "100%")),
                  
                  tabPanel("Co-occurrence",plotOutput("coocrplots"))
                  
      ) # end of tabsetPanel
    )
  )
))