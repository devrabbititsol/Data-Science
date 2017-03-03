
library(shiny)
library(shinydashboard)
library(dplyr)
library(lubridate)
library(DT)
library(googleVis)
library(readr)
library(ggplot2)
library(highcharter)

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
                                  valueBoxOutput("mEratio",width=3),
                                  valueBoxOutput("dVisitsBox",width=3),
                                  valueBoxOutput("salesComparision",width=3),
                                  valueBoxOutput("mNewCustBox",width = 3),
                                  valueBoxOutput("mrecustomers",width=3),
                                  valueBoxOutput("websitetrafficgrowth",width=3)
                                  # valueBoxOutput("bouncerate",width=3),
                                  # valueBoxOutput("websiteconversionrate",width=3),
                                  
                                ),
                              
                                fluidRow( box(
                                  tabsetPanel(
                                    tabPanel("Day",htmlOutput("today_sales_graph"),selectInput("sty","",selected=NULL,choices = list("Today","Yesterday"))),
                                    tabPanel("Month",htmlOutput("monthly_sales_graph")),
                                    tabPanel("Location",htmlOutput("sales_Location_graph")),
                                    tabPanel("Brand ",htmlOutput("Revenue_of_the_brand")),
                                    tabPanel("Difference",htmlOutput('Rev_curr')),
                                    tabPanel("Return vs New",htmlOutput("New_Rep_Cust_per"))
                                    
                                  ),
                                  title="Sales Analysis of Current Month ",
                                  solidHeader = TRUE,
                                  height = "400px",
                                  width=6
                                 ),

                                box(
                                  tabsetPanel(
                                    tabPanel("Sales of a Month",htmlOutput("Month_sales_graph_everyYear")),
                                    tabPanel("Trends in FebMar",htmlOutput("Trends_FM")),
                                    tabPanel("Customers",highchartOutput("month_cust",height = "300px"))

                                  ),
                                  title="Sales Analysis March",
                                  solidHeader = TRUE,
                                  height = "400px",
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
                                       valueBoxOutput("mtopbrand",width = 3),
                                       valueBoxOutput("topcustomerforcurrentmonth",width = 3)
                                       # valueBoxOutput("month",width = "6"),
                                       
                                       )

                              
                                
                                )),
                        ##FirstTabItem Finished
                        tabItem(tabName = "currentyear",
                                fluidRow(
                                  valueBoxOutput("yrevenue",width=3),
                                  valueBoxOutput("yavg_order",width=3),
                                  valueBoxOutput("yEratio",width=3),
                                  valueBoxOutput("yrecustomers",width=3),
                                  valueBoxOutput("ytopbrand",width = 3),
                                  valueBoxOutput("topcustomerforcurrentyear",width = 3)
                                  
                                ),
                                fluidPage(fluidRow(
                                  
                                  box(
                                    tabsetPanel(
                                      tabPanel("Year",htmlOutput("Yearly_sales_graph")),
                                      tabPanel("Location",htmlOutput("sales_Location_graph_Year")),
                                      tabPanel("Brand ",htmlOutput("year_wise_Brand_Revenue"))
                                      # tabPanel("Total Sales BY Location",htmlOutput("sales_Location_Total_Year"))
                                    ),
                                    title="Sales Analysis of Current Year",
                                    solidHeader = TRUE,
                                    height="400px",
                                    width=6
                                  ),
                                  box(
                                    tabsetPanel(
                                      tabPanel("Sales of a Year",htmlOutput("year_wise_revenue")),
                                      tabPanel("Customer",highchartOutput("year_cust",height="300px")),
                                      tabPanel("Traffic",htmlOutput("web_traffic"))
                                      # tabPanel("Customers",htmlOutput("cust_graph"))
                                      
                                    ),
                                    title="Year Analysis of Revenue",
                                    soliidHeader = TRUE,
                                    height="400px",
                                    width=6
                                    
                                  ),
                                  box(
                                    tabsetPanel(
                                      tabPanel("Product",htmlOutput("topproducts")),
                                      tabPanel("Location",htmlOutput("topproductsinlocwise"))
                                    ),
                                    title="Top 10 Best Products ",
                                    solidHeader = TRUE,
                                    height = "350px",
                                    width=6
                                  ),
                                  box(
                                    tabsetPanel(tabPanel("Brand Sales",htmlOutput("ySalesdiff"))
                                                
                                    ),
                                    title="Year Analysis",
                                    soliidHeader = TRUE,
                                    height="360px",
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
                                                   infoBoxOutput("munits",width=3),
                                                  infoBoxOutput("Topcustomer",width = 3)),
                                          fluidRow(
                                            box(
                                              tabsetPanel(tabPanel("SalesPricing",htmlOutput("msalespricing")),
                                                          tabPanel("Quantity Sold",htmlOutput("mQty_Sold_loc")),
                                                          tabPanel("Brand ",htmlOutput("mBrand_wise_qty")),
                                                          tabPanel("Difference ",htmlOutput("Qty_curr"))
                                                          ),
                                              title="Month Analysis of Quantity  ",
                                              soliidHeader = TRUE,
                                              width=6,
                                              height = "330px"
                                            ),
                                            box(
                                              tabsetPanel(
                                                tabPanel("Today&Yesterday",DT::dataTableOutput('tb2')),
                                                tabPanel("Yesterday",htmlOutput("ygraphs")),
                                                tabPanel("Today",htmlOutput("tgraphs"))
                                                # tabPanel("Today&Yesterday",htmlOutput('tb2'))
                                              ),
                                              title="Trends",
                                              soliidHeader = TRUE,
                                              width=6
                                            ),
                                            
                                            box(
                                              tabsetPanel(
                                                tabPanel("Inventory",
                                                  DT::dataTableOutput('tbl'),
                                                  p(class = 'text-center', downloadButton('x3', 'Download Filtered Data'))
                                                  
                                                )),
                                              title="Available Inventory stock",
                                              solidHeader = TRUE,
                                              width=12
                                             )
                                            
                                          )
                                          
                                )),
                        tabItem(tabName = "currentyearim",fluidPage(                                                                 
                          fluidRow(
                            infoBoxOutput("yinventory",width=3),
                            infoBoxOutput("ytopproduct",width=3),
                            infoBoxOutput("yiturn",width=3),
                            infoBoxOutput("yunits",width=3),
                            infoBoxOutput("ytopcustomer",width = 3)),
                            fluidRow(box(
                              tabsetPanel(tabPanel("SalesPricing",htmlOutput("ysalespricing")),
                                          tabPanel("Quantity Sold",htmlOutput("YQty_Sold_loc")),
                                          tabPanel("Brand ",htmlOutput("yBrand_wise_qty"))
                                          )
                              ,
                              title="Year Analysis of Quantity ",
                              soliidHeader = TRUE,
                              width=6,
                              height="350px"
                            ),
                            box(
                              tabsetPanel(
                                tabPanel("Years",DT::dataTableOutput('tb4'),style="overflow-y: scroll" ),
                                tabPanel("Region",htmlOutput("qty_in_each_region"),DT::dataTableOutput('tb5')),
                                tabPanel("Quantity",htmlOutput("total_units_sold"))
                                
                              ),
                              title="Units Sold Year",
                              solidHeader = TRUE,
                               # height="",
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
                              tabsetPanel(tabPanel("Brand Quantity",htmlOutput("Qty_15_16"))
                                          
                              ),
                              title="Year Analysis",
                              soliidHeader = TRUE,
                              height="360px",
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





