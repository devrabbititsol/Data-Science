

##### Prediction for Sanfrancisco by monthly wise(12 Months) 

sanfrancisco<-read.csv("san_metro.csv")

sanfrans <- sample(1:nrow(sanfrancisco),size = 0.8*nrow(sanfrancisco))

trainfrans <- sanfrancisco[sanfrans,] 
train<-write.csv(trainfrans,"train.csv")


testfrans <- sanfrancisco[-sanfrans,]


metrolm<-lm(HomeValues~Year+Months,trainfrans)

testing<-predict(metrolm,testfrans)

p2<-predict(metrolm)

newdata<-data.frame(Year=c(2017),Months=c(1,2,3,4,5,6,7,8,9,10,11,12))

p3<-predict(metrolm,newdata=newdata)
p3

preictedvaluesinq1<-c(868854.3,871832.4,874810.6,877788.7,880766.9,883745.0,886723.1,889701.3,892679.4,895657.6,898635.7,901613.9)


######## Prediction for los_Angles by monthly wise(12 Months) 


  losangels<-read.csv("losanglesdatafrom2010-2016.csv")



los <- sample(1:nrow(losangels),size = 0.8*nrow(losangels)) 

trainlos <- losangels[los,] 


testlos <- losangels [-los,]


metrolos<-lm(HomeValues~Year+Months,trainlos)

metrotestdata<-predict(metrolos,testlos)
test<-write.csv(testlos,"losangelstestdata.csv")
test1<-write.csv(metrotestdata,"losangelstestdata1.csv")


metro <- predict(metrolos)

newdata1<-data.frame(Year=c(2017),Months=c(1,2,3,4,5,6,7,8,9,10,11,12))

metro1 <- predict(metrolos,newdata1)

predicteddata<-write.csv(metro1,"predicteddataforlosangels.csv")



##### Prediction for Sanfrancisco by monthly wise(12 Months) 

napa<-read.csv("Metro_napa.csv")

metro_napa <- sample(1:nrow(napa),size = 0.8*nrow(napa))

trainnapa <- napa[metro_napa,] 
test<-write.csv(trainnapa,"test.csv")


testnapa <- napa[-metro_napa,]


metronapalm<-lm(HomeValues~Year+Months,trainnapa)

testing<-predict(metronapalm,testnapa)

napap3<-predict(metronapalm)
napap3

newdatanapa<-data.frame(Year=c(2017),Months=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"))

napap4<-predict(metronapalm,newdata=newdatanapa)
napap4


# ###########prediction for Alameda data(2010-2016) County
# Alameda<-read.csv("AlamedaDataFrom2010-2016.csv")
# 
# 
# Ala <- sample(1:nrow(Alameda),size = 0.8*nrow(Alameda)) 
# 
# trainAlameda <- Alameda[Ala,] 
# 
# 
# testAlameda <- Alameda [-Ala,]
# 
# 
# CountyAlameda<-lm(HomeValues~Year+Months,trainAlameda)
# 
# CountyAlamedaTestData<-predict(CountyAlameda,testAlameda)
# test<-write.csv(testAlameda,"Alamedatestdata.csv")
# test1<-write.csv(CountyAlamedaTestData,"Alamedatestdata1.csv")
# 
# 
# Alameda1 <- predict(CountyAlameda)
# 
# newdata3<-data.frame(Year=c(2017),Months=c(1,2,3,4,5,6,7,8,9,10,11,12))
# 
# AlamedaPredictedValues <- predict(CountyAlameda,newdata3)
# 
# predictedAlameda<-write.csv(AlamedaPredictedValues,"AlamedaPredictedValues.csv")
# 
# 
# 
# 
# 




