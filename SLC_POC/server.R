
library(shinydashboard)
library(shiny)
library(googleVis)
library(dplyr)
library(lubridate)
library(DT)
library(readr)
library(ggplot2)

# library(plotly)




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
      tdsales<- select(tdaysales,timestamp,Sales)
      x<-as.POSIXct(tdaysales$timestamp)
      z<-round_date(x,unit="minute")
      Time<-strftime(z, format="%I.%M %p")
      todaysales<-cbind(Time,tdsales)
      tdsalechart<-gvisAreaChart(todaysales,xvar="Time",yvar="Sales",options=list(width="100%",height="200px"))
      return(tdsalechart)
      
    })
       
  }
  if(x=="Yesterday")
  {
    output$today_sales_graph <- renderGvis({
      ydsales<- select(ydaysales,timestamp,Sales)
      x<-as.POSIXct(ydaysales$timestamp)
      z<-round_date(x,unit="minute")
      Time<-strftime(z, format="%I.%M %p")
      yedaysales<-cbind(Time,ydsales)
      ydsalechart<-gvisAreaChart(yedaysales,xvar="Time",yvar="Sales",options=list(width="100%",height="200px"))
      return(ydsalechart)
      
    })
  }
  })
    
  ##plot for monthly sales analysis
  output$monthly_sales_graph <- renderGvis({
    msales<- select(daywisesales,day,sales)
    # Msales<-daywisesales$sales
    # msaleval<-cbind(msales,Msales)
    msalechart<-gvisColumnChart(msales,xvar="day",yvar="sales",options =list(seriesType="bars",series='{1: {type:"line"}}',colors="['#A52A2A']"))
    return(msalechart)
    
  })
  ##plot for yearly sales analysis
  output$Yearly_sales_graph <- renderGvis({
    # ysales<- select(ysalesval,Month,Sales)
     Month<-c("Jan","Feb","Mar")
     Sales<-ysalesval$Sales
     ysd<-data.frame(Month,Sales)
    # ysalechart<-gvisColumnChart(ysd,xvar="Month",yvar="Sales",options=list(colors="['#1ABC9C']"))
     ysalechart<-gvisPieChart(ysd,options=list(colors="['#1ABC9C']"))
    return(ysalechart)
    
  })
  #####Top 10 best products of current year(2016) in location wise"
  output$topproductsinlocwise<- renderGvis({
    TopBestinloc<- select(locationwise,Location,Name,sales)
    
    topbestproinlocchart<-gvisTable(TopBestinloc)
    return(topbestproinlocchart)
    
  })
  #####Top 10 best products of current year(2016) in location wise"
  output$top_Qty_products_loc<- renderGvis({
    topBestinloc<- select(locationwise,Location,Name,Quantity)
    
    Topbestlocchart<-gvisTable(topBestinloc)
    return(Topbestlocchart)
    
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
    # marchrevenue<- select(RevenueMarchVal,RMinc,Revenue,Year)
     marchrevenue<- select(RMVal,Revenue,Year)
    # setNames(, c("Year","Revenue","RMinc.annotation"))
    # growthinsales.annotation<-(RMVal$RMinc)
    marchchart<-gvisColumnChart(RMVal,xvar = "Year",yvar = c("Revenue","RMinc.annotation"),options=list(colors="['#F1C40F']"))
    
    return(marchchart)
    
  })
 
  ##plot for projection revenue genrted 
  output$Projection<- renderGvis({
    pRsales<- select(RevenueMarchVal,Year,Revenue)
    
    Erevenue<-RevenueMarchVal$Revenue[4]
    year<-RevenueMarchVal$Year[4]
    if(input$bins!=1)
    {
      Prevenue<-(Erevenue+(Erevenue*input$bins/100))
      inc.annotation<-paste(((Prevenue-Erevenue)/Erevenue)*100,"%")
      rbind<-data.frame(Prevenue,year,inc.annotation)
      pRsalechart<-gvisColumnChart(rbind,xvar = "year",yvar = c("Prevenue","inc.annotation"),options=list(colors="['#008000']"))
      return(pRsalechart)
    }else{
      rbind<-data.frame(Erevenue,year)
      pRsalechart<-gvisColumnChart(rbind,xvar = "year",yvar = "Erevenue",options=list(colors="['#008000']"))
      return(pRsalechart)
    }
    
    
  })
  
  
  ##plot for revenue genrted in all the years
  output$year_wise_revenue<- renderGvis({
    # yRsales<- select(yRevenue,Year,Revenue,yminc.annotation)
    yRsalechart<-gvisColumnChart(ymval,xvar = "Year",yvar = c("Revenue","yminc.annotation"),options=list(colors="['#008000']"))
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
    yunitssell<-gvisColumnChart(ydf,options=list(seriesType="bars",series='{2: {type:"line"}}',colors="['green','blue','#BA4A00']"))
    
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
  # ###############Bounce Rate
  # output$bouncerate <- renderValueBox({
  #   valueBox(
  #     paste(round(bouncerate,2),"%"), "Bounce Rate", icon = icon("glyphicon glyphicon-minus",lib="glyphicon"),
  #     color = "navy"
  #   )
  #   
  # })
  #################Increase in Sales Percentage
  output$salesComparision <- renderValueBox({
    valueBox(
      paste(round(mincreaseper,2),"%"), "Growth in sales", icon = icon("glyphicon glyphicon-open",lib="glyphicon"),
      color = "red"
    )
    
  })
  #####Top 10 best products of current year(2016)"
  output$topproducts<- renderGvis({
    TopBest<- select(TopBestProducts,Productid,Name,Sales)
    topbestprochart<-gvisTable(TopBest)
    return(topbestprochart)
    
  })
  
  #####Top 10 best products of current year(2016) by quantity"
  output$top_Qty_products<- renderGvis({
    topBest<- select(TopBestProducts,Productid,Name,Quantity)
    topprochart<-gvisTable(topBest)
    return(topprochart)
    
  })

###Available Inventory and Downlaoding filteredData  
  output$tbl = DT::renderDataTable(
    availInventoryStock, filter = 'top', options = list(lengthChange = TRUE, pageLength = 5,scrollX = TRUE)
    
  )
  
  #####for download button################ 
  output$x3 = downloadHandler("mydata.csv",
                              filename = function() {
                                # input$filetype
                                paste( "filtereddata",sep = ".","csv")
                              },
                              
                              content = function(file) {
                                s = input$tbl_rows_all
                                write.csv(availstock[s, , drop = FALSE], file)
                              } )
  availstock = availInventoryStock[, c('Productid', 'Quantity','Productname')]
  
  output$tb1 = DT::renderDataTable(availstock, server = FALSE,options=list("scrollY":"350px",
                                   "scrollCollapse": TRUE,
                                   "paging":         FALSE))
  

  ##Average Inventory sold for a month
  output$minventory <- renderInfoBox({
    infoBox(
      " Averge Inventory SOld per Day", paste(round(dInvent/26,2)),icon=icon("glyphicon glyphicon-scale",lib="glyphicon"),
      color = "blue",fill = TRUE
    )
  })
  ##Average Inventorysold for a year
  output$yinventory <- renderInfoBox({
    infoBox(
      " Averge Inventory SOld Per Month", paste( round(yInvent/3,2)),icon=icon("glyphicon glyphicon-scale",lib="glyphicon"),
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
      "Units SOld in Month",paste(round(dInvent)),icon = icon("glyphicon glyphicon-usd",lib="glyphicon"),
      color = "green",fill = TRUE
    )
  })
  ##Inventory tunrnover for a year
  output$yiturn<- renderInfoBox({
    infoBox(
      "Units Sold in Year",paste(round(yInvent)),icon = icon("glyphicon glyphicon-usd",lib="glyphicon"),
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
  ### month
  output$month <- renderValueBox({
    valueBox(
      "26 March 2016",paste("Analysis"),
      color = "orange"
    )
  })
 # ###Top 10  Products in corresponding months
 #  output$TopProduct_sold_Analysis<- renderGvis({
 #    yTopProSold<- select(yTopProSales,months1,Qty)
 #    yTopProSoldchart<-gvisPieChart(yTopProSold)
 #    return(yTopProSoldchart)
 #    
 #  })
 #  
  observe({
    y<-input$Month_Sold_Pro 
    
    if(y=="Mar")
    {
      
      output$TopProduct_sold_Analysis<- renderGvis({
        ymarTopProSold<- select(yTopProSales3,Name,Qty)
        ymarTopProSoldchart<-gvisPieChart(ymarTopProSold)
        return(ymarTopProSoldchart) 
      })
    }
    if(y=="Feb")
    {
      output$TopProduct_sold_Analysis<- renderGvis({
        yfebTopProSold<- select(yTopProSales2,Name,Qty)
        yfebTopProSoldchart<-gvisPieChart(yfebTopProSold)
        return(yfebTopProSoldchart) 
      })
    }
    if(y=="Jan")
    {
      output$TopProduct_sold_Analysis<- renderGvis({
        yjanTopProSold<- select(yTopProSales1,Name,Qty)
        yjanTopProSoldchart<-gvisPieChart(yjanTopProSold)
        return(yjanTopProSoldchart) 
        
      })
    }
  
  })
  
  ##################max_units ordered for all years##############
  output$tb4 = DT::renderDataTable(
    maxunitssold, filter = 'top', options = list(lengthChange = TRUE, pageLength = 5,scrollY = TRUE,scrollX = TRUE,autoWidth = T)
    
  )
  
  #################total number of units  sold in all years############################"
  output$total_units_sold<- renderGvis({
    numberofunits<- select(numberofunitssold,year,qty)
    
    numberofunitschart<-gvisColumnChart(numberofunits)
    return(numberofunitschart)
    
  })
  ###################Low stock analysis in all years######
  output$tb3 = DT::renderDataTable(
    lowstockdays2,  options = list(lengthChange = TRUE, pageLength = 5,scrollY = TRUE,scrollX = TRUE)
    
  )
  ###############################################
  output$tb5 = DT::renderDataTable(
    wholeyears, filter = 'top', options = list(lengthChange = TRUE, pageLength = 5,scrollY = TRUE,scrollX = TRUE,autoWidth = T)
    
  )
  #############plot for Trends in the today and yesterday#############
  
  output$tb2 = DT::renderDataTable(
    row2016 ,options = list(lengthChange=FALSE,class = 'cell-border stripe')
    
  )
  
  # output$websiteconversionrate <- renderValueBox({
  #   valueBox(
  #     paste(wrate,"%"), "WebSiteConversion Rate", icon = icon("glyphicon glyphicon-open",lib="glyphicon"),
  #     color = "purple"
  #   )
  #   
  # })
  ###########websitetraffic growth percentage####################### 
  output$websitetrafficgrowth <- renderValueBox({
    valueBox(
      paste(mwgrowth,"%"), "WebSiteTraffic Growth", icon = icon("glyphicon glyphicon-open",lib="glyphicon"),
      color = "aqua"
    )
    
  })
  
  
  
  
  
}