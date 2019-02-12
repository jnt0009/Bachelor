library(shiny)
library(shinythemes)
Episodes = list.files('C:/Users/Jamarius Taylor/Desktop/Projects/Personal/theBachelor/bachelor_subtitles/data/episodes')
ui <- fluidPage(
  theme = shinytheme(theme = 'sandstone'),
  titlePanel('The Bachelor'),
  fluidRow(
    column(3,
           h4('Options'),
           tags$br(),
           selectInput('Episode','Choose an episode',
                       choices = c(1:21),
                       ##list('Viewer','Multi Download','Audit') one day all of these will work
                       selected = NULL
           ),
           actionButton('info','Select Episode'),
           tags$br(),
           uiOutput("names"),
           tags$br(),
           uiOutput("Visuals"),
           uiOutput("stats"),
           h3(textOutput("Name")),
           h3(textOutput("Occupation"))
    ),
    mainPanel(
      h4('Visuals'),
      tabsetPanel(type = "tabs",
                  tabPanel('Sankey',htmlOutput('viz')),
                  tabPanel('Word Cloud',plotOutput('WC'))
      )
    )
  )
)
