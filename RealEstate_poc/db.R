library(sqldf)

db <- dbConnect(SQLite(), dbname='Test1.sqlite')


##################table for SantaCruz MetroSFR
dbWriteTable(conn = db, name = 'SantaCruz', value = 'SantaCruzDataFrom2010-2016.csv',
             row.names = FALSE, header = TRUE)
dbListTables(db)                   
dbListFields(db, 'SantaCruz')      
dbReadTable(db, 'SantaCruz') 

#################table for SantaCruz Predicted values
dbWriteTable(conn = db, name = 'SantaCruz-Predicted-Values', value = 'SantaCruzPredictedValues.csv',
             row.names = FALSE, header = TRUE)
dbListTables(db)                   
dbListFields(db, 'SantaCruz-Predicted-Values')      
dbReadTable(db, 'SantaCruz-Predicted-Values') 

################table for "LosAngels" MetroSFR
dbWriteTable(conn = db, name = 'LosAngels', value = 'losanglesDataFrom2010-2016.csv',
             row.names = FALSE, header = TRUE)
dbListTables(db)                   
dbListFields(db, 'LosAngels')      
dbReadTable(db, 'LosAngels') 

################tables for "LosAngels Predicted Values"
dbWriteTable(conn = db, name = 'LosAngels-Predicted-Values', value = 'predicteddataforlosangels.csv',
             row.names = FALSE, header = TRUE)
dbListTables(db)                   
dbListFields(db, 'LosAngels-Predicted-Values')      
dbReadTable(db, 'LosAngels-Predicted-Values') 

##############tables for "SanJose" MetroSFR
dbWriteTable(conn = db, name = 'SanJose', value = 'SanJoseDataFrom2012-2016.csv',
             row.names = FALSE, header = TRUE)
dbListFields(db, 'SanJose')      
dbReadTable(db, 'SanJose') 

################tables for "SanJose Predicted Values"
dbWriteTable(conn = db, name = 'SanJose-Predicted-Values', value = 'SanJosePredictedValues.csv',
             row.names = FALSE, header = TRUE)
                   
dbListFields(db, 'SanJose-Predicted-Values')      
dbReadTable(db, 'SanJose-Predicted-Values') 

#########table for Alameda County wise
dbWriteTable(conn = db, name = 'Alameda', value = 'AlamedaDataFrom2010-2016.csv',
             row.names = FALSE, header = TRUE)
dbListFields(db, 'Alameda')      
dbReadTable(db, 'Alameda') 

#######################################################################

dbWriteTable(conn = db, name = 'city-rental-least', value = 'city_rental_least.csv',
             row.names = FALSE, header = TRUE)

dbWriteTable(conn = db, name = 'city-current-month', value = 'citycurmnth.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db,'city-current-month')

dbWriteTable(conn = db, name = 'city-rental-SFR', value = 'cityrentalSFR.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db,'city-rental-SFR')



dbWriteTable(conn = db, name = 'city-top-nlowHV', value = 'citytopnlowHV.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db,'city-top-nlowHV')



dbWriteTable(conn = db, name = 'city-wise-1BH', value = 'citywise1BH.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db,'city-wise-1BH')


dbWriteTable(conn = db, name = 'city-wise-2BH', value = 'citywise2BH.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db,'city-wise-2BH')


dbWriteTable(conn = db, name = 'City-wise-HV-allyears-single', value = 'citywise_HV_allyears_single.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db,'City-wise-HV-allyears-single')



dbWriteTable(conn = db, name = 'city_wise_rental-Zri', value = 'Citywise_rental_Zri.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db, 'city_wise_rental-Zri')



dbWriteTable(conn = db, name = 'county_currentmnth_HVandPHV', value = 'county_cuurentmnth_HVandPHV.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db,'county_currentmnth_HVandPHV')


dbWriteTable(conn = db, name = 'county-rental-zri', value = 'county_rental_zri.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db,'county-rental-zri')

dbWriteTable(conn = db, name = 'county-current-month', value = 'countycurmnth.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db,'county-current-month')



dbWriteTable(conn = db, name = 'county-top-nlow-homevalues', value = 'countytopnlowhomevalues.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db,'county-top-nlow-homevalues')


dbWriteTable(conn = db, name = 'county-wise-2BH', value = 'countywise2BH.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db,'county-wise-2BH')


dbWriteTable(conn = db, name = 'county_wise_1BH', value = 'countywise_1BH.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db,'county_wise_1BH')


# dbWriteTable(conn = db, name = 'county_wise-allyear-sheat', value = 'Countywiseallyearsheat.csv',
#              row.names = FALSE, header = TRUE)
# dbReadTable(db,'county_wise-allyear-sheat')

dbWriteTable(conn=db,name='year-sheet',value='countyallyears.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db,'year-sheet')


dbWriteTable(conn = db, name = 'county_ZRISFR', value = 'CountyZRISFR.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db, 'county_ZRISFR')


dbWriteTable(conn = db, name = 'current-month-summary', value = 'currentmonthsummary.csv',
             row.names = FALSE, header = TRUE)
dbListTables(db)                   
dbListFields(db, 'current-month-summary') 
dbReadTable(db, 'current-month-summary') 


dbWriteTable(conn = db, name = 'current-month-state-zri', value = 'currmonthstate_zri.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db,'current-month-state-zri')


dbWriteTable(conn = db, name = 'forecast-2018-prediction', value = 'FORCAST_2018_PRE.csv',
             row.names = FALSE, header = TRUE)

dbWriteTable(conn = db, name = 'metro-rental-2BH', value = 'met_Ren_2bh.csv',
             row.names = FALSE, header = TRUE)

dbWriteTable(conn = db, name = 'Metro_napa', value = 'Metro_napa.csv',
             row.names = FALSE, header = TRUE)

dbWriteTable(conn = db, name = 'Metro-Rental-SFR', value = 'Metro_Rent_SFR.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db,'Metro-Rental-SFR')



dbWriteTable(conn = db, name = 'metro-rental-sf', value = 'metro_rental_sf.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db,'metro-rental-sf')


dbWriteTable(conn = db, name = 'metro-single1', value = 'metro_single1.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db,'metro-single1')

dbWriteTable(conn = db, name = 'metro-wise-2BH', value = 'metro_wise_2bh.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db,'metro-wise-2BH')


dbWriteTable(conn = db, name = 'metro_current-zri', value = 'metrocurr_zri.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db,'metro_current-zri')



dbWriteTable(conn = db, name = 'metro-current-year', value = 'metrocurrentyr.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db,'metro-current-year')



dbWriteTable(conn = db, name = 'metro_current_month', value = 'metroCurrMon.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db, 'metro_current_month') 




dbWriteTable(conn = db, name = 'metro-HVSFR', value = 'metroHVSFR.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db,'metro-HVSFR')


dbWriteTable(conn = db, name = 'metro-Rental-Zri', value = 'metroRentalZri.csv',
             row.names = FALSE, header = TRUE)

dbWriteTable(conn = db, name = 'metro-top-low-homevalues', value = 'metrotoplowhomevalues.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db,'metro-top-low-homevalues')



dbWriteTable(conn = db, name = 'metro-wise-1Bh', value = 'metrowise1BH.csv',
            row.names = FALSE, header = TRUE)
dbReadTable(db,'metro-wise-1Bh')


dbWriteTable(conn = db, name = 'Napa-predict', value = 'NapaPredict.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db,'Napa-predict')


dbWriteTable(conn = db, name = 'predict', value = 'predict.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db,'predict')

dbWriteTable(conn = db, name = 'Rental-state', value = 'Reantal_state.csv',
             row.names = FALSE, header = TRUE)

dbWriteTable(conn = db, name = 'rental-1BH', value = 'rental_1BH.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db, 'rental-1BH')



dbWriteTable(conn = db, name = 'reantal-city-least', value = 'rental_city_least.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db,'reantal-city-least')

dbWriteTable(conn = db, name = 'renatl-city-top', value = 'rental_city_top.csv',
             row.names = FALSE, header = TRUE)

dbReadTable(db,'renatl-city-top')

dbWriteTable(conn = db, name = 'rental-county-1BH', value = 'rental_coun_1bh.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db,'rental-county-1BH')


dbWriteTable(conn = db, name = 'Rental', value = 'Rental_county_1_BH.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db,'Rental')



dbWriteTable(conn = db, name = 'Rental_county_least', value = 'rental_county_least.csv',
             row.names = FALSE, header = TRUE)

 dbWriteTable(conn = db, name = 'rentalmetro', value = 'RentalMetro1BH.csv',
             row.names = FALSE, header = TRUE)
  dbReadTable(db,'rentalmetro')



 dbWriteTable(conn = db, name = 'rental-metro-least', value = 'rental_metro_least.csv',
             row.names = FALSE, header = TRUE)
 dbReadTable(db,'rental-metro-least')

  dbWriteTable(conn = db, name = 'rental-metro-top', value = 'rental_metro_top.csv', 
               row.names = FALSE, header = TRUE)
   dbReadTable(db,'rental-metro-top')



dbWriteTable(conn = db, name = 'rental-year-state-2Bh', value = 'rentalyearstate_2bh.csv',
             row.names = FALSE, header = TRUE)

dbWriteTable(conn = db, name = 'san-metro', value = 'san_metro.csv',
             row.names = FALSE, header = TRUE)

dbWriteTable(conn = db, name = 'san-predict', value = 'san_predict.csv',
             row.names = FALSE, header = TRUE)
dbReadTable(db,'san-predict')

dbWriteTable(conn = db, name = 'state-vbox', value = 'state_vBox.csv',
             row.names = FALSE, header = TRUE)

dbWriteTable(conn = db, name = 'state-zhvi-summary-allHomes', value = 'State_Zhvi_Summary_AllHomes.csv',
             row.names = FALSE, header = TRUE)

dbWriteTable(conn = db, name = 'test', value = 'test.csv',
             row.names = FALSE, header = TRUE)

dbWriteTable(conn = db, name = 'train', value = 'train.csv',
             row.names = FALSE, header = TRUE)

dbWriteTable(conn=db,name='SantaclaraData',value='SantaclaraDataoriginal.csv',
             row.names = FALSE, header = TRUE)            
 dbReadTable(db,'SantaClaraData')


 dbWriteTable(conn=db,name='SantaClara-Predicted-Values',value='SantaClaraPredictedValues.csv',
              row.names = FALSE, header = TRUE)            
 dbReadTable(db,'SantaClara-Predicted-Values')
 
 
 dbWriteTable(conn=db,name='SanMateo-Data',value='SanmateoDataFrom2012-2016.csv',
              row.names = FALSE, header = TRUE)            
 dbReadTable(db,'SanMateo-Data')
 
 
 
 dbWriteTable(conn=db,name='SanMateo-predicted-values',value='Sanmateopredictedvalues.csv',
              row.names = FALSE, header = TRUE)            
 dbReadTable(db,'SanMateo-predicted-values')
 

 dbWriteTable(conn=db,name='Marin-data',value='MarinDataFrom2012-2016.csv',
              row.names = FALSE, header = TRUE)            
 dbReadTable(db,'Marin-data')
 
 dbWriteTable(conn=db,name='Marin-predicted-values',value='Marinpredictedvalues.csv',
              row.names = FALSE, header = TRUE)            
 dbReadTable(db,'Marin-predicted-values')
 
 
 







































