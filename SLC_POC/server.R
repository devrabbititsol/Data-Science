
library(shinydashboard)
library(shiny)
library(googleVis)
library(dplyr)
library(lubridate)
library(DT)
library(readr)
library(ggplot2)




server <- function(input, output) {
  
  ##plot for monthly sales analysis
  output$monthly_sales_graph <- renderGvis({
    msales<- select(daywisesales,day,sales)
    msalechart<-gvisLineChart(msales,xvar="day",yvar="sales")
    return(msalechart)
    
  })
  ##plot for yearly sales analysis
  output$Yearly_sales_graph <- renderGvis({
    ysales<- select(ysalesval,Month,Sales)
    ysalechart<-gvisColumnChart(ysales,xvar="Month",yvar="Sales",options=list(colors="['#008000']"))
    
    return(ysalechart)
    
  })
  #####Top 10 best products of current year(2016) in location wise"
  output$topproductsinlocwise<- renderGvis({
    TopBestinloc<- select(locationwise,productid,location,name,qty)
    
    topbestproinlocchart<-gvisTable(TopBestinloc)
    return(topbestproinlocchart)
    
  })
  ##plot for revenue by category
  output$rvcgraph <- renderGvis({
    crvalue<- select(Rbycatval,category_id,Revenue)
    crchart<-gvisLineChart(crvalue,xvar="category_id",yvar="Revenue",options=list(colors="['#008000']"))
    
    return(crchart)
    
  })
  ##plot for monthly wise sales by lcoation
  output$sales_Location_graph <- renderGvis({
    
    mlocsales <- msalelocval 
    msaleloc <- na.omit(mlocsales) 
    mgeostate <- gvisGeoChart(msaleloc,"Location","Revenue",options=list(region="US",displayMode="regions",resolution="provinces",width="400px",height="200px"))
    return(mgeostate)
    
  })
  ##plot for yearly wise sales by lcoation
  output$sales_Location_graph_Year <- renderGvis({
    
    ylocsales <- ysalelocvaly 
    ysaleloc <- na.omit(ylocsales) 
    ygeostate <- gvisGeoChart(ysaleloc,"Location","Revenue",options=list(region="US",displayMode="regions",resolution="provinces",width="400px",height="200px"))
    return(ygeostate)
    
  })
  ##plot for a month sales in all the years
  output$Month_sales_graph_everyYear <- renderGvis({
    marchrevenue<- select(RevenueMarchVal,Revenue,Year)
    marchchart<-gvisColumnChart(marchrevenue,xvar = "Year",yvar = "Revenue",options=list(colors="['#008000']"))
    
    return(marchchart)
    
  })
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
    milgeostate <- gvisGeoChart(milsales,"Location","QuantityOrdered",options=list(region="US",displayMode="regions",resolution="provinces",width="400px",height="200px"))
    return(milgeostate)
    
  })
  ##plot for Qty sold by lcoation in a year
  output$YQty_Sold_loc<- renderGvis({
    # ilsales<- select(InventsalesbyRegion,Revenue,Location)
    yInventorysalesbyRegion <- yIsalesbyRegion
    yilsales <- na.omit(yInventorysalesbyRegion)
    yilgeostate <- gvisGeoChart(yilsales,"Location","QuantityOrdered",options=list(region="US",displayMode="regions",resolution="provinces",width="400px",height="200px"))
    return(yilgeostate)
    
  })
  ##plot for sales and Pricing in a year
  output$ysalespricing<- renderGvis({
    yunitssoldandship<- select(ysupplychainval,Month,UnitsOrdered,UnitsShipped)
    
    Month<-Month<-c("JAN","FEB","MAR")
    # ysupplychainval$Month
    UnitsSold<-ysupplychainval$UnitsOrdered
    UnitsShipped<-ysupplychainval$UnitsShipped
    ydf<-data.frame(Month,UnitsSold,UnitsShipped)
    # unitssell<-gvisComboChart(unitssoldandship,xvar="UnitsOrderd",yvar="UnitsShipped")
    yunitssell<-gvisColumnChart(ydf)
    
    return(yunitssell)
    
  })
  ######
  ##plot for sales and Pricing in a month
  output$msalespricing<- renderGvis({
    munitssoldandship<- select(msupplychainval,Day,UnitsOrdered,UnitsShipped)
    Day<-msupplychainval$Day
    UnitsSold<-msupplychainval$UnitsOrdered
    UnitsShipped<-msupplychainval$UnitsShipped
    mdf<-data.frame(Day,UnitsSold,UnitsShipped)
    # unitssell<-gvisComboChart(unitssoldandship,xvar="UnitsOrderd",yvar="UnitsShipped")
    munitssell<-gvisColumnChart(mdf)
    
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
      paste(round(mAvg_Value,2),"$"), "AverageOrderValue", icon = icon("glyphicon glyphicon-usd",lib="glyphicon"),
      color = "fuchsia"
    )
    
  })
  ##average order value for a year
  output$yavg_order <- renderValueBox({
    valueBox(
      paste(round(YAvg_Value,2),"$"), "AverageOrderValue", icon = icon("glyphicon glyphicon-usd",lib="glyphicon"),
      color = "fuchsia"
    )
    
  })
  ##returning customers in a month
  output$mrecustomers <- renderValueBox({
    valueBox(
      paste(mRepeatVal), "returning customers", icon = icon("glyphicon glyphicon-scale",lib="glyphicon"),
      color = "teal"
    )
    
  })
  ###returning customers in a year
  output$yrecustomers <- renderValueBox({
    valueBox(
      paste(yRepeatVal), "returning customers", icon = icon("glyphicon glyphicon-scale",lib="glyphicon"),
      color = "teal"
    )
    
  })
  ##Ecomerce ratio for a month
  output$mEratio <- renderInfoBox({
    infoBox(
      "Ecommerce Conversion Ratio",paste(round(mERatio,4),"%"),
      color = "purple",fill = TRUE,icon = icon("credit-card")
    )
    
  })
  ##Ecomerce ratio for a year
  output$yEratio <- renderInfoBox({
    infoBox(
      "Ecommerce Conversion Ratio",paste(round(yERatio,4),"%"),
      color = "purple",fill = TRUE,icon = icon("credit-card")
    )
    
  })
  ###Visits per day
  ###### Total Visits Per day ########
  
  output$dVisitsBox <- renderValueBox({
    infoBox(
      paste(dVisitsperday), "Visits/Day",icon = icon("glyphicon glyphicon-eye-open",lib="glyphicon"),
      color = "green",fill=TRUE
    )
  })
  
  #####Top 10 best products of current year(2016)"
  output$topproducts<- renderGvis({
    TopBest<- select(TopBestProducts,productid,name,qty)
    topbestprochart<-gvisTable(TopBest)
    return(topbestprochart)
    
  })
  
  # #####Available Inventory Stock#######################
  # output$Avail_Inventory_stock<- renderGvis({
  #   AIstock<- select(availInventoryStock,productid,productname,qty)
  #   
  #   AIstockchart<-gvisTable(AIstock)
  #   print(AIstockchart$AIstock)
  #   
  #   return(AIstockchart)
  #   
  # })
  output$tbl = DT::renderDataTable(
    availInventoryStock, filter = 'top', options = list(lengthChange = TRUE)
  )
  # ##############for download button################ availInventoryStock2.xlsx
  # output$x3 = downloadHandler(availInventoryStock, content = function(file) {
  #   s = input$tbl_rows_all
  #   write.xlsx(availstock[s, , drop = FALSE], file)
  # })
  # availstock = availInventoryStock[, c('productid', 'qty','productname')]
  # 
  # output$tb1 = DT::renderDataTable(availstock, server = FALSE)
  # 
  ##AverageInventory for a month
  output$minventory <- renderInfoBox({
    infoBox(
      " Averge Inventory", paste( 254.4808,"K"),icon=icon("tree"),
      color = "blue",fill = TRUE
    )
  })
  ##AverageInventory for a year
  output$yinventory <- renderInfoBox({
    infoBox(
      " Averge Inventory", paste( 254.4808,"K"),icon=icon("tree"),
      color = "blue",fill = TRUE
    )
  })
  ##top product in a month by sales
  output$mtopproduct<- renderInfoBox({
    infoBox(
      " TopProduct )",paste(maxQty/1000,"K"),icon=icon("glyphicon glyphicon-apple",lib="glyphicon"),
      color = "red",fill = TRUE
    )
  })
  ##top product in a year by sales
  output$ytopproduct<- renderInfoBox({
    infoBox(
      " TopProduct ",paste(ymaxQty/1000,"K"),icon=icon("glyphicon glyphicon-apple",lib="glyphicon"),
      color = "red",fill = TRUE
    )
  })
 
  ##Inventory tunrnover for a year
  output$miturn<- renderInfoBox({
    infoBox(
      "Inventory Turnover",paste(round(inventurnover/254480.8,2)),icon = icon("glyphicon glyphicon-usd",lib="glyphicon"),
      color = "green",fill = TRUE
    )
  })
  ##Inventory tunrnover for a year
  output$yiturn<- renderInfoBox({
    infoBox(
      "Inventory Turnover",paste(round(inventurnover/254480.8,2)),icon = icon("glyphicon glyphicon-usd",lib="glyphicon"),
      color = "green",fill = TRUE
    )
  })
###Units per transactions in a month
  output$munits <- renderValueBox({
  infoBox(
    "Units/Transaction",paste(round(munitspertransaction,3)),  icon = icon("thumbs-up", lib = "glyphicon"),
    color = "orange",fill=TRUE
  )
})
  ###Units per transactions in a month
  output$yunits <- renderValueBox({
    infoBox(
      "Units/Transaction",paste(round(yunitspertransaction),3),  icon = icon("thumbs-up", lib = "glyphicon"),
      color = "orange",fill=TRUE
    )
  })
 
}