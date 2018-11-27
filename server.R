library(shiny)
library(MASS)

sigRNAseq <- read.delim("data/sigmatrixRNAseq.txt", check.names = F)
sigMicroarray <- read.delim("data/sigmatrixMicro.txt", check.names = F)
target <- read.delim("data/target.txt", header = F)

### MOD
function(input, output) {
   
  dataset <- reactive( {
    req(input$GeneExpr)
    read.delim(input$GeneExpr$datapath) 
    })
 
  
    Dec_res <- reactive({
    # req(dataset())
    # dataset()
    
   input$goButton # this would activate this render function
   isolate({
      if(input$ExprType == "R"){
    genes <- intersect(rownames(dataset()), rownames(sigRNAseq))
      Dec <- (apply(dataset()[genes,], 2, function(x) coef(rlm( as.matrix(sigRNAseq[genes,]), x )))) *100
     }           

    if(input$ExprType == "M"){
      genes <- intersect(rownames(dataset()), rownames(sigMicroarray))
      dataset2 <- normalize.quantiles.use.target(as.matrix(dataset()[genes,]), target,copy=TRUE,subset=NULL)
      colnames(dataset2) <-colnames(dataset())
      rownames(dataset2) <- genes
      Dec <- (apply(dataset2, 2, function(x) coef(rlm( as.matrix(sigMicroarray), x )))) *100
      }
     Dec <- signif(Dec, 3)
    cbind(rownames(Dec), Dec)
    })
  })
  
    output$TableDec <- renderDataTable({
      Dec_res()
    })
    
      
    
   #### Save the files!
   output$downloadData <- downloadHandler(
     filename = function() {
       paste(input$GeneExpr$name, "_deconvolution.txt", sep = "")
     },
     content = function(file) {
       write.table( Dec_res(), file, sep="\t", row.names = F)
     }
   )
}

