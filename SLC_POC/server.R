
library(shinydashboard)
library(shiny)
library(googleVis)
library(dplyr)
library(lubridate)
library(DT)
library(readr)
library(ggplot2)
library(highcharter)
library(httr)
library(purrr)

# library(plotly)




server <- function(input, output) {
  
  ###############################################################################Month Dashboard for sales Start#################################################### 
  ##revenue generated for a month
  output$mrevenue <- renderValueBox({
    valueBox(
      paste(round(mRevenueval/1000000,2),"M" ), "Revenue", icon = icon("glyphicon glyphicon-usd",lib="glyphicon"),
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
  ##Ecomerce ratio for a month
  output$mEratio <- renderValueBox({
    valueBox(
      paste(round(mERatio,2),"%"),"Ecommerce Conversion Ratio",
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
  
  #################Increase in Sales Percentage
  differencegrowth=marchdata-febdata
  mincreaseper=(differencegrowth/febdata)
  output$salesComparision <- renderValueBox({
    valueBox(
      paste(round(mincreaseper*100,2),"%"), "Growth in sales", icon = icon("glyphicon glyphicon-open",lib="glyphicon"),
      color = "red"
    )
    
  })
  ##New customers added in a month
  output$mNewCustBox <- renderInfoBox({
    valueBox(
      paste(mNewCustVal), "New Customers", icon = icon("glyphicon glyphicon-user",lib="glyphicon"),
      color = "blue"
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
  ###########websitetraffic growth percentage#######################
  output$websitetrafficgrowth <- renderValueBox({
    valueBox(
      paste(webtrafficgrowthin2016,"%"), "WebSiteTraffic Growth", icon = icon("glyphicon glyphicon-arrow-down",lib="glyphicon"),
      color = "aqua"
    )
    
  })
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
        tdsalechart<-gvisAreaChart(todaysales,xvar="Time",yvar="Sales",options=list(height="200px"))
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
    msalechart<-gvisColumnChart(msales,xvar="day",yvar="sales",options =list(seriesType="bars",colors="['66CCFF']",height="300px"))
    return(msalechart)
    
  })
  ##plot for monthly wise sales by lcoation
  output$sales_Location_graph <- renderGvis({
    
    mlocsales <- msalelocval 
    msaleloc <- na.omit(mlocsales) 
    mgeostate <- gvisGeoChart(msaleloc,"Location","Revenue",options=list(region="US",displayMode="regions",resolution="provinces",height="300px",colors="green"))
    return(mgeostate)
    
  })
  
  ########################Brand wise Revenue in a month####################
  
  output$Revenue_of_the_brand<- renderGvis({
    BrandRevenue<- select(BrandRevenue,Brand,Revenue)
    
    BrandRevenuechart<-gvisPieChart(BrandRevenue,options=list(height="300px"))
    return(BrandRevenuechart)
    
  })
  ###Difference in sales per month
  output$Rev_curr<- renderGvis({
    revqty<- select(msalebrand16mar,Brand,CurrentMonthSales,LastMonthSales,SalesGrowth)
    revqtychart<-gvisTable(revqty,options=list(height="300px"))
    return(revqtychart)
    
  })
  
  #####NewCustomer Vs RepeatedCustomer
  output$New_Rep_Cust_per<- renderGvis({
    mname<-c("New","Return")
    mnn<-c(mNewCustmerper,mRepeatCustmerper,mnewCustmerRev$Revenue,mRepeatCustmerRev$Revenue)
    mNewRetcustPie<-data.frame(mname,mnn)
    mNewRepCustchart<-gvisPieChart(mNewRetcustPie,options=list(colors="['B84B9E','32B92D']",height="300px"))
    return(mNewRepCustchart) 
  })
  
  ##plot for a month sales in all the years
  output$Month_sales_graph_everyYear <- renderGvis({
    # marchrevenue<- select(RevenueMarchVal,RMinc,Revenue,Year)
    marchrevenue<- select(RMVal,Revenue,Year)
    # setNames(, c("Year","Revenue","RMinc.annotation"))
    # growthinsales.annotation<-(RMVal$RMinc)
    # marchchart<-gvisColumnChart(RMVal,xvar = "Year",yvar = c("Revenue","RMinc.annotation"),options=list(colors="['#F1C40F']"))
    # 
    # return(marchchart)
    if(input$probins!=1)
    {
      
      Prevenue<-(RMVal$Revenue[4]+(RMVal$Revenue[4]*input$probins/100))
      minc1=(((Prevenue-RMVal$Revenue[4])/((RMVal$Revenue[4])))*100)
      mic.annotation<-c(RMinc.annotation[1],RMinc.annotation[2],RMinc.annotation[3],paste(round(minc1516+minc1,1),"%"))
      # print(Prevenue)
      rrevenue<-c(RMVal$Revenue[1],RMVal$Revenue[2],RMVal$Revenue[3],Prevenue)
      year<-c(RMVal$Year[1],RMVal$Year[2],RMVal$Year[3],RMVal$Year[4])
      # inc.annotation<-paste(((Prevenue-Revenue[4])/Revenue[4])*100,"%")
      rbind<-data.frame(rrevenue,year,mic.annotation)
      pRsalechart<-gvisColumnChart(rbind,xvar = "year",yvar = c("rrevenue","mic.annotation"),options=list(colors="['#008000']"))
      return(pRsalechart)
    }else{
      marchchart<-gvisColumnChart(RMVal,xvar = "Year",yvar = c("Revenue","RMinc.annotation"),options=list(colors="['#F1C40F']"))
      return(marchchart)
    }
    
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
    Trends<-gvisColumnChart(trend,xvar=c("Year"),yvar=c("F","M","Trdiff.annotation"),options=list(seriesType="bars",colors="['814374','51A39D']",height="300px"))
    return(Trends)
    
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
  
  ###########topbrand for current month#########
  output$mtopbrand <- renderValueBox({
    valueBox(
      paste("NextLevelApparel"),"Top Brand ",
      color = "maroon"
    )
    
  })
  ##################top customer by revenue for current month##############
  output$topcustomerforcurrentmonth <- renderValueBox({
    valueBox(
      paste(topcustomercurrentmonth),paste(round(mtopcust$Revenue/1000,2),"K TopCustomer"), icon = icon("glyphicon glyphicon-star",lib="glyphicon"),
      color = "olive"
    )
    
  })
  ###############################comparision of visitors in the curren month(25th nd 26th days))#################
  output$comparisionofvisitors<- renderValueBox({
    valueBox(
      paste(visitorsinday2526,"%"), "Growth/Fall in no of visitors",icon = icon("glyphicon glyphicon-sort",lib="glyphicon"), 
      color = "purple"
    )
    
    
  })
  ### month
  output$month <- renderValueBox({
    valueBox(
      "26 March 2016",paste("Analysis"),
      color = "orange"
    )
  })
  
  
  ###############################################################################Month Dashboard for sales End####################################################
  ##########################################################################Year Dashbaord for Sales Start########################################################
  
  #################Increase in Sales Percentage per year
  yincreaseper=(differencey/data15)*100
  output$ysalesComparision <- renderValueBox({
    valueBox(
      paste(round(yincreaseper,2),"%"), "Growth in sales", icon = icon("glyphicon glyphicon-sort",lib="glyphicon"),
      color = "red"
    )
    
  })
  ##average order value for a year
  output$yavg_order <- renderValueBox({
    valueBox(
      paste(round(YAvg_Value,2),"%"), "Average Order Value", icon = icon("glyphicon glyphicon-usd",lib="glyphicon"),
      color = "fuchsia"
    )
    
  })
  ##Ecomerce ratio for a year
  output$yEratio <- renderValueBox({
    valueBox(
      paste(round(yERatio,2),"%"),"Ecommerce Conversion Ratio",
      color = "purple",icon = icon("credit-card")
      
    )
    
  })
  ###returning customers in a year
  output$yrecustomers <- renderValueBox({
    valueBox(
      paste(round(Inc,2),"%"), "Returning Customers", icon = icon("glyphicon glyphicon-repeat",lib="glyphicon"),
      color = "teal"
    )
    
  })
  
  
  ###AverageOrder +/- Growth
  Avg_Inc=((YAvg_Value-YAvg_Value15)/YAvg_Value15)*100
  output$incavg_order <- renderValueBox({
    valueBox(
      paste(round(Avg_Inc,2),"%"), "Growth/Fall Avg Order Value", icon = icon("glyphicon glyphicon-arrow-down",lib="glyphicon"),
      color = "olive"
    )
    
  })
  
  
  ###returning customers in a year in %
  orderrate=((order16-order15)/order15)*100
  output$orderpick <- renderValueBox({
    valueBox(
      paste(round(orderrate,2),"%"), "Order Picking Rate", icon = icon("glyphicon glyphicon-circle-arrow-down",lib="glyphicon"),
      color = "navy"
    )
    
  })
  ##revenue generated for a year
  output$yrevenue <- renderValueBox({
    valueBox(
      paste(round(yRevenueval/1000000,2),"M" ), "Revenue", icon = icon("glyphicon glyphicon-usd",lib="glyphicon"),
      color = "orange"
    )
  })
  ###############################comparision of visitors in the current year(2016) & previous year(2015)#################
  
  output$yearwisevisitors<- renderValueBox({
     visitorsinyear201516<-cbind(((visitorsinyear2016-visitorsinyear2015)/visitorsinyear2015)*100)
    valueBox(
      paste(round(visitorsinyear201516),"%"), "Growth/Fall in no of visitors ",icon = icon("glyphicon glyphicon-sort",lib="glyphicon"), 
      color = "black"
    )
    
    
  })
  ###Q1 sales analysis
  
  output$Q1Sales <- renderValueBox({
    quartersalesinyear201516<-(((salesq1[2]-salesq1[1])/salesq1[1]))*100  
    valueBox(
      paste(round(quartersalesinyear201516,3),"%"),"Growth in Sales Q1",  icon = icon("glyphicon glyphicon-arrow-up", lib = "glyphicon"),
      color = "yellow"
    )
  })
  ###Q1Visitors
  output$Q1Visitors <- renderValueBox({
    quartervisitorsinyear201516<-(((visitorsq1[1]-visitorsq1[2])/visitorsq1[2]))*100
    valueBox(
      paste(round(quartervisitorsinyear201516,2),"%"), "Growth in Visitors Q1", icon = icon("glyphicon glyphicon-plus-sign", lib = "glyphicon"),
      color = "maroon"
    )
  })
  # ###Q1return
  # output$Q1return <- renderValueBox({
  #   valueBox(
  #     paste(round(repeatedcustomersin201516,2),"%"), "Growth in Returning Visitors Q1", icon = icon("thumbs-up", lib = "glyphicon"),
  #     color = "orange"
  #   )
  # })
  ###Q1orderpick
  output$Q1orderpick <- renderValueBox({
    orderratein201516<-((q1order[1]-q1order[2])/q1order[2])*100
    valueBox(
      paste(round(orderratein201516,2),"%"),"Growth in OrderPick Q1",  icon = icon("glyphicon glyphicon-gift", lib = "glyphicon"),
      color = "light-blue"
    )
  })
  ##Q1Avgorder
  output$Q1Avgorder <- renderValueBox({
    Avg_Inc201516<-((q1avgorder[1]-q1avgorder[2])/q1avgorder[2])*100
    valueBox(
      paste(round(Avg_Inc201516,2),"%"),"Growth in Avg Order Value Q1",  icon = icon("glyphicon glyphicon-circle-arrow-down", lib = "glyphicon"),
      color = "aqua"
    )
  })
  ##plot for yearly sales analysis
  output$Yearly_sales_graph <- renderGvis({
    # ysales<- select(ysalesval,Month,Sales)
    Month<-c("Jan","Feb","Mar")
    Sales<-ysalesval$Sales
    ysd<-data.frame(Month,Sales)
    # ysalechart<-gvisColumnChart(ysd,xvar="Month",yvar="Sales",options=list(colors="['#1ABC9C']"))
    ysalechart<-gvisPieChart(ysd,options = list(colors="['51A39D','B7695C','CDBB79']",height="300px"))
    return(ysalechart)
    
  })
  ##plot for yearly wise sales by lcoation
  output$sales_Location_graph_Year <- renderGvis({
    
    ylocsales <- ysalelocvaly 
    ysaleloc <- na.omit(ylocsales) 
    ygeostate <- gvisGeoChart(ysaleloc,"Location","Revenue",options=list(region="US",displayMode="regions",resolution="provinces",height="300px",colors="red"))
    return(ygeostate)
    
  })
  ########################Brand wise Revenue in the current year(2016)####################
  
  output$year_wise_Brand_Revenue<- renderGvis({
    YBrandRevenue1<- select(YBrandRevenue,Brand,Revenue)
    
    YBrandRevenuechart<-gvisPieChart(YBrandRevenue1,options=list(height="300px"))
    return(YBrandRevenuechart)
    
  })
  ##plot for revenue genrted in all the years
  output$year_wise_revenue<- renderGvis({
    # yRsales<- select(yRevenue,Year,Revenue,yminc.annotation)
    yRsalechart<-gvisColumnChart(ymval,xvar = "Year",yvar = c("Revenue","yminc.annotation"),options=list(colors="['#008000']",height="300px"))
    return(yRsalechart)
    
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
  ###############finding the number of visitors in all years ##################
  output$web_traffic<- renderGvis({
    #visitors1<- select(yearwebtraffic,year,visitors,visitors1.annotation)
    # gf<-select(yearwebtraffic)
    visitors1.annotation<-c("0%","252%","18%","41%","-71%")
    visitorsgrowthorfall<-data.frame(yearwebtraffic,visitors1.annotation)
    visitorschart<-gvisColumnChart(visitorsgrowthorfall,xvar = "year",yvar = c("visitors","visitors1.annotation"),option=list(height="300px",colors="['3399CC']"))
    return(visitorschart)
    
  })
  
  #####Top 10 best products of current year(2016)"
  output$topproducts<- renderGvis({
    TopBest<- select(TopBestProducts,Productid,Name,Sales)
    topbestprochart<-gvisTable(TopBest)
    return(topbestprochart)
    
  })
  #####Top 10 best products of current year(2016) in location wise"
  output$topproductsinlocwise<- renderGvis({
    TopBestinloc<- select(locationwise,Location,Name,sales)
    
    topbestproinlocchart<-gvisTable(TopBestinloc)
    return(topbestproinlocchart)
    
  })
  ###Difference in sales
  output$ySalesdiff<- renderGvis({
    yrevqty<- select(ybrandsale,Brand,CurrentYear,LastYear,GrowthinSales)
    yrevqtychart<-gvisTable(yrevqty)
    return(yrevqtychart)
    
  })
  ###################################################################CurrentYear Dashboard for sales end############################################################
  ####################################################CurrentMonth Inventory#############################################################
  ##Average Inventory sold for a month
  output$minventory <- renderInfoBox({
    infoBox(
      " Averge Inventory SOld per Day", paste(round(mtotUnitsSold/26,2)),icon=icon("glyphicon glyphicon-scale",lib="glyphicon"),
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
  
  ##Average units sold for a day in month
  output$miturn<- renderInfoBox({
    infoBox(
      "Units SOld in Month",paste(mtotUnitsSold),icon = icon("glyphicon glyphicon-usd",lib="glyphicon"),
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
  
  ##plot for Qty sold by lcoation in a month
  output$mQty_Sold_loc<- renderGvis({
    # ilsales<- select(InventsalesbyRegion,Revenue,Location)
    mInventorysalesbyRegion <- mIsalesbyRegion
    milsales <- na.omit(mInventorysalesbyRegion)
    milgeostate <- gvisGeoChart(milsales,"Location","QuantityOrdered",options=list(region="US",displayMode="regions",resolution="provinces",height="230px",colors="['#2C3E50']"))
    return(milgeostate)
    
  })
  
  #####Brand wise quantity month
  output$mBrand_wise_qty<- renderGvis({
    mbrndwiseqty<- select(BrandRevenue,Brand,Qty)
    mbrandwiseqtychart<-gvisPieChart(mbrndwiseqty,options = list(height="230px"))
    return(mbrandwiseqtychart) 
  })
  
  ##Difference in Qty Per month
  output$Qty_curr<- renderGvis({
    revqty<- select(msalebrand16mar,Brand,CurrentmonthQty,LastmonthQty,QuantityGrowth)
    revqtychart<-gvisTable(revqty,options=list(height="230px"))
    return(revqtychart)
    
  })
  
  #############plot for Trends in the today and yesterday#############
  
  output$tb2<-renderTable(row2016 ,options = list(lengthChange=TRUE,class = 'cell-border stripe',height="1000px"))
  output$tb2<-renderGvis({
    
    trends<-select(row2016,AvgperCustomer,Sales,QtyOrdered)
    row2016$totalcustomers <- NULL
    row2016$month <- NULL
    row2016$day <- NULL
    row2016$year <- NULL
    rownames<-c("Yesterday","Today","+/- in Percentage")
    # rownames[2]<-"Today"
    # rownames[3]<-"+/- in Percentage"
    tdata<-data.frame(rownames,row2016)
    
    trendsoutput<-gvisTable(tdata,options=list(width="100%",height="230px"))
    return(trendsoutput)
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
  
  
  
  ##################top customer by items ordered for current month##############
  outputTopcustomer<- renderValueBox({
    valueBox(
      paste(topcustomercurrentmonthbyitem), "Top customer ",icon = icon("glyphicon glyphicon-heart",lib="glyphicon"), 
      color = "orange"
    )
    
  })
  
  ###############################################Quantity CurrentMonth Dashboard end############################################################
  #########################################Quantity currentYear Dashboard end############################################################
  
  ##Average Inventorysold for a year
  output$yinventory <- renderInfoBox({
    infoBox(
      " Averge Inventory SOld Per Month", paste( round(ytotUnitsSold/3,2)),icon=icon("glyphicon glyphicon-scale",lib="glyphicon"),
      color = "blue",fill = TRUE
    )
  })
  
  ##top product in a year by sales
  output$ytopproduct<- renderInfoBox({
    infoBox(
      " Top Product ",paste(ymaxQty/1000,"K"),icon=icon("glyphicon glyphicon-apple",lib="glyphicon"),
      color = "red",fill = TRUE
    )
  })
  
  
  ##Average units sold for a month in a year
  output$yiturn<- renderInfoBox({
    infoBox(
      "Units Sold in Year",paste(ytotUnitsSold),icon = icon("glyphicon glyphicon-usd",lib="glyphicon"),
      color = "green",fill = TRUE
    )
  })
  
  ###Units per transactions in a year
  output$yunits <- renderValueBox({
    infoBox(
      "Units per Transaction",paste(round(yunitspertransaction,3)),  icon = icon("thumbs-up", lib = "glyphicon"),
      color = "orange",fill=TRUE
    )
  })
  
  
  ##plot for Qty sold by lcoation in a year
  output$YQty_Sold_loc<- renderGvis({
    # ilsales<- select(InventsalesbyRegion,Revenue,Location)
    yInventorysalesbyRegion <- yIsalesbyRegion
    yilsales <- na.omit(yInventorysalesbyRegion)
    yilgeostate <- gvisGeoChart(yilsales,"Location","QuantityOrdered",options=list(region="US",displayMode="regions",resolution="provinces",width="600px",height="400px",colors="['#5B2C6F']"))
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
    yunitssell<-gvisColumnChart(ydf,options=list(seriesType="bars",series='{2: {type:"line"}}',colors="['0099CC','CCFFCC','#BA4A00']",height = "400px"))
    
    return(yunitssell)
    
  })
  
  
  ##################max_units ordered for all years##############lengthChange = TRUE, pageLength = 5,scrollY = TRUE,scrollX = FALSE,autoWidth = T
  output$tb4 = DT::renderDataTable(
    maxunitssold, filter = 'top', options = list(lengthChange = TRUE, pageLength = 5,scrollY = TRUE,scrollX = FALSE,autoWidth = T)
    
  )
  
  #################total number of units  sold in all years############################"
  output$total_units_sold<- renderGvis({
    numberofunits<- select(numberofunitssold,year,qty)
    
    numberofunitschart<-gvisColumnChart(numberofunits,options=list(height="400px"))
    return(numberofunitschart)
    
  })
  
  ###############################################
  output$tb5 = DT::renderDataTable(
    wholeyears, filter = 'top', options = list(lengthChange = TRUE, pageLength = 5,scrollY = TRUE,scrollX = TRUE,autoWidth = T)
    
  )
  
  #####Top 10 best products of current year(2016) by quantity"
  output$top_Qty_products<- renderGvis({
    topBest<- select(TopBestProducts,Productid,Name,Quantity)
    topprochart<-gvisTable(topBest)
    return(topprochart)
    
  }) 
  
  
  #######yesterday graph
  output$ygraphs<- renderGvis({
    #ord<- select(row2016)
    values<-c("Quantityordered","AvgperCustomer","Sales")
    # yesterday<-c(1129.00,194.8583,4481.74)
    # today<-c(825.00,200.1278,3602.30)
    difference<-c(-26.93,2.7,-19.62)
    
    # yes<-yesterday
    # tod<-today
    # 
    tdf<-data.frame(values,difference)
    ordchart <-gvisColumnChart(tdf,options=list(title="Growth or Fall",colors="['666633','CCCC99']"))
    return(ordchart) 
  })
  
  
  #####Brand wise quantity year
  output$yBrand_wise_qty<- renderGvis({
    ybrndwiseqty<- select(YBrandRevenue,Brand,Qty)
    ybrandwiseqtychart<-gvisPieChart(ybrndwiseqty,options=list(height="400px"))
    return(ybrandwiseqtychart) 
  })
  ###difference in Qty
  output$Qty_15_16<- renderGvis({
    yrevqty<- select(ybrandsale,Brand,CurrentYearQty,LastYearQty,GrowthinQuantity)
    yrevqtychart<-gvisTable(yrevqty)
    return(yrevqtychart)
    
  })
  #####Top 10 best products of current year(2016) in location wise"
  output$top_Qty_products_loc<- renderGvis({
    topBestinloc<- select(locationwise,Location,Name,Quantity)
    
    Topbestlocchart<-gvisTable(topBestinloc)
    return(Topbestlocchart)
    
  })
  
  
  
}