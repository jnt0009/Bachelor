library(shiny)
library(networkD3)
library(googleVis)
library(dplyr)
library(plyr)
library(RCurl)
library(rsconnect)
library(wordcloud)
library(tm)
library(SnowballC)

source('source.R')
shinyServer(function(input, output,session) {
  ## Functions ##
  
  

  
  dataReturn <-  eventReactive(input$info,{
    ## Read data ##
    num = as.numeric(input$Episode)
    print(num)
    x = getURL(episodes[num])
    y = read.csv(text = x)
    print('data downloaded')
    #print(y)
    y
  })
  
  dataTransform <- reactive({
        req(dataReturn())
        y = dataReturn()
        y1 <- select(y, line, type, talking, talking_to, words)
        y2 <- filter(y1, talking != "???" & talking != "")
        y3 <- y2[complete.cases(y2),]
        #y3$count <- sapply(strsplit(as.character(y3$words), " "), length)
        y3$talking <- as.character(y3$talking)
        y3$talking_to <- as.character(y3$talking_to)
        for(i in 1:length(y3$talking)){
          print(i)
          if(y3$talking[i] == y3$talking_to[i]){
            print('error saved')
            y3$talking_to[i] = "self" 
          }
        }
        y4 <- select(y3,talking,talking_to)
        y4$count = 1
        y5 <- plyr::ddply(y4, .(talking, talking_to), transform, count = length(count))
        y6 <- unique(y5)
        y6$talking <- as.character(y6$talking)
        y6$talking_to <- as.character(y6$talking_to)
        y6
  })
  
  word.cloud <- reactive({
    req(dataReturn())
    y = dataReturn()
    y1 <- select(y, line, type, talking, talking_to, words) ## Select data 
    y2 <- filter(y1, talking != "???" & talking != "")
    y3 <- y2[complete.cases(y2),]
    #y3$count <- sapply(strsplit(as.character(y3$words), " "), length)
    y3$talking <- as.character(y3$talking)
    y3$talking_to <- as.character(y3$talking_to)
    for(i in 1:length(y3$talking)){
      print(i)
      if(y3$talking[i] == y3$talking_to[i]){
        print('error saved')
        y3$talking_to[i] = "self" 
      }
    }
    y4 <- filter(y3, talking == input$People) #& talking_to == "chris")
    
    y5 <- Corpus(VectorSource(y4$words))
    y5.strip <- tm_map(y5, stripWhitespace)
    y5.lower <- tm_map(y5.strip, tolower)
    y5.stop <- tm_map(y5.lower, removeWords, stopwords("english"))
    y5.fin <- tm_map(y5.stop, stemDocument)
    
    
  })
  
  sankey <- reactive({
    focus = input$People
    df = dataTransform()
    df <- filter(df, talking == focus )
    gvisSankey(
      data = df,
      from = 'talking',
      to = 'talking_to'
    )
  })
  
  ##Outputs ##
  output$names <- renderUI({
    tagList(
      selectInput('People','Choose a Person',
                  choices = unique(dataTransform()[1]),
                  ##list('Viewer','Multi Download','Audit') one day all of these will work
                  selected = NULL
      )
    )
  }) ## Creates a drop down of names
  
  output$Visuals <- renderUI({
    # 
    # tagList(
    #   selectInput('People','Choose a visual',
    #               choices = list('Sankey','Word Cloud', 'table'),
    #               ##list('Viewer','Multi Download','Audit') one day all of these will work
    #               selected = NULL
    #   )
    # )
  }) ## Creates a drop down of names
  
  output$df <-renderDataTable({
    req(input$People)
    dataTransform()
  })  ## ouputs tags to a main panel
  
  ## Viz ##
  output$viz <- renderGvis({
     #require(input$People)
     sankey()
   }) ## Outputs a sankey plot to a main panel 
  output$WC <- renderPlot({
    v <- word.cloud()
    wordcloud(v, scale=c(4,.5), min.freq=1, max.words=600, random.order=T, rot.per=0.5, use.r.layout=T, colors=brewer.pal(8, "Dark2"))
    
  })
  ## Ladies info
  output$stats <- renderUI({
   require(input$People)
   Lrow = match(as.character(input$People),ladies$rn)
   print(Lrow)
   pic = ladies[Lrow]$pic
    tagList(tags$img(
      src = pic,
      width = 200,
      height = 150
    ))
  })  
  output$Name <- renderText({
    req(input$People)
    Lrow = match(as.character(input$People),ladies$rn)
    l.name = ladies[Lrow]$rn
    print(l.name)
  })
  output$Occupation <- renderText({
    req(input$People)
    Lrow = match(as.character(input$People),ladies$rn)
    job = as.character(ladies[Lrow]$occupation)
    if(input$People == 'heather' & as.numeric(input$Episode) > 3 ){
      print("Has been kissed")
    } else {
      print(job)
    }
  })
})



## Deploy 
#rsconnect::deployApp('C:/Users/Jamarius Taylor/Desktop/Projects/Personal/theBachelor', appTitle = "The Bachelor")
## logs
## https://www.shinyapps.io/admin/#/application/352938/logs
