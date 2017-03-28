
library(shiny)
library(shinydashboard)
library(dplyr)
library(lubridate)
library(DT)
library(googleVis)
library(readr)
library(ggplot2)
library(highcharter)
library(plotly)
library(C3)
library(ECharts2Shiny)

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
                                    tabPanel("Sales of a Month",htmlOutput("Month_sales_graph_everyYear"),sliderInput("probins", "Increase in percentage",min= 1, max=100, value=1)),
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
                                       
                                       valueBoxOutput("mtopbrand",width = 3),
                                       valueBoxOutput("topcustomerforcurrentmonth",width = 3),
                                       valueBoxOutput("comparisionofvisitors",width = 3),
                                       valueBoxOutput("month",width = 3),
                                       box(
                                         
                                       tabsetPanel(tabPanel("PreviousYear",
                                         # actionButton("update","update gauge"),
                                       
                                       # example use of the automatically generated output function
                                       C3GaugeOutput("gauge1",height="200px" )
                                                    
                                       )
                                      
                                       ),
                                       
                                       width = 6,
                                       height="300px"
                                       ),
                                       box(
                                         
                                         tabsetPanel( tabPanel("CurrentYear",
                                                               loadEChartsLibrary(),
                                                               
                                                               tags$div(id="test", style="height:300px;"),
                                                               deliverChart(div_id = "test")
                                                               # tabPanel("gauge_1",plotOutput("G"))
                                         )
                                         ),
                                         width = 6,
                                         height="300px"
                                       )
                                       )

                              
                                
                                )),
                        ##FirstTabItem Finished
                        tabItem(tabName = "currentyear",
                                fluidRow(
                                  valueBoxOutput("ysalesComparision",width = 3),
                                  valueBoxOutput("incavg_order",width = 3),
                                  valueBoxOutput("yEratio",width=3),
                                  valueBoxOutput("yrecustomers",width=3),
                                  valueBoxOutput("orderpick",width = 3),
                                  valueBoxOutput("yrevenue",width=3),
                                  valueBoxOutput("yearwisevisitors",width=3),
                                  valueBoxOutput("yavg_order",width=3)
                                  
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
                                      tabPanel("Sales of a Year",htmlOutput("year_wise_revenue"),sliderInput("yprobins", "Increase in percentage",min= 1, max=100, value=1)),
                                      tabPanel("Customer",highchartOutput("year_cust",height="300px")),
                                      # tabPanel("Traffic",htmlOutput("web_traffic")
                                               
                                      tabPanel("Traffic",plotlyOutput("web_traffic",height="300px") ),
                                      tabPanel("Brand Sales",htmlOutput("ySalesdiff"))         
                                      
                                     
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
                                      # tabPanel("Brand Sales",htmlOutput("ySalesdiff"))
                                    ),
                                    title="Top 10 Best Products ",
                                    solidHeader = TRUE,
                                    height = "350px",
                                    width=6
                                  ),
                                  box(
                                    
                                    tabsetPanel(
                                      tabPanel("CurrentYear",plotlyOutput("Avg_day",height = "250px")),
                                      tabPanel("PreviousYear",plotlyOutput("month_avg",height = "250px")),
                                      tabPanel("Eratio",plotlyOutput("er_year",height = "250px")),
                                      tabPanel("SalesGrowth",plotlyOutput("sp_year",height = "250px"))
                                                
                                    ),
                                    title="BenchMarking Analysis",
                                    soliidHeader = TRUE,
                                    height="360px",
                                    width=6
                                  )
                                  
                                  ),
                                fluidRow(
                                  
                                  box(
                                    ###per quarter
                                    valueBoxOutput("Q1Sales",width = 3),
                                    valueBoxOutput("Q1Visitors",width=3),
                                    # valueBoxOutput("Q1return",width=3),
                                    valueBoxOutput("Q1orderpick",width=3),
                                    valueBoxOutput("Q1Avgorder",width=3),
                                    title="Quarter Analysis",
                                    width=12
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
                                                tabPanel("Today&Yesterday", tableOutput("tb2")),
                                                # DT::dataTableOutput('tb2')
                                                ##DT::dataTableOutput('tb2')
                                                tabPanel("T&Y Trends",htmlOutput("ygraphs"))
                                              ),
                                              title="Trends",
                                              soliidHeader = TRUE,
                                              height = "330px",
                                              width=6
                                            ),
                                            
                                            box(
                                              tabsetPanel(
                                                tabPanel("Inventory",
                                                  DT::dataTableOutput('tbl'),
                                                  p(class = 'text-center', downloadButton('x3', 'Download'))
                                                  
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
                              height="500px"
                            ),
                            box(
                              tabsetPanel(
                                tabPanel("Years",DT::dataTableOutput('tb4') ),
                                tabPanel("Region",htmlOutput("qty_in_each_region"),DT::dataTableOutput('tb5')),
                                tabPanel("Quantity",htmlOutput("total_units_sold"))
                                
                              ),
                              title="Units Sold Year",
                              solidHeader = TRUE,
                              height="500px",
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
                        ,
                        tabItem(tabName = "forecasting",
                                fluidPage(fluidRow(
                                  
                                  
                                  box(
                                   
                                      tabPanel("Revenue",plotlyOutput("revenue",height = "300px")),
                                      
                                    
                                    title="Revenue",
                                    status = "warning",
                                    # collapsible = TRUE,
                                    solidHeader = TRUE,
                                    height="400px",
                                    width=6
                                    
                                  ),
                                  box(
                                   
                                      tabPanel("visitors",plotlyOutput("visitors",height="300px")),
                                      
                                      
                                  
                                    title="Visitors",
                                    status = "primary",
                                    solidHeader = TRUE,
                                    height="400px",
                                    width=6
                                    
                                  ),
                                  
                                  valueBoxOutput("Revenue_in_q1",width=3),
                                  valueBoxOutput("Revenue_in_q2",width=3),
                                  valueBoxOutput("Revenue_in_q3",width=3),
                                  valueBoxOutput("Revenue_in_q4",width=3),
                                  valueBoxOutput("Number_of_visitors_in_q1",width=3),
                                  valueBoxOutput("Number_of_visitors_in_q2",width=3),
                                  valueBoxOutput("Number_of_visitors_in_q3",width=3),
                                  valueBoxOutput("Number_of_visitors_in_q4",width=3)
                                  
                                  
                                  
                                )
                                # ,
                                # 
                                # fluidRow(
                                #   box(
                                #     tabsetPanel(
                                #       
                                #       
                                #       tabPanel("visitors",plotlyOutput("visitors",height="300px"))
                                #       
                                #       
                                #     ),
                                #     # title="Visitors 2016",
                                #     soliidHeader = TRUE,
                                #     height="400px",
                                #     width=6
                                #     
                                #   ),
                                #  
                                #   valueBoxOutput("Number_of_visitors_in_q1",width=3),
                                #   valueBoxOutput("Number_of_visitors_in_q2",width=3),
                                #   valueBoxOutput("Number_of_visitors_in_q3",width=3),
                                #   valueBoxOutput("Number_of_visitors_in_q4",width=3)
                                #   
                                #   
                                #   
                                #   
                                # )
                                )

                        )
                        
                      )
                      
                      
                      ##tabitems
                      
                    )         
                    ##dashboard body  
                    
)
##DashboardPage                   





