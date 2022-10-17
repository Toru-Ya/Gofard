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

shinyUI(navbarPage(theme = shinytheme("sandstone"),"Gofard",
                   
      ##Home tab-------
       tabPanel("Home",
       h1("Gofard - Data Science Toolkit for all R and D"),
       h2("Gofardとは"),
       p("Gofardは研究開発に役立つデータ分析法をマウス操作で実行できるオープンソースアプリです。"),
       p("このアプリのライセンスはGPLv3に準拠します。ソースコートは下記URLに公開しています。"),
       a(href="https://github.com/Toru-Ya/Gofard", 
         p("https://github.com/Toru-Ya/Gofard")),
       p("Gofardのホームページは下記URLから。"),
       a(href="http://gofard.com/", 
         p("http://gofard.com/")),
       helpText("©️ 2022 Toru Yashima"),
       h2("________________________________________________"),
       h2("Gofard ver.1.1.2 Menu"),
       h3("■データハンドリング"),
       p("作図(散布図・棒グラフ・箱ヒゲ図)：データの全体像を観察し、分かりやすいグラフを作成できます。"),
       p("集計計算：データの合計値、最大値、最小値、平均値、中央値、標準偏差を計算します。"),
       h3("■計画法"),
       p("実験計画表作成：DSD法にて実験条件から最小手数のスクリーニング計画表を作成します。"),
       p("工程計画：PERT法にて複数の工程を含んだプロジェクトの所要時間を計算します。"),
       h3("■数値予測"),
       p("単回帰分析：最小二乗法にて1つの目的変数を1つの説明変数で予測します。定量分析にも利用できます。"),
       p("多変量回帰分析：LASSO回帰にて1つの目的変数を複数の説明変数で予測します。要因分析にも利用できます"),
       h3("■データ分類"),
       p("教師有り分類（決定木）：決定木によりツリーモデル図を作成し、データの特徴を分析できます。"),
       p("教師無し分類（k-means）：k-means法にて近い性質のデータサンプルごとに分類を行えます。"),
       h2("________________________________________________"),
       ),
       
       
       ##How to use tab----------
       tabPanel("使い方",
         h3("基本の分析用データの作り方"),
         a(href="https://gofard.com/how-to-make-data-for-analysis/", 
           p("https://gofard.com/how-to-make-data-for-analysis/")),
         h3("作図機能の使い方"),
         a(href="https://gofard.com/how-to-use-drawing-functions/", 
           p("https://gofard.com/how-to-use-drawing-functions/")),
         h3("実験計画表(DSD)の使い方"),
         a(href="https://gofard.com/how-to-use-the-design-of-experiments-dsd/", 
           p("https://gofard.com/how-to-use-the-design-of-experiments-dsd/")),
         h3("工程計画(PERT)の使い方"),
         a(href="https://gofard.com/how-to-use-process-plan-pert/", 
           p("https://gofard.com/how-to-use-process-plan-pert/")),
         h3("数値予測(回帰)の説明"),
         a(href="https://gofard.com/numerical-prediction/", 
           p("https://gofard.com/numerical-prediction/")),
         h3("単回帰分析(最小二乗法)の説明"),
         a(href="https://gofard.com/simple-regression-analysis/", 
           p("https://gofard.com/simple-regression-analysis/")),
         h3("多変量回帰分析(LASSO)の説明"),
         a(href="https://gofard.com/multivariate-regression-analysis-lasso/", 
           p("https://gofard.com/multivariate-regression-analysis-lasso/")),
         h3("決定木の説明"),
         a(href="https://gofard.com/decision-tree/", 
           p("https://gofard.com/decision-tree/")),
         h3("k-meansの説明"),
         a(href="https://gofard.com/k-means/", 
           p("https://gofard.com/k-means/")),
         ),
       
       ##Data handling tab-----
      navbarMenu("データハンドリング",
      #scatter plot-----           
      tabPanel("散布図", sidebarLayout(
        sidebarPanel(
          h3("データ設定"),
          h5("1. csvファイルを選択"),
          uif_csv_uplode("datafile", ""),
          
          h5("2.グラフ作成_軸にする列を選択"),
          htmlOutput("colname1"),
          htmlOutput("colname2"),
          h5("3.色分け：基準となるカテゴリデータ列を選択"),
          htmlOutput("colname3"),
          h5("4.回帰直線：グラフに回帰直線を追加するか選択"),
          htmlOutput("colname4"),
          h5("5.グラフ作成_図をクリックしてタブを確認"),
          actionButton("trigger_data_plot", "プロットを出力"),
          ),
          mainPanel(
          tabsetPanel(type = "tabs",
                      tabPanel("データ確認", 
                               DT::dataTableOutput("table")),
                      tabPanel("プロット出力", 
                               h5("ドラックしたポイントのデータを確認できます。"),
                               plotOutput("scatter_plot", brush = brushOpts(id="plot_brush")),
                               DT::dataTableOutput("plot_brushedPoints"),
                               ),
        ))
      )),
      ##bar_box polt
      tabPanel("棒グラフ・箱ヒゲ図", sidebarLayout(
        sidebarPanel(
          h3("データ設定"),
          h5("1. csvファイルを選択"),
          uif_csv_uplode("datafile_barbox", ""),
          h5("2.グラフ作成_軸にする列を選択"),
          htmlOutput("data_barbox_x"),
          htmlOutput("data_barbox_y"),
          h5("3.統計値：棒グラフの縦軸にする統計値を選択"),
          selectInput("bar_stat", "",c("平均値"="mean",
                                          "中央値"="median",
                                          "合計値"="sum",
                                          "最大値"="max",
                                          "最小値"="min",
                                          "標準偏差"="sd")),
          h5("4.散布点：棒グラフに素データの散布点を追加"),
          selectInput("bar_scatter", "",c("OFF","ON")),
          h5("5.グラフ作成_図をクリックしてタブを確認"),
          actionButton("trigger_barbox", "プロットを出力"),
        ),
        mainPanel(
          tabsetPanel(type = "tabs",
                      tabPanel("データ確認", 
                               DT::dataTableOutput("table_barbox")),
                      tabPanel("プロット出力", 
                               h5("棒グラフ"),
                               plotOutput("bar_plot"),
                               h5("箱ヒゲ図"),
                               plotOutput("box_plot"),
                      ),
          ))
      )),
      
      ##data aggregate calculation tab-------
      tabPanel("集計計算", sidebarLayout(
        sidebarPanel(
          h3("データ設定"),
          h5("1. csvファイルを選択"),
          uif_csv_uplode("datafile_ac", ""),
          htmlOutput("data_ac"),
          h6("※数値のみが入っている列を選択してください"),
          actionButton("button_ac", "計算実行")
        ),
        mainPanel(
          tabsetPanel(type = "tabs",
                      tabPanel("データ確認", 
                               DT::dataTableOutput("table_ac")),
                      tabPanel("集計計算結果", 
                               h4("データリスト"),
                               #h6("左端にクラスタ番号が入っています。"),
                               DT::dataTableOutput("tableout_ac"),
                               h6("表データをcsvで出力"),
                               downloadButton("downloadData_ac", "Download"))
          )
        )
      )),
      ),##Data handling tab end-----
      ##design tab--------
      navbarMenu("計画法",
      #DSD--------------       
      tabPanel("実験計画表作成(DSD)", sidebarLayout(
        sidebarPanel(
          h3("実験条件表入力"),
          h5("1. 実験条件表csvファイルを選択"),
          uif_csv_uplode("datafile_dsd", ""),
          actionButton("button_dsd", "作成実行")
        ),
        mainPanel(
          tabsetPanel(type = "tabs",
                      tabPanel("入力データ確認",
                               h4("実験条件表"), 
                               DT::dataTableOutput("table_dsd")),
                      tabPanel("実験計画表出力", 
                               h4("実験計画表"),
                               DT::dataTableOutput("tableout_dsd"),
                               h6("表データをcsvで出力"),
                               downloadButton("downloadData_dsd", "Download")
                      ),
          )
        )
      )),#dsd end--------
      #PERT--------------       
      tabPanel("工程計画作成(PERT)", sidebarLayout(
        sidebarPanel(
          h3("作業表入力"),
          h5("1. 作業表csvファイルを選択"),
          uif_csv_uplode("datafile_pert", ""),
          actionButton("button_pert", "作成実行")
        ),
        mainPanel(
          tabsetPanel(type = "tabs",
                      tabPanel("日程計画",
                               h4("作業表"), 
                               dataTableOutput("table_pert",
                                               width = "50%"),
                               h4("日程計画出力"),
                               h5("ガントチャート"),
                               plotOutput("pert_gantt"),
                               h4("最短所要時間"), 
                               textOutput("summary_pert")
                               ),
          )
        )
      )),#PERT end--------
      ),  #design tab tab--------
     ##prediction tab-----
     navbarMenu("数値予測",
     #lslr-----
     tabPanel("単回帰分析(最小二乗法)", sidebarLayout(
              sidebarPanel(
              h3("データ設定"),
              h5("1. 学習用データcsvファイルを選択"),
              uif_csv_uplode("datafile_reg_lslr", ""),
              htmlOutput("data_reg_x_lslr"),
              htmlOutput("data_reg_y_lslr"),
              h5("4.y予測用データcsvファイルを選択"),
              uif_csv_uplode("datafile_predY_lslr", ""),
              htmlOutput("data_predY_x_lslr"),
              h5("4.x予測用データcsvファイルを選択"),
              uif_csv_uplode("datafile_predX_lslr", ""),
              htmlOutput("data_predX_y_lslr"),
              actionButton("regression_button_lslr", "予測実行")
              ),
              mainPanel(
              tabsetPanel(type = "tabs",
                          tabPanel("入力データ確認",
                                   h4("学習用データ"), 
                                   DT::dataTableOutput("table_reg_x_lslr"),
                                   h4("y予測用データ"),
                                   DT::dataTableOutput("table_predY_x_lslr"),
                                   h4("x予測用データ"),
                                   DT::dataTableOutput("table_predX_y_lslr")),
                          tabPanel("予測モデル結果", 
                                   h4("実測値-計算値プロット"),
                                   plotOutput("plot_regression_lslr", 
                                              brush = brushOpts(id="plot_brush_reg_lslr")),
                                   DT::dataTableOutput("plot_brushedPoints_reg_lslr"),
                                   h4("相関係数:"),
                                   h6("1に近いほど予測精度の良いモデルです"),
                                   verbatimTextOutput("summary_cor_lslr"),
                                   h4("モデル検証データリスト"),
                                   h6("元の学習用データに目的変数の計算値を結合させた表データを返します"),
                                   DT::dataTableOutput("tableout_insp_lslr"),
                                   h6("表データをcsvで出力"),
                                   downloadButton("downloadData_insp_lslr", "Download"),
                                ),
                          tabPanel("予測データ出力",
                                   h4("y予測データリスト"),
                                   h6("元のy予測用データに目的変数yの予測値を結合させた表データを返します"),
                                   DT::dataTableOutput("tableout_predY_lslr"),                                       
                                   h6("表データをcsvで出力"),
                                    downloadButton("downloadData_predY_lslr", "Download"),
                                   h4("x予測データリスト"),
                                   h6("元のx予測用データに説明変数xの予測値を結合させた表データを返します"),
                                   DT::dataTableOutput("tableout_predX_lslr"),                                       
                                   h6("表データをcsvで出力"),
                                   downloadButton("downloadData_predX_lslr", "Download"),
                                ),
                    )
                  )
                )),#lslr end--------
     #lasso-----
     tabPanel("多変量回帰分析(LASSO)", sidebarLayout(
        sidebarPanel(
          h3("データ設定"),
          h5("1. 学習用データcsvファイルを選択"),
          uif_csv_uplode("datafile_reg_lasso", ""),
          htmlOutput("data_reg_x_lasso"),
          htmlOutput("data_reg_y_lasso"),
          h5("4.予測用データcsvファイルを選択"),
          uif_csv_uplode("datafile_pred_lasso", ""),
          htmlOutput("data_pred_x_lasso"),
          actionButton("regression_button_lasso", "予測実行")
        ),
        mainPanel(
          tabsetPanel(type = "tabs",
                      tabPanel("入力データ確認",
                               h4("学習用データ"), 
                               DT::dataTableOutput("table_reg_x_lasso"),
                               h4("予測用データ"),
                               DT::dataTableOutput("table_pred_x_lasso")),
                      tabPanel("予測モデル結果", 
                               h4("実測値-計算値プロット"),
                               plotOutput("plot_regression_lasso", 
                                          brush = brushOpts(id="plot_brush_reg_lasso")),
                               DT::dataTableOutput("plot_brushedPoints_reglasso"),
                               h4("相関係数:"),
                               h6("1に近いほど予測精度の良いモデルです"),
                               verbatimTextOutput("summary_cor_lasso"),
                               h4("説明変数の回帰係数："),
                               h6("１に近いほど目的値を大きくする、
                                  −１に近いほど目的値を小さく要因です"),
                               plotOutput("coef_barplot_lasso"),
                               h5("説明変数の回帰係数データリスト"),
                               dataTableOutput("coef_table_lasso",
                                               width = "50%"),
                               h4("モデル検証データリスト"),
                               h6("学習用データに目的変数の計算値を結合させた表データを返します"),
                               DT::dataTableOutput("tableout_insp_lasso"),
                               h6("表データをcsvで出力"),
                               downloadButton("downloadData_insp_lasso", "Download"),
                               ),
                       tabPanel("予測データ出力",
                               h4("予測データリスト"),
                               h6("予測データに目的変数の予測値を結合させた表データを返します"),
                               DT::dataTableOutput("tableout_pred_lasso"),
                               h6("表データをcsvで出力"),
                               downloadButton("downloadData_pred_lasso", "Download"),
                               ),
          )
        )
      )),#lasso end-------
     
     ),#pred_tab end
     # Classification tab ------
     navbarMenu("データ分類",
     #tree--------           
     tabPanel("決定木", sidebarLayout(
       sidebarPanel(
         h3("データ設定"),
         h5("1. 学習用データcsvファイルを選択"),
         uif_csv_uplode("datafile_tree", ""),
         htmlOutput("data_x_tree"),
         htmlOutput("data_y_tree"),
         h5("3.最小分割サンプル数を変更(デフォルト:20)"),
         numericInput("minsplit_number", "最小分割サンプル数を指定",
                      min = 1, max = 1000, value = 20, step = 1),
         actionButton("regression_button_tree", "分類実行")
       ),
       mainPanel(
         tabsetPanel(type = "tabs",
                     tabPanel("入力データ確認",
                              DT::dataTableOutput("table_x_tree"),
                              ),
                     tabPanel("分類結果", 
                              h4("ツリーモデル:"),
                              plotOutput("summary_tree"), 
                       )
                     )),
     )),#tree end-----------
     #k-means tab-------
     tabPanel("k-means", sidebarLayout(
         sidebarPanel(
           h3("データ設定"),
           h5("1. 学習用データcsvファイルを選択"),
           uif_csv_uplode("datafile_kmeans", ""),
           htmlOutput("data_kmeans"),
           h6("※数値のみが入っている列を選択してください"),
           #h5("3.最適クラスター数の確認"),
           #actionButton("regression_button_gap_kmeans", "確認実行"),
           h5("3.分類するクラスター数を入力"),
           numericInput("cluster_number", "クラスタ数を指定",
                      min = 1, max = 50, value = 0, step = 1),
         　actionButton("regression_button_clus_kmeans", "クラスタリング実行")
       ),
       mainPanel(
         tabsetPanel(type = "tabs",
                     tabPanel("データ確認", 
                              DT::dataTableOutput("table_kmeans")),
                     #tabPanel("最適クラスター数", 
                    #           plotOutput("summary_gap_kmeans")),
                     tabPanel("クラスタリング結果", 
                              plotOutput("summary_clus_kmeans"),
                              h4("データリスト"),
                              h6("左端にクラスター番号が入っています。"),
                              DT::dataTableOutput("tableout_kmeans"),
                              h6("表データをcsvで出力"),
                              downloadButton("downloadData_kmeans", "Download"))
         )
       )
     )),
     ),#class_navebar tab end--------
     
              
 
       #end-----------
       ))
       
