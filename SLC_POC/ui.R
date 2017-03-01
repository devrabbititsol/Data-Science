
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
                      menuItem("Inventory Analysis",menuSubItem("Current Month",tabName="currentmonthim"),menuSubItem("Current Year",tabName="currentyearim"),icon = icon("glyphicon glyphicon-home",lib="glyphicon")),
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
                                  valueBoxOutput("dVisitsBox",width=3),
                                  valueBoxOutput("mEratio",width=3),
                                  valueBoxOutput("salesComparision",width=3),
                                  # valueBoxOutput("bouncerate",width=3),
                                  valueBoxOutput("mNewCustBox",width = 3),
                                  # valueBoxOutput("websiteconversionrate",width=3),
                                  valueBoxOutput("websitetrafficgrowth",width=3)
                                ),
                              
                                fluidRow( box(
                                  tabsetPanel(
                                    tabPanel("Day",htmlOutput("today_sales_graph"),selectInput("sty","",selected=NULL,choices = list("Today","Yesterday"))),
                                    tabPanel("Month",htmlOutput("monthly_sales_graph")),
                                    tabPanel("Location",htmlOutput("sales_Location_graph"))
                                    
                                  ),
                                  title="Sales Analysis of Current Month ",
                                  solidHeader = TRUE,
                                  width=6
                                 ),

                                box(
                                  tabsetPanel(
                                    tabPanel("Sales of a Month",htmlOutput("Month_sales_graph_everyYear"))
                                    

                                  ),
                                  title="Sales Analysis March",
                                  solidHeader = TRUE,
                                  width=6
                                )
                                
                                
                               ),
                              fluidRow(
                                       box(
                                         tabPanel("Projection of a Month",htmlOutput("Projection")),

                                       title="Projection Sales Analysis March",
                                       solidHeader = TRUE,
                                       width=6)
                                       ,
                                       box(
                                         sliderInput("bins", "Increase in percentage",min= 1, max=100, value=1)
                                       ),
                                       valueBoxOutput("month",width = "6")
                                       # box(width = 6,height="120px","26th March 2016",background="orange",status = "warning",solidHeader = TRUE))
                                       )

                              
                               # fluidRow(
                               #   box("26th March 2016",width = 12,height="100px",background="orange",status = "warning",solidHeader = TRUE)
                               #   
                               # )
                                
                                )),
                        ##FirstTabItem Finished
                        tabItem(tabName = "currentyear",
                                fluidRow(
                                  valueBoxOutput("yrevenue",width=3),
                                  valueBoxOutput("yavg_order",width=3),
                                  valueBoxOutput("yrecustomers",width=3),
                                  valueBoxOutput("yEratio",width=3)
                                  
                                  
                                ),
                                fluidPage(fluidRow(
                                  
                                  box(
                                    tabsetPanel(
                                      tabPanel("Year",htmlOutput("Yearly_sales_graph")),
                                      tabPanel("Location",htmlOutput("sales_Location_graph_Year"))
                                      # tabPanel("Total Sales BY Location",htmlOutput("sales_Location_Total_Year"))
                                    ),
                                    title="Sales Analysis of Current Year",
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
                                      tabPanel("Product",htmlOutput("topproducts")),
                                      tabPanel("Location",htmlOutput("topproductsinlocwise"))
                                      
                                    ),
                                    title="Top 10 Best Products ",
                                    solidHeader = TRUE,
                                    width=6
                                  )
                                  
                                  
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
                                              tabsetPanel(tabPanel("SalesPricing",htmlOutput("msalespricing")),
                                                          tabPanel("Quantity Sold",htmlOutput("mQty_Sold_loc"))
                                                          ),
                                              title="Quantity Sold in Location in a Month",
                                              soliidHeader = TRUE,
                                              width=6,
                                              height = "350px"
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
                                             ),
                                            box(
                                              tabsetPanel(
                                                tabPanel("low stock days",DT::dataTableOutput('tb3'))
                                                
                                                
                                                
                                              ),
                                              # title="low stock days in all years",
                                              solidHeader = TRUE,
                                              width=6
                                            ),
                                            box(
                                              tabsetPanel(
                                                tabPanel("Trends in the today and yesterday",DT::dataTableOutput('tb2'))
                                                
                                                
                                                
                                              ),
                                              # title="Trends in the today and yesterday sales,orders,avg_per_customer",
                                              soliidHeader = TRUE,
                                              width=6
                                            )
                                          )
                                          
                                )),
                        tabItem(tabName = "currentyearim",fluidPage(                                                                 
                          fluidRow(
                            infoBoxOutput("yinventory",width=3),
                            infoBoxOutput("ytopproduct",width=3),
                            infoBoxOutput("yiturn",width=3),
                            infoBoxOutput("yunits",width=3),
                            box(
                              tabsetPanel(tabPanel("SalesPricing",htmlOutput("ysalespricing")),tabPanel("Quantity Sold",htmlOutput("YQty_Sold_loc"))
                                          )
                              ,
                              title="Quantity Sold in Location in a year",
                              soliidHeader = TRUE,
                              width=6
                            ),
                            box(
                              tabsetPanel(tabPanel("Top 10 Products in a Month",htmlOutput("TopProduct_sold_Analysis"),selectInput("Month_Sold_Pro","",selected="Mar",choices = list("Jan","Feb","Mar")))
                                          
                              ),
                              title="Year Analysis",
                              soliidHeader = TRUE,
                              width=6
                            ),
                            box(
                              tabsetPanel(
                                tabPanel("Quantity",htmlOutput("top_Qty_products")),
                                tabPanel("Location",htmlOutput("top_Qty_products_loc"))
                                
                              ),
                              title="Top 10 Best Products ",
                              solidHeader = TRUE,
                              width=6
                            ),
                            box(
                              tabsetPanel(
                                tabPanel("max quantity sold in all years",DT::dataTableOutput('tb4'))
                                
                                
                                
                              ),
                              # title="max quantity sold in all years",
                              solidHeader = TRUE,
                              width=6
                            ),
                            box(
                              tabsetPanel(
                                tabPanel("total number of units  sold in all years",htmlOutput("total_units_sold"))
                                
                                
                                
                              ),
                              title="total number of units  sold in all years",
                              solidHeader = TRUE,
                              width=6
                            ),
                            box(
                              tabsetPanel(
                                tabPanel("Quantity sold in each region",htmlOutput("qty_in_each_region")),
                                DT::dataTableOutput('tb5')
                                
                                
                              ),
                              title="Quantity sold in each region ",
                              solidHeader = TRUE,
                              width=6
                            )
                            
                          )
                        )
                        
                        )
                        
                      )
                      
                      
                      ##tabitems
                      
                    )         
                    ##dashboard body  
                    
)
##DashboardPage                   





