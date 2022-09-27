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


shinyServer(function(input, output) {
###start------------------------------------------------------
###Data_tab-----------------
  ##Data plot tab-----------------
  #CSV input
  inputfile=serverf_csv_uplode("datafile", stringsAsFactors = FALSE)
  #table output
  output$table <- DT::renderDataTable({
    inputfile()
  })
  #Data_select
  output$colname1 = renderUI({ 
    selectInput("plot_x", "x軸を選択", colnames(inputfile()))
  })
  output$colname2 = renderUI({ 
    selectInput("plot_y", "y軸を選択", colnames(inputfile()))
  })
  #scatter plot
  output$scatter_plot <- renderPlot({
    input$trigger_scatter_plot
    plot(isolate(inputfile()[, c(input$plot_x, input$plot_y)]))
  })
  
  output$plot_brushedPoints <- DT::renderDataTable({
    res <- brushedPoints(inputfile(), input$plot_brush, 
                         xvar = input$plot_x,
                         yvar = input$plot_y)
    
    if (nrow(res) == 0)
      return()
    res
  })
  ##ac tab ---------
  #CSV input
  inputfile_ac=serverf_csv_uplode("datafile_ac", stringsAsFactors = FALSE)
  #table output 
  output$table_ac <- DT::renderDataTable(
    inputfile_ac(), selection = list(target = 'column')
  )
  #select
  output$data_ac = renderUI({ 
    selectInput("data_ac", "2.計算する列を選択",colnames(inputfile_ac()), multiple=T)
    
  })
  
  observeEvent(input$button_ac, {#ac swich start
    #ac process
    data_out_ac <- reactive({
      xy_si=data.frame(matrix(rep(NA, 6), nrow=1))[numeric(0), ]
      colnames(xy_si)=c("合計値","最大値","最小値","平均値","中央値","標準偏差")
      for (i in input$data_ac) {
        x_n=colnames(inputfile_ac()[i])
        xy_si=inputfile_ac()%>%
          summarise("合計値"=sum(.data[[x_n]],na.rm = TRUE),
                    "最大値"=max(.data[[x_n]],na.rm = TRUE),
                    "最小値"=min(.data[[x_n]],na.rm = TRUE),
                    "平均値"=mean(.data[[x_n]],na.rm = TRUE),
                    "中央値"=median(.data[[x_n]],na.rm = TRUE),
                    "標準偏差"=sd(.data[[x_n]],na.rm = TRUE),
                    
          )%>%
          rbind(xy_si)
      }
      data_out_ac=apply(xy_si,2,rev)%>%
        t()%>%
        as.data.frame()
      colnames(data_out_ac)=colnames(inputfile_ac()[c(input$data_ac)])
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
  
  #x_select
  output$data_reg_x_lslr = renderUI({ 
    selectInput("data_reg_x_lslr", "2.説明変数を一つ選択",colnames(inputfile_reg_lslr()), multiple=F)
  })
  
  #y_select
  output$data_reg_y_lslr = renderUI({ 
    selectInput("data_reg_y_lslr", "3.目的変数を一つ選択", colnames(inputfile_reg_lslr()))
  })
  #predYCSV input
  inputfile_predY_lslr=serverf_csv_uplode("datafile_predY_lslr", stringsAsFactors = FALSE)
  #table
  output$table_predY_x_lslr <- DT::renderDataTable(
    inputfile_predY_lslr(), selection = list(target = 'column')
  )
  #x_predY_select
  output$data_predY_x_lslr = renderUI({ 
    selectInput("data_predY_x_lslr", "5.2と同種の説明変数を選択",colnames(inputfile_predY_lslr()), multiple=F)
  })
  #predXCSV input
  inputfile_predX_lslr=serverf_csv_uplode("datafile_predX_lslr", stringsAsFactors = FALSE)
  #table
  output$table_predX_y_lslr <- DT::renderDataTable(
    inputfile_predX_lslr(), selection = list(target = 'column')
  )
  #y_predX_select
  output$data_predX_y_lslr = renderUI({ 
    selectInput("data_predX_y_lslr", "5.3と同種の目的変数を選択",colnames(inputfile_predX_lslr()), multiple=F)
  })
  
  ##prediction_lslr modeling
  observeEvent(input$regression_button_lslr, {#pred swich start
    lslrmodel <-  reactive({
      lslrmodel<-lm(inputfile_reg_lslr()[,input$data_reg_y_lslr]~inputfile_reg_lslr()[,input$data_reg_x_lslr])
      return(lslrmodel)
    })
    lslrcoef=reactive({
    lslrcoef=lslrmodel()$coefficients
    return(lslrcoef)
    })
    ##model output
    #summary tab
    output$plot_regression_lslr <- renderPlot({
      est.Y <- lslrcoef()[[1]]+lslrcoef()[[2]]*inputfile_reg_lslr()[,input$data_reg_x_lslr]
      plot(inputfile_reg_lslr()[,input$data_reg_y_lslr],
           est.Y, 
           xlab="Measured value", 
           ylab="Prediction value")
      abline(a=0, b=1, col="red", lwd=2)
    })
    output$summary_cor_lslr <- renderPrint({
      est.Y <- lslrcoef()[[1]]+lslrcoef()[[2]]*inputfile_reg_lslr()[,input$data_reg_x_lslr]
      cat("相関係数（予測モデルの精度）")
      print(cor(inputfile_reg_lslr()[,input$data_reg_y_lslr],est.Y))
      print(paste("回帰式：y =",lslrcoef()[1], "+", lslrcoef()[2], "*x"))
    })
    #data_insp_out
    data_insp_lslr <- reactive({
      est.Y <- lslrcoef()[[1]]+lslrcoef()[[2]]*inputfile_reg_lslr()[,input$data_reg_x_lslr]
      data_insp_lslr=mutate(inputfile_reg_lslr(),est.Y)
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
  output$table_pred_x_lasso <- DT::renderDataTable(
    inputfile_pred_lasso(), selection = list(target = 'column')
  )
  #x_select
  output$data_reg_x_lasso = renderUI({ 
    selectInput("data_reg_x_lasso", "2.説明変数を選択",colnames(inputfile_reg_lasso()), multiple=T)
  })
  
  #y_select
  output$data_reg_y_lasso = renderUI({ 
    selectInput("data_reg_y_lasso", "3.目的変数を一つ選択", colnames(inputfile_reg_lasso()))
  })
  #predCSV input
  inputfile_pred_lasso=serverf_csv_uplode("datafile_pred_lasso", stringsAsFactors = FALSE)
  #x_pred_select
  output$data_pred_x_lasso = renderUI({ 
    selectInput("data_pred_x_lasso", "5.2と同種の説明変数を選択",colnames(inputfile_pred_lasso()), multiple=T)
  })
  
  
  ##prediction_lasso modeling
  observeEvent(input$regression_button_lasso, {#pred swich start
    #scale off
    Best.lasso <-  reactive({
    results.cvlasso<-glmnet::cv.glmnet(x = as.matrix(inputfile_reg_lasso()[,input$data_reg_x_lasso]), 
                                       y = as.matrix(inputfile_reg_lasso()[,input$data_reg_y_lasso]),
                                      alpha = 1,nlambda=100,nfolds=5)
    bestlamda<-results.cvlasso$lambda.min　
    Best.lasso<- glmnet::glmnet(x = as.matrix(inputfile_reg_lasso()[,input$data_reg_x_lasso]), 
                                y = as.matrix(inputfile_reg_lasso()[,input$data_reg_y_lasso]), 
                                alpha = 1,lambda=bestlamda) 
    return(Best.lasso)
  })
    #scale on
    Best.lasso_s <-  reactive({
      results.cvlasso_s<-glmnet::cv.glmnet(x = as.matrix(scale(inputfile_reg_lasso()[,input$data_reg_x_lasso])), 
                                         y = as.matrix(scale(inputfile_reg_lasso()[,input$data_reg_y_lasso])),
                                         alpha = 1,nlambda=100,nfolds=5)
      bestlamda_s<-results.cvlasso_s$lambda.min　
      Best.lasso_s<- glmnet::glmnet(x = as.matrix(scale(inputfile_reg_lasso()[,input$data_reg_x_lasso])), 
                                  y = as.matrix(scale(inputfile_reg_lasso()[,input$data_reg_y_lasso])), 
                                  alpha = 1,lambda=bestlamda_s) 
      return(Best.lasso_s)
    })
    ##model output
    #summary tab
    output$plot_regression_lasso <- renderPlot({
      est.Y <- predict(Best.lasso(), 
                       newx = as.matrix(inputfile_reg_lasso()[,input$data_reg_x_lasso])) 
      plot(y = as.matrix(inputfile_reg_lasso()[,input$data_reg_y_lasso]),
           est.Y, 
           xlab="Measured value", 
           ylab="Prediction value")
      abline(a=0, b=1, col="red", lwd=2)
    })
    output$summary_cor_lasso <- renderPrint({
      cat("相関係数（予測モデルの精度）")
      est.Y <- predict(Best.lasso(), 
                       newx = as.matrix(inputfile_reg_lasso()[,input$data_reg_x_lasso]))
     print(cor(y = as.matrix(inputfile_reg_lasso()[,input$data_reg_y_lasso]),est.Y) )
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
                                 newx = as.matrix(inputfile_reg_lasso()[,input$data_reg_x_lasso]))
      data_insp_lasso=mutate(inputfile_reg_lasso(),prediction_data)
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
  #output$table_x_tree <- DT::renderDataTable(
   # inputfile_tree(), selection = list(target = 'column')
  #)
  #x_select
  output$data_x_tree = renderUI({ 
    selectInput("data_x_tree", "2.説明変数を選択",colnames(inputfile_tree()), multiple=T)
  })
  #y_select
  output$data_y_tree = renderUI({ 
    selectInput("data_y_tree", "3.目的変数を一つ選択", colnames(inputfile_tree()))
  })
  #tree modeling
  observeEvent(input$regression_button_tree, {#tree swich start
  decisonTree=reactive({
    #xcol=paste(input$data_x_tree,collapse = "+")
    #ycol=input$data_y_tree
    #yx=as.formula(paste0(ycol,"~",xcol))
    decisonTree= rpart(as.formula(paste0(input$data_y_tree,"~",
                                  paste(input$data_x_tree,collapse = "+")
                       )),
                       data=inputfile_tree(),
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
  #x_select
  output$data_kmeans = renderUI({ 
    selectInput("data_kmeans", "2.変数の列を選択",colnames(inputfile_kmeans()), multiple=T)
    
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
    km_model=reactive({
      km_model=kmeans(scale(inputfile_kmeans()[,input$data_kmeans]),
             centers = input$cluster_number) 
      return(km_model)
    })
    #visualization of clusters
    output$summary_clus_kmeans <- renderPlot({
      fviz_cluster(km_model(), data = scale(inputfile_kmeans()[,input$data_kmeans]))
    })

    #dataout tab
    data_out_kmeans <- reactive({
      data_out_kmeans=cbind(km_model()$cluster,inputfile_kmeans()) 
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
 
###end----------------------------------------------------
})
