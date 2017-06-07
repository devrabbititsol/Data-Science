library(leaflet)
library(shiny)
library(shinydashboard)
library(plotrix)
library(plotly)
library(metricsgraphics)
library(googleVis)
library(highcharter)
library(gender)
#library(genderizeR)
library(plotrix)

  

server <- function(input, output, session) {
  
  output$followerscount <- renderValueBox({
    valueBox(
      paste(lastweeklikescount), "Last Week Likes",icon = icon("glyphicon glyphicon-thumbs-up",lib="glyphicon"),
      color = "red")
  })
  
  output$favouritescount <- renderValueBox({
    valueBox(
      paste(Favouritescount), "Followers Count of Ebay",icon = icon("glyphicon glyphicon-thumbs-up",lib="glyphicon"),
      color = "green"
      
    )
  })
  
  output$retweetcount <- renderValueBox({
    
    valueBox(
      paste(RetweetcountWeek), "Last Week Retweets",icon = icon("glyphicon glyphicon-thumbs-up",lib="glyphicon"),
      color = "blue")
  })
  
  
  
  output$Postsperweek <- renderValueBox({
    valueBox(
      paste(posts1perweek), "Posts per week",icon = icon("glyphicon glyphicon-list-alt",lib="glyphicon"),
      color = "green")
  })
  
  output$Likesperweek <- renderValueBox({
    valueBox(
      paste(likesperweek), "Likes per week",icon = icon("glyphicon glyphicon-thumbs-up",lib="glyphicon"),
      color = "red")
  })
  
  output$Commentsperweek <- renderValueBox({
    valueBox(
      paste(commentsperweek), "Comments per week",icon = icon("glyphicon glyphicon-comment",lib="glyphicon"),
      color = "teal")
  })
  
  output$Sharesperweek <- renderValueBox({
    valueBox(
      paste(sharesperweek), "Shares per week",icon = icon("glyphicon glyphicon-send",lib="glyphicon"),
      color = "yellow")
  })
  
  observeEvent(input$Map_marker_click, { # update the map markers and view on map clicks
    p <- input$Map_marker_click
    proxy <- leafletProxy("mymap")
    if(p$id=="Selected"){
      proxy %>% removeMarker(layerId="Selected")
    } 
    else {
      proxy %>% setView(lng=p$lng, lat=p$lat, input$Map_zoom) %>% acm_defaults(p$lng, p$lat)
    }
  })
  
  observeEvent(input$Map_marker_click, { # update the location selectInput on map clicks
    p <- input$Map_marker_click
    if(!is.null(p$id)){
      if(is.null(input$location) || input$location!=p$id) updateSelectInput(session, "location", selected=p$id)
    }
  })
  
    output$mymap <- renderLeaflet({
      
      
      
     longlat<-longlat
      
   
     leaflet(data=longlat) %>%
       addTiles(urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
                                       
                                       attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>') %>%
      
        addMarkers(data =longlat, lng = longlat$lon, lat = longlat$lat, popup = longlat$cities) %>%
        
       setView(lng = -93.85, lat = 37.45, zoom = 4) %>%
       addProviderTiles(providers$Stamen.TonerLite,
                        options = providerTileOptions(noWrap = TRUE))
      
    })
    
   
  
  output$mymap1 <- renderLeaflet({
    
   
    leaflet() %>%addTiles(urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
                                      
                                      attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>') %>%
  addMarkers(data = longlat1, lat = ~longlat1$lat, lng = ~longlat1$lon,popup = paste0(longlat1$cities)) %>%
      setView(lng = -93.85, lat = 37.45, zoom = 3) %>%
     addProviderTiles(providers$Stamen.TonerLite,
                      options = providerTileOptions(noWrap = TRUE))


  })
  
   output$hour<-renderHighchart({
    
      highchart() %>%
      hc_add_series_boxplot(x = count_hour$Freq, by = count_hour$Time, name = "Tweets per Hour")
 })

   output$my6map<- renderHighchart({

    highchart() %>%
      hc_chart(type = "line") %>%
      hc_xAxis(categories = Post_count_hour$Time) %>%
      hc_add_series(name = "Number of Posts", data = Post_count_hour$Freq,color = "#B71C1C") 
 })
   
   output$mymap6<- renderHighchart({
     
     highchart() %>%
       hc_chart(type = "line") %>%
       hc_xAxis(categories = count_df$Time) %>%
       hc_add_series(name = "Tweets per Minute", data = count_df$Freq,color = "#B71C1C") 
   })
   
   output$my7map<- renderPlotly({
     
     plot_ly(polarity_per, labels = ~polarity_per$polarity, values = ~polarity_per$percentage, type = 'pie') %>%
       layout(title = "Twitter sentiment proportion for ebay",
              xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
              yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
     
      
     
   })
   

output$plotwc<- renderPlot({
  
  wordcloud(d$word,d$freq,scale=c(3,0.5),max.words=100,
            random.order=FALSE,rot.per=0.30, use.r.layout=TRUE, colors=brewer.pal(8, "Dark2"))
 
  
  
})

output$plotwc3<-  renderHighchart({
  

 # plot_ly(country_count_likes1, x = ~Country, y = ~Likes, type = 'bar', name = 'Primary Product', marker = list(color = 'rgb(49,130,189)')) %>%
    #add_trace(y = ~country_count_likes$count, name = 'Secondary Product', marker = list(color = 'rgb(204,204,204)')) %>%
   # layout(xaxis = list(title = "", tickangle = -45),
          # yaxis = list(title = ""),
         #  margin = list(b = 200),
         #  barmode = 'group')
  highchart() %>%
  
    hc_add_series_labels_values(country_count_likes1$Country, country_count_likes1$Likes, colors = substr(terrain.colors(country_likes_color), 10 , 7),
                              type = "pie", name = "Bar", colorByPoint = TRUE, center = c('50%', '50%'),
                              size = 300, dataLabels = list(enabled = TRUE)) 
  
  })
  
  

output$Revcurr<- renderGvis({
revqty<- select(Recenttop10frnds,name,location,Followingcount,Followerscount,Likescount)
  revqtychart<-gvisTable(revqty)
  return(revqtychart)

})


output$plotwc10<- renderPlotly({

p<-ggplot(twf, aes(factor(!is.na(replyToSID)))) +
  geom_bar(fill = "midnightblue") +
  theme(legend.position="none", axis.title.x = element_blank()) +
  ylab("Number of tweets") +
  ggtitle("Replied Tweets") +
  scale_x_discrete(labels=c("Not in reply", "Replied tweets"))

p
})


output$plotwc1<- renderPlot({
  
  wordcloud(d1$word,d1$freq,scale=c(3,0.5),max.words=100,
            random.order=FALSE,rot.per=0.30, use.r.layout=TRUE, colors=brewer.pal(8, "Dark2"))
  
  
  
})
output$plot1 <- renderHighchart({
  
  highchart() %>% 
    
    
    hc_add_series_labels_values(sentiment$Emotion, sentiment$value, name = "Pie", colorByPoint = TRUE, type = "column") %>% 
    
    hc_add_series_labels_values(sentiment$Emotion, sentiment$value, colors = substr(terrain.colors(9), 0 , 7),
                                type = "pie", name = "Bar", colorByPoint = TRUE, center = c('35%', '10%'),
                                size = 100, dataLabels = list(enabled = FALSE)) %>% 
    
    
    hc_yAxis(title = list(text = "Number  of Emotions"),labels = list(format = "{value}"), max=75) %>% 
    hc_xAxis(title=list(text="Emotion"),categories = sentiment$Emotion) %>% 
    hc_legend(enabled = FALSE) %>% 
    hc_tooltip(pointFormat = "{point.y}")
  
  
  
  
  
  
})


output$plot2<- renderHighchart({
 
  highchart() %>% 
    
    
  hc_add_series_labels_values(posneg$Emotion, posneg$value, name = "Pie", colorByPoint = TRUE, type = "column") %>% 
    
    hc_yAxis(title = list(text = "Number  of Emotions"),labels = list(format = "{value}"), max=75) %>% 
    hc_xAxis(title=list(text="Emotion"),categories = posneg$Emotion) %>% 
    hc_legend(enabled = FALSE) %>% 
    hc_tooltip(pointFormat = "{point.y}")
})

}










