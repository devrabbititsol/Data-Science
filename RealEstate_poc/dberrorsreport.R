
#################rental metro least

n1 = 100000 # experiment with this number
f1 = file('rental_metro_least.csv') 
con = open(f1) # open a connection to the file
data1 <-read.csv(f1,nrows=n,header=TRUE)
var.names = names(data1)    

#setting up sqlite
#con_data = dbConnect(SQLite(), dbname="yoursqlitefile")
db <- dbConnect(SQLite(), dbname='Test1.sqlite')

while(nrow(data1) == n1) { # if not reached the end of line
  dbWriteTable(db, data1, name='rental-metro-least',append=TRUE ) #write to sqlite 
  data1 <-read.csv(f1,nrows=n,header=FALSE)
  names(data) <- var.names      
} 
close(f1)
if (nrow(data1) != 0 )       
  dbWriteTable(db,  data1, name='rental-metro-least',append=TRUE )


################rental metro top

n = 100000 # experiment with this number
f = file('rental_metro_top.csv') 
con = open(f) # open a connection to the file
data <-read.csv(f,nrows=n,header=TRUE)
var.names = names(data)    

#setting up sqlite
#con_data = dbConnect(SQLite(), dbname="yoursqlitefile")
db <- dbConnect(SQLite(), dbname='Test1.sqlite')

while(nrow(data) == n) { # if not reached the end of line
  dbWriteTable(db, data, name='rental-metro-top',append=TRUE ) #write to sqlite 
  data <-read.csv(f,nrows=n,header=FALSE)
  names(data) <- var.names      
} 
close(f)
if (nrow(data) != 0 )       
  dbWriteTable(db,  data, name='rental-metro-top',append=TRUE )


##################### RentalMetro1BH

n = 100000 # experiment with this number
f = file('RentalMetro1BH.csv') 
con = open(f) # open a connection to the file
data <-read.csv(f,nrows=n,header=TRUE)
var.names = names(data)    

#setting up sqlite
#con_data = dbConnect(SQLite(), dbname="yoursqlitefile")
db <- dbConnect(SQLite(), dbname='Test1.sqlite')

while(nrow(data) == n) { # if not reached the end of line
  dbWriteTable(db, data, name='rentalmetro',append=TRUE ) #write to sqlite 
  data <-read.csv(f,nrows=n,header=FALSE)
  names(data) <- var.names      
} 
close(f)
if (nrow(data) != 0 )       
  dbWriteTable(db,  data, name='rentalmetro',append=TRUE )


######### metrowise1BH

n = 100000 # experiment with this number
f = file('metrowise1BH.csv') 
con = open(f) # open a connection to the file
data <-read.csv(f,nrows=n,header=TRUE)
var.names = names(data)    

#setting up sqlite
#con_data = dbConnect(SQLite(), dbname="yoursqlitefile")
db <- dbConnect(SQLite(), dbname='Test1.sqlite')

while(nrow(data) == n) { # if not reached the end of line
  dbWriteTable(db, data, name='metro-wise-1Bh',append=TRUE ) #write to sqlite 
  data <-read.csv(f,nrows=n,header=FALSE)
  names(data) <- var.names      
} 
close(f)
if (nrow(data) != 0 )       
  dbWriteTable(db,  data, name='metro-wise-1Bh',append=TRUE )


######### metro_rental_sf

n = 100000 # experiment with this number
f = file('metro_rental_sf.csv') 
con = open(f) # open a connection to the file
data <-read.csv(f,nrows=n,header=TRUE)
var.names = names(data)    

#setting up sqlite
#con_data = dbConnect(SQLite(), dbname="yoursqlitefile")
db <- dbConnect(SQLite(), dbname='Test1.sqlite')

while(nrow(data) == n) { # if not reached the end of line
  dbWriteTable(db, data, name='metro-rental-sf',append=TRUE ) #write to sqlite 
  data <-read.csv(f,nrows=n,header=FALSE)
  names(data) <- var.names      
} 
close(f)
if (nrow(data) != 0 )       
  dbWriteTable(db,  data, name='metro-rental-sf',append=TRUE )




