library(tm)
library(wordcloud)
library(syuzhet) 
library(ggplot2)
library(dplyr )
library(NLP)
library(twitteR)
library(ggmap)
library(plyr)
library(stringr)
library(RColorBrewer)
library(Rfacebook)
library(stringr)
library(reshape2)
library(leaflet)
library(R2WinBUGS)
library(gender)
library(qdap)
library(data.table)
library(scales)
library(lubridate)
library(ROAuth)
library(httr)
library(lubridate)
library(chron)
library(devtools)
# install_github("pablobarbera/NYU-AD-160J/NYU160J")
library(NYU160J)
library(xts)
library(stringi)
library(SciencesPo)
library(RNeo4j)
library(xts)
library(DT)




api_key<-"KyYm719eKWCz15KBkJVA2G82g"
api_secret<-"LE8EDB5qByktXujkyAj5dlI5R8u7fAE7t1wE1Yogmg0gzkj4Wz"
access_token<-"2380143139-QB6qWurXS1bGEqFNbfASCOULIUDymBPsIFYaw2m"
access_token_secret<-"obg5agkjQRUofLtuaFz1F71sDbSFR5sQOyT8lquBal88R"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)
tweet <- searchTwitter("eBay", n=1000,lang="en")  
tweets.text <- lapply(tweet, function(t)t$getText())

################ remove the Twitter handlers
nohandles <- str_replace_all(tweets.text, "@\\w+", "")

#############clean up the remaining text
wordCorpus <- Corpus(VectorSource(nohandles))
wordCorpus <- tm_map(wordCorpus, removePunctuation)
wordCorpus <- tm_map(wordCorpus, content_transformer(tolower))
wordCorpus <- tm_map(wordCorpus, removeWords, stopwords("english"))
wordCorpus <- tm_map(wordCorpus, removeWords, c("like", "video"))
wordCorpus <- tm_map(wordCorpus, stripWhitespace)
wordCorpus <- tm_map(wordCorpus, stemDocument)
dtm <- TermDocumentMatrix(wordCorpus)

m <- as.matrix(dtm)

v <- sort(rowSums(m),decreasing=TRUE)

d <- data.frame(word = names(v),freq=v)

############################let us move to sentiment analysis
mysentiment<-get_nrc_sentiment((nohandles))

# Get the sentiment score for each emotion
mysentiment.positive =sum(mysentiment$positive)
mysentiment.anger =sum(mysentiment$anger)
mysentiment.anticipation =sum(mysentiment$anticipation)
mysentiment.disgust =sum(mysentiment$disgust)
mysentiment.fear =sum(mysentiment$fear)
mysentiment.joy =sum(mysentiment$joy)
mysentiment.sadness =sum(mysentiment$sadness)
mysentiment.surprise =sum(mysentiment$surprise)
mysentiment.trust =sum(mysentiment$trust)
mysentiment.negative =sum(mysentiment$negative)

sentiment <- cbind.data.frame(mysentiment.positive,mysentiment.anger,mysentiment.anticipation,mysentiment.disgust,
                              mysentiment.fear,mysentiment.joy,mysentiment.sadness,mysentiment.surprise,
                              mysentiment.trust,mysentiment.negative)



sentiment<-data.frame(rbind(mysentiment.positive,mysentiment.anger,mysentiment.anticipation,mysentiment.disgust,mysentiment.fear,mysentiment.joy,mysentiment.sadness,mysentiment.trust,mysentiment.negative))

sentiname<-c("Positive","Anger","Anticipation","Disgust","Fear","joy","Sadness","Trust","Negative")

sentiment<-cbind.data.frame(sentiname,sentiment)

colnames(sentiment)<-c("Emotion","value")


###########DB Creation#########

twf<-twListToDF(tweet)

######getting the locations 
users <- lookupUsers(twf$screenName)

users_df <- twListToDF(users)

cities <-users_df$location
cities[cities == " "] <- "NULL"
cities<-na.omit(cities)
longlat<-geocode(cities)
longlat<-cbind(longlat,cities)
longlat<-na.omit(longlat)

# function score.sentiment
score.sentiment = function(sentences, pos.words, neg.words, .progress='none')
{
  
  scores = laply(sentences,
                 function(sentence, pos.words, neg.words)
                 {
                   # remove punctuation
                   sentence = gsub("[[:punct:]]", "", sentence)
                   # remove control characters
                   sentence = gsub("[[:cntrl:]]", "", sentence)
                   # remove digits?
                   sentence = gsub('\\d+', '', sentence)
                   
                   # define error handling function when trying tolower
                   tryTolower = function(x)
                   {
                     # create missing value
                     y = NA
                     # tryCatch error
                     try_error = tryCatch(tolower(x), error=function(e) e)
                     # if not an error
                     if (!inherits(try_error, "error"))
                       y = tolower(x)
                     # result
                     return(y)
                   }
                   # use tryTolower with sapply
                   sentence = sapply(sentence, tryTolower)
                   
                   # split sentence into words with str_split (stringr package)
                   word.list = str_split(sentence, "\\s+")
                   words = unlist(word.list)
                   
                   # compare words to the dictionaries of positive & negative terms
                   pos.matches = match(words, pos.words)
                   neg.matches = match(words, neg.words)
                   
                   # get the position of the matched term or NA
                   # we just want a TRUE/FALSE
                   pos.matches = !is.na(pos.matches)
                   neg.matches = !is.na(neg.matches)
                   
                   # final score
                   score = sum(pos.matches) - sum(neg.matches)
                   return(score)
                 }, pos.words, neg.words, .progress=.progress )
  
  # data frame with scores for each sentence
  scores.df = data.frame(text=sentences,score=scores)
  return(scores.df)
}

##############################Top Tweet
  
  dd<-max(twf$retweetCount)
  
  dd<-data.frame(dd)
  setnames(dd,old='dd',new='Retweetcount')
  dd1<-which(twf$retweetCount == max(twf$retweetCount))
  toptweet<-twf$text[which(twf$retweetCount == max(twf$retweetCount))]
  toptweet<-data.frame(toptweet)
  
  #####################Getting the positive and negative words
  
  pos = readLines("positive_words.txt")
  neg = readLines("negative_words.txt")
  tag_txt = sapply(tweet, function(t)t$getText())
  #calculate Sentiment score
  
  scores = score.sentiment(tag_txt, pos, neg, .progress='text')
  pos_sen<-scores[scores$score>0,]
  
  neg_sen<-scores[scores$score<0,]
  neu_sen<-scores[scores$score==0,]
  
  #Count positive,negative,netural sentences
  positive_count<-nrow(pos_sen)
  negative_count<-nrow(neg_sen)
  neutral_count<-nrow(neu_sen)
  
  
  #Perecentages positive,
  Positive_per<-(positive_count*100)/nrow(twf)
  negative_per<-(negative_count*100)/nrow(twf)
  neutral_per<- (neutral_count*100)/nrow(twf)
  
  polarity_count<-rbind(positive_count,negative_count,neutral_count)
  cnt<-as.data.frame(polarity_count)
  cnt1<-data.frame(sum(cnt$V1))
  
  polarity<-rbind("positive_count","negative_count","neutral_count")
  
  cnt<-cbind(polarity,cnt)
  setnames(cnt, old =c('polarity','V1'), new =c('Responces','Total_Count'))
 
   polarity_per<-rbind(Positive_per,negative_per,neutral_per)

    polarity_per <- cbind(newColName = rownames(polarity_per),polarity_per)
  
  rownames(polarity_per) <- 1:nrow(polarity_per)
  
 
 colnames(polarity_per)<-c("polarity","percentage")

 polarity_per <-as.data.frame(as.matrix(polarity_per))
  polarity_per$percentage<-as.numeric(as.character(polarity_per$percentage))

  ##############################Followers and Friends of Ebay
  user1<-getUser('ebay')
  Followerscount<-user1$getFollowersCount()
  
  Recenttop10frnds<-user1$getFriends(n=10)
  Recenttop10frnds<-twListToDF(Recenttop10frnds)
  Favouritescount<-user1$getFavouritesCount()
  Retweetscount<-sum(twf$retweetCount)
  colnames(Recenttop10frnds)<-c("name","location","Followingcount","Followerscount","Likescount")
  Recenttop10frnds<-setDT(Recenttop10frnds)
  
  ########################WordCloud Creation for Twitter
  
  tweets.text <- lapply(tweet, function(t)t$getText())
    
  # remove retweet entities
  some_txt = gsub("(RT|via)((?:\\b\\W*@\\w+)+)","", tweets.text )
  
  # remove at people
  some_txt = gsub("@\\w+", "", some_txt)
  
  # remove punctuation
  some_txt = gsub("[[:punct:]]", "", some_txt)
  
  # remove numbers
  some_txt = gsub("[[:digit:]]", "", some_txt)
  
  # remove html links
  some_txt = gsub("http\\w+", "", some_txt)
  
  # remove unnecessary spaces
  some_txt = gsub("[ \t]{2,}", "", some_txt)
  some_txt = gsub("^\\s+|\\s+$", "", some_txt)
  tweets_df <- data.frame(some_txt)
  mycorpus <- Corpus(VectorSource(tweets_df$some_txt))
  
  pal <- brewer.pal(9,"YlGnBu")
  pal <- pal[-(1:4)]
  set.seed(123)
  wordcloud::wordcloud(words = mycorpus,scale=c(5,0.1),max.words=100,
                       random.order=FALSE,rot.per=0.35, use.r.layout=FALSE, colors=pal)
  
    ############ Aggregate of Tweets Per Second on Twitter
  tweets.df<-twf$created
  tweets.df<-as.data.frame(cbind(twf$created,1),StringsAsFactors=FALSE)
  colnames(tweets.df)<-c("Time","Frequency")
  tweets.df$Time <- as.POSIXct(tweets.df$Time,origin=Sys.Date())
  by.sec <- cut.POSIXt(tweets.df$Time,"min")
  tweets.sec <- split(tweets.df, by.sec)
  s<-sapply(tweets.sec,function(x)sum(as.integer(x$Frequency)))
  #View(table(by.sec))
  count_df<-as.data.frame(table(by.sec))
  count_df$by.sec<-sapply(count_df$by.sec,substring,12,19)
  
  count_df$Time <- format(count_df$by.sec, format = "%H:%M:%S")
  
  count_df$Time <- as.POSIXct(count_df$Time, format = "%H:%M:%S",size=4)
  
  count_df$Time<-as.character(count_df$Time)
  
  ################### tweets per hour
  tweets<-userTimeline("ebay",n=1000)
  tweets.df<-twListToDF(tweets)
  
  ########## Tweet Per sec")
  tweets.df$format<- as.POSIXct(tweets.df$created,format ="%d-%m-%Y%H:%M:%S", tz="") 
  tweets.df$Uhrzeit <- sub(".* ", "", tweets.df$format)
  tweets.df1<-as.data.frame(cbind(tweets.df$Uhrzeit,1),stringsAsFactors=FALSE)
  colnames(tweets.df1)<-c("time","freq")
  x <- as.POSIXct(tweets.df1$time,"%H:%M:%S",tz="")
  #tweets.df1$time) <- strptime(x=tweets.df1$time,format="%H:%M:%S",tz="")
  by.hour <- cut.POSIXt(x,"hour")
  
  tweets.hour <- split(tweets.df1, by.hour)
  count_hour<-as.data.frame((sapply(tweets.hour,function(x)sum(as.integer(x$freq)))))
  count_hour <- cbind(newColName = rownames(count_hour), count_hour)
  rownames(count_hour) <- 1:nrow(count_hour)
  colnames(count_hour)<-c("Time","Freq")
  
  Hours<-data.frame(
    time=format(as.POSIXct(count_hour$Time, format="%Y-%m-%d %H:%M"), format="%H:%M"))
  #Hours<-as.numeric(as.POSIXct(count_hour$time))
  count_hour<-data.frame(cbind(count_hour,Hours))
  TimeinHours<-data.frame(count_hour$Time)
  Frequency<-data.frame(count_hour$Freq)
  
  ts=xts(rep(1,times=nrow(tweets.df)),tweets.df$created)
  
  
  
  #######Aggrigate of Tweets per daily#########
  ts.sum_daily=apply.daily(ts,sum) 
  
  sum.daily=data.frame(date=index(ts.sum_daily), coredata(ts.sum_daily))
  
  colnames(sum.daily)=c('Daily','sum')
  
  ggplot(sum.daily)+geom_line(aes(x=Daily,y=sum))
  
  #######Aggrigate of Tweets per weekly#########
  ts.sum_weekly=apply.weekly(ts,sum) 
  sum.weekly=data.frame(date=index(ts.sum_weekly), coredata(ts.sum_weekly))
  colnames(sum.weekly)=c('weekly','sum')
  ggplot(sum.weekly)+geom_line(aes(x=weekly,y=sum))
  
  #########################Aggrigate of Tweets per monthly####
  ts.sum_monthly=apply.monthly(ts,sum) 
  sum.monthly=data.frame(date=index(ts.sum_monthly), coredata(ts.sum_monthly))
  colnames(sum.monthly)=c('monthly','sum')
  
  ######Aggrigate of Tweets per Quarterly###############
  
  ts.sum_quarterly=apply.quarterly(ts,sum) 
  
  sum.quarterly=data.frame(date=index(ts.sum_quarterly), coredata(ts.sum_quarterly))
  
  colnames(sum.quarterly)=c('quarterly','sum')
  
  ggplot(sum.quarterly)+geom_line(aes(x=quarterly,y=sum))
  
  ########################## Face Book Analysis
  
  token <-"EAACEdEose0cBABPnuLEgFUFsE0QZABXxxoj6QCAUR97dsCBMn6RtrPOKC2P5mn8B6En6RiThw8ZAYs52Lv6hcgwyrWyNqxGga5TZB0eq9GRQhDCM2JvZC6u33OIE1E9XoYhgaYiBcrePfmvcgYGV4fjtGEljuOzG0ZB5PpmesZAs3VYBBNq3SlyDR87fYhZBeEZD"
  
  fb_oauth <- fbOAuth(app_id="168337503648123", app_secret="60a2bfbf835a58ee80138d4266ad9798",extended_permissions = FALSE)
  # Request posts
  save(fb_oauth, file="fb_oauth")
  
  load("fb_oauth")
  
  pages <- searchPages("eBay",token, n=100)
  
  post<-data.frame(pages)
  
  # remove retweet entities
  
  some_txt = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", post$about)
  
  # remove at people
  
  some_txt = gsub("@\\w+", "", some_txt)
  
  # remove punctuation
  
  some_txt = gsub("[[:punct:]]", "", some_txt)
  
  # remove numbers
  
  some_txt = gsub("[[:digit:]]", "", some_txt)
  
  # remove html links
  
  some_txt = gsub("http\\w+", "", some_txt)
  
  # remove unnecessary spaces
  
  some_txt = gsub("[ \t]{2,}", "", some_txt)
  
  some_txt = gsub("^\\s+|\\s+$", "", some_txt)
  
  some_txt <- sapply(some_txt,function(row) iconv(row, "latin1", "ASCII", sub=""))
  
  tweets_df <- data.frame(some_txt)
  
  twe<-na.omit(tweets_df)
  
  mycorpus <- Corpus(VectorSource(tweets_df$some_txt))
  dtm1 <- TermDocumentMatrix(mycorpus)
  
  m1 <- as.matrix(dtm1)
  
  v1<- sort(rowSums(m1),decreasing=TRUE)
  
  d1 <- data.frame(word = names(v),freq=v)

############################### Gender Analysis

  require(Rfacebook)
  library(gender)
  library(genderizeR)
  page<- getPage("ebay", token, n = 200)
  
  post1<- getPost("185499393135_10156087605523136", token, n = 1000, likes = TRUE,comments = TRUE)
  library (plyr)
  df2<- ldply (post1, data.frame)
 
  gm<-df2$from_name
  gm1<-findGivenNames(gm)
  gm2<-data.frame(gm1)
  
 
  ml1<-subset(gm2, gender=="male")
  fe1<-subset(gm2, gender=="female")
  
  
  x1<-nrow(ml1)
  y1<-nrow(fe1)
  
  slices <- c(x1,y1)

#################### Number of Likes On ebay Monthly on Facebook

  formatFbDate <- function(datestring, format="datetime") {
    if (format=="datetime"){
      date <- as.POSIXct(datestring, format = "%Y-%m-%dT%H:%M:%S+0000", tz = "GMT")    
    }
    if (format=="date"){
      date <- as.Date(datestring, format = "%Y-%m-%dT%H:%M:%S+0000", tz = "GMT")   
    }
    return(date)
  }

  page$datetime = formatFbDate(page$created_time)
  results = aggregateMetric(page, metric="likes")
  results1<-results
  Months<-c("mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec","Jan","Feb","Mar","Apr","May")
  results1<-cbind(results1,Months)
  setnames(results1, old = 'x', new ='Total_Likes')
  
  ################### Creation of wordcloud 
  
  pal <- brewer.pal(9,"YlGnBu")
  pal <- pal[-(1:4)]
  set.seed(200)
  wordcloud::wordcloud(words = mycorpus,max.words=100,
                     random.order=FALSE,rot.per=0.35, use.r.layout=FALSE, colors=pal)

####################let us move to sentiment analysis
  mysentiment<-get_nrc_sentiment((some_txt))
  
  # Get the sentiment score for each emotion
  mysentiment.positive =sum(mysentiment$positive)
  mysentiment.anger =sum(mysentiment$anger)
  mysentiment.anticipation =sum(mysentiment$anticipation)
  mysentiment.disgust =sum(mysentiment$disgust)
  mysentiment.fear =sum(mysentiment$fear)
  mysentiment.joy =sum(mysentiment$joy)
  mysentiment.sadness =sum(mysentiment$sadness)
  mysentiment.surprise =sum(mysentiment$surprise)
  mysentiment.trust =sum(mysentiment$trust)
  mysentiment.negative =sum(mysentiment$negative)
  
  posneg<-cbind.data.frame(mysentiment.positive,mysentiment.anger,mysentiment.anticipation,mysentiment.disgust,
                          mysentiment.fear,mysentiment.joy,mysentiment.sadness,mysentiment.trust,mysentiment.negative)

  posneg<-data.frame(rbind(mysentiment.positive,mysentiment.anger,mysentiment.anticipation,mysentiment.disgust,mysentiment.fear,mysentiment.joy,mysentiment.sadness,mysentiment.trust,mysentiment.negative))
  
  posname<-c("Positive","Anger","Anticipation","Disgust","Fear","joy","Sadness","Trust","Negative")
  
  posneg<-cbind.data.frame(posname,posneg)
  
  colnames(posneg)<-c("Emotion","value")

  
  #################Location wise post on facebook
  cities1<-post$city
  cities1[cities1 == " "] <- "NULL"
  cities1<-na.omit(cities1)
  longlat1<-geocode(cities1)
  longlat1<-cbind(longlat1,cities1)
  longlat1<-na.omit(longlat1)
  View(longlat1)
  
  ##########number of replied tweets
  ggplot(twf, aes(factor(!is.na(replyToSID)))) +
    geom_bar(fill = "midnightblue") +
    theme(legend.position="none", axis.title.x = element_blank()) +
    ylab("Number of tweets") +
    ggtitle("Replied Tweets") +
    scale_x_discrete(labels=c("Not in reply", "Replied tweets"))

  repliednotrplyed<-data.frame(twf$replyToSID)
  replied<-data.frame(na.omit(repliednotrplyed))
  
  sf<-searchPages("ebay",token)
  
    sf %>%
      group_by(country,city,longitude,latitude) %>%
      summarise(count=n() ) %>%
      arrange(desc(count) )-> cou
    cou1<-na.omit(cou)
    View(cou1)
    cou2<-aggregate(count~country,data=cou1,sum,na.rm=TRUE)
    ct<-data.frame(sf$country)
    li<-data.frame(sf$likes)
    ctli<-cbind(ct,li)
    ctli<-na.omit(ctli)
    
    ctli1<-aggregate(sf.likes~sf.country,data=ctli,sum,na.rm=TRUE)
    ctli1 <- ctli1[-c(37,38, 39, 40,41), ]
    country_count_likes<-data.frame(cbind(ctli1,cou2))
    setnames(country_count_likes,old = 'sf.likes',new='NumberOfLikes')
    country_count_likes1<-country_count_likes
    country_count_likes1<-country_count_likes[ ,-c(3,4)]
    colnames(country_count_likes1)<- c("Country","Likes")
    
    country_likes_color<-nrow(country_count_likes1)

 #######likes,comments,shares
    page1<- getPage("ebay", since = as.character(Sys.Date()-7), until = as.character(Sys.Date()), token, n = 100)
    
    page1$time <- as.POSIXct(page1$created_time,origin="Sys.Date()")
    
    likesperweek <-data.frame(sum(page1$likes_count))
   commentsperweek<-data.frame(sum(page1$comments_count))
    sharesperweek<-data.frame(sum(page1$shares_count))
    postsperweek<-data.frame(count(page1$id))
    posts1perweek<-data.frame(sum(lastweekposts$freq))
  library(maps)
  countries <- map.where(database="world", x=longlat$lon, y=longlat$lat)
  countries1<-data.frame((sort(table(countries), decreasing=TRUE)))

  library(Rfacebook)
  library(dplyr)
  library(lubridate)
  library(stringr)
  library(xts)
  library(stringr)
  library(xts)
  
  post24<-data.frame(page)
  
  posts24<-post24$id
 
  library(stringr)
  library(xts)
  
  post24$format <- strptime(post24$created_time,"%FT%T")
  
  post24$format<- as.POSIXct(post24$format,format ="%d-%m-%Y%H:%M:%S", tz="") 
  
  post24$hrmise <- sub(".* ", "", post24$format)
  
  post.df1<-as.data.frame(cbind(post24$hrmise,1),stringsAsFactors=FALSE)
  
  colnames(post.df1)<-c("time","freq")
  
  x <- as.POSIXct(post.df1$time,"%H:%M:%S",tz="")
  
  by.hour <- cut.POSIXt(x,"hour")
  
  View(table(by.hour))
  
  post.hour <- split(post.df1, by.hour)
  
  Post_count_hour<-as.data.frame((sapply(post.hour,function(x)sum(as.integer(x$freq)))))
  
 
  Post_count_hour <- cbind(newColName = rownames(Post_count_hour),Post_count_hour)
  
  rownames(Post_count_hour) <- 1:nrow(Post_count_hour)
  
  colnames(Post_count_hour)<-c("Time","Freq")
  
  #Post_count_hour$Time<-substr(Post_count_hour$Time,12,19)
  
  View(Post_count_hour)
  
  ######################################################### up date 25-5-2017
  
  
  #######Aggrigate of Retweets Lastweek#########
  
  tweet <- userTimeline("eBay", n=1000)  
  
  tweets.df<-twListToDF(tweets)
  
  tweets.df$format<- as.POSIXct(tweets.df$created,format ="%d-%m-%Y%H:%M:%S", tz="") 
  ts1=xts(tweets.df$retweetCount,tweets.df$format)
  ts1.sum_weekly=apply.weekly(ts1,sum) 
  sum.weekly=data.frame(date=index(ts1.sum_weekly), coredata(ts1.sum_weekly))
  colnames(sum.weekly)=c('weekly','sum')
  View(sum.weekly)
  index<-nrow(sum.weekly)
  RetweetcountWeek<-sum.weekly$sum[index]
   
  #########################Aggrigate of Twitter Likes  Last week####
  
  
  ts=xts(tweets.df$favoriteCount,tweets.df$format)
  ts.sum_weekly_likes=apply.weekly(ts,sum) 
  sum.weekly_likes=data.frame(date=index(ts.sum_weekly_likes), coredata(ts.sum_weekly_likes))
  colnames(sum.weekly_likes)=c('weekly_likes','sum_likes')
  View(sum.weekly_likes)
  index<-nrow(sum.weekly_likes)
  lastweeklikescount<-sum.weekly_likes$sum_likes[index]

