
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
library(C3)
library(plotly)
library(broom)
library(ECharts2Shiny)



server <- function(input, output) {
  # output$outputId<-renderPlotly({
  #   base_plot <- plot_ly(
  #     type = "pie",
  #     values = c(RMVal$Revenue[4], RMVal$Revenue[1], RMVal$Revenue[2], RMVal$Revenue[3]),
  #     # labels = c("-", "0", "20", "40", "60", "80", "100"),
  #     labels = c( RMVal$Revenue[1], RMVal$Revenue[2], RMVal$Revenue[3], RMVal$Revenue[4]),
  #     rotation = 108,
  #     direction = "anticlockwise",
  #     hole = 0.4,
  #     textinfo = "label",
  #     textposition = "outside",
  #     hoverinfo = "none",
  #     domain = list(x = c(0, 0.48), y = c(0, 1)),
  #     marker = list(colors = c('rgb(255, 255, 255)', 'rgb(255, 255, 255)', 'rgb(255, 255, 255)', 'rgb(255, 255, 255)', 'rgb(255, 255, 255)', 'rgb(255, 255, 255)', 'rgb(255, 255, 255)')),
  #     showlegend = FALSE
  #   )
  #   b_plot <- add_trace(
  #      base_plot,
  #     type = "pie",
  #     values = c(RMVal$Revenue[4],RMVal$Revenue[1], RMVal$Revenue[2], RMVal$Revenue[3],RMVal$Revenue[4]),
  #     labels = c("CurrentYearSales", "FirstYear", "SecondYear", "ThirdYear", "FinalYear"),
  #     # values = c(RMVal$Revenue[4]),
  #     # labels = c("CurrentYearSales"),
  #      rotation = 133,
  #     direction = "anticlockwise",
  #     hole = 0.3,
  #     textinfo = "label",
  #     textposition = "inside",
  #     hoverinfo = TRUE,
  #     domain = list(x = c(0, 0.48), y = c(0, 1)),
  #     marker = list(colors = c('rgb(255, 255, 255)', 'rgb(232,226,202)', 'rgb(226,210,172)', 'rgb(223,189,139)', 'rgb(223,162,103)', 'rgb(226,126,64)')),
  #     showlegend= FALSE
  #   )
  #   a <- list(
  #     showticklabels = FALSE,
  #     autotick = FALSE,
  #     showgrid = FALSE,
  #     zeroline = FALSE)
  # 
  #   b <- list(
  #     xref = 'paper',
  #     yref = 'paper',
  #     x = 0.23,
  #     y = 0.45,
  #     showarrow = FALSE,
  #     text = RMVal$Revenue[4])
  # 
  #   base_chart <- layout(
  #     b_plot,
  #     shapes = list(
  #       list(
  #         type = 'path',
  #         path = 'M 0.235 0.5 L 0.24 0.62 L 0.245 0.5 Z',
  #         xref = 'paper',
  #         yref = 'paper',
  #         fillcolor = 'rgba(44, 160, 101, 0.5)'
  #       )
  #     ),
  #     xaxis = a,
  #     yaxis = a,
  #     annotations = b
  #   )
  #   
  # })
  ######################Gauge chart###############
  
  value = reactive({
    input$update
    # round(runif(1,0,RMVal$Revenue[3]),1)
    round(runif(50, min =0 , max =100),2)
    # min=0 max=100 n=23
    # RMVal$Revenue[3]
  })
  
  # example use of the automatically generated render function
  output$gauge1 <- renderC3Gauge({ 
    # C3Gauge widget
    
    C3Gauge(RMVal$Revenue[3])
  })
  r1=RMVal$Revenue[4]
  r2=round(r1,1)
  renderGauge(div_id = "test",rate = RMVal$Revenue[4], gauge_name = "Revenue",show.tools = TRUE,
              animation = TRUE,
              running_in_shiny = TRUE)
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
     Msales<-daywisesales$sales
     msaleval<-cbind(msales,Msales)
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
    
    if(input$probins!=1)
    {
      Prevenue<-((RMVal$Revenue[4]*input$probins/100))
      minc1=((((RMVal$Revenue[4]+Prevenue)-RMVal$Revenue[4])/((RMVal$Revenue[4])))*100)
      # mic.annotation<-c(RMinc.annotation[1],RMinc.annotation[2],RMinc.annotation[3],RMinc.annotation[4])
      # print(Prevenue)
      ProRevenue<-c(0,0,0,Prevenue)
      mic.annotation<-c(paste(0,"%"),paste(0,"%"),paste(0,"%"),paste(round(minc1,1),"%"))
      ActRevenue<-c(RMVal$Revenue[1],RMVal$Revenue[2],RMVal$Revenue[3],RMVal$Revenue[4])
      year<-c(RMVal$Year[1],RMVal$Year[2],RMVal$Year[3],RMVal$Year[4])
      # inc.annotation<-paste(((Prevenue-Revenue[4])/Revenue[4])*100,"%")
      # benchmark<-c(69821,69821,69821,69821)
      rbind<-data.frame(ActRevenue,ProRevenue,year,RMinc.annotation,mic.annotation)
      pRsalechart<-gvisColumnChart(rbind,xvar = "year",yvar = c("ActRevenue","RMinc.annotation","ProRevenue","mic.annotation"),options=list(isStacked=TRUE,colors="['0072BB','FF4C3B']"))
      return(pRsalechart)
    }else{
      # benchmark<-c(69821,69821,69821,69821)
      # Rmval<-data.frame(RMVal,benchmark)
      marchchart<-gvisColumnChart(RMVal,xvar = "Year",yvar = c("Revenue","RMinc.annotation"),options=list(seriesType="bars",colors="['0072BB']"))
      # ,series='{2: {type:"line"}}'
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
     # Trends<-plot_ly(trend,x=~(Year),y=c("F","M","Trdiff.annotation"),type='bar',orientation = 'c')
  
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
      value=tags$p("NextLevelApparel",style = "font-size: 75%;"),"Top Brand ",
      color = "maroon"
    )
    
  })
  ##################top customer by revenue for current month##############
  output$topcustomerforcurrentmonth <- renderValueBox({
    valueBox(
      paste(topcustomercurrentmonth,topcustomerlname,sep=""),paste("TopCustomer",round(mtopcust$Revenue/1000,2),"K"), icon = icon("glyphicon glyphicon-star",lib="glyphicon"),
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
      paste(round(YAvg_Value,2),"$"), "Average Order Value", icon = icon("glyphicon glyphicon-usd",lib="glyphicon"),
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
  output$Yearly_sales_graph <- renderPlotly({
    # ysales<- select(ysalesval,Month,Sales)
    Month<-c("Jan","Feb","Mar")
    Sales<-ysalesval$Sales
    ysd<-data.frame(Month,Sales)
    p<-plot_ly(ysd,labels = Month, values = Sales) %>%
      add_pie(hole = 0.6) %>%
      layout( showlegend = F,
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    p
    
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
    if(input$yprobins!=1){
      Psales<-((ypincval$Revenue[5]*input$yprobins/100))
      minc1=((((ypincval$Revenue[5]+Psales)-ypincval$Revenue[5])/((ypincval$Revenue[5])))*100)
      ProRevenue<-c(0,0,0,0,Psales)
      mic.annotation<-c(paste(0,"%"),paste(0,"%"),paste(0,"%"),paste(0,"%"),paste(round(minc1,1),"%"))
      ActRevenue<-c(ypincval$Revenue[1],ypincval$Revenue[2],ypincval$Revenue[3],ypincval$Revenue[4],ypincval$Revenue[5])
      year<-c(ypincval$Year[1],ypincval$Year[2],ypincval$Year[3],ypincval$Year[4],ypincval$Year[5])
      rbind<-data.frame(ActRevenue,ProRevenue,year,yminc.annotation,mic.annotation)
      yRsalechart<-gvisColumnChart(rbind,xvar = "year",yvar = c("ActRevenue","yminc.annotation","ProRevenue","mic.annotation"),options=list(isStacked=TRUE,colors="['#008000','3A5F0B']"))
      return(yRsalechart) 
      
     
      
    }else{
      yRsalechart<-gvisColumnChart(ymval,xvar = "Year",yvar = c("Revenue","yminc.annotation"),options=list(colors="['#008000']"))
      return(yRsalechart)
      }
    
    
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
  output$web_traffic<- renderPlotly({
    # visitors1<- select(yearwebtraffic,year,visitors,visitors1.annotation)
    # gf<-select(yearwebtraffic)
    visitors1.annotation<-c("0%","252%","18%","41%","-71%")
    visitorsgrowthorfall<-data.frame(yearwebtraffic,visitors1.annotation)
    f <- list(
      family = "Courier New, monospace",
      size = 18,
      color = "#7f7f7f"
    )
    x <- list(title = "Year",titlefont = f)
    y <- list(
      title = "Visitors",
      titlefont = f
    )
    visitorschart<-plot_ly(x=c(yearwebtraffic$year),y=c(yearwebtraffic$visitors),type="bar",mode="markers")%>%
      layout(xaxis = x, yaxis = y)
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
  
  #####Average day order value##########
  output$Avg_day<-renderPlotly({
    df<-select(YmAvg_Value,Month,AvgOrderValue)
    YmAvg_Value$Month<-NULL
    Month<-c('JAN','FEB','MAR')
    AvgValue<-c(YmAvg_Value$AvgOrderValue[1],YmAvg_Value$AvgOrderValue[2],YmAvg_Value$AvgOrderValue[3])
    b2b<-c(491,491,491)
    b2c<-c(147,147,147)
    df<-data.frame(Month,AvgValue,b2b,b2c)
    df$Month <- factor(df$Month, levels = df[["Month"]])
    f <- list(
      family = "Courier New, monospace",
      size = 18,
      color = "#7f7f7f"
    )
    x <- list(title = "Month",titlefont = f)
    y <- list(
      title = "AverageOrderValue",
      titlefont = f
    )
    daygv<-plot_ly(df,x=~Month,y=~AvgValue,type = "bar" ,name = 'AverageOrderValue',mode = "markers" )%>%
      add_trace(y = ~b2b, name = 'B2B',type="scatter",mode="line") %>%
      add_trace(y = ~b2c, name = 'B2c Values',type="scatter",mode="line") %>%
      layout(xaxis = x, yaxis = y)
    return(daygv)
  })
  #####BenchMarking for year2015
  #####Average day order value##########
  output$month_avg<-renderPlotly({
    df<-select(ypAvg_value,Month,AvgOrderValue)
    YmAvg_Value$Month<-NULL
    Month<-c("JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC")
    AvgValue<-c(ypAvg_value$AvgOrderValue[1],ypAvg_value$AvgOrderValue[2],ypAvg_value$AvgOrderValue[3],ypAvg_value$AvgOrderValue[4],ypAvg_value$AvgOrderValue[5],ypAvg_value$AvgOrderValue[6],
                ypAvg_value$AvgOrderValue[7],ypAvg_value$AvgOrderValue[8],ypAvg_value$AvgOrderValue[9],ypAvg_value$AvgOrderValue[10],ypAvg_value$AvgOrderValue[11],ypAvg_value$AvgOrderValue[12])
    b2b<-c(491,491,491,491,491,491,491,491,491,491,491,491)
    b2c<-c(147,147,147,147,147,147,147,147,147,147,147,147)
    df<-data.frame(Month,AvgValue,b2b,b2c)
    df$Month <- factor(df$Month, levels = df[["Month"]])
    f <- list(
      family = "Courier New, monospace",
      size = 18,
      color = "#7f7f7f"
    )
    x <- list(title = "Month",titlefont = f)
    y <- list(
      title = "AverageOrderValue",
      titlefont = f
    )
    daygv<-plot_ly(df,x=~Month,y=~AvgValue,type = "bar" ,name = 'AverageOrderValue',mode = "markers",marker = list(color = 'rgb(153, 0, 51)') )%>%
      add_trace(y = ~b2b, name = 'B2B',type="scatter",mode="line") %>%
      add_trace(y = ~b2c, name = 'B2c Values',type="scatter",mode="line") %>%
      layout(xaxis = x, yaxis = y)
    return(daygv)
  })
  #####Benchmarking for EcommerceRatio
  output$er_year<-renderPlotly({
    # df<-select(ypVisitsval,ypTrValue)
    ypVisitsval$Month<-NULL
    ypTrValue$Month<-NULL
    Month<-c('JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC')
    for(i in 1:12){
      EpRation<-c((ypTrValue$Count/ypVisitsval$Visitor)*100)
    }
    
    b2b<-c(3,3,3,3,3,3,3,3,3,3,3,3)
    b2c<-c(3.24,3.24,3.24,3.24,3.24,3.24,3.24,3.24,3.24,3.24,3.24,3.24)
    df<-data.frame(Month,EpRation,b2b,b2c)
    df$Month <- factor(df$Month, levels = df[["Month"]])
    f <- list(
      family = "Courier New, monospace",
      size = 18,
      color = "#7f7f7f"
    )
    x <- list(title = "Month",titlefont = f)
    y <- list(
      title = "ECommerceRatio",
      titlefont = f
    )
    daygv<-plot_ly(df,x=~Month,y=~EpRation,type = "bar" ,name = 'ECommerceRatio',mode = "markers",marker = list(color = 'rgb(102, 153, 0)') )%>%
      add_trace(y = ~b2b, name = 'B2B',type="scatter",mode="line") %>%
      add_trace(y = ~b2c, name = 'B2c Values',type="scatter",mode="line") %>%
      layout(xaxis = x, yaxis = y)
    return(daygv)
  })
  #####Benchmarking for Growth in sales
  output$sp_year<-renderPlotly({
    dff<-select(ymval,Year,ysales)
    growth<-dff$ysales
    Year<-dff$Year
    b2b<-c(22,22,22,22,22)
    # b2c<-c(3.24,3.24,3.24,3.24,3.24,3.24,3.24,3.24,3.24,3.24,3.24,3.24)
    df<-data.frame(growth,Year,b2b)
    # df$Month <- factor(df$Month, levels = data[["Month"]])
    f <- list(
      family = "Courier New, monospace",
      size = 18,
      color = "#7f7f7f"
    )
    x <- list(title = "Year",titlefont = f)
    y <- list(
      title = "Growth in sales",
      titlefont = f
    )
    daygv<-plot_ly(df,x=~Year,y=~growth,type = "bar" ,name = 'Growth in Sales',mode = "markers",marker = list(color = 'rgb(0, 153, 255)') )%>%
      add_trace(y = ~b2b, name = 'B2B',type="scatter",mode="line") %>%
      # add_trace(y = ~b2c, name = 'B2c Values',type="scatter",mode="line") %>%
      layout(xaxis = x, yaxis = y)
    return(daygv)
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
  
  # output$tb2<-renderTable(row2016 ,options = list(lengthChange=TRUE,class = 'cell-border stripe',height="1000px"))
  output$tb2<-renderGvis({
    
    trends<-select(row2016,AvgperCustomer,Sales,QtyOrdered)
    row2016$totalcustomers <- NULL
    row2016$month <- NULL
    row2016$day <- NULL
    row2016$year <- NULL
    Trends<-c("Yesterday","Today","+/- in Percentage")
    # rownames[2]<-"Today"
    # rownames[3]<-"+/- in Percentage"
    tdata<-data.frame(Trends,row2016)
    
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
  
     
    
  # })
  
 
 ####Predictions 
  output$revenue<-renderPlotly({
    
    month <- c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul',
               'Aug', 'Sep', 'Oct', 'Nov', 'Dec')
    
    
    quarterRevenues<-c(177305.1500,156696.6500,167589.9700,
                       161294.24,175739.46,190184.69,
                       205526.02,220761.76,235997.50,
                       227371.41,208482.62,189593.83)
    LowerLimit<-c(0,0,0,
                  101319.770,116706.017,119813.433,
                  143911.48,157583.78,158676.15,
                  138624.5448,127634.9472,104348.9918)
    UpperLimit<-c(0,0,0,
                  238789.2,245967.2,265424.1,
                  284751.8,290014.6,307857.3,
                  316567.9,290000.7,275729.9)
    
    
    data <- data.frame(month,quarterRevenues,LowerLimit,UpperLimit)
    
    data$month <- factor(data$month, levels = data[["month"]])
    
    p <- plot_ly(data, x = ~month, y =~quarterRevenues, name = 'Revenue', type = 'scatter', mode = 'lines',
                 marker = list(color = 'rgb(205, 12, 24)')  ) %>%
      # add_trace(y = ~quarterRevenues, name = ' Revenue', line = list(color ='rgb(205, 12, 24)' , width = 4,dash = 'dash')) %>%
      # add_trace(y = ~UpperLimit, name = ' upper limit', line = list(color ='rgb( 0, 114, 187 )' , width = 4)) %>%
      
      
      layout(title = "Prediction of Revenue",
             xaxis = list(title = "Months"),
             yaxis = list (title = "Revenues"),
             barmode = 'relative')
    
    
    return(p)
    
  })   
  
  output$visitors<-renderPlotly({
    # #
    
    month <- c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul',
               'Aug', 'Sep', 'Oct', 'Nov', 'Dec')
    
    
    quarterVisitors<-c(55371,59321,49380,
                       38318.2,40783.6,43249.0,
                       45035.84,49172.54,53309.24,
                       69588.11,62947.05,56305.98)
    LowerLimit<-c(0,0,0,
                  33306.01,37050.95,39602.31,
                  25629.402,29496.699,30488.904,
                  14005.040,15439.092,5650.064)
    
    UpperLimit<-c(0,0,0,
                  44618.59,46935.80,50446.58,
                  65701.10,67460.50,72095.00,
                  120376.17,108385.40,107617.70)
    
    
    data <- data.frame(month,quarterVisitors,LowerLimit,UpperLimit)
    
    data$month <- factor(data$month, levels = data[["month"]])
    
    p <- plot_ly(data, x = ~month, y = ~quarterVisitors,  type = 'bar', name = 'Visitors',color = 'rgb( 255, 76, 59 )') %>%
      layout(title = 'Number of visitors ',
             xaxis = list(title = 'Month'),
             yaxis = list(title = 'Number of visitors'),
             barmode = 'relative')
    
    return(p)
    
    
    
  })
  
  
  #############Revenue in Q1
  output$Revenue_in_q1 <- renderValueBox({
    valueBox(
      paste(round(TotalRevenueinQ1,2)), "Total Revenue in Q1", icon = icon("glyphicon glyphicon-usd",lib="glyphicon"),
      color = "fuchsia"
    )
    
  })
  
  #############Revenue in Q2
  output$Revenue_in_q2 <- renderValueBox({
    valueBox(
      paste(round(TotalRevenueinQ2,2)), "Total Revenue in Q2", icon = icon("glyphicon glyphicon-usd",lib="glyphicon"),
      color = "purple"
    )
    
  })
  
  #############Revenue in Q3
  output$Revenue_in_q3 <- renderValueBox({
    valueBox(
      paste(round(TotalRevenueinQ3,2)), "Total Revenue in Q3", icon = icon("glyphicon glyphicon-usd",lib="glyphicon"),
      color = "orange"
    )
    
  })
  
  #############Revenue in Q4
  output$Revenue_in_q4 <- renderValueBox({
    valueBox(
      paste(round(TotalRevenueinQ4,2)), "Total Revenue in Q4", icon = icon("glyphicon glyphicon-usd",lib="glyphicon"),
      color = "black"
    )
    
  })
  
  
  
  #############Visitors in Q1
  output$Number_of_visitors_in_q1 <- renderValueBox({
    valueBox(
      paste(round(totalNumberofVisitorsinQ1,2),"K"), "Total Number of Visitors in Q1", icon = icon("glyphicon glyphicon-user",lib="glyphicon"),
      color = "red"
    )
    
  })
  
  ############Visitors in Q2
  output$Number_of_visitors_in_q2 <- renderValueBox({
    valueBox(
      paste(round(totalNumberofVisitorsinQ2,2),"K"), "Total Number of Visitors in Q2", icon = icon("fa fa-user-circle"),
      color = "teal"
    )
    
  })
  
  #############Visitors in Q3
  output$Number_of_visitors_in_q3 <- renderValueBox({
    valueBox(
      paste(round(totalNumberofVisitorsinQ3,2),"K"), "Total Number of Visitors in Q3", icon = icon("fa fa-user"),
      color = "navy"
    )
    
  })
  
  #############Visitors in Q4
  output$Number_of_visitors_in_q4 <- renderValueBox({
    valueBox(
      paste(round(totalNumberofVisitorsinQ4,2),"K"), "Total Number of Visitors in Q4", icon = icon("fa fa-user-md"),
      color = "yellow"
    )
    
  })
  
  
  
 
  
}