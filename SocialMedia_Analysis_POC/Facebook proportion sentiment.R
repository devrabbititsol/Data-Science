library(Rfacebook)
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

library(plotrix)

token <-"EAACEdEose0cBAPQEz6aZATGGCefSUZCE6JGGthhF7N9aNScNVvnaS4kZAvFj4qiQQr339rWm7VLZBLikTZBDjjsZC16g5Le6MwmiGK0WMeZCQRWzZBz4uPwfOiBGHfvZCceEle3L6M3ZAS4MNZBBonRmCoSuD7uf7iMrGwcpz6DZAES8OgZANmZBYOb8ZBMWIRFzJsqa4IZD"
fb_oauth <- fbOAuth(app_id="2293310030894266", app_secret="e2032dbfa23cf08aae8019d8e5639709",extended_permissions = TRUE)
save(fb_oauth, file="fb_oauth")

load("fb_oauth")

page<- getPage("ebay", token, n = 500)

pos = readLines("C:/Users/Sudeer/Desktop/Twiiter/positive_words.txt")
neg = readLines("C:/Users/Sudeer/Desktop/Twiiter/negative_words.txt")

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
scores = score.sentiment(page$message, pos, neg, .progress='text')
post_ebay_df<-cbind(page,scores$score)
pos_pdf<-scores[scores$score>0,]
positive_count<-nrow(pos_pdf)
Positive_per<-(positive_count*100)/nrow(post_ebay_df)
neg_pdf<-scores[scores$score<0,]
negative_count<-nrow(neg_pdf)
negative_per<-(negative_count*100)/nrow(post_ebay_df)
neu_pdf<-scores[scores$score==0,]
neutral_count<-nrow(neu_pdf)
neutral_per<-Positive_per<-(neutral_count*100)/nrow(post_ebay_df)

polarity_count<-rbind(positive_count,negative_count,neutral_count)
cnt<-as.data.frame(polarity_count)

polarity<-rbind("positive","negative","neutral")
cnt<-cbind(polarity,cnt)
View(cnt)
library(plotly)
 plot_ly(cnt, labels = ~cnt$polarity, values = ~cnt$V1, type = 'pie') %>%
  layout(title = "Facebook sentiment proportion for ebay('%')",
         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))







