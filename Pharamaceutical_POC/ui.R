library(shiny)
library(shinydashboard)
library(plotly)
library(httr)
library(highcharter)
library(ggiraph)
library(leaflet)
library(ggmap)
library(maps)
library(RColorBrewer)

ui<- dashboardPage(skin=c("red"),
                   
                   dashboardHeader(title ="Pharmaceutical "),
                   
                   dashboardSidebar(sidebarMenu(
                     menuItem("Dashboard",icon = icon("dashboard",lib="glyphicon"),tabName = "dashboard",menuSubItem("Current Year",tabName = "currentyear"),menuSubItem("Location",tabName = "location"),menuSubItem("Services",tabName = "services"))
                   
                    
                     
                     
                   )),
                   dashboardBody(
                     tabItems(
                       # First tab content
                       tabItem(tabName="currentyear",
                               
                                         fluidPage( fluidRow(
                                            valueBoxOutput("maxphar",width=3),
                                            valueBoxOutput("mediser",width=3),
                                            valueBoxOutput("TotalcommunityPharmacies",width=3),
                                            valueBoxOutput("TotalMur",width=3)
                                      
                                         ),
                     fluidRow( box(
                       tabsetPanel(
                         tabPanel("Community Pharmacies",htmlOutput("ypharmmacies",height="290px")),
                         tabPanel("Growth",htmlOutput('Pharmaciesgrowth'))
                         
                       ),
                       status="warning",
                       collapsible = TRUE,
                       height = "390px",
                       solidHeader = TRUE,
                       width=6,title="Pharmacies"),
                       box(
                         tabsetPanel(
                         
                         tabPanel("Prescription Data",highchartOutput("Esplsp",height="290px")),
                         tabPanel("Exempt Category",plotlyOutput("exemptpharmacies",height = "290px"))
                         ),
                         status="primary",
                         collapsible = TRUE,
                         height = "390px",
                         solidHeader = TRUE,
                         width=6,
                         title="Prescription Items"
                         )),
                       fluidRow(box(tabsetPanel(
                         tabPanel("Esp VS Lsp",highchartOutput("Esplspcontractors",height = "260px")),
                         tabPanel("Indenpendent Vs Multiple",highchartOutput("indvsmul",height = "300px"))
                         
                         ),status="info",
                         collapsible = TRUE,
                         height = "390px",
                         solidHeader = TRUE,
                         width=6,
                         title = "Contractors"
                         ),
                         box(tabsetPanel(
                           tabPanel("Application Decisions",plotlyOutput("AppDec",height="290px")) ,
                        tabPanel("Application Status",plotlyOutput("Appstatus",height = "290px"))
                       
                         
                               
                             ),
                       
                       status="success",
                       collapsible = TRUE,
                       height = "390px",
                       solidHeader = TRUE,
                       width=6,
                       title = "Applications"
                   
                       )))),
                     
                    

                       tabItem(tabName = "location",
                               fluidPage(
                        fluidRow(box(
                               tabsetPanel(
                                 tabPanel("Pharmacies",highchartOutput("locationwisepharma",height="300px")),
                                 tabPanel("PharmaciesPer10000Population",plotlyOutput("populationwisepharmacies",height = "300px"))
                                
                               ),
                               status="success",
                               collapsible = TRUE,
                               height = "400px",
                               solidHeader = TRUE,
                               width=6,
                               title = "Pharmacies Count"),
                               box(
                                 tabsetPanel(
                                
                                 tabPanel("PrescriptiondispensedItems",highchartOutput("Mitemsperpharm",height="300px")),
                                 tabPanel("AvgMonthlyItems",highchartOutput("AvgMitems",height="300px"))
                                 ),
                                 status="primary",
                                 collapsible = TRUE,
                                 height = "400px",
                                 solidHeader = TRUE,
                                 width=6,
                                 title = "Items Count")
                                 
                              
                               
                               ),
                        
                               box(
                                 tabsetPanel(
                                   tabPanel("ESPLSP Vs OtherLSP",plotlyOutput("Ycontractors",height="300px")),
                                   tabPanel("Independent Vs Multiple",plotlyOutput("lcontractors",height="300px"))
                                 ),
                                 status="info",
                                 collapsible = TRUE,
                                 height = "400px",
                                 solidHeader = TRUE,
                                 width=6,
                                 title = "Contractors"),
                              
                        box(
                          tabsetPanel(
                            tabPanel("Community Pharmacies",plotlyOutput("lexemptplot",height = "300px")),
                            tabPanel("100Hr Pharmacies",highchartOutput("ltotalexempt",height = "300px"))
                          ),
                          status="warning",
                          collapsible = TRUE,
                          height="400px",
                          width=6,
                          solidHeader = TRUE,
                          title = "Exempt Category"
                          
                        )
                                 
                                 )
                              ),
                     tabItem(tabName = "services",
                             fluidPage(
                               fluidRow(  box(
                                    tabsetPanel(
                                      tabPanel("Year",highchartOutput("pharmaciesprov",height="300px")),
                                     tabPanel("Location ",plotlyOutput("Mur",height="300px"))
                                   ),
                                   status="success",
                                   collapsible = TRUE,
                                   height="400px",
                                   width=6,
                                   solidHeader = TRUE,
                                   title = "MURServices"

                                 ),
                                 box(
                                   tabsetPanel(
                                     tabPanel("Year",ggiraphOutput("Nms",height = "300px")),
                                     tabPanel("Location ",highchartOutput("Nmsserervice",height="300px"))
                                   ),
                                   status="primary",
                                   collapsible = TRUE,
                                   height="400px",
                                   width=6,
                                   solidHeader = TRUE,
                                   title = "NMSServices"
                                   
                                 )
                                 ),
                               fluidRow(box(
                                 tabsetPanel(
                                   tabPanel("Year",ggiraphOutput("Aur",height="300px")),
                                   tabPanel("Location",highchartOutput("Aurser",height="300px"))
                                 ),
                                 status="info",
                                 collapsible = TRUE,
                                 height="400px",
                                 width=6,
                                 solidHeader = TRUE,
                                 title = "AURServices"
                                 
                               ),
                               box(
                                 tabsetPanel(
                                   tabPanel("Year",plotlyOutput("YSAC",height="300px")),
                                   tabPanel("Location",htmlOutput("Difference",height="300px"))
                                 ),
                                 status="warning",
                                 collapsible = TRUE,
                                 height="400px",
                                 width=6,
                                 solidHeader = TRUE,
                                 title = "SACServices"
                                 
                               )
                               
                               
                               
                               ))))
                               
                      
                     
                       ))   
                     

                   



