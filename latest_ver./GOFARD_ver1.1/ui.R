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
       h2("Gofard ver.1.0 Menu"),
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
       navlistPanel("Gofardでのデータ分析",
         tabPanel("基本の分析用データの作り方",
                  h3("基本の分析用データの作り方"),
                  p("Gofardは表形式のデータセットを使用してデータの分類や
                     機械学習による予測などの分析を行うことができます。"),
                  p("分析したいデータセットをExcelなどで下図の表データ形式で作成して頂き、
                     csvファイルとして保存してご準備ください。"),
                  p("csvファイルを読み込むことで様々なデータ分析をマウス操作で簡単に実行出来ます。"),
                  img(src="Gofard1.0_h1_jp.png", height = 350, width = 600),
                  p("例：散布図でのデータ確認"),
                  img(src="Gofard1.1_h2_jp.png", height = 500, width = 600),
                  h3("表データ作成の注意点"),
                  p("1.表データの１列目は番号にしてください。"),
                  p("2.表データの１行目は各データの項目名にしてください。"),
                  p("3.ファイル名や表中の文字は半角英数で入力、
                     かつ空白は使用しないでください。"),
                  p("※ Excelにてcsv形式で保存する際、「CSV UTF-8(コンマ区切り)」は使用しないでください。"),
         ),
         tabPanel("作図機能の使い方",
                  h3("作図機能の使い方"),
                  p("データから主要な情報を効率良く伝えるため、直感的に分かりやすい作図は大切です。Gofardでは散布図、棒グラフ、箱ヒゲ図を簡単に作図することが出来ます。"),
                  h3("散布図の使用例"),
                  p("アヤメ(iris)の3品種分類データに対してデータの特徴が分かるよう散布図を作成します。"),
                  p("このデータは3品種のアヤメ『setosa』、『versicolor』、『virginica』を各50サンプルずつ”がく片 (Sepal)”と”花弁 (Petal)” を幅および長さの4つの計測値でまとめたデータセットです。"),
                  p("散布図ではcsvファイルを入力し、横軸(x軸)と縦軸（y軸）に表示する数値データ列を設定し、プロット出力を押せば出力タブにプロットが出力されます。またデータを分類を示すカテゴリデータごとの色分けも可能です。回帰直線の設定をONにすると、散布図に最小二乗法法による回帰直線を表示することも可能です。"),
　　　　　　　　　p("実際にirisデータで試してみましょう。色分けはOFF、回帰直線はONで作図します。"),
                  img(src="Gofard1.1_plot1.png", height = 410, width = 500),
　　　　　　　　　img(src="Gofard1.1_plot2.png", height = 410, width = 500),
　　　　　　　　　p(""),
　　　　　　　　　p("これは全品種での数値データの散布図を示していますが、あまり読み取れる情報はありません。"),
                  p("次にカテゴリデータではある品種ごとに色分けして作図しましょう。"),
　　　　　　　　　img(src="Gofard1.1_plot3.png", height = 410, width = 500),
　　　　　　　　　img(src="Gofard1.1_plot4.png", height = 410, width = 500),
　　　　　　　　　p(""),
                  p("これで３種ごとのデータの特徴が理解しやすくなりました。"),
　　　　　　　　　p("またマウスでプロットをドラックすると、そのデータの詳細を確認することも出来ます。"),
　　　　　　　　　img(src="Gofard1.1_plot5.png", height = 410, width = 500),
　　　　　　　　　p(""),
　　　　　　　　　h3("棒グラフ・箱ヒゲ図の使用例"),
                  p("これらの作図はカテゴリーごとのデータ分布を見るのに適しています。"),
　　　　　　　　　p("csvファイルを入力し、x軸にカテゴリデータ列、y軸にデータ列、また棒グラフは縦軸に示す統計値を設定してプロット出力を押せば、出力タブにそれぞれの図が出力されます。"),
　　　　　　　　　p("また棒グラフについては散布点をONにすると、素データのプロットを重ね書きします。データの特徴を分かりやすく示せます。"),
　　　　　　　　　img(src="Gofard1.1_plot6.png", height = 410, width = 500),
　　　　　　　　　img(src="Gofard1.1_plot7.png", height = 410, width = 500),
　　　　　　　　　p(""),
　　　　　　　　　
         ),
         tabPanel("実験計画表(DSD)の使い方",
                  h3("実験計画表(DSD)の使い方"),
                  p("実験計画法の一種である決定的スクリーニング計画（Definitive Screening Design; DSD）に基づいて、
                    研究の初期段階で行うスクリーニング計画表を作成できます。"),
                  p("回帰などの分析を行えるほどのデータ数が無い初期段階において、
                    本計画法によるデータを取得することで少ない実験数で良好な予測モデルを作成でき、研究期間を短くすることが出来ます。"),
                  p("下図の「実験条件表」を作成し、Gofardに読み込めばワンクリックでスクリーニング計画表を出力します。"),
                  img(src="Gofard1.0_dsd2_jp.png", height = 350, width = 500),
                  p("「実験条件表」は下記に従って作成してください。"),
                  p("1. 1列目は「空白,1,2,3」、2列目は「level,-1,0,1」のこの表記にしてください。"),
                  p("2. 2列目以降から各実験条件（原料比、温度など）を「-1=低、0=中、1=高」の3水準で具体的な値を入力してください。"),
                  p("3. 2択の実験条件の場合(ON/OFFなど)、-1の行に０、１の行に１を入力してください。"),
                  p("低水準値、高水準値については実施出来る範囲で最も低い、或いは高い値を入力すると最も網羅的なスクリーニング計画になります。"),
         ),
         tabPanel("工程計画(PERT)の使い方",
                  h3("工程計画(PERT)の使い方"),
                  p("Gofardでは工程管理手法の一つであるPERT（Program Evaluation and Review Technique）に基づいて、
                    複数の並列工程を含むプロジェクトの最短所要時間を算出できます。"),
                  p("研究の進捗管理において、全体の予想完了期間やその律速となる重要工程を把握することは大切です。"),
                  p("複数の並列工程を含むプロジェクト全体を可視化する方法として下図のアローダイアグラムがあります。"),
                  p("例として多工程の有機合成計画のアローダイアグラムを示します"),
                  img(src="Gofard1.0_pert1.png", height = 230, width = 500),
                  p("1〜9の矢印の結合点はノードと呼び、各ノード間を各工程作業で示します。"),
                  p("Gofardでプロジェクトの最短所要時間を算出するためには、ダイアグラムに従って下表のように作業表のcsvファイルを作成してください。"),
                  img(src="Gofard1.0_pert2.png", height = 230, width = 500),
                  p("※ノードについて、出発点と終結点が一つに集結しないと正しく計算されません。この例では出発点を一つに集結させる為にダミー作業A,Bを追加しています。"),
                  p("作業表データを読み込み、計算を実行すると、所要時間を示したガントチャートを出力します。"),
                  img(src="Gofard1.0_pert3.png", height = 600, width = 500),
                  p("このプロジェクトの最短所要時間は10dayと分かります。"),
                  p("またクリティカルパス(工程に遅れが生じるとプロジェクト全体が遅れる重要な工程：CR）を赤色で、
                    そうでない工程(NC)を青色で示します。"),
                  p("またNC工程については余裕時間をバーの右側に水色で示してあります。"),
         ),
         tabPanel("数値予測(回帰)の説明",
                  h3("数値予測(回帰)の説明"),
                  p("数値予測では既知のデータに基づいて数値を予測します。回帰とも呼ばれます。"),
                  img(src="Gofard1.0_reg1.png", height = 300, width = 500),
                  p("予測したい目的の変数を「目的変数」、その目的変数の要因付ける変数を「説明変数」と言います。"),
                  p("回帰は目的変数値と説明変数値の揃った既知データセットから機会学習により予測モデルを作成し、
                    そのモデルに未知の説明変数値を代入することで未知の目的変数値を予測します。"),
                  h3("データの準備"),
                  p("回帰を行うには目的変数と説明変数の揃った既知データの「学習用データセット」と
                    予測したい説明変数値の入った「予測用データ」の２種類を準備してください。"),
                  img(src="Gofard1.0_reg2_jp.png", height = 430, width = 500),
                  p("※学習用と予測用のデータは１つのcsvファイルにまとめても、別のファイルに分けても分析できます"),
                  p("Gofardではサイドバーの番号順にデータを入力、計算を実行すれば予測モデルの検証と、
                    予測値が格納されたcsvファイルを出力することが出来ます。"),
         ),
         tabPanel("単回帰分析(最小二乗法)の説明",
                  h3("単回帰分析(最小二乗法)の説明"),
                  p("単回帰分析は一つの説明変数xと一つの目的変数yについての予測モデルを作ります。"),
                  p("Gofardでは最小二乗法に基づいて直線の予測式を作成し、その式を使ってx,y両方の予測値を計算できます。"),
                  p("最もシンプルで一般的な回帰手法で、測定機器を用いた定量分析など、様々な場面で利用されます。"),
                  img(src="Gofard1.0_lslr1_jp.png", height = 150, width = 500),
                  h3("化学物質の定量分析例"),
                  p("単回帰分析(最小二乗法)によるホルマリンの定量分析例を示します。"),
                  p("表データには試料水中のホルマリンを定量するため、
                  規定量のホルマリンを加えた溶液のホルマリン添加量のデータと、
                    その溶液を呈色させて分光光度計で色を濃さを評価したデータが入っています。"),
                  img(src="Gofard1.0_lslr2.png", height = 200, width = 350),
                  p("csvファイルを学習用データとして読み込み、説明変数xにホルマリン量データの列を、
                    目的変数yに色の濃さのデータの列を選択し、計算を実行します。"),
                  img(src="Gofard1.0_lslr3.png", height = 400, width = 500),
                  p(""),
                  img(src="Gofard1.0_lslr4.png", height = 400, width = 500),
                  p("予測モデル結果タブで予測モデル式やモデルの精度確認、
                    リストでの実測値とモデルの計算値、その残差が確認できます。。またこの式を検量線とも言います。"),
                  p(""),
                  p("さらに片方の変数値が入った予測用表データを用意する事で、
                    説明変数xあるいは目的変数yの予測値を作った予測モデルに従って計算できます。"),
                  p("本例では試料液のホルマリン含有量を知りたいので、
                    含有量不明の試料液の色の濃さの評価データが入った表データを準備し、
                    x予測用データとして読み込んで計算実行します。"),
                  img(src="Gofard1.0_lslr5.png", height = 420, width = 500),
                  p(""),
                  img(src="Gofard1.0_lslr6.png", height = 420, width = 500),
                  p("予測データ出力タブにx予測データリストとして予測結果値を含んだデータリストが出力されます。"),
                  p("結果データリストはcsvファイルとしてリスト下部からダウンロードできます。"),
         ),
         tabPanel("多変量回帰分析(LASSO)の説明",
                  h3("多変量回帰分析(LASSO)の説明"),
                  p("多変量回帰分析は複数の説明変数xで一つの目的変数yを予測するモデルを作ります。"),
                  p("GofardではLASSO回帰による多変量回帰分析を実行できます。"),
                  p("LASSO回帰は予測に必要な説明変数を選別する特徴があり、予測精度とモデル解釈性が両立された回帰手法です。要因解析、パロメータ最適化など幅広く利用されます。"),
                  h3("プラント運転データの要因解析例"),
                  p("アンモニアから窒素酸化物を生成する化学プラントの運転データから生産効率において重要な要因を解析してみましょう。"),
                  p("表データには３つの運転条件「Air Flow」(冷却風量)、「Water Temp」(窒素酸化物吸着塔の冷却水温)、「Acid Conc.」(酸濃度)、
                    そして生産効率に関わる「stack.loss」(窒素酸化物の吸着損失)のデータが入っています。"),
                  img(src="Gofard1.0_lasso1.png", height = 350, width = 350),
                  p("csvファイルを学習用データとして読み込み、説明変数に「Air Flow」、「Water Temp」、「Acid Conc.」の列を、
                    目的変数に「stack.loss」の列を選択し、計算を実行します。"),
                  img(src="Gofard1.0_lasso2.png", height = 380, width = 500),
                  p(""),
                  p("予測モデル結果タブで予測モデルの精度確認、説明変数の回帰係数、リストでの実測値とモデルの計算値との比較が行えます。"),
                  img(src="Gofard1.0_lasso3.png", height = 400, width = 500),
                  p(""),
                  p("さらに各説明変数の「影響」の目安になる回帰係数を確認出来ます。"),
                  img(src="Gofard1.0_lasso4.png", height = 500, width = 350),
                  p(""),
                  p("このデータセットからAir Flowが最もstack.lossと正の相関があるようです。対してAcid Conc.はstack.lossにほとんど影響しないとみなされています。"),
                  p("この結果を見て予測モデルの解釈と実際の物理化学的解釈が一致するか、実用性はどうかなどを議論できます。"),
                  h3("最適パロメータの探索"),
                  p("上記モデルが予測に有用であると仮定し、「stack.lossを安定して15以下に抑える運転条件は？」をモデルを元に考えましょう。"),
                  p("「Air Flow」、「Water Temp」を網羅的に変更した予測用データリストを作成します。「Acid Conc.」は86で固定とします。"),
                  img(src="Gofard1.0_lasso5.png", height = 400, width = 270),
                  p(""),
                  p("予測用データを読み込み、計算を実行します。"),
                  img(src="Gofard1.0_lasso6.png", height = 420, width = 500),
                  p(""),
                  p("予測データ出力タブに予測データリストとして予測結果値を含んだデータリストが出力されます。"),
                  p("結果データリストはcsvファイルとしてリスト下部からダウンロードできます。"),
                  img(src="Gofard1.0_lasso7.png", height = 400, width = 500),
                  p(""),
                  p("このデータリストを「データハンドリング：散布図」ツールで確認してみましょう"),
                  img(src="Gofard1.0_lasso8.png", height = 420, width = 500),
                  p(""),
                  p("データを見ると「Air Flow 55以下、Water Tempは20以下を保つ」という案を立てることができます。"),
                  p("また仮にWater Tempの制御が困難であればAir Flowが50以下のデータを取得する必要があると判断できる。"),
                  p("このように多変量解析は複合的な問題へ定量的な予測ができ、効率的なパロメータ探索を行なえます。"),
         ),
         tabPanel("決定木の説明",
                  h3("決定木の説明"),
                  p("GOFARDでは決定木という分類手法でツリーモデルを作成できます。"),
                  p("決定木は分類モデルの解釈がしやすい利点がある為、実験結果やアンケートなどの要因分析に有用な手法です。"),
                  h3("決定木の分析例"),
                  p("アヤメ(iris)の3品種分類データを決定木を用いて要因分析例を示します。"),
                  p("このデータは3品種のアヤメ『setosa』、『versicolor』、『virginica』を各50サンプルずつ”がく片 (Sepal)”と”花弁 (Petal)” を幅および長さの4つの計測値でまとめたデータセットです。"),
                  img(src="Gofard1.0_tree1.png", height = 450, width = 350),
                  p("csvファイルを読み込み、説明変数にがく片と花弁の幅および長さの列を、目的変数に品種の列を選択します。「最小分割サンプル数」は初期値20のまま計算を実行します。"),
                  img(src="Gofard1.0_tree2_jp.png", height = 370, width = 500),
                  p("分類結果タブにツリーモデルが出力されます。"),
                  img(src="Gofard1.0_tree3_jp.png", height = 380, width = 500),
                  p("ツリーの末端の分類結果を見ると3品種に分類されています。
                  　分割データの1行目は目的変数の種類を、
                    2行目は3品種にそれぞれ正しく分類された比率を、
                    3行目には分類データのサンプル数とその全体の割合を示しています。"),
                  p("枝分かれの部分には説明変数の分割条件を示しています。"),
                  p("この図から花弁の長さが2.5以下であれば100%でsetora種に分類でき、次に少し誤分類があるが花弁の幅1.8を閾値に残り2種に分類しています。"),
                  p("このように決定木では分類問題において重要な要因を分かりやすく可視化することができます。"),
                  p("また「最小分割サンプル数」は各ノードの最小サンプル数の設定値で、この値を小さくするほどツリーが深い階層構造になります。次に10に設定して分類をしてみます。"),
                  img(src="Gofard1.0_tree4_jp.png", height = 380, width = 500),
                  p("先ほどの結果に対し、2つ目の末端ノードが更に分割されました。データと目的に応じて適宜設定を変更し、解釈しやすいツリーモデルを作成してください。"),
         ),
         tabPanel("k-meansの説明",
                  h3("k-meansの説明"),
                  p("Gofardはk-mean法によるクラスタリング（データ分類）を行えます。"),
                  p("k-mean法は初めに分類したい数（クラスター数）を指定し、それに応じて似た特徴をもつデータサンプルごとに分類することができます。"),
                  p("データの特徴を探したり、分割回帰に利用されたりなど、様々な目的に利用される手法です。"),
                  h3("k-meansの分析例"),
                  p("アヤメ(iris)の3品種分類データに対してクラスタリング例を示します。"),
                  p("このデータは3品種のアヤメ『setosa』、『versicolor』、『virginica』を各50サンプルずつ”がく片 (Sepal)”と”花弁 (Petal)” を幅および長さの4つの計測値でまとめたデータセットです。"),
                  p("k-meansでは数値が入っている変数列を選択し、クラスター数を指定（この例では３）し、
                    クラスタリングを実行すれば結果タブにグラフとクラスター番号が結合されたデータリストを出力します。"),
                  img(src="Gofard1.0_kmeans1.png", height = 200, width = 500),
                  img(src="Gofard1.0_kmeans2.png", height = 300, width = 500),
                  p("誤分類もあるが、ほとんど3品種ごとにクラスター分けされていることがデータリストから確認出来る。このようにk-meansは似た特徴のデータサンプルごとに分類が出来ます。"),
                  p("結果データリストはcsvファイルとしてページ下部からダウンロードできます。"),
                  img(src="Gofard1.0_kmeans3.png", height = 300, width = 500),
                  p("結果したcsvデータを「散布図」や「棒グラフ・箱ヒゲ図」でどのような分類がされたか良く観察できるので、オススメです。"),
                  h3("k-meansの注意点"),
                  p("このアルゴリズムはクラスターの初期中心点をランダムに決定する為、計算毎に異なる結果を出すことがあります。irisデータも下図のような実行結果になる場合があります。"),
                  img(src="Gofard1.0_kmeans4.png", height = 300, width = 500),
                  p("その為、k-meansは複数回実行し、データと目的に応じて解釈しやすい結果を選択してください。"),
         ),
      
       )),
       
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
       
