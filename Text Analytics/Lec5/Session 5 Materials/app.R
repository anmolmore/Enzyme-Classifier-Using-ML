#---------------------------------------------------------------------#
#               k-means Clustering App                               #
#---------------------------------------------------------------------#

library("shiny")

# Define ui function
ui <- shinyUI(
  fluidPage(
    
    titlePanel("k-means Clustering"),
    
    sidebarLayout( 
      
      sidebarPanel(  
        
        fileInput("file", "Upload data (csv file with header)"),
        
        numericInput('clusters', 'Number of Clusters', 3,
                     min = 1, max = 19)     ),   # end of sidebar panel
      
      
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



# Define Server function
server <- shinyServer(function(input, output) {
  
  Dataset <- reactive({
    if (is.null(input$file)) { return(NULL) }
    else{
      Data <- as.data.frame(read.csv(input$file$datapath ,header=TRUE, sep = ","))
      rownames(Data) = Data[,1]
      Data1 = Data[,2:ncol(Data)]
      return(Data1)
    }
  })
  
  output$plot1 = renderPlot({ 
    data.pca <- prcomp(Dataset(),center = TRUE,scale. = TRUE)
    plot(data.pca, type = "l"); abline(h=1)    
  })
  
  clusters <- reactive({
    kmeans(Dataset(), input$clusters)
  })
  
  output$clust_summary = renderTable({
    out = data.frame(Cluser = row.names(clusters()$centers),clusters()$centers)
    out
  })
  
  output$clust_data = renderDataTable({
    out = data.frame(row_name = row.names(Dataset()),Dataset(),Cluster = clusters()$cluster)
    out
  })
  
})

shinyApp(ui = ui, server = server)