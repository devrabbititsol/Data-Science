library(dbConnect)
library(RSQLite)
library(DBI)
library(rsconnect)
library(dplyr)
library(sqldf)
library(XLConnect)
upArrow <-c('<i class="glyphicon glyphicon-arrow-up" style="color:green;float: right;padding: 2px 15px 0px 0px;"></i>')
downArrow<-c('<i class="glyphicon glyphicon-arrow-down" style="color:#bc3f30;float: right;padding: 2px 15px 0px 0px;"></i>')
minus<-c('<i class="glyphicon glyphicon-minus" style="float: right;padding: 2px 15px 0px 0px;"></i>')

pharmaciesandavgdispences<-read.csv("2a.csv",row.names = 1)
maxno.ofcommphar<-max(dispenca1$Numberofcommunitypharmacies)
ytop<-max(dispenca1$Year)
avgitems<-max(dispenca1$Averagemonthlyitemsperpharmacy)

totser<-read.csv(file="Totalservices.csv")

a<-as.numeric(as.character(contra$IndependentContractors))
a<-na.omit(a)
IndependentFactors<-data.frame(cbind(a))


b<-as.numeric(as.character(contra$MultipleContractors))
b<-na.omit(b)
mulplecontractors<-data.frame(cbind(b))
c<-as.numeric(as.character(totalpharmacies$Number.of.community.pharmacies))
c<-na.omit(c)
totalpharmacies<-data.frame(cbind(c))

d<-as.numeric(as.character(totser$PatientGroupDirectionService))
d<-na.omit(d)
patientser<-data.frame(cbind(d))




############  db   #############################################

db <- dbConnect(SQLite(), dbname='Pharma.sqlite')

################################################################
#indvsmul<-read.csv(file="inpenvsmultipercent.csv")
dbWriteTable(conn = db, name = 'indvsmul3', value = 'inpenvsmultipercent.csv', 
             row.names = FALSE, header = TRUE,overwrite=TRUE)
dbListTables(db)                   
dbListFields(db, 'indvsmul3')      
indvsmul3<-dbReadTable(db, 'indvsmul3') 

#pharmaciesandavgdispences<-read.csv("2a.csv",row.names = 1)
dbWriteTable(conn = db, name = 'dispenca1', value = '2a.csv', 
             row.names = FALSE, header = TRUE,overwrite=TRUE)
dbListTables(db)                   
dbListFields(db, 'dispenca1')      
dispenca1<-dbReadTable(db, 'dispenca1') 

#applicationstatus14<-read.csv("6aDecisions.csv",row.names = 1)
dbWriteTable(conn = db, name = 'statuss', value = '6aDecisions.csv', 
             row.names = FALSE, header = TRUE,overwrite=TRUE)
dbListTables(db)                   
dbListFields(db, 'statuss')      
statuss<-dbReadTable(db, 'statuss') 

#ycontractors<-read.csv("4acontractors.csv",row.names = 1)
dbWriteTable(conn = db, name = 'ycontracto', value = '4acontractors.csv', 
             row.names = FALSE, header = TRUE,overwrite=TRUE)
dbListTables(db)                   
dbListFields(db, 'ycontractor')      
ycontractor<-dbReadTable(db, 'ycontractor') 

#lcontractors<-read.csv("4blcontractors.csv",row.names = 1)
dbWriteTable(conn = db, name = 'lcontracto2', value = '4blcontractors.csv', 
             row.names = FALSE, header = TRUE,overwrite=TRUE)
dbListTables(db)                   
dbListFields(db, 'lcontracto2')      
lcontracto2<-dbReadTable(db, 'lcontracto2') 

#Yno.ofphar<-read.csv("3aNo.ofPharmacies.csv",row.names = 1,header=TRUE,colClasses="character")
dbWriteTable(conn = db, name = 'Ynoofpham', value = '3aNo.ofPharmacies.csv', 
             row.names = FALSE, header = TRUE,overwrite=TRUE)
dbListTables(db)                   
dbListFields(db, 'Ynoofpham')      
Ynoofpham<-dbReadTable(db, 'Ynoofpham') 

#diff1314<-read.csv("4bdiff.csv",row.names = 1)
dbWriteTable(conn = db, name = 'diff13141', value = '4bdiff.csv', 
             row.names = FALSE, header = TRUE,overwrite=TRUE)
dbListTables(db)                   
dbListFields(db, 'diff13141')      
diff13141<-dbReadTable(db, 'diff13141') 

#decision<-read.csv("5aDecisionsonapplications.csv",row.names = 1)
dbWriteTable(conn = db, name = 'decisions', value = '5aDecisionsonapplications.csv', 
             row.names = FALSE, header = TRUE,overwrite=TRUE)
dbListTables(db)                   
dbListFields(db, 'decisions')      
decisions<-dbReadTable(db, 'decisions') 

#pharmaitemsdispenced<-read.csv("3bno.ofprescriptionitemsdispensed.csv",row.names = 1)
dbWriteTable(conn = db, name = 'pharmaitemsdispencedd', value = '3bno.ofprescriptionitemsdispensed.csv', 
             row.names = FALSE, header = TRUE,overwrite=TRUE)
dbListTables(db)                   
dbListFields(db, 'pharmaitemsdispencedd')      
pharmaitemsdispencedd<-dbReadTable(db, 'pharmaitemsdispencedd') 

#PharmprovidingMurservice<-read.csv("11aMUR.csv",row.names = 1)
dbWriteTable(conn = db, name = 'PharmprovidingMurservices', value = '11aMUR.csv', 
             row.names = FALSE, header = TRUE,overwrite=TRUE)
dbListTables(db)                   
dbListFields(db, 'PharmprovidingMurservices')      
PharmprovidingMurservices<-dbReadTable(db, 'PharmprovidingMurservices') 

#Esplsplsp<-read.csv(file="Esplsplspcontructors.csv")
dbWriteTable(conn = db, name = 'Esplsplspc', value = 'Esplsplspcontructors.csv', 
             row.names = FALSE, header = TRUE,overwrite=TRUE)
dbListTables(db)                   
dbListFields(db, 'Esplsplspc')      
Esplsplspc<-dbReadTable(db, 'Esplsplspc') 

#Esplspercentages<-read.csv(file="esplsppercentages.csv")
dbWriteTable(conn = db, name = 'Esplspercentagess', value = 'esplsppercentages.csv', 
             row.names = FALSE, header = TRUE,overwrite=TRUE)
dbListTables(db)                   
dbListFields(db, 'Esplspercentagess')      
Esplspercentagess<-dbReadTable(db, 'Esplspercentagess') 

#yexempcategory<-read.csv("7aYexemptcategory.csv",row.names = 1)
dbWriteTable(conn = db, name = 'yexempcategoryy', value = '7aYexemptcategory.csv', 
             row.names = FALSE, header = TRUE,overwrite=TRUE)
dbListTables(db)                   
dbListFields(db, 'yexempcategoryy')      
yexempcategoryy<-dbReadTable(db, 'yexempcategoryy') 

#lexemptcategorydata<-read.csv("7blexempt.csv",row.names = 1)
dbWriteTable(conn = db, name = 'lexemptcategorydataa', value = '7blexempt.csv', 
             row.names = FALSE, header = TRUE,overwrite=TRUE)
dbListTables(db)                   
dbListFields(db, 'lexemptcategorydataa')      
lexemptcategorydataa<-dbReadTable(db, 'lexemptcategorydataa') 

#YSAC<-read.csv("14aYSACservice.csv",row.names = 1)
dbWriteTable(conn = db, name = 'YSACs', value = '14aYSACservice.csv', 
             row.names = FALSE, header = TRUE,overwrite=TRUE)
dbListTables(db)                   
dbListFields(db, 'YSACs')      
YSACs<-dbReadTable(db, 'YSACs') 


totalpharmacies<-read.csv(file="communitypharmacies.csv")
prescridata<-read.csv(file="prescriptiondata.csv")
totser<-read.csv(file="Totalservices.csv")
locationpharma<-read.csv("2b.csv",row.names = 1)
openclose <- read.csv(file="opening.csv")
Nms<-read.csv(file="Nms.csv")
NMSservice<-read.csv(file="NMSservice.csv")
AUR<-read.csv(file="AUR.csv")
LSACdata<-read.csv("14bLSAC.csv",row.names = 1)
AurService<-read.csv((file="AurService.csv"))
Murser<-read.csv(file="Murservice.csv")

