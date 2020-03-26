#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(tidytext)
library(textrank)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Text Summarization Shiny App"),

    # Sidebar with a slider input for number of bins
    sidebarPanel(
            
            fileInput("file", "Upload text file"),
            
            numericInput("num", "Number of Summary Sentences", 5)
            
        ),
    
    mainPanel(
            
            tabsetPanel(type = "tabs",
                        
                    tabPanel("Overview",h4(p("How to use this App")),
                             
                       p("To use this app you need a document (e.g., newspaper article etc.) in txt file format.\n\n 
                       To upload the article text, click on Browse in left-sidebar panel and upload the txt file from your local machine. \n\n
                       Once the file is uploaded, the shinyapp will compute a text summary in the back-end with default inputs and accordingly results will be displayed in various tabs.", align = "justify")),
        
            
                    tabPanel("Article Sentences",
                             h4(p("Original Article Sentences")),
                             tableOutput("article_sentences")),
                    
                    tabPanel("Article Summary", 
                             h4(p("Selected Summary Sentences")),
                             tableOutput("output1")),
            
                    tabPanel("Sentence_scores Plot",
                             h4(p("Plotting TextRank scores for each sentence")),
                             plotOutput("output2"))
            
                    )  # tabSetPanel closes
        
        )  # mainPanel closes
    
)
)  # fluidPage() & ShinyUI() close