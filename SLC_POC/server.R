
library(shinydashboard)
library(shiny)
library(googleVis)
library(dplyr)
library(lubridate)
library(DT)
library(readr)
library(ggplot2)




server <- function(input, output) {
  ##today_sales_graph
  
  ##plot for monthly sales analysis
  observe({
  x<-input$sty 
  # print(x)
  if(x=="Today")
     {
       # print("Hi all")
    output$today_sales_graph <- renderGvis({
      tdsales<- select(tdaysales,Time,sales)
      tdsalechart<-gvisColumnChart(tdsales,xvar="Time",yvar="sales",options=list(width="100%",height="200px"))
      return(tdsalechart)
      
    })
       
  }
  if(x=="Yesterday")
  {
    output$today_sales_graph <- renderGvis({
      ydsales<- select(ydaysales,day,sales)
      ydsalechart<-gvisColumnChart(ydsales,xvar="day",yvar="sales",options=list(width="100%",height="200px"))
      return(ydsalechart)
      
    })
  }
  })
    
  ##plot for monthly sales analysis
  output$monthly_sales_graph <- renderGvis({
    msales<- select(daywisesales,day,sales)
    msalechart<-gvisLineChart(msales,xvar="day",yvar="sales",options =list(colors="['#A52A2A']"))
    return(msalechart)
    
  })
  ##plot for yearly sales analysis
  output$Yearly_sales_graph <- renderGvis({
    # ysales<- select(ysalesval,Month,Sales)
     Month<-c("Jan","Feb","Mar")
     Sales<-ysalesval$Sales
     ysd<-data.frame(Month,Sales)
    ysalechart<-gvisColumnChart(ysd,xvar="Month",yvar="Sales",options=list(colors="['#1ABC9C']"))
    
    return(ysalechart)
    
  })
  #####Top 10 best products of current year(2016) in location wise"
  output$topproductsinlocwise<- renderGvis({
    TopBestinloc<- select(locationwise,Location,Name,Quantity)
    
    topbestproinlocchart<-gvisTable(TopBestinloc)
    return(topbestproinlocchart)
    
  })
  
  ##plot for monthly wise sales by lcoation
  output$sales_Location_graph <- renderGvis({
    
    mlocsales <- msalelocval 
    msaleloc <- na.omit(mlocsales) 
    mgeostate <- gvisGeoChart(msaleloc,"Location","Revenue",options=list(region="US",displayMode="regions",resolution="provinces",width="100%",height="200px",colors="green"))
    return(mgeostate)
    
  })
  ##plot for yearly wise sales by lcoation
  output$sales_Location_graph_Year <- renderGvis({
    
    ylocsales <- ysalelocvaly 
    ysaleloc <- na.omit(ylocsales) 
    ygeostate <- gvisGeoChart(ysaleloc,"Location","Revenue",options=list(region="US",displayMode="regions",resolution="provinces",width="400px",height="200px",colors="red"))
    return(ygeostate)
    
  })
  ##plot for a month sales in all the years
  output$Month_sales_graph_everyYear <- renderGvis({
    marchrevenue<- select(RevenueMarchVal,Revenue,Year)
    marchchart<-gvisColumnChart(marchrevenue,xvar = "Year",yvar = "Revenue",options=list(colors="['#F1C40F']"))
    
    return(marchchart)
    
  })
  
  # ##plot for a month sales in all the years
  # output$slider_input <- renderGvis({
  #   promarchrevenue<- select(RevenueMarchVal,Revenue,Year)
  #   promarchchart<-gvisColumnChart(marchrevenue,xvar = "Year",yvar = "Revenue",options=list(colors="['#008000']"))
  #   
  #   return(marchchart)
  #   
  # })
  ##plot for revenue genrted in all the years
  output$year_wise_revenue<- renderGvis({
    yRsales<- select(yRevenue,Year,Revenue)
    yRsalechart<-gvisColumnChart(yRsales,xvar = "Year",yvar = "Revenue",options=list(colors="['#008000']"))
    return(yRsalechart)
    
  })
  ##plot for Qty sold by lcoation in a month
  output$mQty_Sold_loc<- renderGvis({
    # ilsales<- select(InventsalesbyRegion,Revenue,Location)
    mInventorysalesbyRegion <- mIsalesbyRegion
    milsales <- na.omit(mInventorysalesbyRegion)
    milgeostate <- gvisGeoChart(milsales,"Location","QuantityOrdered",options=list(region="US",displayMode="regions",resolution="provinces",width="400px",height="200px",colors="['#2C3E50']"))
    return(milgeostate)
    
  })
  ##plot for Qty sold by lcoation in a year
  output$YQty_Sold_loc<- renderGvis({
    # ilsales<- select(InventsalesbyRegion,Revenue,Location)
    yInventorysalesbyRegion <- yIsalesbyRegion
    yilsales <- na.omit(yInventorysalesbyRegion)
    yilgeostate <- gvisGeoChart(yilsales,"Location","QuantityOrdered",options=list(region="US",displayMode="regions",resolution="provinces",width="400px",height="200px",colors="['#5B2C6F']"))
    return(yilgeostate)
    
  })
  ##plot for sales and Pricing in a year
  output$ysalespricing<- renderGvis({
    yunitssoldandship<- select(ysupplychainval,Month,UnitsOrdered,UnitsShipped)
    
    Month<-Month<-c("JAN","FEB","MAR")
    # ysupplychainval$Month
    UnitsSold<-ysupplychainval$UnitsOrdered
    UnitsShipped<-ysupplychainval$UnitsShipped
    Sales<-ysupplychainval$sales
    ydf<-data.frame(Month,UnitsSold,UnitsShipped,Sales)
    # unitssell<-gvisComboChart(unitssoldandship,xvar="UnitsOrderd",yvar="UnitsShipped")
    yunitssell<-gvisColumnChart(ydf,options=list(seriesType="bars",series='{2: {type:"line"}}',colors="['green','black','#BA4A00']"))
    
    return(yunitssell)
    
  })
  ######
  ##plot for sales and Pricing in a month
  output$msalespricing<- renderGvis({
    munitssoldandship<- select(msupplychainval,Day,UnitsOrdered,UnitsShipped)
    Day<-msupplychainval$Day
    UnitsSold<-msupplychainval$UnitsOrdered
    UnitsShipped<-msupplychainval$UnitsShipped
    Sales<-msupplychainval$sales
    mdf<-data.frame(Day,UnitsSold,UnitsShipped,Sales)
    # unitssell<-gvisComboChart(unitssoldandship,xvar="UnitsOrderd",yvar="UnitsShipped")
    munitssell<-gvisColumnChart(mdf,options=list(seriesType="bars",series='{2: {type:"line"}}'))
    
    return(munitssell)
    
  })
  
  ##revenue generated for a month
  output$mrevenue <- renderValueBox({
    valueBox(
      paste(round(mRevenueval/1000000,2),"M" ), "Revenue", icon = icon("glyphicon glyphicon-usd",lib="glyphicon"),
      color = "orange"
    )
  })
  ##revenue generated for a year
  output$yrevenue <- renderValueBox({
    valueBox(
      paste(round(yRevenueval/1000000,2),"M" ), "Revenue", icon = icon("glyphicon glyphicon-usd",lib="glyphicon"),
      color = "orange"
    )
  })
  ##average order value for a month
  output$mavg_order <- renderValueBox({
    valueBox(
      paste(round(mAvg_Value,2),"$"), "Average Order Value", icon = icon("glyphicon glyphicon-usd",lib="glyphicon"),
      color = "fuchsia"
    )
    
  })
  ##average order value for a year
  output$yavg_order <- renderValueBox({
    valueBox(
      paste(round(YAvg_Value,2),"$"), "Average Order Value", icon = icon("glyphicon glyphicon-usd",lib="glyphicon"),
      color = "fuchsia"
    )
    
  })
  ##returning customers in a month
  output$mrecustomers <- renderValueBox({
    valueBox(
      paste(mRepeatVal), "Returning Customers", icon = icon("glyphicon glyphicon-repeat",lib="glyphicon"),
      color = "teal"
      ##glyphicon glyphicon-scale
    )
    
  })
  ###returning customers in a year
  output$yrecustomers <- renderValueBox({
    valueBox(
      paste(yRepeatVal), "Returning Customers", icon = icon("glyphicon glyphicon-repeat",lib="glyphicon"),
      color = "teal"
    )
    
  })
  ##New customers added in a month
  output$mNewCustBox <- renderInfoBox({
    valueBox(
      paste(mNewCustVal), "New Customers", icon = icon("glyphicon glyphicon-user",lib="glyphicon"),
      color = "blue"
    )
    
  })
  ##Ecomerce ratio for a month
  output$mEratio <- renderValueBox({
    valueBox(
      paste(round(mERatio,4),"%"),"Ecommerce Conversion Ratio",
      color = "purple",icon = icon("credit-card")
       
    )
    
  })
  ##Ecomerce ratio for a year
  output$yEratio <- renderValueBox({
    valueBox(
      paste(round(yERatio,4),"%"),"Ecommerce Conversion Ratio",
      color = "purple",icon = icon("credit-card")
      
    )
    
  })
  ###Visits per day
  ###### Total Visits Per day ########
  
  output$dVisitsBox <- renderValueBox({
    valueBox(
      paste(dVisitsperday), "Visits per Day",icon = icon("glyphicon glyphicon-eye-open",lib="glyphicon"),
      color = "green"
      
    )
  })
  ###############Bounce Rate
  output$bouncerate <- renderValueBox({
    valueBox(
      paste(round(bouncerate,2),"%"), "Bounce Rate", icon = icon("glyphicon glyphicon-minus",lib="glyphicon"),
      color = "navy"
    )
    
  })
  #################Increase in Sales Percentage
  output$salesComparision <- renderValueBox({
    valueBox(
      paste(round(mincreaseper,2),"%"), "Growth in sales", icon = icon("glyphicon glyphicon-open",lib="glyphicon"),
      color = "red"
    )
    
  })
  #####Top 10 best products of current year(2016)"
  output$topproducts<- renderGvis({
    TopBest<- select(TopBestProducts,Productid,Name,Quantity)
    topbestprochart<-gvisTable(TopBest)
    return(topbestprochart)
    
  })

  output$tbl = DT::renderDataTable(
    availInventoryStock, filter = 'top', options = list(lengthChange = TRUE)
  )
 
  ProcessedFilteredData <- reactive({
    s =input$tbl_rows_all
    # This code assumes that there is an entry for every
    # cell in the table (see note above about replacing
    # NA values with the empty string).
    col_names <- names(availInventoryStock)
    n_cols <- length(col_names)
    n_row <- length(s)/n_cols
     m <- matrix(s,ncol = n_cols, byrow = TRUE)
    dff <- data.frame(m)
    names(dff) <- col_names
    return(dff)
  })
  output$x3 <- downloadHandler(
    filename = function() { 'filtered_data.csv' }, content = function(file) {
      write.csv(ProcessedFilteredData(), file, row.names = FALSE)
    }
  )
  
  # output$tb1 = DT::renderDataTable(availstock, server = FALSE)

  ##AverageInventory for a month
  output$minventory <- renderInfoBox({
    infoBox(
      " Averge Inventory", paste(round(dInvent/1000,2) ,"K"),icon=icon("glyphicon glyphicon-scale",lib="glyphicon"),
      color = "blue",fill = TRUE
    )
  })
  ##AverageInventory for a year
  output$yinventory <- renderInfoBox({
    infoBox(
      " Averge Inventory", paste( round(yInvent/1000,2),"K"),icon=icon("glyphicon glyphicon-scale",lib="glyphicon"),
      color = "blue",fill = TRUE
    )
  })
  ##top product in a month by sales
  output$mtopproduct<- renderInfoBox({
    infoBox(
      " Top Product",paste(maxQty/1000,"K"),icon=icon("glyphicon glyphicon-apple",lib="glyphicon"),
      color = "red",fill = TRUE
    )
  })
  ##top product in a year by sales
  output$ytopproduct<- renderInfoBox({
    infoBox(
      " Top Product ",paste(ymaxQty/1000,"K"),icon=icon("glyphicon glyphicon-apple",lib="glyphicon"),
      color = "red",fill = TRUE
    )
  })
 
  ##Inventory tunrnover for a month
  output$miturn<- renderInfoBox({
    infoBox(
      "Inventory Turnover",paste(round(minventurnover/dInvent)),icon = icon("glyphicon glyphicon-usd",lib="glyphicon"),
      color = "green",fill = TRUE
    )
  })
  ##Inventory tunrnover for a year
  output$yiturn<- renderInfoBox({
    infoBox(
      "Inventory Turnover",paste(round(yinventurnover/yInvent)),icon = icon("glyphicon glyphicon-usd",lib="glyphicon"),
      color = "green",fill = TRUE
    )
  })
###Units per transactions in a month
  output$munits <- renderValueBox({
  infoBox(
    "Units per Transaction",paste(round(munitspertransaction,3)),  icon = icon("thumbs-up", lib = "glyphicon"),
    color = "orange",fill=TRUE
  )
})
  ###Units per transactions in a month
  output$yunits <- renderValueBox({
    infoBox(
      "Units per Transaction",paste(round(yunitspertransaction,3)),  icon = icon("thumbs-up", lib = "glyphicon"),
      color = "orange",fill=TRUE
    )
  })
 
}