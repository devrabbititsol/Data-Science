library(shiny)
library(shinydashboard)
library(googleVis)
library(plotly)
library(highcharter)
ui <- dashboardPage(skin=c("purple"),
                    
              dashboardHeader(title ="Restaurant_POC"),
                    
              dashboardSidebar(
                      sidebarMenu(
                      
                      menuItem("Monthly_Reprt",tabName = "monthly",icon = icon("glyphicon glyphicon-fast-forward",lib="glyphicon")),
                      
                      conditionalPanel('input.sidebarMenu == monthly',
                                       fileInput('file1', 'Upload Month Report in .csv format',
                                                 accept = c(
                                                   'text/csv',
                                                   'text/comma-separated-values',
                                                   'text/tab-separated-values',
                                                   'text/plain',
                                                   '.csv'))),
                      
                      menuItem("Day_Report",tabName = "daywise",icon = icon("glyphicon glyphicon-fast-forward",lib="glyphicon")),
                      conditionalPanel("input.sidebarMenu == `daywise`",
                                       fileInput('file2', 'Upload Day Report in .csv format',
                                                 accept = c(
                                                   'text/csv',
                                                   'text/comma-separated-values',
                                                   'text/tab-separated-values',
                                                   'text/plain',
                                                   '.csv')))
                      
                    )
                    ),
                    
                    dashboardBody(
                      
                      tabItems(
                          # First tab content
                          tabItem(tabName="monthly",
                                  
                        fluidPage(   
                        
                          fluidRow(
                                  valueBoxOutput("grosss_sales",width = 3),
                                  valueBoxOutput("tax",width = 3),
                                  valueBoxOutput("Avg_Rev_per_day",width = 3),
                                  valueBoxOutput("monthly_home_delivaeries",width = 3)
                              
                            ),
                          
                    fluidRow( box(
                      tabsetPanel(
                        tabPanel("Day Sales",htmlOutput("day_sales_mon")),
                        tabPanel("Day wise Total Sales",htmlOutput("days_sales"))
                        
                      ),
                      title="Revenue Analysis",
                      status="warning",
                      collapsible = TRUE,
                      height = "400px",
                      solidHeader = TRUE,
                      width=6
                      ),
                      
                      box(tabsetPanel(
                        
                        tabPanel("Week",highchartOutput("week_sales_charts",height="300px"))
                        
                      ),
                      title="Week Analysis",
                      status="info",
                      height = "400px",
                      collapsible = TRUE,
                      width=6,
                      solidHeader = TRUE
                      )
                      ),
                    
                    
                    fluidRow( box(
                      tabsetPanel(
                        tabPanel("credit card",highchartOutput("credit_card_sales",height = "300px"))
                      ),
                      title="Payment Details",
                      status="success",
                      collapsible = TRUE,
                      height = "400px",
                      solidHeader = TRUE,
                      width=6
                    ),
                
                    box(
                      tabsetPanel(
                        tabPanel("Walk Dine Sales",htmlOutput("dine_walk"))
                      ),
                      title="Walk Sales",
                      status="primary",
                      width = 6,
                      height="400px",
                      collapsible = TRUE,
                      solidHeader = TRUE
                    
                    ))
                    )
                   ),
                    
                    
                    tabItem(tabName="daywise",
                      fluidPage(   
                         fluidRow(
                            valueBoxOutput("BILL_DISCOUNT",width=3),
                            valueBoxOutput("tax_day",width=3),
                            valueBoxOutput("Top_Item",width=3),
                            valueBoxOutput("revenue",width=3)
                              ),
                      
                    fluidRow(
                      box( 
                        tabsetPanel(
                          tabPanel("Item Sales",plotlyOutput("item_sales"))
                        ),
                        title="Categories Sales",
                        status="primary",
                        width = 12,
                        height="400px",
                        collapsible = TRUE,
                        solidHeader = TRUE
                      ),
                   # fluidRow(
                      box(
                        tabsetPanel(
                          tabPanel("Item Quantity",plotlyOutput("item_qty"),height="400px")
                        ),
                        title="Category Quantities",
                        status="info",
                        width = 12,
                        height="400px",
                        collapsible = TRUE,
                        solidHeader = TRUE
                     ))
                      )
                      ))
                    ))
