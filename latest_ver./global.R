if(!require(shiny)){
  install.packages("shiny",dependencies = TRUE)
  library(shiny)
}
if(!require(ragg)){
  install.packages("ragg",dependencies = TRUE)
  library(ragg)
}
##csv_up_down_moduele-----------
#uif_csv_uplode
uif_csv_uplode=function(id, label = "CSV file") {
  ns <- NS(id)
  
  tagList(
    fileInput(ns("file"), label),
    
  )
}
  
#serverf_csv_uplode
serverf_csv_uplode=function(id, stringsAsFactors) {
  moduleServer(
    id,
    #--------------------
    function(input, output, session) {
      userFile <- reactive({
        validate(need(input$file, message = FALSE))
        input$file
      })
      dataframe <- reactive({
        read.csv(userFile()$datapath,
                 row.names=1,
                 header=T, sep= ",", 
                 as.is=TRUE, strip.white=FALSE,
                 na.strings = '',
                 stringsAsFactors = stringsAsFactors)
      })
      observe({
        msg <- sprintf("File %s was uploaded", userFile()$name)
        cat(msg, "\n")
      })
      return(dataframe)
    }
  )    
}
#serverf_csv_uplode for corrplot
serverf_csv_uplode_nonNA=function(id, stringsAsFactors) {
  moduleServer(
    id,
    #--------------------
    function(input, output, session) {
      userFile <- reactive({
        validate(need(input$file, message = FALSE))
        input$file
      })
      dataframe <- reactive({
        read.csv(userFile()$datapath,
                 row.names=1,
                 header=T, sep= ",", 
                 as.is=TRUE, strip.white=FALSE,
                 stringsAsFactors = stringsAsFactors)
      })
      observe({
        msg <- sprintf("File %s was uploaded", userFile()$name)
        cat(msg, "\n")
      })
      return(dataframe)
    }
  )    
}

##---------------------------------------
