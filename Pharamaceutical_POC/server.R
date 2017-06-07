library(shiny)
library(shinydashboard)
library(googleVis)
library(highcharter)
library(ggiraph)
library(ggplot2)
library(ggmap)
library(plotrix)
library(rsconnect)
library(RSQLite)


server <- function(input, output) {
  output$maxphar <- renderValueBox({
    valueBox(
      paste(maxno.ofcommphar),paste("Community Pharmacies"), icon = icon("glyphicon glyphicon-star",lib="glyphicon"),
      color = "aqua"
    )
     }) 
  output$mediser <- renderValueBox({
    valueBox(
      paste(round(sum(patientser$d))), "Patient Group Direction Top Service",icon = icon("glyphicon glyphicon-open",lib="glyphicon"), 
      color = "purple")
    
  })
  output$avgitems <- renderValueBox({
    valueBox(
      paste(avgitems),paste("AvgMonthlyItemsDispencedPerPharmacy"), icon = icon("glyphicon glyphicon-asterisk",lib="glyphicon"),
      color = "red"
    )
  })
  output$TotalMur <- renderValueBox({
    
    valueBox(paste(max(Murserv$Total.MURs)),"Mur Service Top City(London)",color = "teal",icon = icon("glyphicon glyphicon-record",lib="glyphicon"))
    
  })
  output$TotalcommunityPharmacies<-renderValueBox({
    
    valueBox(
      paste("0.27","%"), "Community Pharmacies Growth", icon = icon("glyphicon glyphicon-tree-conifer",lib="glyphicon"),
      color = "olive")
    
  })
  output$AvgMitems<-renderHighchart({
  
          highchart() %>%
      hc_yAxis(
        title = list(text = "Items Per Pharmacy")
        
      ) %>%
          hc_xAxis(categories = locationpharma$England,title=list(text = "Regions")) %>%
          hc_add_series(name="AvgMonthlyItemsPerPharmacy",data = locationpharma$Averagemonthlyitemsperpharmacy, type = "column",color="purple",
                        showInLegend = FALSE )
  })
  output$Pharmaciesgrowth<- renderGvis({
    Region<-diff13141$Region
    PreviousYear<-diff13141$CommunityPharmacies13
    CurrentYear<-diff13141$CommunityPharmacies2014
       Growth<-c(paste(0.23,upArrow),paste(0.22,upArrow),paste(0.29,upArrow),paste(0.27,upArrow),paste(0.15,upArrow))
    pharmadiff<- data.frame(Region,CurrentYear,PreviousYear,Growth)
    Pharmaciesgrowthchart<-gvisTable(pharmadiff,options=list(height="290px"))
    return(Pharmaciesgrowthchart)
    
  })
  output$PharmaandItemsdispenced<-renderPlotly({
   
    m <- list(
      l = 50,
      r = 50,
      b = 100,
      t = 100,
      pad = 3
    )
    y <- list(
      title = ""
      
    )
    x <- list(
      title = "Years"
      
    )
    
    plot_ly(pharmaitemsdispenced
            , x = ~pharmaitemsdispencedd$Year) %>%
      add_bars(y=~pharmaitemsdispencedd$`0-2000`, name = "0-2000", visible = T,color="pink") %>%
      add_bars(y=~pharmaitemsdispencedd$`2000-4000`, name = "2000-4000",visible=T,color="purple")%>%
      add_bars(y=~pharmaitemsdispencedd$`4000-6000`, name = "4000-6000", visible = T,color="skyblue") %>%
      add_bars(y=~pharmaitemsdispencedd$`6000-8000`, name = "6000-8000", visible = T,color="orange") %>%
      add_bars(y=~pharmaitemsdispencedd$`8000-10000`, name = "8000-10000", visible = T,color="grey") %>%
      add_bars(y=~pharmaitemsdispencedd$`10000+`, name = "10000+", visible = T) %>%
      
      layout( margin=m, xaxis=x,yaxis=y)
  })
  output$AppDec<-renderPlotly({
    
    colors <- c('rgb(211,94,96)', 'rgb(128,133,133)', 'rgb(144,103,167)', 'rgb(171,104,87)', 'rgb(114,147,203)')
    
    p <- plot_ly( marker = list(colors = colors,width=2)) %>%
      add_pie(data = decisions, labels = decisions$Applications, values = decisions$NewPremises,
              name = "NewPremises", domain = list(x = c(0, 0.4), y = c(0.4, 1))) %>%
      add_pie(data =decisions , labels = decisions$Applications, values = decisions$AdditionalPremises,
              name = "AdditionalPremises", domain = list(x = c(0.6, 1), y = c(0.4, 1))) %>%
      
      layout(title = "Decisions on applications relating to NHS", showlegend = T,
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    p
  })
  
  output$populationwisepharmacies<-renderPlotly({
    m <- list(
      l = 50,
      r = 50,
      b = 100,
      t = 100,
      pad = 3
    )
    y <- list(
      title = "Pharmacies"
      
    )
    x <- list(
      title = "Regions"
      
    )
    library(plotly)
    set.seed(100)
   
    plot_ly(locationpharma, x = ~England, y = ~Pharmaciesper100000population,type = "bar",color = ~England)%>%
      layout(margin=m,xaxis=x,yaxis=y,showlegend=F)
  })
  output$contractorsdiff<- renderGvis({
    revqty<- select(msalebrand16mar,Brand,Revenue,LastMonthSales,SalesGrowth)
    revqtychart<-gvisTable(revqty,options=list(height="300px"))
    return(revqtychart)
    
  })
  
 
  
  
  
  output$ypharmmacies<- renderGvis({
    Years<-dispenca1$Year
     Pharmacies<-dispenca1$Numberofcommunitypharmacies
    pharma1<-data.frame(cbind(Years,Pharmacies))
    ypharmmacieschart<-gvisColumnChart(pharma1,xvar = "Years",yvar = "Pharmacies",options =list(seriesType="bars",colors="['66CCFF']",height="290px",width="550px"))
    return(ypharmmacieschart)
  })
  
 
  output$locationwisepharma <- renderHighchart({
    

    highchart() %>%
      
      hc_xAxis(categories =locationpharma$England) %>%
      hc_add_series(name="Pharmacies",data =locationpharma$Numberofcommunitypharmacies , type = "area",
                    fillColor = 'url(#custom-pattern)',
                    showInLegend = FALSE )%>%
      hc_add_theme(hc_theme_chalk())%>%
      hc_defs(patterns = list(
        list(id = 'custom-pattern',
             path = list(d = 'M 0 0 L 10 10 M 9 -1 L 11 1 M -1 9 L 1 11',
                         stroke = "white",
                         strokeWidth = 1
             )
        )
      )) 
    
                    
    

  })
  output$plotIris<- renderGvis({
   
    openclose<-openclose
    openclose<-na.omit(openclose)
    yilgeostate <- gvisBubbleChart(openclose,"England","CommunityPharmaciesOpening1314",options=list(height="300px",region="England",displayMode="regions",resolution="provinces",height="400px",colors="['#5B2C6F']"))
    return(yilgeostate)
    
  })
  output$Mitemsperpharm<-renderHighchart({
   
    highchart() %>%
    hc_chart(type = "scatter") %>%
    hc_yAxis(
      title = list(text = "Dispenced Items")

    ) %>%
      
    hc_add_theme(hc_theme_sandsignika())%>%
    hc_xAxis(categories = locationpharma$England) %>%
    hc_add_series(name = "Cities", data = locationpharma$Prescriptionitemsdispensedpermonth000s) %>%
    

     hc_chart(type = "column",
              options3d = list(enabled = TRUE, beta = 15, alpha = 15))

  
  })
  
  output$Ycontractors<-renderPlotly({
    m <- list(
      l = 50,
      r = 50,
      b = 80,
      t = 100,
      pad = 3
    )
    y <- list(
      title = "Contractors"
      
    )
    x <- list(
      title = "Region Names"
      
    )
    
    plot_ly(Esplsplspc
            , x = ~Esplsplspc$England) %>%
      add_bars(y=~Esplsplspc$ESPLPScontractors, name = "ESPLSPContractors", visible = T,marker = list(color = 'rgb(49,130,189)')) %>%
      add_bars(y=~Esplsplspc$otherLPcontractors, name = "OtherLSPContractors",visible=T, marker = list(color = 'rgb(8,48,107)'))%>%
      
      layout( margin=m, xaxis=x,yaxis=y,showlegend=F)
   
  })
  
  output$lcontractors<-renderPlotly({
    m <- list(
      l = 50,
      r = 50,
      b = 80,
      t = 100,
      pad = 3
    )
    y <- list(
      title = "Contractors"
      
    )
    x <- list(
      title = "Region Names"
      
    )
    
    plot_ly(lcontracto2
            , x = ~lcontracto2$England) %>%
      add_lines(y=~lcontracto2$IndependentContractors14, name = "IndependentContractors", visible = T) %>%
      add_lines(y=~lcontracto2$MultipleContractors14, name = "MultipleContractors",visible=T)%>%
    
      layout( margin=m, xaxis=x,yaxis=y,showlegend=F)

  })
  output$Esplsp <- renderHighchart({
    Year<-prescridata$Year
    PrescriptionItems<-prescridata$Prescriptionitemsdispensed..millions.
    df<-data.frame(PrescriptionItems,Year)
       highchart() %>%
         hc_yAxis(
           title = list(text = "Pharmacies")
           
         ) %>%
      hc_add_theme(hc_theme_darkunica())%>%
      hc_xAxis(categories=df$Year,title=list(text = "Years")) %>%
      hc_add_series(name="Items",data =df$PrescriptionItems , 
                    showInLegend = FALSE ,color="skyblue",title=
                      "Prescription Data")
  })
  
  output$EspLSpLSP <- renderPlotly({
    cites<-as.list(Esplsplspc$England)
    Espcontra<-as.list(Esplsplspc$ESPLPScontractors)
    otercontru<-as.list(Esplsplspc$otherLPcontractors)
    m <- list(
      l = 50,
      r = 50,
      b = 90,
      t = 100,
      pad = 3
    )
    y <- list(
      title = "ESPLSP Contractors"
      
    )
    x <- list(
      title = "Regions"
      
    )
    
    
    plot_ly(Esplsplspc, x = ~cites) %>%
      add_polygons(y=~Esplsplspc$otherLPcontractors, name = "OterLspcontractors") %>%
      add_bars(y=~Esplsplspc$ESPLPScontractors, name = "EspContractors", visible = T)  %>%
      add_paths(y=~Esplsplspc$otherLPcontractors, name = "OterLspcontractors", visible = T) %>%
      layout( margin = m,xaxis=x,yaxis=y,title="
              ")
    
    
  })
  
  
  output$Mur <- renderPlotly({
    city<- Murser$England
    communityphar<-Murser$Number.of.community.pharmacies.2013.14
    Murservices<- Murser$PercentageofPharmaciesprovidingMURservices
    m <- list(
      l = 50,
      r = 50,
      b = 90,
      t = 100,
      pad = 3
    )
    y <- list(
      title = " MURServices"
      
    )
    x <- list(
      title = "England"
      
    )
    
    
    plot_ly(Murser, x = ~Murser$England) %>%
      
      
      add_trace(y=~Murser$Number.of.community.pharmacies.2013.14, name = "Mur Services", visible = T)%>%
      layout( margin = m,xaxis=x,yaxis=y,title="MURServices")
    
    
    
  })
 
  output$pharmaranges1<-renderPlotly({
    
    m <- list(
      l = 50,
      r = 50,
      b = 100,
      t = 100,
      pad = 4
    )
    y <- list(
      title = ""

    )
    x <- list(
      title = "Years"

    )
    plot_ly(Ynoofpham,x = ~Ynoofpham$Year) %>%
      add_bars(y=~Ynoofpham$`0-2000`, name = "0-2000", visible = T) %>%
      add_bars(y=~Ynoofpham$`2000-4000`, name = "2000-4000",visible=T) %>%
      add_bars(y=~Ynoofpham$`4000-6000`, name = "4000-6000", visible = T) %>%
      add_bars(y=~Ynoofpham$`6000-8000`, name = "6000-8000", visible = T) %>%
      add_bars(y=~Ynoofpham$`8000-10000`, name = "8000-10000", visible = T) %>%
      add_bars(y=~Ynoofpham$`10000+`, name = "10000+", visible = T)%>%
      layout(margin = m,title="Year Wise Pharmacies Range",xaxis=x,yaxis=y, height = "260px")


      
  })



output$indvsmul<- renderHighchart({
 
 ind<-as.integer(indvsmul3$independentcontructors)
    
    mul<-as.integer(indvsmul3$multiplecontructors)
    names<-c("Indpendentcontructors","Multiplecontructors")
     names=as.data.frame(names)
     cont<-data.frame(rbind(ind,mul))
     contdata<-cbind(names,cont)
     
    
    
     highchart(width = 50, height = 50) %>%
       hc_title(text = "Independent Vs Multiple Contractors") %>%
       

       hc_chart(type = "pie", options3d = list(enabled = TRUE, alpha = 70, beta = 0,color = 'rgb(255, 110, 176)')) %>%
       hc_plotOptions(pie = list(depth = 70)) %>%
       hc_add_series_labels_values(contdata$names,contdata$rbind.ind..mul.) %>%
       hc_add_theme(hc_theme(
         chart = list(
          backgroundColor = NULL

         )
       ))
})
output$Nmsser<-renderPlotly({
  
  plot_ly(NMSservice, x = ~NMSservice$Area) %>%
    add_histogram2dcontour(y=~NMSservice$Total.NMSs.1, name = "NMS Services", visible = T)
})


filterIris2 <- reactive({
  filter(AUR, year == AUR$year)
})
output$Aur<-renderggiraph({
  
  
  gg <- ggplot(filterIris2(), aes(x = year, y = TotalAurs),color="yellow")
  gg <- gg + geom_bar_interactive(stat = "identity",color=c("green","red","yellow","blue","purple"),
                                  aes(tooltip = filterIris2()$TotalAurs), size = 0.5)
  
  ggiraph(code = print(gg),height_svg = 3.3)
})


filterIris1 <- reactive({
  filter(Nms, Year == Nms$Year)
})


output$Nms<-renderggiraph({
  
  gg <- ggplot(filterIris1(), aes(x = Year, y = Total.NMS),color="yellow")
  gg <- gg + geom_bar_interactive(stat = "identity",color=c("green","red","yellow"),
                                  aes(tooltip = filterIris1()$Total.NMS), size = 0.5)
  
  ggiraph(code = print(gg),height_svg = 3.3)
})


output$totalser<-renderPlotly({

  m <- list(
    l = 50,
    r = 50,
    b = 100,
    t = 100,
    pad = 3
  )
  y <- list(
    title = ""
    
  )
  x <- list(
    title = "Years"
    
  )
  
  plot_ly(Totalser
          , x = ~Totalser$X) %>%
    add_bars(y=~Esplsplspc$ESPLPScontractors, name = "0-2000", visible = T,color="skyblue") %>%
    add_bars(y=~Esplsplspc$otherLPcontractors, name = "2000-4000",visible=T,color="orange")%>%
       layout( margin=m, xaxis=x,yaxis=y,height="260px")
})
output$AppDec<-renderPlotly({
  
  colors <- c('rgb(211,94,96)', 'rgb(128,133,133)', 'rgb(144,103,167)', 'rgb(171,104,87)', 'rgb(114,147,203)')
  
  p <- plot_ly( marker = list(colors = colors,width=1)) %>%
    add_pie(data = decisions, labels = decisions$Applications, values = decisions$NewPremises,
            name = "NewPremises", domain = list(x = c(0, 0.4), y = c(0.1, 1.5))) %>%
    add_pie(data =decisions , labels = decisions$Applications, values = decisions$AdditionalPremises,
            name = "AdditionalPremises", domain = list(x = c(0.6, 1), y = c(0.1, 1.5))) %>%
    
    layout(title = "Decisions on applications relating to NHS", showlegend = T,
           xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  p
})
output$Appstatus<-renderPlotly({
 
  plot_ly(statuss, labels = statuss$Decisions, values = statuss$Controlledarea, type = "pie",name = "Application Status", showlegend = T) %>%
    layout(title = "Decisions on application on appeal",xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  
})
output$pharmaciesprov<-renderHighchart({
  highchart() %>%
    hc_yAxis(title=list(text = "Pharmacies"))%>%
    hc_add_theme(hc_theme_ffx())%>%
    hc_xAxis(categories=PharmprovidingMurservices$Year,title=list(text = "Years")) %>%
    hc_add_series(name="Pharmacies",data = PharmprovidingMurservices$PharmaciesprovidingMURservices, 
                  showInLegend = FALSE )
})
output$exemptpharmacies<-renderPlotly({
  p <- plot_ly(yexempcategoryy, x = ~Year, y = ~Numberofcommunitypharmacies,  type = 'scatter', mode = 'markers', size = ~Year, color = ~Year, colors = 'Paired',
               marker = list(opacity = 0.5, sizemode = 'diameter')) %>%
    layout(title = 'Exempt Category wise Items',
           xaxis = list(showgrid = FALSE,title="Years"),
           yaxis = list(showgrid = FALSE,title="Items"),
           showlegend = FALSE)
  p
})


output$lexemptplot<-renderPlotly({
                 
  m <- list(
    l = 50,
    r = 50,
    b = 100,
    t = 100,
    pad = 3
  )
  y <- list(
    title = "Pharmacies"
    
  )
  x <- list(
    title = "Regions"
    
  )
  library(plotly)
  set.seed(100)
  plot_ly(lexemptcategorydataa,x=~Region,y=~Numberofcommunitypharmacies,type = "bar", marker = list(color = 'rgba(50, 171, 96, 0.7)',
                                                                                                   line = list(color = 'rgba(50, 171, 96, 1.0)', width = 1)))%>%
    layout(margin=m,xaxis=x,yaxis=y,showlegend=F)
  
})

output$YSAC<-renderPlotly({
  p<-plot_ly(YSACs,x = ~Year,y = ~CommunitypharmacyprovidingSAC, type = "bar",
            marker = list(color = brewer.pal(6, "Paired")))%>%
    layout(title="Community Pharmacies Providing SAC Service", xaxis = list(title = "Year"), yaxis = list(title = "Pharmacies"))
})
output$Difference<- renderGvis({
  Region<-LSACdata$Regions
  PreviousYear<-LSACdata$AverageSACpercommunitypharmacy13
  CurrentYear<-LSACdata$AverageSACpercommunitypharmacy14
  #Growth<-paste(diff1314$Pharmagrowth,upArrow)
  Growth<-c(paste(4.32,upArrow),paste(3.68,upArrow),paste(-4.57,downArrow),paste(9.05,upArrow))
  lSACdiff<- data.frame(Region,CurrentYear,PreviousYear,Growth)
  SACGrowthchart<-gvisTable(lSACdiff,options=list(height="300px"))
  return(SACGrowthchart)
  
})
output$ltotalexempt<-renderHighchart({
  highchart() %>%
    #hc_add_theme(hc_theme_ffx())%>%
    hc_yAxis(title=list(text = "Pharmacies"))%>%
    hc_xAxis(categories=lexemptcategorydataa$Region,title=list(text = "Regions")) %>%
    hc_add_series(name="Pharmacies",data = lexemptcategorydataa$hr.100pharmacies, 
                  showInLegend = FALSE )
})
output$Nmsserervice<-renderHighchart({
  
  highchart() %>%
    hc_chart(type = "area") %>%
    hc_xAxis(categories=NMSservice$Area,title = list(text = "Region Names")) %>%
    hc_yAxis(
      title = list(text = "NMS Services")
    ) %>% 
    hc_add_theme(hc_theme_sandsignika())%>%
    hc_add_series(name = "England", data =NMSservice$AverageNMSperpharmacy)
  
})

output$Aurser<-renderHighchart({
  
  highchart() %>%
    hc_yAxis(
      title = list(text = "Pharmacies")
    ) %>%
    hc_xAxis(categories = AurService$Regions,title = list(text = "Regions")) %>%
    hc_add_series(name="AUR SERVICEs",data = AurService$Number.of.community.pharmacy.and.appliance.contractors, type = "column",color="blue",
                  showInLegend = FALSE )
  # highchart() %>%
  #   hc_xAxis(categories = AurService$Regions) %>%
  #   hc_add_series(name="AUR SERVICEs",data = AurService$AurServices, type = "column",color="blue",
  #                 showInLegend = FALSE )
})
output$Esplspcontractors<- renderHighchart({
  ind<-as.integer(Esplspercentagess$esplspcontractors)
  
  mul<-as.integer(Esplspercentagess$lspcontractors)
  
  colors<- c('#2f7ed8', '#0d233a', '#8bbc21', '#910000', 
           '#1aadce', '#492970', '#f28f43', '#77a1e5', '#c42525', '#a6c96a')
  
  
  names<-c("EspLspcontractors","Othercontractors")
  names=as.data.frame(names)
  cont<-data.frame(rbind(ind,mul))
  contdata<-cbind(names,cont)
  
  
  
  highchart(width = 50, height = 50) %>%
    hc_title(text = "ESPLSP Vs OtherLSP Contractors") %>%

    hc_chart(type = "pie", options3d = list(enabled = TRUE, alpha = 70, beta = 0,color =  colors)) %>%
    hc_plotOptions(pie = list(depth = 70)) %>%
    hc_add_series_labels_values(contdata$names,contdata$rbind.ind..mul.) %>%
    hc_add_theme(hc_theme(
      chart = list(
        backgroundColor = NULL

      )
    ))
 
})

}
