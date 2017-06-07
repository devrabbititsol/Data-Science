library(shiny)
library(shinydashboard)
library(plotly)
library(leaflet)
library(ggiraph)
library(highcharter)
library(wordcloud)
ui <- dashboardPage(skin=c("purple"),
                    
                    dashboardHeader(title ="SocialMedia Analysis "),
                    
                    dashboardSidebar(sidebarMenu(
                      menuItem("Facebook Analysis",tabName = "FacebookAnalysis"),
                      menuItem("Twitter Analysis",tabName = "TwitterAnalysis")
                      
                    )),
                    
                    dashboardBody(
                     
                      tabItems(       
                      tabItem(tabName = "FacebookAnalysis",
                              fluidPage(
                                fluidRow( 
                                  
                                  
                                  valueBoxOutput("Postsperweek",width=3),
                                  valueBoxOutput("Likesperweek",width=3),
                                  valueBoxOutput("Commentsperweek",width=3),
                                  valueBoxOutput("Sharesperweek",width=3)),
                                
                                
                             fluidRow(
                                
                                box(
                                  tabsetPanel(
                                    tabPanel("Wordcloud",plotOutput("plotwc1",height = "350px"),height="350px"),
                                    tabPanel("Location Wise Posts",leafletOutput("mymap1",height = "350px"),height="350px")
                                    # tabPanel("Gender Percentage",plotlyOutput("mymap3",height = 400))
                                ),
                                  title="Posts Analysis",
                                  solidHeader = TRUE,
                                  height="500px",
                                  width=6,
                                  status="warning",
                                  collapsible = TRUE
                                ),
                             
                               
                               box(
                                 tabsetPanel(
                                   tabPanel("Posts per Hour",highchartOutput("my6map",height = "350px"),height="350px"),
                                   tabPanel("Emotions of the Posts",highchartOutput("plot2",height = "350px"),height="350px"),
                                   tabPanel("country wise Likes",highchartOutput("plotwc3",height = "350px"),height="350px")
                      
                                 ),
                                 
                                 title="Posts Analysis",
                                 solidHeader = TRUE,
                                 height="500px",
                                 width=6,
                                 status="success",
                                 collapsible = TRUE
                               )
                                 
                             ))
                      ),
                     
                        # First tab content
                        tabItem(tabName="TwitterAnalysis",
                                
                                fluidPage(
                                  
                                  fluidRow(
                                     valueBoxOutput("retweetcount",width=4),
                                     valueBoxOutput("followerscount",width=4),
                                     valueBoxOutput("favouritescount",width=4)),
                                    
                                  
                                  fluidRow(box(
                                    tabsetPanel(
                                      tabPanel("Wordcloud",plotOutput("plotwc",height = "350px"),height="350px"),
                                      tabPanel("Location Wise Tweets",leafletOutput("mymap",height = "350px"),height="350px"),
                                      tabPanel("Proportion of the Sentiments",plotlyOutput("my7map",height = "350px"),height="350px"),
                                     tabPanel("Recent top 10 list",htmlOutput("Revcurr",height = "350px"),height="350px")
                                     # tabPanel("Recent top 10 list",dataTableOutput("mytable1"))
                                      
                                    
                                     ),
                                    title="Location Wise Tweets",
                                    solidHeader = TRUE,
                                    height="500px",
                                    width=6,
                                    status="success",
                                    collapsible = TRUE
                                    
                                  ),
                                  box(
                                    tabsetPanel(
                                      
                                      tabPanel("Emotions of the Tweets",highchartOutput("plot1",height = "350px"),height="350px"),
                                      tabPanel("Tweets per Minute",highchartOutput("mymap6",height = "350px"),height="350px"),
                                      tabPanel("Tweets per Hour",highchartOutput("hour",height = "350px"),height="350px"),
                                      tabPanel("Replied and notreplied Tweets",plotlyOutput("plotwc10",height = "350px"),height="350px")
                                      
                                    ),
                                    
                                    title=" Tweets Analysis",
                                    solidHeader = TRUE,
                                    height="500px",
                                    width=6,
                                    status="warning",
                                    collapsible = TRUE
                                    
                                  )
                                  
                                  )
                                ))
                      
                      
                      )))



