library(shiny)
library(MASS)

### Deconvolution
sigRNAseq <- read.delim("data/sigmatrixRNAseq.txt", check.names = F)
sigMicroarray <- read.delim("data/sigmatrixMicro.txt", check.names = F)
target <- read.delim("data/target.txt", header = F)


### Gene viewer
MedianTPM <- read.delim("data/Median_TPMTMM_values.txt", header = T, check.names = F)
Annotation <- read.delim("data/Annotation_genes.txt", header = T, check.names = F)
rownames(Annotation) <- Annotation[,1]

function(input, output) {
  
  ###################################
  ###### DECONVOLUTION PART #########
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
  
  
  ####################################
  ######### GENE VIEWER ############
  IDgene <- reactive({ 
    
    input$goButtonGeneViewer 
    isolate({  
      if(grepl("^ENSG", input$geneInput )){
        grep(input$geneInput,Annotation[,1])[1]
      }else if( grepl( "[A-Z]+", input$geneInput)){
        grep(input$geneInput,Annotation[,2])[1]
      }else{
        grep(input$geneInput,Annotation[,3])[1]
      }
    })
  })  
  
  output$BarPlot <- renderPlot({
    values <- as.numeric(MedianTPM[IDgene(),])
    names(values) <- colnames(MedianTPM)
    par(mar=c(7,5,1,2))
    barplot(values, col = "lightblue", ylab = "Median TPM_TMM value", las=2)
  })
  
  output$tabGene <- renderTable({
    t(Annotation[IDgene(),])
    
  },  include.rownames=T,   include.colnames=FALSE)
  
}






