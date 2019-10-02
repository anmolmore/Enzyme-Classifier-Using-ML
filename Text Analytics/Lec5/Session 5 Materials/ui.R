#---------------------------------------------------------------------#
#               k-means Clustering App                               #
#---------------------------------------------------------------------#


library("shiny")

shinyUI(
  fluidPage(
  
    titlePanel("k-means Clustering"),
  
    sidebarLayout( 
      
      sidebarPanel(  
        
              fileInput("file1", "Upload data (csv file with header)"),
              
              numericInput('clusters', 'Number of Clusters', 3,
                                        min = 1, max = 9)     ),   # end of sidebar panel
    
    
    mainPanel(
      
      tabsetPanel(type = "tabs",
                  
                      tabPanel("Overview",
                               h4(p("Data input")),
                               p("This app supports only comma separated values (.csv) data file. CSV data file should have headers and the first column of the file should have row names.",align="justify"),
                               p("Please refer to the link below for sample csv file."),
                               a(href="https://github.com/sudhir-voleti/sample-data-sets/blob/master/Segmentation%20Discriminant%20and%20targeting%20data/ConneCtorPDASegmentation.csv"
                                 ,"Sample data input file"),   
                               br(),
                               h4('How to use this App'),
                               p('To use this app, click on', 
                                 span(strong("Upload data (csv file with header)")),
                                 'and uppload the csv data file. You can also change the number of clusters to fit in k-means clustering')),
                      tabPanel("Scree plot", 
                                   plotOutput('plot1')),
                      
                      tabPanel("Cluster mean",
                               tableOutput('clust_summary')),
                      
                      tabPanel("Data",
                               dataTableOutput('clust_data'))
        
      ) # end of tabsetPanel
          )# end of main panel
            ) # end of sidebarLayout
              )  # end if fluidPage
                ) # end of UI
  


