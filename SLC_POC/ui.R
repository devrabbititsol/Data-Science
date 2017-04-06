
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
library(png)
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
                                  title=strong("Sales Analysis of Current Month "),
                                  status="info",
                                  collapsible = TRUE,
                                  # solidHeader = TRUE,
                                  height = "400px",
                                  width=6
                                 ),

                                box(
                                  tabsetPanel(
                                    tabPanel("Sales of a Month",htmlOutput("Month_sales_graph_everyYear"),sliderInput("probins", "Increase in percentage",min= 1, max=100, value=1)),
                                    tabPanel("Trends in FebMar",htmlOutput("Trends_FM")),
                                    tabPanel("Customers",highchartOutput("month_cust",height = "300px"))
                                    

                                  ),
                                  title=strong("Sales Analysis March"),
                                  status="warning",
                                  collapsible = TRUE,
                                  # solidHeader = TRUE,
                                  height = "400px",
                                  width=6
                                )
                                
                                
                               ),
                              fluidRow(
                                       
                                       valueBoxOutput("mtopbrand",width = 3),
                                       valueBoxOutput("topcustomerforcurrentmonth",width = 3),
                                       valueBoxOutput("comparisionofvisitors",width = 3),
                                       valueBoxOutput("month",width = 3)
                                       )

                              
                                
                                )),
                        ##FirstTabItem Finished
                        tabItem(tabName = "currentyear",
                                fluidRow(
                                  valueBoxOutput("yrevenue",width=3),
                                  valueBoxOutput("yavg_order",width=3),
                                  valueBoxOutput("yEratio",width=3),
                                  valueBoxOutput("yrecustomers",width=3),
                                  valueBoxOutput("ysalesComparision",width = 3),
                                  valueBoxOutput("incavg_order",width = 3),
                                  valueBoxOutput("orderpick",width = 3),
                                  valueBoxOutput("yearwisevisitors",width=3)
                                 
                                  
                                ),
                                fluidPage(fluidRow(
                                  
                                  box(
                                    tabsetPanel(
                                      # tabPanel("Year",htmlOutput("Yearly_sales_graph")),
                                      tabPanel("Year",plotlyOutput("Yearly_sales_graph",height="300px")),
                                      tabPanel("Location",htmlOutput("sales_Location_graph_Year")),
                                      tabPanel("Brand ",htmlOutput("year_wise_Brand_Revenue")),
                                      tabPanel("Product",htmlOutput("topproducts")),
                                      tabPanel("Location",htmlOutput("topproductsinlocwise"))
                                      # tabPanel("Total Sales BY Location",htmlOutput("sales_Location_Total_Year"))
                                    ),
                                    title=strong("Sales Analysis of Current Year"),
                                     status="success",
                                    collapsible = TRUE,
                                    # background = "olive",
                                    # solidHeader = TRUE,
                                    height="450px",
                                    width=6
                                  ),
                                  box(
                                    tabsetPanel(
                                      tabPanel("Sales of a Year",htmlOutput("year_wise_revenue"),sliderInput("yprobins", "Increase in percentage",min= 1, max=100, value=1)),
                                      tabPanel("Customer",highchartOutput("year_cust",height="350px")),
                                      # tabPanel("Traffic",htmlOutput("web_traffic")
                                               
                                      tabPanel("Traffic",plotlyOutput("web_traffic",height="300px") ),
                                      tabPanel("Brand Sales",htmlOutput("ySalesdiff")) 
                                      
                                     
                                      # tabPanel("Customers",htmlOutput("cust_graph"))
                                      
                                    ),
                                    title=strong("Year Analysis of Revenue"),
                                    status="info",
                                    collapsible = TRUE,
                                    # solidHeader = TRUE,
                                    height="450px",
                                    width=6
                                    
                                  ),
                                  box(
                                    tabsetPanel(
                                      
                                      tabPanel("Growth",htmlOutput("visits_Growth")),
                                      tabPanel("Currentyear",plotlyOutput("visits_sales",height = "300px")),
                                      tabPanel("PreiousYear",plotlyOutput("visits_sales2015",height = "300px"))
                                    ),
                                    title=strong("Customer Insights"),
                                    status="primary",
                                    collapsible = TRUE,
                                    # solidHeader = TRUE,
                                    height = "400px",
                                    width=6
                                  ),
                                  box(
                                    
                                    tabsetPanel(
                                      tabPanel("CurrentYear",plotlyOutput("Avg_day",height = "300px")),
                                      tabPanel("PreviousYear",plotlyOutput("month_avg",height = "300px")),
                                      tabPanel("Eratio",plotlyOutput("er_year",height = "300px")),
                                      tabPanel("SalesGrowth",plotlyOutput("sp_year",height = "300px"))
                                                
                                    ),
                                    title=strong("BenchMarking Analysis"),
                                    status="danger",
                                    collapsible = TRUE,
                                    # solidHeader = TRUE,
                                    height="400px",
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
                                    title=strong("Quarter Analysis"),
                                    width=12
                                  )
                                )
                                  
                                  
                                )
                        ),
                        ##SecondTabITem Finished
                        tabItem(tabName = "currentmonthim",
                                fluidPage(
                                          fluidRow(
                                            box(
                                              tabsetPanel(tabPanel("SalesPricing",htmlOutput("msalespricing")),
                                                          tabPanel("Quantity Sold",htmlOutput("mQty_Sold_loc")),
                                                          tabPanel("Brand ",htmlOutput("mBrand_wise_qty")),
                                                          tabPanel("Difference ",htmlOutput("Qty_curr"))
                                                          ),
                                              title=strong("Month Analysis of Quantity"),
                                              status="primary",
                                              solidHeader = TRUE,
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
                                              title=strong("Trends"),
                                              status="success",
                                              solidHeader = TRUE,
                                              height = "330px",
                                              width=6
                                            )),
                                          fluidRow(width=12,
                                                   infoBoxOutput("minventory",width=3),
                                                   infoBoxOutput("mtopproduct",width=3),
                                                   infoBoxOutput("miturn",width=3),
                                                   infoBoxOutput("munits",width=3),
                                                   infoBoxOutput("Topcustomer",width = 3)),
                                          
                                          fluidRow(
                                            
                                            box(
                                              tabsetPanel(
                                                tabPanel("Inventory",
                                                  DT::dataTableOutput('tbl'),
                                                  p(class = 'text-center', downloadButton('x3', 'Download'))
                                                  
                                                )),
                                              title=strong("Available Inventory stock"),
                                              status="warning",
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
                              title=strong("Year Analysis of Quantity "),
                              status="primary",
                              solidHeader = TRUE,
                              width=6,
                              height="500px"
                            ),
                            box(
                              tabsetPanel(
                                tabPanel("Years",DT::dataTableOutput('tb4') ),
                                tabPanel("Region",htmlOutput("qty_in_each_region"),DT::dataTableOutput('tb5')),
                                tabPanel("Quantity",htmlOutput("total_units_sold"))
                                
                              ),
                              title=strong("Units Sold Year"),
                              status="danger",
                              solidHeader = TRUE,
                              height="500px",
                              width=6
                            ),
                            box(
                              tabsetPanel(
                                tabPanel("Quantity",htmlOutput("top_Qty_products")),
                                tabPanel("Location",htmlOutput("top_Qty_products_loc"))
                                
                              ),
                              title=strong("Top 10 Best Products"),
                              status="warning",
                              solidHeader = TRUE,
                              width=6
                            ),
                            box(
                              tabsetPanel(tabPanel("Brand Quantity",htmlOutput("Qty_15_16"))
                                          
                              ),
                              title=strong("Year Analysis"),
                              status="info",
                              solidHeader = TRUE,
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
                                  valueBoxOutput("Number_of_visitors_in_q1",width=3),
                                  valueBoxOutput("Number_of_visitors_in_q2",width=3),
                                  valueBoxOutput("Revenue_in_q3",width=3),
                                  valueBoxOutput("Revenue_in_q4",width=3),
                                  valueBoxOutput("Number_of_visitors_in_q3",width=3),
                                  valueBoxOutput("Number_of_visitors_in_q4",width=3)
                                  
                                )
                                ,fluidRow(
                                  img(src="SLC_Logo_charcoal.png",height="350px",width="1326px")
                                )
                                
                                )

                        )
                        
                      )
                      
                      
                      ##tabitems
                      
                    )         
                    ##dashboard body  
                    
)
##DashboardPage                   





