
library(shiny)

# Define UI for application that draws a histogram
fluidPage(
  
  # Application title
  titlePanel("Deconvolution of ABsolute Immune Signal"),
  
  hr(),
  
  fluidRow(
    column(3,
           wellPanel(
             h4("Input:"),
             
             fileInput('GeneExpr', strong('Choose gene expression file:'), multiple = FALSE,
                       accept = c('text/plain', ".txt")),
             
             radioButtons("ExprType", "Technology",
                          c("RNA-Seq"="R", "Microarray"="M")),
             
             actionButton("goButton", "Submit!")
       
          ),
             
             ### save the data panel
             hr(),
          wellPanel(
             h4("Save results:"),
             downloadButton("downloadData", "Download")
          )
      ),
              
     column(9,
            dataTableOutput("TableDec")
            )
))
        
