library(shiny)
library(shinydashboard)
library(googleVis)
library(plotly)

server <- function(input, output) {
  
  data1 <- function(){
    inFile <- input$file1
    if (is.null(inFile))
      return()
    
    data2 <- as.data.frame(read.csv(inFile$datapath))
    return(data2)
 }
  
  output$grosss_sales<- renderValueBox({
   
      data2 <- data1()
      
      if(length(data2) > 0)
      {
      valueBox(paste(round(sum(data2$Gross_Sale ))), "Revenue", icon = icon("glyphicon glyphicon-usd",lib="glyphicon"),color = "fuchsia")
      }
      else
      {
        valueBox(paste(""), "Revenue",color = "fuchsia")
      }
     
  })
  
  output$cash <- renderValueBox({
    
      data2 <- data1()
      if(length(data2) > 0)
       valueBox(paste(sum(data2$Cash )), "Cash", icon = icon("glyphicon glyphicon-usd",lib="glyphicon"),color = "blue")
      else
        valueBox(paste(""), "Cash",color = "blue")
  })
  
  output$credit_card <- renderValueBox({
    data2 <- data1()
    if(length(data2) > 0)
    valueBox(paste(round(sum(data2$Credit_Card ))), "Credit Card", icon = icon("glyphicon glyphicon-credit-card",lib="glyphicon"),color = "purple")
    else
      valueBox(paste(""), "Credit Card",color = "purple")
   })
  
  output$tax <- renderValueBox({
    data2 <- data1()
    if(length(data2) > 0)
    {
    tax1<-(sum(data2$Sale_Including_Tax)-sum(data2$Net_Sale_Excluding_Tax))
    valueBox(paste(round(tax1,0)), "Tax", icon = icon("glyphicon glyphicon-arrow-down",lib="glyphicon"),color = "black")
    }
    else
    valueBox(paste(""), "Tax",color = "black")
  })
  
  output$day_sales_mon<- renderGvis({
    data2 <- data1()
    if(length(data2) > 0)
    {
    Gross_sales<-data2$Gross_Sale
    Date<-data2$Date
    Total_sales<-data.frame(Date,Gross_sales)
    totalsales<-gvisColumnChart(Total_sales,options=list(height="300px",colors="['#FF6EB0']"))
    return(totalsales)
    }
    
  })
  
 output$days_sales<- renderGvis({
   daydata <- data1()
   if(length(daydata) > 0)
   {
    Day<-daydata$Day
    sales<-daydata$Sale
    
    y<-length(daydata$Day)
    
    sunTot <<- 0
    for(i in 1:y)
    {
      if(Day[i]=='SUN')
      {
        sunTot<<-sunTot+daydata$Gross_Sale[i]
      }
      
    }
    # Sunday<-Sun
    monTot <<- 0
    for(i in 1:y)
    {
      if(Day[i]=='MON')
      {
        monTot<<-monTot+daydata$Gross_Sale[i]
      }
    }
    #Monday<-Mon
    tueTot <<- 0
    for(i in 1:y)
    {
      if(Day[i]=='TUE')
      {
        tueTot<<-tueTot+daydata$Gross_Sale[i]
      }
    }
    #Tuesday<-Tue
    wedTot <<- 0
    for(i in 1:y)
    {
      if(Day[i]=='WED')
      {
        wedTot<<-wedTot+daydata$Gross_Sale[i]
      }
    }
    #Wednesday<-Wed
    
    thuTot <<- 0
    for(i in 1:y)
    {
      if(Day[i]=='THU')
      {
        thuTot<<-thuTot+daydata$Gross_Sale[i]
      }
    }
    #Thursday<-Thu
    
    friTot <<- 0
    for(i in 1:y)
    {
      if(Day[i]=='FRI')
      {
        friTot<<-friTot+daydata$Gross_Sale[i]
      }
    }
    #Friday<-Fri
    satTot <<- 0
    for(i in 1:y)
    {
      if(Day[i]=='SAT')
      {
        satTot<<-satTot+daydata$Gross_Sale[i]
      }
    }
    Week<-c(sunTot,monTot,tueTot,wedTot,thuTot,friTot,satTot)
    Days<-c("Sun","Mon","Tue","Wed","Thu","Fri","Sat")
    totWeek<-cbind.data.frame(Days,Week)
    #View(WeekDays)
    Weeksales<-gvisColumnChart(totWeek,options=list(height="300px",colors="['orange']"))
    return(Weeksales)
   }
 })
 
 
  output$dine_walk<- renderGvis({
    
    data2 <- data1()
    
    if(length(data2) > 0)
    {
    Date<-data2$Date
    
    Dine_In<-data2$Dine_In
    Walk_In<-data2$Walk_In
    Total_walk_dine<-data.frame(Date,Dine_In,Walk_In)
    walk_chart<-gvisLineChart(Total_walk_dine,options=list(height="300px",colors="['0199CC','AAAAAC','#F#4A00']"))
    return(walk_chart)
    }
  })
  
  output$month_checks <- renderValueBox({
    data2 <- data1()
    if(length(data2) > 0)
    valueBox(paste(round(sum(data2$Restaurant_Checks ))), "Checks", icon = icon("glyphicon glyphicon-user",lib="glyphicon"),color = "green")
    else
      valueBox(paste(""), "Checks",color = "green")
  })
  
  
  output$Avg_Rev_per_day <- renderValueBox({
    
    data2 <- data1()
  if(length(data2) > 0)
   valueBox(paste(round(sum(data2$Gross_Sale)/nrow(data2),0)), "Average Revenue per Day", icon = icon("glyphicon glyphicon-usd",lib="glyphicon"),color = "red")
  else
    valueBox(paste(""), "Average Revenue per Day",color = "red")
    
  })
  
  output$monthly_home_delivaeries <- renderValueBox({
    
    data2 <- data1()
    if(length(data2) > 0)
    valueBox(paste(round(sum(data2$Delivery),0)), "Home Deliveries", icon = icon("glyphicon glyphicon-usd",lib="glyphicon"),color = "teal")
    else
    valueBox(paste(""), "Home Deliveries",color = "teal")
  })
  
##################################################################################################################################################
  ################# Day Sales ###########################
  
  data3 <- function(){
    
    inFile <- input$file2
    if (is.null(inFile))
      return(NULL)
    daydata <- as.data.frame(read.csv(inFile$datapath))
    return(daydata)
  }
  
  
   output$Top_Item<- renderValueBox({

      daydata <- data3()
      if(length(daydata) > 0)
      valueBox(paste(round(max(daydata$TOTAL,0))), "Top Item", icon = icon("glyphicon glyphicon-usd",lib="glyphicon"),color = "teal")
      else
      valueBox(paste(""), "Top Item",color = "teal")
      
    })
   
  output$revenue<- renderValueBox({
    
    daydata <- data3()
    if(length(daydata) > 0)
    valueBox(paste(round(sum(daydata$  AMOUNT,0))),"Revenue", icon = icon("glyphicon glyphicon-usd",lib="glyphicon"),color = "green")
    else
      valueBox(paste(""), "Revenue",color = "green")
  })
  
  output$tax_day<- renderValueBox({
    
    daydata <- data3()
    if(length(daydata) > 0)
    valueBox(paste(round(sum(daydata$  TAX_AMT,0))),"Tax", icon = icon("glyphicon glyphicon-usd",lib="glyphicon"),color = "navy")
    else
      valueBox(paste(""), "Tax",color = "navy")
  })
  
  
  output$BILL_DISCOUNT<- renderValueBox({
    
    daydata <- data3()
    if(length(daydata) > 0)
     valueBox(paste(round(sum(daydata$BILL_DISCOUNT,0))),"Discount Amount",icon = icon("glyphicon glyphicon-usd",lib="glyphicon"),color = "fuchsia")
    else
      valueBox(paste(""), "Discount Amount",color = "fuchsia")
  })
  
  
  output$item_sales<- renderPlotly({
    m <- list(
      l = 50,
      r = 50,
      b = 100,
      t = 100,
      pad = 4
    )
    
    daydata <- data3()
    if(length(daydata) > 0)
    {
    Category_Names<-as.list(daydata$Category_Names)
    TOTAL<-as.list(daydata$TOTAL)
    TAX_AMT<-as.list(daydata$TAX_AMT)
    data<-data.frame(Category_Names,TAX_AMT)
    p <- plot_ly(data, x = ~Category_Names, y = ~TOTAL, type = 'bar',height = "300px", name = 'Item_Total', marker = list(color = 'rgb(  50, 185, 45)')) %>%
      add_trace(y = ~TAX_AMT, name = 'Item_Tax',height="300px", marker = list(color = 'rgb(255, 110, 176)')) %>%
      layout(autosize = F, width = 1250, height = 300, margin = m)
    return(p)
    }
    else
      return()
      
    })
  
  output$item_qty<- renderPlotly({
    m <- list(
      l = 50,
      r = 50,
      b = 100,
      t = 100,
      pad = 4
    )
    
    daydata <- data3()
    
    if(length(daydata) > 0)
    {
      Category_Names<-as.list(daydata$Category_Names)
      Quantity<-as.list(daydata$QTY)
      
      p<-plot_ly(daydata, x = ~Category_Names,height="300px") %>%
        
        add_lines(y=~Quantity, name = "item_QTY", visible = T,height="300px")%>%
      layout(autosize = F, width = 1200, height = 300, margin = m)
      return(p)
    }
    else
      return()
    })
  output$week_sales_charts<- renderHighchart({
    
    daydata <- data1()
    if(length(daydata) > 0)
    {
      Day<-daydata$Day
      sales<-daydata$Sale
      
      y<-length(daydata$Day)
      
      sunTot <- 0
      for(i in 1:y)
      {
        if(Day[i]=='SUN')
        {
          sunTot<-sunTot+daydata$Gross_Sale[i]
        }
        
      }
      # Sunday<-Sun
      monTot <- 0
      for(i in 1:y)
      {
        if(Day[i]=='MON')
        {
          monTot<-monTot+daydata$Gross_Sale[i]
        }
      }
      #Monday<-Mon
      tueTot <- 0
      for(i in 1:y)
      {
        if(Day[i]=='TUE')
        {
          tueTot<-tueTot+daydata$Gross_Sale[i]
        }
      }
      #Tuesday<-Tue
      wedTot <- 0
      for(i in 1:y)
      {
        if(Day[i]=='WED')
        {
          wedTot<-wedTot+daydata$Gross_Sale[i]
        }
      }
      #Wednesday<-Wed
      
      thuTot <- 0
      for(i in 1:y)
      {
        if(Day[i]=='THU')
        {
          thuTot<-thuTot+daydata$Gross_Sale[i]
        }
      }
      #Thursday<-Thu
      
      friTot <- 0
      for(i in 1:y)
      {
        if(Day[i]=='FRI')
        {
          friTot<-friTot+daydata$Gross_Sale[i]
        }
      }
      #Friday<-Fri
      satTot <- 0
      for(i in 1:y)
      {
        if(Day[i]=='SAT')
        {
          satTot<-satTot+daydata$Gross_Sale[i]
        }
      }
      
      weekendTot <-  sum(sunTot,satTot)
      weekdaysTot <- sum(monTot,tueTot,wedTot,thuTot,friTot)
      names<-c("weekendTot","weekdaysTot")
      names=as.data.frame(names)
      week2<-c(weekendTot,weekdaysTot)
      week2=as.data.frame(week2)
      salesdata1<-cbind.data.frame(names,week2)
      highchart(width="25px",height = "25px") %>%
        hc_title(text = "Weekend Vs Week Days") %>%
        hc_chart(type = "pie", options3d = list(enabled = TRUE, alpha = 50, beta = 0)) %>%
        hc_plotOptions(pie = list(depth = 90)) %>%
        hc_add_series_labels_values(salesdata1$names, salesdata1$week2) %>%
        hc_add_theme(hc_theme(
          chart = list(
            backgroundColor = NULL
          
            
          )
        ))
      # Weeksaleschart<-gvisPieChart(salesdata1)
      # return(Weeksaleschart)
      
    }
    
  })
  output$credit_card_sales<- renderHighchart({
    data2 <- data1()
    cash<-sum(data2$Cash)
    
    Credit_Card <-sum(data2$Credit_Card )
    names<-c("cash","Credit_Card")
    names=as.data.frame(names)
    cashval<-c(cash,Credit_Card)
    cashval=as.data.frame(cashval)
    cashdata1<-cbind.data.frame(names,cashval)
    
    highchart(width = 50, height = 50) %>%
      hc_title(text = "Cash And Credit Card Sales") %>%
      
      hc_chart(type = "pie", options3d = list(enabled = TRUE, alpha = 70, beta = 0,color = 'rgb(255, 110, 176)')) %>%
      hc_plotOptions(pie = list(depth = 70)) %>%
      hc_add_series_labels_values(cashdata1$names,cashdata1$cashval) %>%
      hc_add_theme(hc_theme(
        chart = list(
          backgroundColor = NULL
          
        )
      ))
    
  })
  
  
 }