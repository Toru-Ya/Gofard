if(!require(shiny)){
  install.packages("shiny",dependencies = TRUE)
  library(shiny)
}
if(!require(shinythemes)){
  install.packages("shinythemes",dependencies = TRUE)
  library(shinythemes)
}
if(!require(DT)){
  install.packages("DT",dependencies = TRUE)
  library(DT)
}
if(!require(ragg)){
  install.packages("ragg",dependencies = TRUE)
  library(ragg)
}



shinyUI(navbarPage(theme = shinytheme("sandstone"),"Gofard",
      ##Home tab-------
       tabPanel("Home",
       h1("Gofard - Data Science Toolkit for all R and D"),
       h2("What is Gofard?"),
       p("Gofard is an open source GUI app for data analysis techniques."),
       p("The license of this app complies with GPLv3. The source code is open to the public at the following URL."),
       a(href="https://github.com/Toru-Ya/Gofard", 
         p("https://github.com/Toru-Ya/Gofard")),
       p("Gofard's homepage is the following URL."),
       a(href="http://gofard.com/", 
         p("Home page")),
       helpText("©️ 2022 Toru Yashima"),
       h2("________________________________________________"),
       h2("Gofard ver.1.2 Menu"),
       h3("■Data-handling"),
       p("Drawing functions (scatter plot, bar plot, box plot,and histogram): Observe the big picture of data and create easy-to-understand graphs."),
       p("Correlation matrix:Create scatterplot matrices and correlation matrices to quickly visualize the features between each element."),
       p("Aggregate calculation: calculates the total, maximum, minimum, mean, median, and standard deviation of the data."),
       h3("■Planning method"),
       p("Creation of experimental design: A screening design with the minimum number of moves is created based on the experimental conditions using the DSD."),
       p("Process Planning(PERT): Calculate the time required for a project that includes multiple processes using the PERT."),
       h3("■Numerical prediction"),
       p("Single regression analysis: predicts one objective variable with one explanatory variable using the least squares method. Can also be used for quantitative analysis."),
       p("Multivariate regression analysis(LASSO): predict one objective variable with multiple explanatory variables in LASSO regression. It can also be used for factor analysis and conditional optimization."),
       h3("■Data classification"),
       p("Decision Tree: Decision trees allow for the creation of tree model diagrams and analysis of data characteristics."),
       p("k-means: Classification can be performed for each sample of data with similar characteristics using the k-means."),
       h2("________________________________________________"),
       ),
       
       
       ##How to use tab----------
       tabPanel("How to use (Link)",
         h3("How to make data for analysis"),
         a(href="https://gofard.com/how-to-make-data-for-analysis/", 
           p("Japanese")),
         a(href="https://gofard.com/en/how-to-make-data-for-analysis/", 
           p("English")),
         h3("Drawing functions"),
         a(href="https://gofard.com/how-to-use-drawing-functions/", 
           p("Japanese")),
         a(href="https://gofard.com/en/how-to-use-drawing-functions/", 
           p("English")),
         h3("Correlation matrix"),
         a(href="https://gofard.com/correlation-matrix/", 
           p("Japanese")),
         a(href="https://gofard.com/en/correlation-matrix/", 
           p("English")),
         h3("Design of experiments (DSD)"),
         a(href="https://gofard.com/how-to-use-the-design-of-experiments-dsd/", 
           p("Japanese")),
         a(href="https://gofard.com/en/how-to-use-the-design-of-experiments-dsd/", 
           p("English")),
         h3("Process planing (PERT)"),
         a(href="https://gofard.com/how-to-use-process-plan-pert/", 
           p("Japanese")),
         a(href="https://gofard.com/en/how-to-use-process-plan-pert/", 
           p("English")),
         h3("About numerical prediction"),
         a(href="https://gofard.com/numerical-prediction/", 
           p("Japanese")),
         a(href="https://gofard.com/en/umerical-prediction/", 
           p("English")),
         h3("Simple-regression-analysis"),
         a(href="https://gofard.com/simple-regression-analysis/", 
           p("Japanese")),
         a(href="https://gofard.com/en/simple-regression-analysis/", 
           p("English")),
         h3("Multivariate regression analysis(lasso)"),
         a(href="https://gofard.com/multivariate-regression-analysis-lasso/", 
           p("Japanese")),
         a(href="https://gofard.com/en/multivariate-regression-analysis-lasso/", 
           p("English")),
         h3("Decision-tree"),
         a(href="https://gofard.com/decision-tree/", 
           p("Japanese")),
         a(href="https://gofard.com/en/decision-tree/", 
           p("English")),
         h3("K-means"),
         a(href="https://gofard.com/k-means/", 
           p("Japanese")),
         a(href="https://gofard.com/k-means/", 
           p("English")),
         ),
       
       ##Data handling tab-----
      navbarMenu("Data-handling",
      #scatter plot-----           
      tabPanel("Scatter plot", sidebarLayout(
        sidebarPanel(
          h3("Data setting"),
          h5("1. Select a csv file"),
          uif_csv_uplode("datafile", ""),
          
          h5("2.Choose columns for axes"),
          htmlOutput("colname1"),
          htmlOutput("colname2"),
          h5("3.Color-code: select categorical data columns"),
          htmlOutput("colname3"),
          h5("4.Regression Line: Select whether to add a regression line to the graph"),
          htmlOutput("colname4"),
          h5("5.You can choose unused rows."),
          htmlOutput("colname5"),
          h5("6.Create graph"),
          actionButton("trigger_data_plot", "Output plot"),
          ),
          mainPanel(
          tabsetPanel(type = "tabs",
                      tabPanel("Uploaded data", 
                               DT::dataTableOutput("table")),
                      tabPanel("Usage data", 
                               DT::dataTableOutput("Usage_table"),
                               h6("Output table data as csv"),
                               downloadButton("downloadData_scatter", "Download")
                               ),
                      tabPanel("Output plot", 
                               h5("You can check the data of the dragged point."),
                               plotOutput("scatter_plot", brush = brushOpts(id="plot_brush")),
                               DT::dataTableOutput("plot_brushedPoints"),
                               ),
                      
        ))
      )),
      ##bar_box plot-------
      tabPanel("Bar graph/Box plot", sidebarLayout(
        sidebarPanel(
          h3("Data setting"),
          h5("1.Select a csv file"),
          uif_csv_uplode("datafile_barbox", ""),
          h5("2.Choose columns for axes"),
          htmlOutput("data_barbox_x"),
          htmlOutput("data_barbox_y"),
          h5("3.Statistics: Select the statistic for the vertical axis of the bar graph"),
          selectInput("bar_stat", "",c("Average value"="mean",
                                          "Median"="median",
                                          "Total value"="sum",
                                          "Maximum value"="max",
                                          "Minimum value"="min",
                                          "Standard deviation"="sd")),
          h5("4.Scatter Points: Add data scatter points to your bar chart"),
          selectInput("bar_scatter", "",c("OFF","ON")),
          h5("5.You can choose unused rows."),
          htmlOutput("unused_rows_barbox"),
          h5("6.Create graph"),
          actionButton("trigger_barbox", "Output plot"),
        ),
        mainPanel(
          tabsetPanel(type = "tabs",
                      tabPanel("Upload data", 
                               DT::dataTableOutput("table_barbox")),
                      tabPanel("Usage data", 
                               DT::dataTableOutput("Usage_table_barbox"),
                               h6("Output table data as csv"),
                               downloadButton("download_usagedata_barbox", "Download")
                               ),
                      tabPanel("Output plot", 
                               h5("Bar graph"),
                               plotOutput("bar_plot"),
                               h5("Box plot"),
                               plotOutput("box_plot"),
                      ),
          ))
      )),
      ##histogram-------
      tabPanel("histogram", sidebarLayout(
        sidebarPanel(
          h3("Data setting"),
          h5("1.Select a csv file"),
          uif_csv_uplode("datafile_histogram", ""),
          h5("2.Choose columns for axes"),
          htmlOutput("data_histogram_x"),
          h5("3.Color-code: select categorical data columns"),
          htmlOutput("data_histogram_color"),
          h5("4.You can choose unused rows."),
          htmlOutput("unused_rows_histogram"),
          h5("5.Create graph"),
          actionButton("trigger_histogram", "Output plot"),
        ),
        mainPanel(
          tabsetPanel(type = "tabs",
                      tabPanel("Upload data", 
                               DT::dataTableOutput("table_histogram")),
                      tabPanel("Usage data", 
                               DT::dataTableOutput("Usage_table_histogram"),
                               h6("Output table data as csv"),
                               downloadButton("download_usagedata_histogram", "Download")
                      ),
                      tabPanel("Output plot", 
                               h5("histogram"),
                               plotOutput("histogram_plot"),
                      ),
          ))
      )),
      ##corrplot------
      tabPanel("Correlation matrix", sidebarLayout(
        sidebarPanel(
          h3("Data setting"),
          h5("1.Select a csv file"),
          uif_csv_uplode("datafile_corrplot", ""),
          h5("2.Select data columns to use"),
          htmlOutput("data_corrplot"),
          h6("※Select a column that contains only numerics."),
          h5("3.You can choose unused rows."),
          htmlOutput("unused_rows_corrplot"),
          h5("4.Create graph"),
          actionButton("trigger_corrplot", "Output plot"),
        ),
        mainPanel(
          tabsetPanel(type = "tabs",
                      tabPanel("Upload data", 
                               DT::dataTableOutput("table_corrplot")),
                      tabPanel("Usage data", 
                               DT::dataTableOutput("Usage_table_corrplot"),
                               h6("Output table data as csv"),
                               downloadButton("download_usagedata_corrplot", "Download")
                      ),
                      tabPanel("Output plot", 
                               h5("Scatter plot matrix"),
                               plotOutput("scatter_matrix"),
                               h5("correlation matrix"),
                               p("Blue circles indicates positive correlation, red circles indicates negative correlation."),
                               p("The size of the upper right circle indicates the strength of the correlation."),
                               plotOutput("corrplot_plot"),
                      ),
          ))
      )),
      ##data aggregate calculation tab-------
      tabPanel("Aggregate calculation", sidebarLayout(
        sidebarPanel(
          h3("Data setting"),
          h5("1.Select a csv file"),
          uif_csv_uplode("datafile_ac", ""),
          htmlOutput("data_ac"),
          h6("※Select a column that contains only numerics."),
          h5("3.You can choose unused rows."),
          htmlOutput("unused_rows_ac"),
          actionButton("button_ac", "Calculation")
        ),
        mainPanel(
          tabsetPanel(type = "tabs",
                      tabPanel("Upload data", 
                               DT::dataTableOutput("table_ac")),
                      tabPanel("Usage data", 
                               DT::dataTableOutput("Usage_table_ac"),
                               h6("Output table data as csv"),
                               downloadButton("download_usagedata_ac", "Download")
                      ),
                      tabPanel("Result", 
                               h4("Data list"),
                               #h6("左端にクラスタ番号が入っています。"),
                               DT::dataTableOutput("tableout_ac"),
                               h6("Output table data as csv"),
                               downloadButton("downloadData_ac", "Download"))
          )
        )
      )),
      ),##Data handling tab end-----
      ##design tab--------
      navbarMenu("Planing",
      #DSD--------------       
      tabPanel("Experimental design (DSD)", sidebarLayout(
        sidebarPanel(
          h3("Experimental condition table"),
          h5("1. Select a csv file of Experimental condition table"),
          uif_csv_uplode("datafile_dsd", ""),
          actionButton("button_dsd", "Output")
        ),
        mainPanel(
          tabsetPanel(type = "tabs",
                      tabPanel("Check the data",
                               h4("Experimental condition table"), 
                               DT::dataTableOutput("table_dsd")),
                      tabPanel("Result", 
                               h4("Experiment Plan"),
                               DT::dataTableOutput("tableout_dsd"),
                               h6("Output table data as csv"),
                               downloadButton("downloadData_dsd", "Download")
                      ),
          )
        )
      )),#dsd end--------
      #PERT--------------       
      tabPanel("Process plannig (PERT)", sidebarLayout(
        sidebarPanel(
          h3("Work table input"),
          h5("1.Select a csv file of work table"),
          uif_csv_uplode("datafile_pert", ""),
          actionButton("button_pert", "Output")
        ),
        mainPanel(
          tabsetPanel(type = "tabs",
                      tabPanel("Result",
                               h4("Check table"), 
                               dataTableOutput("table_pert",
                                               width = "50%"),
                               h4("Scheduling output"),
                               h5("Gantt chart"),
                               plotOutput("pert_gantt"),
                               h4("Shortest required time"), 
                               textOutput("summary_pert")
                               ),
          )
        )
      )),#PERT end--------
      ),  #design tab tab--------
     ##prediction tab-----
     navbarMenu("Analysis/Prediction",
     #lslr-----
     tabPanel("Single regression analysis", sidebarLayout(
              sidebarPanel(
              h3("Data setting"),
              h5("1.Select a csv file of training data"),
              uif_csv_uplode("datafile_reg_lslr", ""),
              htmlOutput("data_reg_x_lslr"),
              htmlOutput("data_reg_y_lslr"),
              h5("4.You can choose unused rows."),
              htmlOutput("unused_rows_lslr"),
              h5("5.Select a csv file of prediction data for y"),
              uif_csv_uplode("datafile_predY_lslr", ""),
              htmlOutput("data_predY_x_lslr"),
              h5("6.Select a csv file of prediction data for x"),
              uif_csv_uplode("datafile_predX_lslr", ""),
              htmlOutput("data_predX_y_lslr"),
              actionButton("regression_button_lslr", "Calculation")
              ),
              mainPanel(
              tabsetPanel(type = "tabs",
                          tabPanel("Upload data",
                                   h4("Training data"), 
                                   DT::dataTableOutput("table_reg_x_lslr"),
                                   h4("Prediction data for y"),
                                   DT::dataTableOutput("table_predY_x_lslr"),
                                   h4("Prediction data for x"),
                                   DT::dataTableOutput("table_predX_y_lslr")),
                          tabPanel("Usage training data", 
                                   DT::dataTableOutput("Usage_table_lslr"),
                                   h6("Output table data as csv"),
                                   downloadButton("download_usagedata_lslr", "Download")
                          ),
                          tabPanel("Result", 
                                   h4("Measured-calculated plot"),
                                   plotOutput("plot_regression_lslr", 
                                              brush = brushOpts(id="plot_brush_reg_lslr")),
                                   DT::dataTableOutput("plot_brushedPoints_reg_lslr"),
                                   h4("Correlation coefficient:"),
                                   h6("The closer to 1, the better the prediction accuracy of the model."),
                                   verbatimTextOutput("summary_cor_lslr"),
                                   h4("Model validation data list"),
                                   h6("Table data that combines the calculated values with the original training data."),
                                   DT::dataTableOutput("tableout_insp_lslr"),
                                   h6("Output table data as csv"),
                                   downloadButton("downloadData_insp_lslr", "Download"),
                                ),
                          tabPanel("Prediction data output",
                                   h4("Prediction data list for y"),
                                   h6("Table data that combines the y predicted values with the original training data."),
                                   DT::dataTableOutput("tableout_predY_lslr"),                                       
                                   h6("Output table data as csv."),
                                    downloadButton("downloadData_predY_lslr", "Download"),
                                   h4("Prediction data list for x"),
                                   h6("Table data that combines the x predicted values with the original training data."),
                                   DT::dataTableOutput("tableout_predX_lslr"),                                       
                                   h6("Output table data as csv"),
                                   downloadButton("downloadData_predX_lslr", "Download"),
                                ),
                    )
                  )
                )),#lslr end--------
     #lasso-----
     tabPanel("Multivariate regression analysis (LASSO)", sidebarLayout(
        sidebarPanel(
          h3("Data setting"),
          h5("1.Select a csv file of training data"),
          uif_csv_uplode("datafile_reg_lasso", ""),
          htmlOutput("data_reg_x_lasso"),
          htmlOutput("data_reg_y_lasso"),
          h5("4.You can choose unused rows."),
          htmlOutput("unused_rows_lasso"),
          h5("5.Select a csv file of prediction data"),
          uif_csv_uplode("datafile_pred_lasso", ""),
          htmlOutput("data_pred_x_lasso"),
          actionButton("regression_button_lasso", "Calculation")
        ),
        mainPanel(
          tabsetPanel(type = "tabs",
                      tabPanel("Upload data",
                               h4("Training data"), 
                               DT::dataTableOutput("table_reg_x_lasso"),
                               h4("Prediction data"),
                               DT::dataTableOutput("table_pred_x_lasso")),
                      tabPanel("Usage training data", 
                               DT::dataTableOutput("Usage_table_lasso"),
                               h6("Output table data as csv"),
                               downloadButton("download_usagedata_lasso", "Download")
                      ),
                      tabPanel("Result", 
                               h4("Measured-calculated plot"),
                               plotOutput("plot_regression_lasso", 
                                          brush = brushOpts(id="plot_brush_reg_lasso")),
                               DT::dataTableOutput("plot_brushedPoints_reglasso"),
                               h4("Correlation coefficient:"),
                               h6("The closer to 1, the better the prediction accuracy of the model."),
                               verbatimTextOutput("summary_cor_lasso"),
                               h4("regression coefficients of explanatory variables："),
                               h6("The closer to 1, the larger the target value, and the closer to -1, the smaller the target value."),
                               plotOutput("coef_barplot_lasso"),
                               h5("List of regression coefficients of explanatory variables"),
                               dataTableOutput("coef_table_lasso",
                                               width = "50%"),
                               h4("Model validation data list"),
                               h6("Table data that combines the calculated values with the training data."),
                               DT::dataTableOutput("tableout_insp_lasso"),
                               h6("Output table data as csv"),
                               downloadButton("downloadData_insp_lasso", "Download"),
                               ),
                       tabPanel("Prediction data output",
                               h4("Prediction data list"),
                               h6("Table data that combines the predicted values with the original training data."),
                               DT::dataTableOutput("tableout_pred_lasso"),
                               h6("Output table data as csv"),
                               downloadButton("downloadData_pred_lasso", "Download"),
                               ),
          )
        )
      )),#lasso end-------
     
     ),#pred_tab end
     # Classification tab ------
     navbarMenu("Data classification",
     #tree--------           
     tabPanel("Decision Tree", sidebarLayout(
       sidebarPanel(
         h3("Data setting"),
         h5("1.Select a csv file of training data"),
         uif_csv_uplode("datafile_tree", ""),
         htmlOutput("data_x_tree"),
         htmlOutput("data_y_tree"),
         h5("3.You can choose unused rows."),
         htmlOutput("unused_rows_tree"),
         h5("4.Change the minimum number of split samples (default: 20)"),
         numericInput("minsplit_number", "Specify minimum number of split samples",
                      min = 1, max = 1000, value = 20, step = 1),
         actionButton("regression_button_tree", "Calculation")
       ),
       mainPanel(
         tabsetPanel(type = "tabs",
                     tabPanel("Upload data",
                              DT::dataTableOutput("table_x_tree"),
                              ),
                     tabPanel("Usage data", 
                              DT::dataTableOutput("Usage_table_tree"),
                              h6("Output table data as csv"),
                              downloadButton("download_usagedata_tree", "Download")
                     ),
                     tabPanel("Result", 
                              h4("tree model:"),
                              plotOutput("summary_tree"), 
                       )
                     )),
     )),#tree end-----------
     #k-means tab-------
     tabPanel("k-means", sidebarLayout(
         sidebarPanel(
           h3("Data setting"),
           h5("1.Select a csv file of training data"),
           uif_csv_uplode("datafile_kmeans", ""),
           htmlOutput("data_kmeans"),
           h6("※Select a column that contains only numbers."),
           h5("3.You can choose unused rows."),
           htmlOutput("unused_rows_kmeans"),
           #h5("3.最適クラスター数の確認"),
           #actionButton("regression_button_gap_kmeans", "確認実行"),
           h5("4.Enter the number of clusters to classify"),
           numericInput("cluster_number", "Specify number of clusters",
                      min = 1, max = 50, value = 0, step = 1),
         　actionButton("regression_button_clus_kmeans", "Calculation")
       ),
       mainPanel(
         tabsetPanel(type = "tabs",
                     tabPanel("Upload data", 
                              DT::dataTableOutput("table_kmeans")),
                     tabPanel("Usage data", 
                              DT::dataTableOutput("Usage_table_kmeans"),
                              h6("Output table data as csv"),
                              downloadButton("download_usagedata_kmeans", "Download")
                     ),
                     #tabPanel("最適クラスター数", 
                    #           plotOutput("summary_gap_kmeans")),
                     tabPanel("Result", 
                              plotOutput("summary_clus_kmeans"),
                              h4("Data list"),
                              h6("The cluster number is on the left side."),
                              DT::dataTableOutput("tableout_kmeans"),
                              h6("Output table data as csv."),
                              downloadButton("downloadData_kmeans", "Download"))
         )
       )
     )),
     ),#class_navebar tab end--------
     #debug tab----------
     #tabPanel("debug",
      #        textOutput("zzzz"),
      #        tableOutput("zzzzz")
              
              
     #)#check tab end     
       ))
       
