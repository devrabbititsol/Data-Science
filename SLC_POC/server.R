
library(shinydashboard)
library(shiny)
library(googleVis)
library(dplyr)
library(lubridate)
library(DT)
library(readr)
library(ggplot2)
library(highcharter)

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
      z<-round_date(x,unit="hour")
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
      z<-round_date(x,unit="hour")
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
    msalechart<-gvisColumnChart(msales,xvar="day",yvar="sales",options =list(seriesType="bars",colors="['66CCFF']"))
    return(msalechart)
    
  })
  ##plot for yearly sales analysis
  output$Yearly_sales_graph <- renderGvis({
    # ysales<- select(ysalesval,Month,Sales)
     Month<-c("Jan","Feb","Mar")
     Sales<-ysalesval$Sales
     ysd<-data.frame(Month,Sales)
    # ysalechart<-gvisColumnChart(ysd,xvar="Month",yvar="Sales",options=list(colors="['#1ABC9C']"))
     ysalechart<-gvisPieChart(ysd,options = list(colors="['51A39D','B7695C','CDBB79']"))
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
    yunitssell<-gvisColumnChart(ydf,options=list(seriesType="bars",series='{2: {type:"line"}}',colors="['0099CC','CCFFCC','#BA4A00']"))
    
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
 # # ###Top 10  Products in corresponding months
 # #  output$TopProduct_sold_Analysis<- renderGvis({
 # #    yTopProSold<- select(yTopProSales,months1,Qty)
 # #    yTopProSoldchart<-gvisPieChart(yTopProSold)
 # #    return(yTopProSoldchart)
 # #    
 # #  })
 # #  
 #  observe({
 #    y<-input$Month_Sold_Pro 
 #    
 #    if(y=="Mar")
 #    {
 #      
 #      output$TopProduct_sold_Analysis<- renderGvis({
 #        ymarTopProSold<- select(yTopProSales3,Name,Qty)
 #        ymarTopProSoldchart<-gvisPieChart(ymarTopProSold)
 #        return(ymarTopProSoldchart) 
 #      })
 #    }
 #    if(y=="Feb")
 #    {
 #      output$TopProduct_sold_Analysis<- renderGvis({
 #        yfebTopProSold<- select(yTopProSales2,Name,Qty)
 #        yfebTopProSoldchart<-gvisPieChart(yfebTopProSold)
 #        return(yfebTopProSoldchart) 
 #      })
 #    }
 #    if(y=="Jan")
 #    {
 #      output$TopProduct_sold_Analysis<- renderGvis({
 #        yjanTopProSold<- select(yTopProSales1,Name,Qty)
 #        yjanTopProSoldchart<-gvisPieChart(yjanTopProSold)
 #        return(yjanTopProSoldchart) 
 #        
 #      })
 #    }
 #  
 #  })
  
  ##################max_units ordered for all years##############lengthChange = TRUE, pageLength = 5,scrollY = TRUE,scrollX = FALSE,autoWidth = T
  output$tb4 = DT::renderDataTable(
    maxunitssold, filter = 'top', options = list(lengthChange = TRUE, pageLength = 5,scrollY = TRUE,scrollX = FALSE,autoWidth = T)
    
  )
  
  #################total number of units  sold in all years############################"
  output$total_units_sold<- renderGvis({
    numberofunits<- select(numberofunitssold,year,qty)
    
    numberofunitschart<-gvisColumnChart(numberofunits)
    return(numberofunitschart)
    
  })
  
  ###############################################
  output$tb5 = DT::renderDataTable(
    wholeyears, filter = 'top', options = list(lengthChange = TRUE, pageLength = 5,scrollY = TRUE,scrollX = TRUE,autoWidth = T)
    
  )
  #############plot for Trends in the today and yesterday#############
  
  # output$tb2<-renderTable(row2016 ,options = list(lengthChange=FALSE,class = 'cell-border stripe'))
  
  output$tb2 = DT::renderDataTable(
    
     row2016 ,options = list(lengthChange=FALSE,class = 'cell-border stripe')
   

  )
  #######yesterday graph
  output$ygraphs<- renderGvis({
    #ord<- select(row2016)
    values<-c("qtyordered","AvgperCustomer","Sales")
    yesterday<-c(1129.00,194.8583,4481.74)
    today<-c(825.00,200.1278,3602.30)
    
    # rownames(tdf)[1]<-"qtyordered"
    # rownames(tdf)[2]<-"AvgperCustomer"
    # rownames(tdf)[3]<-"Sales"
    # 
    yes<-yesterday
    tod<-today
    
    tdf<-data.frame(values,yes,tod)
    ordchart <-gvisPieChart(tdf,yes)
    return(ordchart) 
  })
  ###########################today graph########
  output$tgraphs<- renderGvis({
    #ord<- select(row2016)
    values1<-c("qtyordered","AvgperCustomer","Sales")
    yesterday<-c(1129.00,194.8583,4481.74)
    today<-c(825.00,200.1278,3602.30)
    
    # rownames(tdf)[1]<-"qtyordered"
    # rownames(tdf)[2]<-"AvgperCustomer"
    # rownames(tdf)[3]<-"Sales"
    # 
    yes1<-yesterday
    today1<-today
    
    todf<-data.frame(values1,today1,yes1)
    ordchart <-gvisPieChart(todf,today1)
    return(ordchart) 
  })
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
      paste(webtrafficgrowthin2016,"%"), "WebSiteTraffic Growth", icon = icon("glyphicon glyphicon-arrow-down",lib="glyphicon"),
      color = "aqua"
    )

  })
  
  ######################sales analysis for all years in feb and march######################
  
  output$Trends_FM<- renderGvis({
    febmarch<- select(febmarchanalysis,Year,Month,Revenue)
    Tdiff.annotation<-c(0,0,0,0)
    Trdiff.annotation<-c("111.67%","17.1%","7.27%","6.95%")
     # print(Trdiff.annotation)
    Year<-c("2013","2014","2015","2016")
    F<-c(febmarchanalysis$Revenue[1],febmarchanalysis$Revenue[3],febmarchanalysis$Revenue[5],febmarchanalysis$Revenue[7])
    M<- c(febmarchanalysis$Revenue[2],febmarchanalysis$Revenue[4],febmarchanalysis$Revenue[6],febmarchanalysis$Revenue[8])
    # Mbind<-data.frame(M,Trdiff.annotation)
    trend<-data.frame(Year,F,M,Trdiff.annotation)
    Trends<-gvisColumnChart(trend,xvar=c("Year"),yvar=c("F","M","Trdiff.annotation"),options=list(seriesType="bars",colors="['814374','51A39D']"))
    return(Trends)
    
  })
  ########################Brand wise Revenue in a month####################
  
  output$Revenue_of_the_brand<- renderGvis({
    BrandRevenue<- select(BrandRevenue,Brand,Revenue)
    
    BrandRevenuechart<-gvisPieChart(BrandRevenue)
    return(BrandRevenuechart)
    
  })
  ########################Brand wise Revenue in the current year(2016)####################
  
  output$year_wise_Brand_Revenue<- renderGvis({
    YBrandRevenue1<- select(YBrandRevenue,Brand,Revenue)
    
    YBrandRevenuechart<-gvisPieChart(YBrandRevenue1)
    return(YBrandRevenuechart)
    
  })
  #######################Customer Repeat vs New for month#######################################33
  output$month_cust<- renderHighchart({
    # grndcntfornew<-c(20,64,67,102)
    # grndcntforrep<-c(27,51,83,116)
    # year2<-c("2013","2014","2015","2016")
    # 
    # newcust<-grndcntfornew
    # repcust<-grndcntforrep
    # 
    # nrc<-data.frame(year2,newcust,repcust)
    # 
    # nrepcustformarch<-gvisColumnChart(nrc,options=list(colors="['92CD00','FFCF79']"))
    # 
    # return(nrepcustformarch)
    year<-c(2013,2014,2015,2016)
    mcustnew<-c(20,64,67,102)
    mcustrep<-c(27,51,83,116)
    mydata <- data.frame(NewCustomer=mcustnew,
                         RepeatCustomer=mcustrep
    )
    
    highchart() %>% 
      hc_chart(type = "column") %>% 
      hc_title(text = "Customer") %>% 
      hc_xAxis(categories =c('2013', '2014', '2015', '2016'))%>%
      hc_yAxis(title = list(text = "no of Customers")) %>% 
      hc_plotOptions(column = list(
        dataLabels = list(enabled = TRUE),
        stacking = "normal",
        enableMouseTracking = TRUE
      )
      ) %>% 
      hc_series(list(name="NewCustomer",data=mydata$NewCustomer),
                list(name="RepeatCustomer",data=mydata$RepeatCustomer)
      )
    
  })
  #####FOr year########################
  output$year_cust<- renderHighchart({
       year<-c(2012,2013,2014,2015,2016)
        ycustnew<-c(25,86,115,152,108)
       ycustrep<-c(68,191,314,402,220)
    mydata <- data.frame(NewCustomer=ycustnew,
                         RepeatCustomer=ycustrep
                         )
    
   highchart() %>% 
      hc_chart(type = "column") %>% 
      hc_title(text = "Customer") %>% 
      hc_xAxis(categories =c('2012', '2013', '2014', '2015', '2016'))%>%
      hc_yAxis(title = list(text = "no of Customers")) %>% 
      hc_plotOptions(column = list(
        dataLabels = list(enabled = TRUE),
        stacking = "normal",
        enableMouseTracking = TRUE
        )
      ) %>% 
     hc_series(list(name="NewCustomer",data=mydata$NewCustomer),
                list(name="RepeatCustomer",data=mydata$RepeatCustomer)
                )
    
    
    
   
  })
  
  #####Brand wise quantity month
  output$mBrand_wise_qty<- renderGvis({
    mbrndwiseqty<- select(BrandRevenue,Brand,Qty)
    mbrandwiseqtychart<-gvisPieChart(mbrndwiseqty)
    return(mbrandwiseqtychart) 
  })
  #####Brand wise quantity year
  output$yBrand_wise_qty<- renderGvis({
    ybrndwiseqty<- select(YBrandRevenue,Brand,Qty)
    ybrandwiseqtychart<-gvisPieChart(ybrndwiseqty)
    return(ybrandwiseqtychart) 
  })
  ###difference in Qty
  output$Qty_15_16<- renderGvis({
    yrevqty<- select(ybrandsale,Brand,Qty16,Qty15,QuantityDifference)
    yrevqtychart<-gvisTable(yrevqty)
    return(yrevqtychart)
    
  })
  ###Difference in sales
  output$ySalesdiff<- renderGvis({
    yrevqty<- select(ybrandsale,Brand,Revenue16,Revenue15,SalesDifference)
    yrevqtychart<-gvisTable(yrevqty)
    return(yrevqtychart)
    
  })
  ###Difference in sales per month
  output$Rev_curr<- renderGvis({
    revqty<- select(msalebrand16mar,Brand,Revenue,FebRevenue,MSalesDifference)
    revqtychart<-gvisTable(revqty)
    return(revqtychart)
    
  })
  
  ##Difference in Qty Per month
  output$Qty_curr<- renderGvis({
    revqty<- select(msalebrand16mar,Brand,Qty,FebQty,MQtyDifference)
    revqtychart<-gvisTable(revqty)
    return(revqtychart)
    
  })
  ###########topbrand for current month#########
  output$mtopbrand <- renderValueBox({
    valueBox(
      "Top Brand ",paste("NextLevelApparel"),
      color = "maroon"
    )
    
  })
  ###########topbrand for current year#########
  output$ytopbrand <- renderValueBox({
    valueBox(
      paste("NextLevelApparel"), "Top Brand ", 
      color = "teal"
    )
    
  })
  ###############finding the number of visitors in all years ##################
  output$web_traffic<- renderGvis({
    #visitors1<- select(yearwebtraffic,year,visitors,visitors1.annotation)
    # gf<-select(yearwebtraffic)
    visitors1.annotation<-c("0%","252%","18%","41%","-71%")
    visitorsgrowthorfall<-data.frame(yearwebtraffic,visitors1.annotation)
    visitorschart<-gvisColumnChart(visitorsgrowthorfall,xvar = "year",yvar = c("visitors","visitors1.annotation"))
    return(visitorschart)
    
  })
  ##################top customer by revenue for current month##############
  output$topcustomerforcurrentmonth <- renderValueBox({
    valueBox(
      "Top customer ",paste(topcustomercurrentmonth,mtopcust$Revenue), icon = icon("glyphicon glyphicon-star",lib="glyphicon"),
      color = "olive"
    )
    
  })
  
  ##################top customer by revenue for current year##############
  output$topcustomerforcurrentyear <- renderValueBox({
    valueBox(
      paste(topcustomercurrentyear,ytopcust$Revenue), "Top customer ", icon = icon("glyphicon glyphicon-star",lib="glyphicon"),
      color = "green"
    )
    
  })
  ##################top customer by items ordered for current month##############
  outputTopcustomer<- renderValueBox({
    valueBox(
      paste(topcustomercurrentmonthbyitem), "Top customer ",icon = icon("glyphicon glyphicon-heart",lib="glyphicon"), 
      color = "orange"
    )
    
  })
  ##################top customer by items ordered for current year##############
  output$ytopcustomer <- renderValueBox({
    valueBox(
      paste(topcustomerforcurrentyearbyitem), "Top customer ",icon = icon("glyphicon glyphicon-heart",lib="glyphicon"), 
      color = "purple"
    )
    
  })
  output$New_Rep_Cust_per<- renderGvis({
    # mNewRepCust<- select(mNewCustmerper,mRepeatCustmerper)
    mname<-c("New","Return")
    mnn<-c(mNewCustmerper,mRepeatCustmerper)
    mNewRetcustPie<-data.frame(mname,mnn)
    mNewRepCustchart<-gvisPieChart(mNewRetcustPie,options=list(colors="['B84B9E','32B92D']"))
    return(mNewRepCustchart) 
  })
  
  
  
}