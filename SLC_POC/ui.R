
library(shiny)
library(shinydashboard)
library(dplyr)
library(lubridate)
library(DT)
library(googleVis)
library(readr)
library(ggplot2)

ui <- dashboardPage(skin=c("red"),
                    
                    dashboardHeader(title ="SLC Activewear "),
                    
                    dashboardSidebar(sidebarMenu(
                      menuItem("Dashboard",icon = icon("dashboard",lib="glyphicon"),menuSubItem("Current Month",tabName = "currentmonth"),menuSubItem("Current Year",tabName = "currentyear")),
                      menuItem("Inventory Management",menuSubItem("Current Month",tabName="currentmonthim"),menuSubItem("Current Year",tabName="currentyearim"),icon = icon("glyphicon glyphicon-home",lib="glyphicon")),
                      menuItem("Forecasting",tabName = "forecasting",icon = icon("glyphicon glyphicon-fast-forward",lib="glyphicon"),badgeLabel = "Prediction", badgeColor = "green")
                      
                    )),
                    dashboardBody(
                      tabItems(
                        # First tab content
                        tabItem(tabName="currentmonth",
                                fluidPage(fluidRow(
                                  valueBoxOutput("mrevenue",width=3),
                                  valueBoxOutput("mavg_order",width=3),
                                  valueBoxOutput("mrecustomers",width=3),
                                  valueBoxOutput("dVisitsBox",width=3)
                                  
                                ),
                                fluidRow(infoBoxOutput("mEratio",width=3)),
                                fluidRow( box(
                                  tabsetPanel(
                                    tabPanel("today",htmlOutput("today_sales_graph"),selectInput("sty","",selected=NULL,choices = list("today","Yesterday"))),
                                    tabPanel("sales",htmlOutput("monthly_sales_graph")),
                                    tabPanel("Location",htmlOutput("sales_Location_graph"))
                                    
                                  ),
                                  title="current month Analysis",
                                  solidHeader = TRUE,
                                  width=6
                                 ),

                                box(
                                  tabsetPanel(
                                    tabPanel("sales of a Month",htmlOutput("Month_sales_graph_everyYear"))
                                    # tabPanel("projection",htmlOutput("slider_input"),sliderInput("Percentage",
                                    #                                                              min = 1,
                                    #                                                              max = 100
                                    # )
                                    #)

                                  ),
                                  title="Sales Analysis March",
                                  solidHeader = TRUE,
                                  width=6
                                ),
                                
                                box(
                                  title = "Revenue BY Category",
                                  width = 6,
                                  solidHeader = TRUE,
                                  collapsible = FALSE,
                                  htmlOutput("rvcgraph")
                                )
                                
                                )
                                
                                )),
                        ##FirstTabItem Finished
                        tabItem(tabName = "currentyear",
                                fluidPage(fluidRow(
                                  
                                  box(
                                    tabsetPanel(
                                      tabPanel("sales",htmlOutput("Yearly_sales_graph")),
                                      tabPanel("Total Sales BY Location of 2015",htmlOutput("sales_Location_graph_Year"))
                                      # tabPanel("Total Sales BY Location",htmlOutput("sales_Location_Total_Year"))
                                    ),
                                    title="current year Analysis",
                                    solidHeader = TRUE,
                                    width=6
                                  ),
                                  box(
                                    tabsetPanel(
                                      tabPanel("Sales of a Year",htmlOutput("year_wise_revenue"))
                                    ),
                                    title="Year Analysis of Revenue",
                                    soliidHeader = TRUE,
                                    width=6
                                  ),
                                  box(
                                    tabsetPanel(
                                      tabPanel("Top 10 best Products in current yer(2016)",htmlOutput("topproducts"))
                                      
                                    ),
                                    # title="Top 10 best Products in current yer(2016)",
                                    solidHeader = TRUE,
                                    width=4
                                  ),
                                  box(
                                    tabsetPanel(
                                      tabPanel("Top 5 best Products in current yer(2016) in location wise",htmlOutput("topproductsinlocwise"))
                                      
                                    ),
                                    # title="Top 5 best Products in current yer(2016) in location wise",
                                    solidHeader = TRUE,
                                    width=4
                                  )),
                                  fluidRow(
                                    valueBoxOutput("yrevenue",width=3),
                                    valueBoxOutput("yavg_order",width=3),
                                    valueBoxOutput("yrecustomers",width=3),
                                    infoBoxOutput("yEratio",width=3)
                                    
                                    
                                  )
                                  
                                )
                        ),
                        ##SecondTabITem Finished
                        tabItem(tabName = "currentmonthim",
                                fluidPage(fluidRow(width=12,
                                                   infoBoxOutput("minventory",width=3),
                                                   infoBoxOutput("mtopproduct",width=3),
                                                   infoBoxOutput("miturn",width=3),
                                                   infoBoxOutput("munits",width=3)),
                                          fluidRow(
                                            box(
                                              
                                              tabPanel("Quantity Sold",htmlOutput("mQty_Sold_loc")),
                                              title="Quantity Sold in Location in a month",
                                              soliidHeader = TRUE,
                                              width=6
                                            ),
                                            box(
                                              
                                              tabPanel("SalesPricing",htmlOutput("msalespricing")),
                                              title="SalesandPricing",
                                              soliidHeader = TRUE,
                                              width=6
                                            ),
                                            box(
                                              tabsetPanel(
                                                tabPanel(
                                                  DT::dataTableOutput('tbl'),
                                                  p(class = 'text-center', downloadButton('x3', 'Download Filtered Data'))
                                                  
                                                )),
                                              title="Available Inventory stock",
                                              solidHeader = TRUE,
                                              width=6
                                            )
                                          )
                                          
                                )),
                        tabItem(tabName = "currentyearim",fluidPage(                                                                 
                          fluidRow(
                            box(
                              
                              tabPanel("Quantity Sold",htmlOutput("YQty_Sold_loc")),
                              title="Quantity Sold in Location in a year",
                              soliidHeader = TRUE,
                              width=6
                            ),
                            box(
                              
                              tabPanel("SalesPricing",htmlOutput("ysalespricing")),
                              title="SalesandPricing",
                              soliidHeader = TRUE,
                              width=6
                            ),
                            infoBoxOutput("yinventory",width=3),
                            infoBoxOutput("ytopproduct",width=3),
                            infoBoxOutput("yiturn",width=3),
                            infoBoxOutput("yunits",width=3)
                          )
                        )
                        
                        )
                        
                      )
                      
                      
                      ##tabitems
                      
                    )         
                    ##dashboard body  
                    
)
##DashboardPage                   





