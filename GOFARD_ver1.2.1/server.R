if(!require(shiny)){
  install.packages("shiny",dependencies = TRUE)
  library(shiny)
}
if(!require(DT)){
  install.packages("DT",dependencies = TRUE)
  library(DT)
}
if(!require(magrittr)){
  install.packages("magrittr",dependencies = TRUE)
  library(magrittr)
}
if(!require(glmnet)){
  install.packages("glmnet",dependencies = TRUE)
  library(glmnet)
}
if(!require(tidyverse)){
  install.packages("tidyverse",dependencies = TRUE)
  library(tidyverse)
}
if(!require(ggplot2)){
  install.packages("ggplot2",dependencies = TRUE)
  library(ggplot2)
}
if(!require(rpart)){
  install.packages("rpart",dependencies = TRUE)
  library(rpart)
}
if(!require(rattle)){
  install.packages("rattle",dependencies = TRUE)
  library(rattle)
}
if(!require(cluster)){
  install.packages("cluster",dependencies = TRUE)
  library(cluster)
}
if(!require(factoextra)){
  install.packages("factoextra",dependencies = TRUE)
  library(factoextra)
}
if(!require(daewr)){
  install.packages("daewr",dependencies = TRUE)
  library(daewr)
}
if(!require(critpath)){
  install.packages("critpath",dependencies = TRUE)
  library(critpath)
}
if(!require(corrplot)){
  install.packages("corrplot",dependencies = TRUE)
  library(corrplot)
}
if(!require(car)){
  install.packages("car",dependencies = TRUE)
  library(car)
}
if(!require(ragg)){
  install.packages("ragg",dependencies = TRUE)
  library(ragg)
}

shinyServer(function(input, output) {
###start------------------------------------------------------
###Data_tab-----------------
  ##scatter plot tab-----------------
  #CSV input
  inputfile=serverf_csv_uplode("datafile", stringsAsFactors = FALSE)
  #table output
  output$table <- DT::renderDataTable({
    inputfile()
  })
  #Data_select
  output$colname1 = renderUI({ 
    selectInput("plot_x", "Select the x-axis", colnames(inputfile()))
  })
  output$colname2 = renderUI({ 
    selectInput("plot_y", "Select the y-axis", colnames(inputfile()))
  })
  output$colname3 = renderUI({ 
    selectInput("plot_group", "", c("OFF",colnames(inputfile())))
  })
  output$colname4 = renderUI({ 
    selectInput("scatter_line", "",c("OFF","ON"))
  })
  output$colname5 = renderUI({
    selectInput("unused_rows", "",rownames(inputfile()), multiple=T)
  })
  
  observeEvent(input$trigger_data_plot, {#scatter plot swich start
  #unset rows handling----
    inputfile2 <- reactive({
      if (!is.null(input$unused_rows)) {
      delete_row_number <- match(input$unused_rows, rownames(inputfile()))
      inputfile2 <- inputfile()[-c(delete_row_number),]
      } else {
        inputfile2 <- inputfile() 
      }
      return(inputfile2) 
    })
  #unused table  
  output$Usage_table <- DT::renderDataTable({
    inputfile2()
  })  
  output$downloadData_scatter <- downloadHandler(
    filename = function() {
      paste("data-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(inputfile2(), file)
    }
  )#----
  #plot output
  output$scatter_plot <- renderPlot({
    
    if (input$plot_group == "OFF") {
      if (input$scatter_line == "OFF") { 
        plot(inputfile2()[, c(input$plot_x, input$plot_y)],
             pch = 16)
      } else {
        plot(inputfile2()[, c(input$plot_x, input$plot_y)],
             pch = 16)
        lm.obj<-lm(inputfile2()[,input$plot_y]~inputfile()[,input$plot_x])
        abline(lm.obj)
      }
    } else if (input$plot_group != "OFF")  {
      plotgroup=as.factor(inputfile2()[,input$plot_group])
      num_plotgroup=length(unique(plotgroup))
      splitdata_scatter=split(inputfile2(), inputfile()[,input$plot_group])
      if (input$scatter_line == "OFF") {
        plot(inputfile2()[, c(input$plot_x, input$plot_y)]
             ,pch = 16,col=c(2:(1+num_plotgroup))[unclass(plotgroup)])
      } else {
        plot(inputfile2()[, c(input$plot_x, input$plot_y)]
             ,pch = 16,col=c(2:(1+num_plotgroup))[unclass(plotgroup)])
        for (i in 1: length(splitdata_scatter)){
          lm.obj<-lm(splitdata_scatter[[i]][,input$plot_y]~splitdata_scatter[[i]][,input$plot_x])
          abline(lm.obj)
        }
      }
    }
  })
  output$plot_brushedPoints <- DT::renderDataTable({
    res <- brushedPoints(inputfile2(), input$plot_brush,
                         xvar = input$plot_x,
                         yvar = input$plot_y,
                         )
    if (nrow(res) == 0)
      return()
    res
  })
  })#scatter plot swich end
  ##barbox plot tab-----------------
  #CSV input
  inputfile_barbox=serverf_csv_uplode("datafile_barbox", stringsAsFactors = FALSE)
  #table output
  output$table_barbox <- DT::renderDataTable({
    inputfile_barbox()
  })
  #Data_select
  output$data_barbox_x = renderUI({ 
    selectInput("data_barbox_x", "Select the x-axis(category data)", colnames(inputfile_barbox()))
  })
  output$data_barbox_y = renderUI({ 
    selectInput("data_barbox_y", "Select the y-axis", colnames(inputfile_barbox()))
  })
  output$unused_rows_barbox = renderUI({
    selectInput("unused_rows_barbox", "",rownames(inputfile_barbox()), multiple=T)
  })

  observeEvent(input$trigger_barbox, {#barbox plot swich start
    #unset rows handling----
    inputfile_barbox2 <- reactive({
      if (!is.null(input$unused_rows_barbox)) {
        delete_row_number <- match(input$unused_rows_barbox, rownames(inputfile_barbox()))
        inputfile_barbox2 <- inputfile_barbox()[-c(delete_row_number),]
      } else {
        inputfile_barbox2 <- inputfile_barbox() 
      }
      return(inputfile_barbox2) 
    })
    #unused table  
    output$Usage_table_barbox <- DT::renderDataTable({
      inputfile_barbox2()
    })  
    output$downloadData_barbox <- downloadHandler(
      filename = function() {
        paste("data-", Sys.Date(), ".csv", sep="")
      },
      content = function(file) {
        write.csv(inputfile_barbox2(), file)
      }
    )#----
    output$bar_plot <- renderPlot({
      if (input$bar_scatter == "OFF") {
        bar_plot=ggplot(inputfile_barbox2(),
                        aes_string(x=input$data_barbox_x,
                                   y=input$data_barbox_y))+
          stat_summary(geom="bar",fun=input$bar_stat)
        plot(bar_plot)
      } else {
        bar_plot=ggplot(inputfile_barbox2(),
                        aes_string(x=input$data_barbox_x,
                                   y=input$data_barbox_y))+
          stat_summary(geom="bar",fun=input$bar_stat)+
          geom_point(mapping = aes_string(color=input$data_barbox_x),
                     position = position_jitter(width = 0.2,height = 0,seed = 123L),
                     show.legend = F)
        plot(bar_plot)
      }
    })
    output$box_plot <- renderPlot({
      box_plot=ggplot(inputfile_barbox2(),
                      aes_string(x=input$data_barbox_x,
                                 y= input$data_barbox_y,
                                 fill=input$data_barbox_x))+
        geom_boxplot()
      plot(box_plot) 
    })
  })#barbox plot swich end
  ##histogram tab-----------------
  #CSV input
  inputfile_histogram=serverf_csv_uplode("datafile_histogram", stringsAsFactors = FALSE)
  #table output
  output$table_histogram <- DT::renderDataTable({
    inputfile_histogram()
  })
  #Data_select
  output$data_histogram_x = renderUI({ 
    selectInput("data_histogram_x", "Select the x-axis(numerical data)", colnames(inputfile_histogram()))
  })
  output$data_histogram_color = renderUI({ 
    selectInput("data_histogram_color", "", c("OFF",colnames(inputfile_histogram())))
  })
  output$unused_rows_histogram = renderUI({
    selectInput("unused_rows_histogram", "",rownames(inputfile_histogram()), multiple=T)
  })
  observeEvent(input$trigger_histogram, {#histogram swich start
    #unset rows handling----
    inputfile_histogram2 <- reactive({
      if (!is.null(input$unused_rows_histogram)) {
        delete_row_number <- match(input$unused_rows_histogram, rownames(inputfile_histogram()))
        inputfile_histogram2 <- inputfile_histogram()[-c(delete_row_number),]
      } else {
        inputfile_histogram2 <- inputfile_histogram() 
      }
      return(inputfile_histogram2) 
    })
    #unused table  
    output$Usage_table_histogram <- DT::renderDataTable({
      inputfile_histogram2()
    })  
    output$downloadData_histogram <- downloadHandler(
      filename = function() {
        paste("data-", Sys.Date(), ".csv", sep="")
      },
      content = function(file) {
        write.csv(inputfile_histogram2(), file)
      }
    )#----
    output$histogram_plot <- renderPlot({
      if (input$data_histogram_color=="OFF"){
        histogram_plot=ggplot(inputfile_histogram2(),
                              aes_string(x=input$data_histogram_x,
                                         ))+
          geom_histogram()
        plot(histogram_plot)
      }
      else{
      histogram_plot=ggplot(inputfile_histogram2(),
                        aes_string(x=input$data_histogram_x,
                                   fill=input$data_histogram_color,
                                   colour=input$data_histogram_color))+
        geom_histogram(position = "dodge")
        plot(histogram_plot)
      }
    })
  })#histogram swich end
  
  ##corrplot tab-----------------
  #CSV input
  inputfile_corrplot=serverf_csv_uplode_nonNA("datafile_corrplot", stringsAsFactors = FALSE)
  #table output
  output$table_corrplot <- DT::renderDataTable({
    inputfile_corrplot()
  })
  output$unused_rows_corrplot = renderUI({
    selectInput("unused_rows_corrplot", "",rownames(inputfile_corrplot()), multiple=T)
  })
  #Data_select
  output$data_corrplot = renderUI({ 
    selectInput("data_corrplot", "Select data", colnames(inputfile_corrplot()), multiple=T)
  })
  
  observeEvent(input$trigger_corrplot, {#corrplot swich start
    #unset rows handling----
    inputfile_corrplot2 <- reactive({
      if (!is.null(input$unused_rows_corrplot)) {
        delete_row_number <- match(input$unused_rows_corrplot, rownames(inputfile_corrplot()))
        inputfile_corrplot2 <- inputfile_corrplot()[-c(delete_row_number),]
      } else {
        inputfile_corrplot2 <- inputfile_corrplot() 
      }
      return(inputfile_corrplot2) 
    })
    #unused table  
    output$Usage_table_corrplot <- DT::renderDataTable({
      inputfile_corrplot2()
    })  
    output$downloadData_corrplot <- downloadHandler(
      filename = function() {
        paste("data-", Sys.Date(), ".csv", sep="")
      },
      content = function(file) {
        write.csv(inputfile_corrplot2(), file)
      }
    )#----
    output$scatter_matrix <- renderPlot({
      col=colnames(inputfile_corrplot2()[,input$data_corrplot]) %>%
        paste(collapse = "+")
      formula_mat=paste0("~",col) %>%
        as.formula() 
      scatterplotMatrix(formula=formula_mat,
                        data=na.omit(inputfile_corrplot2()[,input$data_corrplot]))
      
    })
    output$corrplot_plot <- renderPlot({
      cor_numVar=scale(inputfile_corrplot2()[,input$data_corrplot])%>%
         cor(use="pairwise.complete.obs")
      corrplot.mixed(cor_numVar,
                     tl.col="black", tl.pos = "lt")
      
    })
  })#corrplot swich end
  
  ##ac tab ---------
  #CSV input
  inputfile_ac=serverf_csv_uplode("datafile_ac", stringsAsFactors = FALSE)
  #table output 
  output$table_ac <- DT::renderDataTable(
    inputfile_ac(), selection = list(target = 'column')
  )
  output$unused_rows_ac = renderUI({
    selectInput("unused_rows_ac", "",rownames(inputfile_ac()), multiple=T)
  })
  #select
  output$data_ac = renderUI({ 
    selectInput("data_ac", "2.Select columns",colnames(inputfile_ac()), multiple=T)
    
  })
  
  observeEvent(input$button_ac, {#ac swich start
    #unset rows handling----
    inputfile_ac2 <- reactive({
      if (!is.null(input$unused_rows_ac)) {
        delete_row_number <- match(input$unused_rows_ac, rownames(inputfile_ac()))
        inputfile_ac2 <- inputfile_ac()[-c(delete_row_number),]
      } else {
        inputfile_ac2 <- inputfile_ac() 
      }
      return(inputfile_ac2) 
    })
    #unused table  
    output$Usage_table_ac <- DT::renderDataTable({
      inputfile_ac2()
    })  
    output$downloadData_ac <- downloadHandler(
      filename = function() {
        paste("data-", Sys.Date(), ".csv", sep="")
      },
      content = function(file) {
        write.csv(inputfile_ac2(), file)
      }
    )#----
    #ac process
    data_out_ac <- reactive({
      xy_si=data.frame(matrix(rep(NA, 6), nrow=1))[numeric(0), ]
      colnames(xy_si)=c("Total","Maximum","Minimum","Mean","Median","Standard deviation")
      for (i in input$data_ac) {
        x_n=colnames(inputfile_ac2()[i])
        xy_si=inputfile_ac2()%>%
          summarise("Total"=sum(.data[[x_n]],na.rm = TRUE),
                    "Maximum"=max(.data[[x_n]],na.rm = TRUE),
                    "Minimum"=min(.data[[x_n]],na.rm = TRUE),
                    "Mean"=mean(.data[[x_n]],na.rm = TRUE),
                    "Median"=median(.data[[x_n]],na.rm = TRUE),
                    "Standard deviation"=sd(.data[[x_n]],na.rm = TRUE),
                    
          )%>%
          rbind(xy_si)
      }
      data_out_ac=apply(xy_si,2,rev)%>%
        t()%>%
        as.data.frame()
      colnames(data_out_ac)=colnames(inputfile_ac2()[c(input$data_ac)])
      return(data_out_ac)
    })
    #ac output
    output$tableout_ac <- DT::renderDataTable({
      data_out_ac()
    })
    output$downloadData_ac <- downloadHandler(
      filename = function() {
        paste("data-", Sys.Date(), ".csv", sep="")
      },
      content = function(file) {
        write.csv(data_out_ac(), file)
      }
    )
    
  })#ac swich end
  ##ac tab end---------
###design_tab--------------
  ##DSD tab-------
  #CSV input
  inputfile_dsd=serverf_csv_uplode("datafile_dsd", stringsAsFactors = FALSE)
  #table output
  output$table_dsd <- DT::renderDataTable({
    inputfile_dsd()
  })
  ##DSD modeling
  observeEvent(input$button_dsd, {#dsd swich start
    dsd_list <-  reactive({
      na.n=ncol(inputfile_dsd())-nrow(na.omit(t(inputfile_dsd())))
      Design<-DefScreen(m=ncol(inputfile_dsd())-na.n-1,c=na.n)
      colnames(Design)=colnames(inputfile_dsd()[,-1])
      Design2=cbind("ex.num."=c(1:nrow(Design)),Design) 
      d1=pivot_longer(inputfile_dsd(),cols = !1,names_to = "factor", values_to = "input")
      d2=pivot_longer(Design2,cols = !1,names_to = "factor", values_to = "value") 
      d3=inner_join(d2,d1,by="factor")
      dsd_list=filter(d3,d3$level==d3$value) %>%
        select(-level,-value) %>%
        pivot_wider(names_from = "factor",values_from = "input")
      return(dsd_list)
    })
    
    #data_dsd_out
    output$tableout_dsd <- DT::renderDataTable({
      dsd_list()
    })
    output$downloadData_dsd <- downloadHandler(
      filename = function() {
        paste("data-", Sys.Date(), ".csv", sep="")
      },
      content = function(file) {
        write.csv(dsd_list(), file)
      }
    )
  })#dsd swich end
  
  ##PERT tab-------
  #CSV input
  inputfile_pert=serverf_csv_uplode("datafile_pert", stringsAsFactors = FALSE)
  #table output
  output$table_pert <- renderDataTable({
    inputfile_pert()
  })
  ##pert modeling
  observeEvent(input$button_pert, {#pert swich start
  
  output$pert_gantt=renderPlot({
    pert_model <- solve_pathAOA(inputfile_pert(), deterministic = T)
    plot_gantt(pert_model)
  })
  output$summary_pert <- renderPrint({
    pert_model <- solve_pathAOA(inputfile_pert(), deterministic = T) 
    print(pert_model[[4]])
  }) 
 　 })#pert swich end
  
###prediction_tab-----------
  ##lslr tab start---------
  #regCSV input
  inputfile_reg_lslr=serverf_csv_uplode("datafile_reg_lslr", stringsAsFactors = FALSE)
  #table output 
  output$table_reg_x_lslr <- DT::renderDataTable(
    inputfile_reg_lslr(), selection = list(target = 'column')
  )
  output$unused_rows_lslr = renderUI({
    selectInput("unused_rows_lslr", "",rownames(inputfile_reg_lslr()), multiple=T)
  })
  #x_select
  output$data_reg_x_lslr = renderUI({ 
    selectInput("data_reg_x_lslr", "2.Select one explanatory variable",colnames(inputfile_reg_lslr()), multiple=F)
  })
  
  #y_select
  output$data_reg_y_lslr = renderUI({ 
    selectInput("data_reg_y_lslr", "3.Select one objective variable", colnames(inputfile_reg_lslr()))
  })
  #predYCSV input
  inputfile_predY_lslr=serverf_csv_uplode("datafile_predY_lslr", stringsAsFactors = FALSE)
  #table
  output$table_predY_x_lslr <- DT::renderDataTable(
    inputfile_predY_lslr(), selection = list(target = 'column')
  )
  #x_predY_select
  output$data_predY_x_lslr = renderUI({ 
    selectInput("data_predY_x_lslr", "Select the same explanatory variables",colnames(inputfile_predY_lslr()), multiple=F)
  })
  #predXCSV input
  inputfile_predX_lslr=serverf_csv_uplode("datafile_predX_lslr", stringsAsFactors = FALSE)
  #table
  output$table_predX_y_lslr <- DT::renderDataTable(
    inputfile_predX_lslr(), selection = list(target = 'column')
  )
  #y_predX_select
  output$data_predX_y_lslr = renderUI({ 
    selectInput("data_predX_y_lslr", "Select the same objective variable",colnames(inputfile_predX_lslr()), multiple=F)
  })
  
  ##prediction_lslr modeling
  observeEvent(input$regression_button_lslr, {#pred swich start
    #unset rows handling----
    inputfile_reg_lslr2 <- reactive({
      if (!is.null(input$unused_rows_lslr)) {
        delete_row_number <- match(input$unused_rows_lslr, rownames(inputfile_reg_lslr()))
        inputfile_reg_lslr2 <- inputfile_reg_lslr()[-c(delete_row_number),]
      } else {
        inputfile_reg_lslr2 <- inputfile_reg_lslr() 
      }
      return(inputfile_reg_lslr2) 
    })
    #unused table  
    output$Usage_table_lslr <- DT::renderDataTable({
      inputfile_reg_lslr2()
    })  
    output$downloadData_lslr <- downloadHandler(
      filename = function() {
        paste("data-", Sys.Date(), ".csv", sep="")
      },
      content = function(file) {
        write.csv(inputfile_reg_lslr2(), file)
      }
    )#----  
    lslrmodel <-  reactive({
      lslrmodel<-lm(inputfile_reg_lslr2()[,input$data_reg_y_lslr]~inputfile_reg_lslr2()[,input$data_reg_x_lslr])
      return(lslrmodel)
    })
    lslrcoef=reactive({
    lslrcoef=lslrmodel()$coefficients
    return(lslrcoef)
    })
    ##model output
    #summary tab
    output$plot_regression_lslr <- renderPlot({
      est.Y <- lslrcoef()[[1]]+lslrcoef()[[2]]*inputfile_reg_lslr2()[,input$data_reg_x_lslr]
      plot(inputfile_reg_lslr2()[,input$data_reg_y_lslr],
           est.Y, 
           xlab="Measured value", 
           ylab="Prediction value")
      abline(a=0, b=1, col="red", lwd=2)
    })
    output$summary_cor_lslr <- renderPrint({
      est.Y <- lslrcoef()[[1]]+lslrcoef()[[2]]*inputfile_reg_lslr2()[,input$data_reg_x_lslr]
      cat("Correlation coefficient (prediction model accuracy)")
      print(cor(inputfile_reg_lslr2()[,input$data_reg_y_lslr],est.Y))
      print(paste("Regression equation：y =",lslrcoef()[1], "+", lslrcoef()[2], "*x"))
    })
    #data_insp_out
    data_insp_lslr <- reactive({
      est.Y <- lslrcoef()[[1]]+lslrcoef()[[2]]*inputfile_reg_lslr2()[,input$data_reg_x_lslr]
      residuals=inputfile_reg_lslr2()[,input$data_reg_x_lslr]-est.Y
      data_insp_lslr=mutate(inputfile_reg_lslr2(),est.Y)%>%
        mutate(residuals)
      return(data_insp_lslr)
    })
    output$tableout_insp_lslr <- DT::renderDataTable({
      data_insp_lslr()
    })
    output$downloadData_insp_lslr <- downloadHandler(
      filename = function() {
        paste("data-", Sys.Date(), ".csv", sep="")
      },
      content = function(file) {
        write.csv(data_insp_lslr(), file)
      }
    )
    #dataout tab
    #data_predY_out
    data_predY_lslr <- reactive({
      predY <- lslrcoef()[[1]]+lslrcoef()[[2]]*inputfile_predY_lslr()[,input$data_predY_x_lslr]
      data_predY_lslr=mutate(inputfile_predY_lslr(),predY)
      return(data_predY_lslr)
    })
    output$tableout_predY_lslr <- DT::renderDataTable({
      data_predY_lslr()
    })
    output$downloadData_predY_lslr <- downloadHandler(
      filename = function() {
        paste("data-", Sys.Date(), ".csv", sep="")
      },
      content = function(file) {
        write.csv(data_predY_lslr(), file)
      }
    )　
    #data_predX_out
    data_predX_lslr <- reactive({
      predX <-(inputfile_predX_lslr()[,input$data_predX_y_lslr]-lslrcoef()[[1]])/lslrcoef()[[2]]
      data_predX_lslr=mutate(inputfile_predX_lslr(),predX) 
      return(data_predX_lslr)
    })
    output$tableout_predX_lslr <- DT::renderDataTable({
      data_predX_lslr()
    })
    output$downloadData_predX_lslr <- downloadHandler(
      filename = function() {
        paste("data-", Sys.Date(), ".csv", sep="")
      },
      content = function(file) {
        write.csv(data_predX_lslr(), file)
      }
    )
  })#lslr pred swich end　　　　　　
  #lslr tab end--------------------------    
  
  ##lasso tab start---------
  #regCSV input
  inputfile_reg_lasso=serverf_csv_uplode("datafile_reg_lasso", stringsAsFactors = FALSE)
  inputfile_pred_lasso=serverf_csv_uplode("datafile_pred_lasso", stringsAsFactors = FALSE)
  #table output 
  output$table_reg_x_lasso <- DT::renderDataTable(
    inputfile_reg_lasso(), selection = list(target = 'column')
  )
  output$unused_rows_lasso = renderUI({
    selectInput("unused_rows_lasso", "",rownames(inputfile_reg_lasso()), multiple=T)
  })
  output$table_pred_x_lasso <- DT::renderDataTable(
    inputfile_pred_lasso(), selection = list(target = 'column')
  )
  #x_select
  output$data_reg_x_lasso = renderUI({ 
    selectInput("data_reg_x_lasso", "2.Select explanatory variables",colnames(inputfile_reg_lasso()), multiple=T)
  })
  
  #y_select
  output$data_reg_y_lasso = renderUI({ 
    selectInput("data_reg_y_lasso", "3.Select one objective variable", colnames(inputfile_reg_lasso()))
  })
  #predCSV input
  inputfile_pred_lasso=serverf_csv_uplode("datafile_pred_lasso", stringsAsFactors = FALSE)
  #x_pred_select
  output$data_pred_x_lasso = renderUI({ 
    selectInput("data_pred_x_lasso", "Select the same explanatory variables",colnames(inputfile_pred_lasso()), multiple=T)
  })
  
  
  ##prediction_lasso modeling
  observeEvent(input$regression_button_lasso, {#pred swich start
    #unset rows handling----
    inputfile_reg_lasso2 <- reactive({
      if (!is.null(input$unused_rows_lasso)) {
        delete_row_number <- match(input$unused_rows_lasso, rownames(inputfile_reg_lasso()))
        inputfile_reg_lasso2 <- inputfile_reg_lasso()[-c(delete_row_number),]
      } else {
        inputfile_reg_lasso2 <- inputfile_reg_lasso() 
      }
      return(inputfile_reg_lasso2) 
    })
    #unused table  
    output$Usage_table_lasso <- DT::renderDataTable({
      inputfile_reg_lasso2()
    })  
    output$downloadData_lasso <- downloadHandler(
      filename = function() {
        paste("data-", Sys.Date(), ".csv", sep="")
      },
      content = function(file) {
        write.csv(inputfile_reg_lasso2(), file)
      }
    )#---- 
    #scale off
    Best.lasso <-  reactive({
    results.cvlasso<-glmnet::cv.glmnet(x = as.matrix(inputfile_reg_lasso2()[,input$data_reg_x_lasso]), 
                                       y = as.matrix(inputfile_reg_lasso2()[,input$data_reg_y_lasso]),
                                      alpha = 1,nlambda=100,nfolds=5)
    bestlamda<-results.cvlasso$lambda.min　
    Best.lasso<- glmnet::glmnet(x = as.matrix(inputfile_reg_lasso2()[,input$data_reg_x_lasso]), 
                                y = as.matrix(inputfile_reg_lasso2()[,input$data_reg_y_lasso]), 
                                alpha = 1,lambda=bestlamda) 
    return(Best.lasso)
  })
    #scale on
    Best.lasso_s <-  reactive({
      results.cvlasso_s<-glmnet::cv.glmnet(x = as.matrix(scale(inputfile_reg_lasso2()[,input$data_reg_x_lasso])), 
                                         y = as.matrix(scale(inputfile_reg_lasso2()[,input$data_reg_y_lasso])),
                                         alpha = 1,nlambda=100,nfolds=5)
      bestlamda_s<-results.cvlasso_s$lambda.min　
      Best.lasso_s<- glmnet::glmnet(x = as.matrix(scale(inputfile_reg_lasso2()[,input$data_reg_x_lasso])), 
                                  y = as.matrix(scale(inputfile_reg_lasso2()[,input$data_reg_y_lasso])), 
                                  alpha = 1,lambda=bestlamda_s) 
      return(Best.lasso_s)
    })
    ##model output
    #summary tab
    output$plot_regression_lasso <- renderPlot({
      est.Y <- predict(Best.lasso(), 
                       newx = as.matrix(inputfile_reg_lasso2()[,input$data_reg_x_lasso])) 
      #plot(y = as.matrix(inputfile_reg_lasso()[,input$data_reg_y_lasso]),
      #     est.Y, 
      plot(y = est.Y,
           as.matrix(inputfile_reg_lasso2()[,input$data_reg_y_lasso]),      
           xlab="Measured value", 
           ylab="Prediction value")
      abline(a=0, b=1, col="red", lwd=2)
    })
    output$summary_cor_lasso <- renderPrint({
      cat("Correlation coefficient (prediction model accuracy)")
      est.Y <- predict(Best.lasso(), 
                       newx = as.matrix(inputfile_reg_lasso2()[,input$data_reg_x_lasso]))
     print(cor(y = as.matrix(inputfile_reg_lasso2()[,input$data_reg_y_lasso]),est.Y) )
     })
    
    output$coef_table_lasso <- renderDataTable({
      as.data.frame(as.matrix(Best.lasso_s()$beta))
    })
    
    output$coef_barplot_lasso <- renderPlot({
      coefdata=as.data.frame(as.matrix(Best.lasso_s()$beta))
      barplot(coefdata[,1], 
              names.arg=row.names(coefdata),
              main="",
              ylim=c(-1,1))
    })
  　#prediction dataout tab
    #data_insp_out
    data_insp_lasso <- reactive({
      prediction_data <- predict(Best.lasso(), 
                                 newx = as.matrix(inputfile_reg_lasso2()[,input$data_reg_x_lasso]))
      residuals=inputfile_reg_lasso2()[,input$data_reg_y_lasso]-prediction_data
      data_insp_lasso=mutate(inputfile_reg_lasso2(),prediction_data)%>%
        mutate(residuals)
      return(data_insp_lasso)
    })
    output$tableout_insp_lasso <- DT::renderDataTable({
      data_insp_lasso()
      })
    output$downloadData_insp_lasso <- downloadHandler(
      filename = function() {
        paste("data-", Sys.Date(), ".csv", sep="")
      },
      content = function(file) {
        write.csv(data_insp_lasso(), file)
      }
    )
    #data_pred_out
    data_pred_lasso <- reactive({
      predY <- predict(Best.lasso(), newx = as.matrix(inputfile_pred_lasso()[,input$data_pred_x_lasso]))
      data_pred_lasso=mutate(inputfile_pred_lasso(),predY) 
      return(data_pred_lasso)
    })
    output$tableout_pred_lasso <- DT::renderDataTable({
      data_pred_lasso()
    })
    output$downloadData_pred_lasso <- downloadHandler(
      filename = function() {
        paste("data-", Sys.Date(), ".csv", sep="")
      },
      content = function(file) {
        write.csv(data_pred_lasso(), file)
      }
    )　　　
  })#lasso pred swich end　　　　　　
#lasso tab end--------------------------    
 
###Classification tab-------
  ##decisonTree tab start------
  inputfile_tree=serverf_csv_uplode("datafile_tree", stringsAsFactors = FALSE)
  #inputfile_pred_tree=serverf_csv_uplode("datafile_pred_tree", stringsAsFactors = FALSE)
  #table output 
  output$table_x_tree <- DT::renderDataTable(
    inputfile_tree(), selection = list(target = 'column')
  )
  output$unused_rows_tree = renderUI({
    selectInput("unused_rows_tree", "",rownames(inputfile_tree()), multiple=T)
  })
  #output$table_x_tree <- DT::renderDataTable(
   # inputfile_tree(), selection = list(target = 'column')
  #)
  #x_select
  output$data_x_tree = renderUI({ 
    selectInput("data_x_tree", "2.Select explanatory variables",colnames(inputfile_tree()), multiple=T)
  })
  #y_select
  output$data_y_tree = renderUI({ 
    selectInput("data_y_tree", "3.Select one objective variable", colnames(inputfile_tree()))
  })
  #tree modeling
  observeEvent(input$regression_button_tree, {#tree swich start
    #unset rows handling----
    inputfile_tree2 <- reactive({
      if (!is.null(input$unused_rows_tree)) {
        delete_row_number <- match(input$unused_rows_tree, rownames(inputfile_tree()))
        inputfile_tree2 <- inputfile_tree()[-c(delete_row_number),]
      } else {
        inputfile_tree2 <- inputfile_tree() 
      }
      return(inputfile_tree2) 
    })
    #unused table  
    output$Usage_table_tree <- DT::renderDataTable({
      inputfile_tree2()
    })  
    output$downloadData_tree <- downloadHandler(
      filename = function() {
        paste("data-", Sys.Date(), ".csv", sep="")
      },
      content = function(file) {
        write.csv(inputfile_tree2(), file)
      }
    )#----
  decisonTree=reactive({
    decisonTree= rpart(as.formula(paste0(input$data_y_tree,"~",
                                  paste(input$data_x_tree,collapse = "+")
                       )),
                       data=inputfile_tree2(),
                       control=rpart.control(minsplit=input$minsplit_number)
                       )
  return(decisonTree)
  })
  #tree surmary output
  output$summary_tree <- renderPlot({
    fancyRpartPlot(decisonTree(),caption = "",
                   node.fun = function(x, labs, digits, varlen) paste(labs,"n=", x$frame$n))
  })
  
  })#tree swich end
  ##k-means tab strat---------
  #CSV input
  inputfile_kmeans=serverf_csv_uplode("datafile_kmeans", stringsAsFactors = FALSE)
  #table output 
  output$table_kmeans <- DT::renderDataTable(
    inputfile_kmeans(), selection = list(target = 'column')
  )
  output$unused_rows_kmeans = renderUI({
    selectInput("unused_rows_kmeans", "",rownames(inputfile_kmeans()), multiple=T)
  })
  #x_select
  output$data_kmeans = renderUI({ 
    selectInput("data_kmeans", "2.Select variable columns",colnames(inputfile_kmeans()), multiple=T)
    
  })
  
  ##modeling
  #observeEvent(input$regression_button_gap_kmeans, {#gap swich start
   #scale on
   #gap statistics
   # opKmean=reactive({ 
   #    opKmean <- clusGap(scale(inputfile_kmeans()[,input$data_kmeans]),
    #                                      FUNcluster=kmeans, 
     #                                     K.max = 15,
      #                                    B=500, 
       #                                   verbose = interactive()) 
    #  return(opKmean)
    #})
   
    #gap summary tab
    #output$summary_gap_kmeans <- renderPlot({
    #plot(opKmean(),ylim=c(0,0.8)) 
    #  })
    #})#gap swich end
    
    #clustering
    #scale on
    observeEvent(input$regression_button_clus_kmeans, {#k-means swich start
      #unset rows handling----
      inputfile_kmeans2 <- reactive({
        if (!is.null(input$unused_rows_kmeans)) {
          delete_row_number <- match(input$unused_rows_kmeans, rownames(inputfile_kmeans()))
          inputfile_kmeans2 <- inputfile_kmeans()[-c(delete_row_number),]
        } else {
          inputfile_kmeans2 <- inputfile_kmeans() 
        }
        return(inputfile_kmeans2) 
      })
      #unused table  
      output$Usage_table_kmeans <- DT::renderDataTable({
        inputfile_kmeans2()
      })  
      output$downloadData_kmeans <- downloadHandler(
        filename = function() {
          paste("data-", Sys.Date(), ".csv", sep="")
        },
        content = function(file) {
          write.csv(inputfile_kmeans2(), file)
        }
      )#----
    km_model=reactive({
      km_model=kmeans(scale(inputfile_kmeans2()[,input$data_kmeans]),
             centers = input$cluster_number) 
      return(km_model)
    })
    #visualization of clusters
    output$summary_clus_kmeans <- renderPlot({
      fviz_cluster(km_model(), data = scale(inputfile_kmeans2()[,input$data_kmeans]))
    })

    #dataout tab
    data_out_kmeans <- reactive({
      data_out_kmeans=cbind(km_model()$cluster,inputfile_kmeans2()) 
      return(data_out_kmeans)
    })
    output$tableout_kmeans <- DT::renderDataTable({
      data_out_kmeans()
    })
    output$downloadData_kmeans <- downloadHandler(
      filename = function() {
        paste("data-", Sys.Date(), ".csv", sep="")
      },
      content = function(file) {
        write.csv(data_out_kmeans(), file)
      }
    )
    
  })#k-means swich end
  ##k-means tab end----------
  
  #debug-----------------------
  output$zzzz=renderPrint({
    #print(typeof(dsd_list()))
    #print(class())
    print(as.numeric(input$unset_rows))
    
  })
   output$zzzzz=renderTable({
     #dsd_list()
    })
   output$zzz=renderPlot({
     plot_gantt(pert_model())
   })
  
  
  
  

   
  
###end----------------------------------------------------
})
