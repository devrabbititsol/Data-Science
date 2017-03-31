library(RMySQL)
mydb = dbConnect(MySQL(),user='readonly',password='readonly123',dbname='slcawdb',host='183.82.106.91')
upArrow <-c('<i class="glyphicon glyphicon-arrow-up" style="color:#0073b7;float: right;padding: 2px 15px 0px 0px;"></i>')
downArrow<-c('<i class="glyphicon glyphicon-arrow-down" style="color:#bc3f30;float: right;padding: 2px 15px 0px 0px;"></i>')
minus<-c('<i class="glyphicon glyphicon-minus" style="float: right;padding: 2px 15px 0px 0px;"></i>')
###current day analysis
# ##current day analysis for sales
tday=dbSendQuery(mydb,'select year(sales_flat_order.updated_at) as year,
                 month(sales_flat_order.updated_at) as month,
                 day(sales_flat_order.updated_at) as day,
                 timestamp( sales_flat_order.updated_at) as timestamp,
                 
                 sum(sales_flat_invoice.grand_total) as Sales
                 
                 from sales_flat_order,sales_flat_invoice
                 
                 where sales_flat_order.entity_id=sales_flat_invoice.order_id  and year(sales_flat_order.updated_at)=2016 and month(sales_flat_order.updated_at)=3 and day(sales_flat_order.updated_at)=26  group by time( sales_flat_order.updated_at)
                 
                 ')
tdaysales= fetch(tday, n=-1) 
# ##analysis for yesterday sales
yday=dbSendQuery(mydb,'select year(sales_flat_order.updated_at) as year,
                 month(sales_flat_order.updated_at) as month,
                 day(sales_flat_order.updated_at) as day,
                 timestamp( sales_flat_order.updated_at) as timestamp,
                 
                 sum(sales_flat_invoice.grand_total) as Sales
                 
                 from sales_flat_order,sales_flat_invoice
                 
                 where sales_flat_order.entity_id=sales_flat_invoice.order_id  and year(sales_flat_order.updated_at)=2016 and month(sales_flat_order.updated_at)=3 and day(sales_flat_order.updated_at)=25  group by time( sales_flat_order.updated_at)   
                 
                 ')
ydaysales= fetch(yday, n=-1) 
# ##current month analysis for sales
rs=dbSendQuery(mydb,'select year(sales_flat_order.updated_at) as year,
               month(sales_flat_order.updated_at) as month,
               day(sales_flat_order.updated_at) as day,
               
               sum(sales_flat_invoice.grand_total) as sales
               
               from sales_flat_order,sales_flat_invoice
               
               where sales_flat_order.entity_id=sales_flat_invoice.order_id  and year(sales_flat_order.updated_at)=2016 and month(sales_flat_order.updated_at)=3    
               
               group by date(sales_flat_order.updated_at)')
daywisesales= fetch(rs, n=-1) 
###current year analysis of sales
Ysales=dbSendQuery(mydb,'select year(sales_flat_order.updated_at) as Year,
                   month(sales_flat_order.updated_at) as Month,
                   
                   sum(sales_flat_invoice.grand_total) as Sales
                   
                   from sales_flat_order,sales_flat_invoice
                   
                   where sales_flat_order.entity_id=sales_flat_invoice.order_id  and year(sales_flat_order.updated_at)=2016     
                   
                   group by Month(sales_flat_order.updated_at)')

ysalesval= fetch(Ysales, n=-1) 

#Query to find AverageOrderValue
#avg order value for a month in a year
mAvg_Order=dbSendQuery(mydb,'select sum(grand_total)/count(*) as AvgOrderValue from sales_flat_order where status="complete" and 
                       year(sales_flat_order.updated_at)=2016 and month(sales_flat_order.updated_at)=3')
mAvg_Value=fetch(mAvg_Order,n=-1)
###avg order value for a year2016
YmAvg_Order=dbSendQuery(mydb,'select sum(grand_total)/count(*) as AvgOrderValue,month(sales_flat_order.updated_at) as Month from sales_flat_order where status="complete" and year(sales_flat_order.updated_at)=2016 group by month(sales_flat_order.updated_at)')
YmAvg_Value=fetch(YmAvg_Order,n=-1)

YAvg_Order=dbSendQuery(mydb,'select sum(grand_total)/count(*) as AvgOrderValue from sales_flat_order where status="complete" and year(sales_flat_order.updated_at)=2016')
YAvg_Value=fetch(YAvg_Order,n=-1)

##AvgOrdervalueBench Marking
ypAvg_order=dbSendQuery(mydb,'select sum(grand_total)/count(*) as AvgOrderValue,month(sales_flat_order.updated_at) as Month from sales_flat_order where status="complete" and year(sales_flat_order.updated_at)>=2015 group by month(sales_flat_order.updated_at);')
ypAvg_value=fetch(ypAvg_order,n=-1)

###avg order value for a year 2015
YAvg_Order15=dbSendQuery(mydb,'select sum(grand_total)/count(*) as AvgOrderValue from sales_flat_order where status="complete" and year(sales_flat_order.updated_at)=2015')
YAvg_Value15=fetch(YAvg_Order15,n=-1)
# Avg_Inc=((YAvg_Value-YAvg_Value15)/YAvg_Value15)*100

#Queryto find revenue
##revenue generated in a month
mRevenueCal=dbSendQuery(mydb,'select sum(grand_total) from sales_flat_invoice where year(sales_flat_invoice.updated_at)=2016 and month(sales_flat_invoice.updated_at)=3')
mRevenueval=fetch(mRevenueCal,n=-1)
## ##revenue generated in a year
yRevenueCal=dbSendQuery(mydb,'select sum(grand_total) from sales_flat_invoice where year(sales_flat_invoice.created_at)=2016')
yRevenueval=fetch(yRevenueCal,n=-1)

#Query to find Repeatedcustomers 
## repeated customers in a month
mRepeatCust=dbSendQuery(mydb,'SELECT COUNT(*) AS grand_count FROM(
                        SELECT customer_email FROM sales_flat_order
                        WHERE sales_flat_order.status NOT LIKE "canceled"
                        AND sales_flat_order.status NOT LIKE "closed"
                        AND sales_flat_order.status NOT LIKE "fraud"
                        AND sales_flat_order.status NOT LIKE "holded"
                        AND sales_flat_order.status NOT LIKE "paypal_canceled_reversal"
                        AND year(sales_flat_order.updated_at)=2016 
                        AND month(sales_flat_order.updated_at)=3
                        GROUP BY customer_email HAVING COUNT(*) > 1
) s')
mRepeatVal=fetch(mRepeatCust,n=-1)
## repeated customers in a year
yRepeatCust=dbSendQuery(mydb,'SELECT COUNT(*) AS grand_count FROM(
                        SELECT customer_email FROM sales_flat_order
                        WHERE sales_flat_order.status NOT LIKE "canceled"
                        AND sales_flat_order.status NOT LIKE "closed"
                        AND sales_flat_order.status NOT LIKE "fraud"
                        AND sales_flat_order.status NOT LIKE "holded"
                        AND sales_flat_order.status NOT LIKE "paypal_canceled_reversal"
                        AND year(sales_flat_order.updated_at)=2016 
                        GROUP BY customer_email HAVING COUNT(*) > 1
) s')
yRepeatVal=fetch(yRepeatCust,n=-1)
yRepeatCust15=dbSendQuery(mydb,'SELECT COUNT(*) AS grand_count FROM(
                          SELECT customer_email FROM sales_flat_order
                          WHERE sales_flat_order.status NOT LIKE "canceled"
                          AND sales_flat_order.status NOT LIKE "closed"
                          AND sales_flat_order.status NOT LIKE "fraud"
                          AND sales_flat_order.status NOT LIKE "holded"
                          AND sales_flat_order.status NOT LIKE "paypal_canceled_reversal"
                          AND year(sales_flat_order.updated_at)=2015 
                          GROUP BY customer_email HAVING COUNT(*) > 1
) s')
yRepeatVal15=fetch(yRepeatCust15,n=-1)
Inc<-cbind((yRepeatVal-yRepeatVal15)/yRepeatVal15*100)
#Calculating E-Commerce Ratio
##for a month
mVisits=dbSendQuery(mydb,"select count(*) from log_visitor where month(log_visitor.first_visit_at)=3 and year(log_visitor.first_visit_at)=2016")
mVisitsval=fetch(mVisits,n=-1)
mTransactions=dbSendQuery(mydb,"select count(*) from sales_flat_order where status='complete' and month(sales_flat_order.created_at)=3 and year(sales_flat_order.created_at)=2016")
mTrValue=fetch(mTransactions,n=-1)
mERatio=(mTrValue/mVisitsval)*100
##for a year
yVisits=dbSendQuery(mydb,"select count(*) from log_visitor where year(log_visitor.first_visit_at)=2016")
yVisitsval=fetch(yVisits,n=-1)
yTransactions=dbSendQuery(mydb,"select count(*) from sales_flat_order where status='complete'  and year(sales_flat_order.created_at)=2016")
yTrValue=fetch(yTransactions,n=-1)
yERatio=(yTrValue/yVisitsval)*100
############## new Customer per month ###################
mNewCust=dbSendQuery(mydb,'SELECT COUNT(*) AS grand_count FROM(
                     SELECT customer_email FROM sales_flat_order
                     WHERE sales_flat_order.status NOT LIKE "canceled"
                     AND sales_flat_order.status NOT LIKE "closed"
                     AND sales_flat_order.status NOT LIKE "fraud"
                     AND sales_flat_order.status NOT LIKE "holded"
                     AND sales_flat_order.status NOT LIKE "paypal_canceled_reversal"
                     AND year(sales_flat_order.updated_at)=2016 
                     AND month(sales_flat_order.updated_at)=3
                     GROUP BY customer_email HAVING COUNT(*) = 1) s')
mNewCustVal=fetch(mNewCust,n=-1)


###########increase % per month#####
monthdata=dbSendQuery(mydb,'select month(sales_flat_order.created_at) as month,sum(sales_flat_order.grand_total) as sale from sales_flat_order where 
                      year(sales_flat_order.created_at)=2016 and month(sales_flat_order.created_at)>=2 group by month;')


percentofmonthsdata=fetch(monthdata,n=-1)

febdata=percentofmonthsdata$sale[1]
marchdata=percentofmonthsdata$sale[2]
# differencegrowth=marchdata-febdata
# print(difference)
# mincreaseper=(difference/febdata)*100
###########increase % per year#####
ydata=dbSendQuery(mydb,'select month(sales_flat_order.created_at) as month,sum(sales_flat_order.grand_total) as sale from sales_flat_order where 
                  year(sales_flat_order.created_at)>=2015  group by year(sales_flat_order.created_at);')


ypdata=fetch(ydata,n=-1)

data15=ypdata$sale[1]
data16=ypdata$sale[2]
differencey=data16-data15
# yincreaseper=(differencey/febdata)*100
# ##Bounce rate for a month
# 
# brate=dbSendQuery(mydb,'select count(*) from log_visitor where last_visit_at=first_visit_at and Month(last_visit_at)=3 and year(last_visit_at)=2016')
# br=fetch(brate,n=-1)
# brate1=dbSendQuery(mydb,'select count(*) from log_visitor where  Month(last_visit_at)=3 and year(last_visit_at)=2016 ')
# br1=fetch(brate1,n=-1)
# bouncerate=br/br1*100


##Revenue of a perticular month in all years

RevenueMarch=dbSendQuery(mydb,'select sum(grand_total) as Revenue ,Month(created_at) as Month,Year(created_at) as Year from sales_flat_order where Month(created_at) =3 group by  Year(created_at)')
RevenueMarchVal=fetch(RevenueMarch,n=-1)
###########increase IN sales % BETWEEN THE YEARS IN A PARTICULAR MONTH MARCH(2013-2014)#####
incsales=dbSendQuery(mydb,'select sum(grand_total) as Revenue ,
                     Month(created_at) as Month,
                     Year(created_at) as Year 
                     from sales_flat_order
                     where Month(created_at) =3 
                     and  Year(created_at)>=2013 
                     group by  Year(created_at);')


pincrease=fetch(incsales,n=-1)

data2013=pincrease$Revenue[1]
data2014=pincrease$Revenue[2]
data2015=pincrease$Revenue[3]
data2016=pincrease$Revenue[4]
minc1314=(((data2014-data2013)/((data2013)))*100)
minc1415=(((data2015-data2014)/((data2014)))*100)
minc1516=(((data2016-data2015)/((data2015)))*100)
RMinc.annotation<-c(paste(round(0),"%"),paste(round(minc1314,1),"%"),paste(round(minc1415,1),"%"),paste(round(minc1516,1),"%"))
RMVal<-cbind(RevenueMarchVal,RMinc.annotation)
##Sales of an item by location in a month
msaleLoc=dbSendQuery(mydb,'select sum(sales_flat_order.grand_total) as Revenue ,sales_flat_order_address.region as Location from 
                     sales_flat_order,sales_flat_order_address where sales_flat_order.entity_id=sales_flat_order_address.parent_id  and YEAR(sales_flat_order.created_at)=2016 and Month(sales_flat_order.created_at)=3 group by 
                     sales_flat_order_address.region')
msalelocval=fetch(msaleLoc,n=-1)
##Sales of an item among  the year by location 
ysaleLocY=dbSendQuery(mydb,'select sum(sales_flat_order.grand_total) as Revenue ,sales_flat_order_address.region as Location from 
                      sales_flat_order,sales_flat_order_address where sales_flat_order.entity_id=sales_flat_order_address.parent_id and YEAR(sales_flat_order.created_at)=2016 group by 
                      sales_flat_order_address.region ')
ysalelocvaly=fetch(ysaleLocY,n=-1)

##Revenue of items among all the years
yrevenue=dbSendQuery(mydb,'select sum(grand_total) as Revenue ,
                     Month(created_at) as Month,
                     Year(created_at) as Year
                     from sales_flat_order 
                     
                     group by  Year
                     ')
yRevenue=fetch(yrevenue,n=-1)
#######calculation of increase in percentage of year wise revenue(2012-2013)##############
ypinc=dbSendQuery(mydb,'select sum(grand_total) as Revenue ,
                  
                  Year(created_at) as Year
                  from sales_flat_order 
                  where Year(created_at)>=2012 group by  Year')
ypincval=fetch(ypinc,n=-1)

y2012=ypincval$Revenue[1]
y2013=ypincval$Revenue[2]
y2014=ypincval$Revenue[3]
y2015=ypincval$Revenue[4]
y2016=ypincval$Revenue[5]
y1213=(((y2013-y2012)/y2012)*100)
y1314=(((y2014-y2013)/y2013)*100)
y1415=(((y2015-y2014)/y2014)*100)
y1516=(((y2016-y2015)/y2015)*100)
yminc.annotation<-c(paste(round(0),"%"),paste(round(y1213,1),"%"),paste(round(y1314,1),"%"),paste(round(y1415,1),"%"),paste(round(y1516,1),"%"))
ysales<-c(round(0),round(y1213,1),round(y1314,1),round(y1415,1),round(y1516,1))
ymval<-cbind(yRevenue,yminc.annotation,ysales)

##### calculating top product in a month  

mTopProduct = dbSendQuery(mydb,'select sum(sales_flat_invoice_item.qty) as Qty, sales_flat_invoice_item.product_id,sales_flat_quote_item.name
                          from sales_flat_invoice_item,sales_flat_quote_item,sales_flat_order 
                          where year(sales_flat_quote_item.updated_at)=2016 and
                          month(sales_flat_quote_item.updated_at)=3 and
                          sales_flat_invoice_item.product_id=sales_flat_quote_item.product_id and
                          sales_flat_order.entity_id=sales_flat_quote_item.quote_id and 
                          sales_flat_order.`status`="complete" group by sales_flat_invoice_item.product_id order by Qty desc limit 1')

mtopproduct= fetch(mTopProduct, n=-1)  
maxQty<-max(mtopproduct$Qty)
############calculating top product in a year
##### 

yTopProduct = dbSendQuery(mydb,'select sum(sales_flat_quote_item.qty) as TotalQty, 
                          sales_flat_quote_item.product_id, sales_flat_quote_item.name 
                          from sales_flat_quote_item,sales_flat_order_item 
                          where YEAR(sales_flat_quote_item.updated_at) = 2016  AND
                          sales_flat_quote_item.product_id = sales_flat_order_item.product_id 
                          group by sales_flat_quote_item.product_id')

ytopproduct= fetch(yTopProduct, n=-1)  
ymaxQty<-max(ytopproduct$TotalQty)

###Revenue By Product Category
Rbycat=dbSendQuery(mydb,'SELECT sum(`qty`) as qty, sum(`total_price`) as Revenue, category_id FROM (SELECT sum(`qty_ordered`) as qty, sum(`row_total`) as total_price, sales_flat_order_item.product_id, catalog_category_product.category_id  FROM `sales_flat_order_item`
                   INNER JOIN catalog_category_product ON catalog_category_product.product_id = sales_flat_order_item.product_id
                   GROUP BY sales_flat_order_item.product_id order by catalog_category_product.category_id desc) as resTable GROUP BY category_id')
Rbycatval=fetch(Rbycat,n=-1)

######Inventory sales by location in a month#####

mInventsales= dbSendQuery(mydb,'select 
                          sales_flat_order_address.region as Location,
                          (sales_flat_invoice.total_qty) as QuantityOrdered
                          
                          from sales_flat_order,sales_flat_order_address,sales_flat_invoice
                          
                          where sales_flat_order.entity_id=sales_flat_order_address.parent_id   
                          
                          and  sales_flat_order.entity_id=sales_flat_invoice.order_id  
                          and year(sales_flat_order.created_at)=2016 and month(sales_flat_order.created_at)=3
                          
                          group by sales_flat_order_address.region')


mIsalesbyRegion = fetch(mInventsales, n=-1)
######Inventory sales by location in a year#####

yInventsales= dbSendQuery(mydb,'select 
                          sales_flat_order_address.region as Location,
                          (sales_flat_invoice.total_qty) as QuantityOrdered
                          
                          from sales_flat_order,sales_flat_order_address,sales_flat_invoice
                          
                          where sales_flat_order.entity_id=sales_flat_order_address.parent_id   
                          
                          and  sales_flat_order.entity_id=sales_flat_invoice.order_id  and
                          year(sales_flat_order.created_at)=2016 
                          
                          group by sales_flat_order_address.region')


yIsalesbyRegion = fetch(yInventsales, n=-1)

##### units per transaction in month ########
mtotalUnitSold = dbSendQuery(mydb,'select sum(sales_flat_invoice_item.qty) as TotalQty
                             from sales_flat_invoice_item,sales_flat_order,sales_flat_invoice
                             where YEAR(sales_flat_order.updated_at)=2016 and MONTH(sales_flat_order.updated_at)=3 and
                             sales_flat_order.entity_id = sales_flat_invoice.order_id and 
                             sales_flat_invoice.entity_id=sales_flat_invoice_item.parent_id and
                             sales_flat_order.status="complete"')

mtotUnitsSold = fetch(mtotalUnitSold, n=-1)

mTransactions=dbSendQuery(mydb,'select count(*) from sales_flat_order where YEAR(updated_at)=2016 and MONTH(updated_at)=3 and status="complete"')

mtotalTransactions=fetch(mTransactions,n=-1)

munitspertransaction<-mtotUnitsSold/mtotalTransactions
################units per transactions in year################
ytotalUnitSold = dbSendQuery(mydb,'select sum(sales_flat_invoice_item.qty) as TotalQty
                             from sales_flat_invoice_item,sales_flat_order,sales_flat_invoice
                             where YEAR(sales_flat_order.updated_at)=2016  and
                             sales_flat_order.entity_id = sales_flat_invoice.order_id and 
                             sales_flat_invoice.entity_id=sales_flat_invoice_item.parent_id and
                             sales_flat_order.status="complete"')

ytotUnitsSold = fetch(ytotalUnitSold, n=-1)

yTransactions=dbSendQuery(mydb,'select count(*) from sales_flat_order where YEAR(updated_at)=2016  and status="complete"')

ytotalTransactions=fetch(yTransactions,n=-1)

yunitspertransaction<-ytotUnitsSold/ytotalTransactions

###################supply chain#########################
####in a month
msupplychain=dbSendQuery(mydb,'select sum(sales_flat_invoice.total_qty) as UnitsOrdered,day(sales_flat_shipment.created_at) as Day,
                         sales_flat_order.`status`,sum(sales_flat_shipment.total_qty) as UnitsShipped,sales_flat_shipment.created_at,sum(sales_flat_invoice.grand_total) as sales from
                         sales_flat_invoice,sales_flat_order,sales_flat_shipment
                         where
                         sales_flat_invoice.order_id=sales_flat_order.entity_id
                         and 
                         sales_flat_invoice.order_id=sales_flat_shipment.order_id
                         and
                         sales_flat_order.`status`="complete"
                         and year(sales_flat_shipment.updated_at)=2016 and month(sales_flat_shipment.created_at)=3
                         group by day(sales_flat_shipment.created_at)
                         ')
msupplychainval=fetch(msupplychain,n=-1)

#################in a year
ysupplychain=dbSendQuery(mydb,'select sum(sales_flat_invoice.total_qty) as UnitsOrdered,Month(sales_flat_shipment.created_at) as Month,
                         sales_flat_order.`status`,sum(sales_flat_shipment.total_qty) as UnitsShipped, sum(sales_flat_invoice.grand_total) as sales,sales_flat_shipment.created_at from
                         sales_flat_invoice,sales_flat_order,sales_flat_shipment
                         where
                         sales_flat_invoice.order_id=sales_flat_order.entity_id
                         and 
                         sales_flat_invoice.order_id=sales_flat_shipment.order_id
                         and
                         sales_flat_order.`status`="complete"
                         and year(sales_flat_shipment.updated_at)=2016 
                         group by Month(sales_flat_shipment.created_at)
                         ')
ysupplychainval=fetch(ysupplychain,n=-1)
#### Visit per Day ########
dVisits=dbSendQuery(mydb,"select count(*) from log_visitor where day(log_visitor.first_visit_at)=26 and 
                    month(log_visitor.first_visit_at)=3 and year(log_visitor.first_visit_at)=2016")
dVisitsperday=fetch(dVisits,n=-1)
###############################comparision of visitors in the curren month(25th nd 26th days))#################
visitorscompare=dbSendQuery(mydb,'select count(*) as visitors ,day(log_visitor.first_visit_at) as day from log_visitor
                            where (day(log_visitor.first_visit_at)>=25 and day(log_visitor.first_visit_at)<=26) and
                            month(log_visitor.first_visit_at)=3 and year(log_visitor.first_visit_at)=2016 
                            group by day')

daywisevisitorscomparision=fetch(visitorscompare,n=-1)

visitorsinday25=daywisevisitorscomparision$visitors[1]
visitorsinday26=daywisevisitorscomparision$visitors[2]
visitorsinday2526=round(((visitorsinday26-visitorsinday25)/visitorsinday25),2)*100
############################### comparision ofnumber of visitors in the current year(2016) with previousyear(2015)#################
visitors201516=dbSendQuery(mydb,'select count(*) as visitors ,year(log_visitor.first_visit_at) as year from log_visitor
                           where year(log_visitor.first_visit_at) >=2015
                           group by year')
yvisitorsin201516=fetch(visitors201516,n=-1)

visitorsinyear2015=yvisitorsin201516$visitors[1]
visitorsinyear2016=yvisitorsin201516$visitors[2]

###########Inventory Availability####################
availStock = dbSendQuery(mydb,'select cataloginventory_stock_status.product_id as Productid,catalog_product_entity_varchar.value as Productname,cataloginventory_stock_status.qty as Quantity
                         
                         from cataloginventory_stock_status,catalog_product_entity,catalog_product_entity_varchar
                         where cataloginventory_stock_status.product_id=catalog_product_entity.entity_id 
                         and catalog_product_entity_varchar.entity_id=catalog_product_entity.entity_id
                         group by cataloginventory_stock_status.product_id;')
availInventoryStock= fetch(availStock, n=-1)
write.csv(availInventoryStock,"mydata.csv")


######Top 10 best Product##########
Products= dbSendQuery(mydb,'select sales_flat_order_item.product_id as Productid,sales_flat_order_item.name as Name,(sales_flat_invoice.total_qty) as Quantity,sales_flat_invoice.grand_total as Sales,sales_flat_order.`status` ,
                      year(sales_flat_order.created_at) as year
                      from sales_flat_order_item,sales_flat_invoice,sales_flat_order
                      where sales_flat_order.entity_id=sales_flat_order_item.item_id and
                      sales_flat_order.entity_id=sales_flat_invoice.entity_id and status="complete"
                      and year(sales_flat_order.created_at)=2016  order by sales_flat_invoice.total_qty desc limit 10;')
TopBestProducts= fetch(Products, n=-1)
######top 5 products in location wise of current year######
locationsale2016 = dbSendQuery(mydb,' select sales_flat_order_item.product_id as Productid,sales_flat_order_item.name as Name,sales_flat_order_address.region as Location,
                               (sales_flat_invoice.total_qty) as Quantity, sum(sales_flat_invoice.grand_total) as sales, sales_flat_order.`status` ,
                               year(sales_flat_order.created_at) as year from 
                               sales_flat_order_item,sales_flat_order_address,sales_flat_invoice,sales_flat_order
                               where sales_flat_order.entity_id=sales_flat_order_item.item_id 
                               and  sales_flat_order.entity_id=sales_flat_invoice.order_id and sales_flat_order.entity_id=sales_flat_order_address.parent_id  
                               and sales_flat_order.status="complete" and year(sales_flat_order.created_at)=2016 group by location order by sales_flat_invoice.total_qty desc limit 10;')
locationwise = fetch(locationsale2016, n=-1) 
# colnames(locationwise)[1]<-"productid"
##Pie Chart Top 10 Product Analysis ######
yTopProSales1=dbSendQuery(mydb,'select sales_flat_order_item.product_id as Productid,sales_flat_order_item.name as Name,
                          (sales_flat_invoice.total_qty) as Qty,sales_flat_order.`status` ,
                          year(sales_flat_order.created_at) as year
                          from sales_flat_order_item,sales_flat_invoice,sales_flat_order
                          where sales_flat_order.entity_id=sales_flat_order_item.item_id and
                          sales_flat_order.entity_id=sales_flat_invoice.order_id and status="complete"
                          and year(sales_flat_order.created_at)=2016 and month(sales_flat_order.created_at)=1 
                          order by sales_flat_invoice.total_qty desc limit 10;')

yTopProSales1=fetch(yTopProSales1,n=-1)

yTopProSales2=dbSendQuery(mydb,'select sales_flat_order_item.product_id as Productid,sales_flat_order_item.name as Name,
                          (sales_flat_invoice.total_qty) as Qty,sales_flat_order.`status` ,
                          year(sales_flat_order.created_at) as year
                          from sales_flat_order_item,sales_flat_invoice,sales_flat_order
                          where sales_flat_order.entity_id=sales_flat_order_item.item_id and
                          sales_flat_order.entity_id=sales_flat_invoice.order_id and status="complete"
                          and year(sales_flat_order.created_at)=2016 and month(sales_flat_order.created_at)=2
                          order by sales_flat_invoice.total_qty desc limit 10;')

yTopProSales2=fetch(yTopProSales2,n=-1)

yTopProSales3=dbSendQuery(mydb,'select sales_flat_order_item.product_id as Productid,sales_flat_order_item.name as Name,
                          (sales_flat_invoice.total_qty) as Qty,sales_flat_order.`status` ,
                          year(sales_flat_order.created_at) as year
                          from sales_flat_order_item,sales_flat_invoice,sales_flat_order
                          where sales_flat_order.entity_id=sales_flat_order_item.item_id and
                          sales_flat_order.entity_id=sales_flat_invoice.order_id and status="complete"
                          and year(sales_flat_order.created_at)=2016 and month(sales_flat_order.created_at)=3 
                          order by sales_flat_invoice.total_qty desc limit 10;')

yTopProSales3=fetch(yTopProSales3,n=-1)
#########maxunits sold for all years######
maxunitssold=dbSendQuery(mydb,'select (sales_flat_invoice.total_qty) as maxunitsorder,
                         year(sales_flat_invoice.created_at) as year,
                         month(sales_flat_invoice.created_at) as month,
                         day(sales_flat_invoice.created_at) as day
                         from sales_flat_invoice
                         where (sales_flat_invoice.total_qty)>1
                         group by year,month,day(sales_flat_invoice.created_at),maxunitsorder ')   
maxunitssold=fetch(maxunitssold,n=-1)
#########################number of units sold in all yearss############################
nunits=dbSendQuery(mydb,'select sum(sales_flat_invoice.total_qty) as qty,
                   year(sales_flat_invoice.created_at) as year
                   
                   from sales_flat_invoice
                   
                   group by year(sales_flat_invoice.created_at)   ')
numberofunitssold=fetch(nunits,n=-1)

###########################Trend in  current month(today and yeasterday) ##################
trend2016=dbSendQuery(mydb,'select year(sales_flat_order.updated_at) as year,count(*) as totalcustomers,sum(sales_flat_invoice.total_qty) as QtyOrdered,
                      
                      (sum((sales_flat_invoice.grand_total))/count(*)) as AvgperCustomer,
                      month(sales_flat_order.updated_at) as month,
                      day(sales_flat_order.updated_at) as day,
                      
                      sum(sales_flat_invoice.grand_total) as Sales
                      
                      from sales_flat_order,sales_flat_invoice
                      
                      where sales_flat_order.entity_id=sales_flat_invoice.order_id 
                      and year(sales_flat_order.updated_at)=2016 
                      and month(sales_flat_order.updated_at)=3 and day(sales_flat_order.updated_at)>=25
                      group by day( sales_flat_order.updated_at)
                      ')
trends2016=fetch(trend2016,n=-1)
########for qty ordered########
yesterdayorder=trends2016$QtyOrdered[1]
todayorder=trends2016$QtyOrdered[2]
trendsinorder2016=round(((todayorder-yesterdayorder)/yesterdayorder)*100,digits = 2)
########for sales##############
yesterdaysales=trends2016$Sales[1]
todaysales=trends2016$Sales[2]
trendsinsales2016=round(((todaysales-yesterdaysales)/yesterdaysales)*100,digits = 2)
#########avg per customer##########
yesterdayAvg=trends2016$AvgperCustomer[1]
todayAvg=trends2016$AvgperCustomer[2]
trendsinAvg2016=round(((todayAvg-yesterdayAvg)/yesterdayAvg)*100,digits = 2)

percentages<-c(0,0,paste(-26.93,downArrow),paste(2.7,upArrow),0,0,paste(-19.62,downArrow))
row2016<-rbind(round(trends2016,2),percentages)

#############location wise quantity sold in the all years######################
years=dbSendQuery(mydb,'select #sales_flat_order_item.product_id as Productid,
                  #sales_flat_order_item.name as Name,
                  sales_flat_order_address.region as Location,
                  sum(sales_flat_invoice.total_qty) as Quantity,sales_flat_order.`status` ,
                  
                  year(sales_flat_order.created_at) as year
                  from sales_flat_order_item,sales_flat_order_address,sales_flat_invoice,sales_flat_order
                  where sales_flat_order.entity_id=sales_flat_order_item.item_id and
                  sales_flat_order.entity_id=sales_flat_invoice.entity_id and sales_flat_order.entity_id=sales_flat_order_address.entity_id  
                  and status="complete"
                  group by year(sales_flat_order.created_at),location')
wholeyears=fetch(years,n=-1)
###############website traffic growth##################
webgrowthin2016=dbSendQuery(mydb,'select count(*) as visitors,
                            month(log_visitor.first_visit_at) as month,year(log_visitor.first_visit_at) as year
                            from log_visitor where month(log_visitor.first_visit_at)>=2 and year(log_visitor.first_visit_at)=2016
                            group by month(log_visitor.first_visit_at),year(log_visitor.first_visit_at);')
webtrafficgrowth2016=fetch(webgrowthin2016,n=-1)
trafficinfeb=webtrafficgrowth2016$visitors[1]
trafficinmarch=webtrafficgrowth2016$visitors[2]
webtrafficgrowthin2016=round(((trafficinmarch-trafficinfeb)/trafficinfeb),2)*100

######################sales analysis for all years in feb and march######################
fbmanalysis=dbSendQuery(mydb,'select sum(grand_total) as Revenue ,Month(created_at) as Month,Year(created_at) as Year 
                        from sales_flat_order 
                        where (Month(created_at) >=2 and Month(created_at)<=3) 
                        and (Year(created_at)>=2013 and year(created_at)<=2016) group by  Year(created_at),month(created_at)')
febmarchanalysis=fetch(fbmanalysis,n=-1)
##############################2013 difference between february and march##################
feb2013=febmarchanalysis$Revenue[1]
march2013=febmarchanalysis$Revenue[2]
fm3=round(((march2013-feb2013)/feb2013)*100,digits = 2)
##############################2014 difference between february and march##################
feb2014=febmarchanalysis$Revenue[3]
march2014=febmarchanalysis$Revenue[4]
fm4=round(((march2014-feb2014)/feb2014)*100,digits = 2)

##############################2015 difference between february and march##################
feb2015=febmarchanalysis$Revenue[5]
march2015=febmarchanalysis$Revenue[6]
fm5=round(((march2015-feb2015)/feb2015)*100,digits = 2)
##############################2016 difference between february and march##################
feb2016=febmarchanalysis$Revenue[7]
march2016=febmarchanalysis$Revenue[8]
fm6=round(((march2016-feb2016)/feb2016)*100,digits = 2)

#################brand wise revenue in the current month(2016)################################
BRevenue=dbSendQuery(mydb,"select sales_flat_order.`status`,
                     (case when sales_flat_order_item.name like 'Yupoong%' then 'Yupoong'
                     
                     when sales_flat_order_item.name like 'Original Chuck%' then 'Original Chuck'
                     when sales_flat_order_item.name like 'Valucap%' then 'Valucap'
                     when sales_flat_order_item.name like '%Next Level Apparel%' then 'Next Level Apparel'
                     when sales_flat_order_item.name like 'Anvil%' then 'Anvil'
                     when sales_flat_order_item.name like 'Cirque Mountain Apparel%' then 'Cirque Mountain Apparel'
                     
                     when sales_flat_order_item.name like 'Independent Trading%' then 'Independent Trading Company'
                     
                     when sales_flat_order_item.name like 'Gildan%' then 'Gildan'
                     when sales_flat_order_item.name like 'Flexfit%' then 'Flexfit'
                     when sales_flat_order_item.name like 'B%+C%' then 'Bella + Canvas'
                     end) as Brand,
                     sum(sales_flat_order_item.row_total) as Revenue,
                     sum(sales_flat_order_item.qty_ordered) as Qty from sales_flat_order_item,sales_flat_order
                     where year(sales_flat_order_item.updated_at)=2016 and month(sales_flat_order_item.updated_at)=3 and
                     sales_flat_order.entity_id=sales_flat_order_item.order_id and
                     
                     sales_flat_order.`status`='complete'
                     group by Brand ")
BrandRevenue=fetch(BRevenue,n=-1)
BrandRevenue[1,2]<-"others"
#################brand wise revenue in the current year(2016)################################
YBRevenue=dbSendQuery(mydb,"select sales_flat_order.`status`,
                      (case when sales_flat_order_item.name like 'Yupoong%' then 'Yupoong'
                      
                      when sales_flat_order_item.name like 'Original Chuck%' then 'Original Chuck'
                      when sales_flat_order_item.name like 'Valucap%' then 'Valucap'
                      when sales_flat_order_item.name like '%Next Level Apparel%' then 'Next Level Apparel'
                      when sales_flat_order_item.name like 'Anvil%' then 'Anvil'
                      when sales_flat_order_item.name like 'Cirque Mountain Apparel%' then 'Cirque Mountain Apparel'
                      
                      when sales_flat_order_item.name like 'Independent Trading%' then 'Independent Trading Company'
                      
                      when sales_flat_order_item.name like 'Gildan%' then 'Gildan'
                      when sales_flat_order_item.name like 'Flexfit%' then 'Flexfit'
                      when sales_flat_order_item.name like 'B%+C%' then 'Bella + Canvas'
                      end) as Brand,
                      sum(sales_flat_order_item.row_total) as Revenue,
                      sum(sales_flat_order_item.qty_ordered) as Qty from sales_flat_order_item,sales_flat_order
                      where year(sales_flat_order_item.updated_at)=2016  and
                      sales_flat_order.entity_id=sales_flat_order_item.order_id and
                      
                      sales_flat_order.`status`='complete'
                      group by Brand ")
YBrandRevenue=fetch(YBRevenue,n=-1)
YBrandRevenue[1,2]<-"others"
#####Brand 15
######################## Difference in % Revenue and Quantity Year 2015 and 2016 ####################

ysalebrand16=dbSendQuery(mydb,"select (case when sales_flat_order_item.name like 'Yupoong%' then 'Yupoong'
                         when sales_flat_order_item.name like 'Original Chuck%' then 'Original Chuck'
                         when sales_flat_order_item.name like 'Valucap%' then 'Valucap'
                         when sales_flat_order_item.name like '%Next Level Apparel%' then 'Next Level Apparel'
                         when sales_flat_order_item.name like 'Anvil%' then 'Anvil'
                         when sales_flat_order_item.name like 'Cirque Mountain Apparel%' then 'Cirque Mountain Apparel'
                         when sales_flat_order_item.name like 'Independent Trading%' then 'Independent Trading Company'
                         when sales_flat_order_item.name like 'Gildan%' then 'Gildan'
                         when sales_flat_order_item.name like 'Flexfit%' then 'Flexfit'
                         when sales_flat_order_item.name like 'B%+C%' then 'Bella + Canvas'
                         end) as Brand,
                         sum(sales_flat_order_item.row_total) as CurrentYear,
                         sum(sales_flat_order_item.qty_ordered) as CurrentYearQty from sales_flat_order_item,sales_flat_order
                         where year(sales_flat_order_item.updated_at)=2016 and 
                         sales_flat_order.entity_id=sales_flat_order_item.order_id and
                         sales_flat_order.`status`='complete'
                         group by Brand ")
ysalebrand16=fetch(ysalebrand16,n=-1)
ysalebrand16[1,1]<-"Others"
ysalebrand16<-ysalebrand16[-2,]  
# ysalebrand16<-ysalebrand16[-1,] 


ysalebrand15=dbSendQuery(mydb,"select(case when sales_flat_order_item.name like 'Yupoong%' then 'Yupoong'
                         when sales_flat_order_item.name like 'Original Chuck%' then 'Original Chuck'
                         when sales_flat_order_item.name like 'Valucap%' then 'Valucap'
                         when sales_flat_order_item.name like '%Next Level Apparel%' then 'Next Level Apparel'
                         when sales_flat_order_item.name like 'Anvil%' then 'Anvil'
                         when sales_flat_order_item.name like 'Cirque Mountain Apparel%' then 'Cirque Mountain Apparel'
                         when sales_flat_order_item.name like 'Independent Trading%' then 'Independent Trading Company'
                         when sales_flat_order_item.name like 'Gildan%' then 'Gildan'
                         when sales_flat_order_item.name like 'Flexfit%' then 'Flexfit'
                         when sales_flat_order_item.name like 'B%+C%' then 'Bella + Canvas'
                         end) as Brand15,
                         sum(sales_flat_order_item.row_total) as LastYear,
                         sum(sales_flat_order_item.qty_ordered) as LastYearQty from sales_flat_order_item,sales_flat_order
                         where year(sales_flat_order_item.updated_at)=2015 and 
                         sales_flat_order.entity_id=sales_flat_order_item.order_id and
                         sales_flat_order.`status`='complete'
                         group by Brand15 ")




ysalebrand15=fetch(ysalebrand15,n=-1)
ysalebrand15[1,1]<-"Others" 
ysalebrand15<-ysalebrand15[-c(6,7),] #####


yOtherrev<-round(((ysalebrand16$CurrentYear[1]-ysalebrand15$LastYear[1])/ysalebrand15$LastYear[1])*100,2)    #### Change Others
yOtherqty<-round(((ysalebrand16$CurrentYearQty[1]-ysalebrand15$LastYearQty[1])/ysalebrand15$LastYearQty[1])*100,2)                ####### Change Others


yFlexfitrev<-round(((ysalebrand16$CurrentYear[2]-ysalebrand15$LastYear[2])/ysalebrand15$LastYear[2])*100,2)

yFlexfitqty<-round(((ysalebrand16$CurrentYearQty[2]-ysalebrand15$LastYearQty[2])/ysalebrand15$LastYearQty[2])*100,2)


ygildanRev=round(((ysalebrand16$CurrentYear[3]-ysalebrand15$LastYear[3])/ysalebrand15$LastYear[3])*100,2)

ygildanQty=round(((ysalebrand16$CurrentYearQty[3]-ysalebrand15$LastYearQty[3])/ysalebrand15$LastYearQty[3])*100,2)


yindiRev=round(((ysalebrand16$CurrentYear[4]-ysalebrand15$LastYear[4])/ysalebrand15$LastYear[4])*100,2)

yindiQty=round(((ysalebrand16$CurrentYearQty[4]-ysalebrand15$LastYearQty[4])/ysalebrand15$LastYearQty[4])*100,2)



ynextlevelRev=round(((ysalebrand16$CurrentYear[5]-ysalebrand15$LastYear[5])/ysalebrand15$LastYear[5])*100,2)

ynextlevelQty=round(((ysalebrand16$CurrentYearQty[5]-ysalebrand15$LastYearQty[5])/ysalebrand15$LastYearQty[5])*100,2)



yyupRev=round(((ysalebrand16$CurrentYear[6]-ysalebrand15$LastYear[6])/ysalebrand15$LastYear[6])*100,2)

yyupQty=round(((ysalebrand16$CurrentYearQty[6]-ysalebrand15$LastYearQty[6])/ysalebrand15$LastYearQty[6])*100,2)

GrowthinSales<-c(paste(yOtherrev,downArrow),paste(yFlexfitrev,upArrow),paste(ygildanRev,downArrow),paste(yindiRev,downArrow),paste(ynextlevelRev,downArrow),paste(yyupRev,downArrow))
GrowthinQuantity<-c(paste(yOtherqty,downArrow),paste(yFlexfitqty,upArrow),paste(ygildanQty,downArrow),paste(yindiQty,downArrow),paste(ynextlevelQty,downArrow),paste(yyupQty,upArrow))

bellacanvas<-c("Bella Canvas",0,0,"Bella Canvas",1383.69,357,100,100)   ####### Change 04/03/2017
orginalchuck<-c("Orginal Chuck",137.60,176,"Orginal Chuck",0,0,0,0)       ####### Change 04/03/2017
valucap<-c("Valu Cap",1737.60,1054,"Valu Cap",0,0,0,0)                    ####### Change 04/03/2017


ybrandsale=cbind(ysalebrand15,ysalebrand16,GrowthinSales,GrowthinQuantity)
ybrandsale<-rbind(ybrandsale,bellacanvas,orginalchuck,valucap)    #

##############month analysis of +/- in Sales and Quantity
msalebrand16mar=dbSendQuery(mydb,"select (case when sales_flat_order_item.name like 'Yupoong%' then 'Yupoong'
                            when sales_flat_order_item.name like 'Original Chuck%' then 'Original Chuck'
                            when sales_flat_order_item.name like 'Valucap%' then 'Valucap'
                            when sales_flat_order_item.name like '%Next Level Apparel%' then 'Next Level Apparel'
                            when sales_flat_order_item.name like 'Anvil%' then 'Anvil'
                            when sales_flat_order_item.name like 'Cirque Mountain Apparel%' then 'Cirque Mountain Apparel'
                            when sales_flat_order_item.name like 'Independent Trading%' then 'Independent Trading Company'
                            when sales_flat_order_item.name like 'Gildan%' then 'Gildan'
                            when sales_flat_order_item.name like 'Flexfit%' then 'Flexfit'
                            when sales_flat_order_item.name like 'B%+C%' then 'Bella + Canvas'
                            end) as Brand,
                            sum(sales_flat_order_item.row_total) as CurrentMonthSales,
                            sum(sales_flat_order_item.qty_ordered) as CurrentmonthQty from sales_flat_order_item,sales_flat_order
                            where year(sales_flat_order_item.updated_at)=2016 and month(sales_flat_order_item.updated_at)=3 and
                            sales_flat_order.entity_id=sales_flat_order_item.order_id and
                            sales_flat_order.`status`='complete'
                            group by Brand ")
msalebrand16mar=fetch(msalebrand16mar,n=-1)
msalebrand16mar[1,1]<-"Other"                           ##Chage04/03/2017  add others
msalebrand16mar<-msalebrand16mar[-2,]   


msalebrand16feb=dbSendQuery(mydb,"select(case when sales_flat_order_item.name like 'Yupoong%' then 'Yupoong'
                            when sales_flat_order_item.name like 'Original Chuck%' then 'Original Chuck'
                                  when sales_flat_order_item.name like 'Valucap%' then 'Valucap'
                            when sales_flat_order_item.name like '%Next Level Apparel%' then 'Next Level Apparel'
                            when sales_flat_order_item.name like 'Anvil%' then 'Anvil'
                            when sales_flat_order_item.name like 'Cirque Mountain Apparel%' then 'Cirque Mountain Apparel'
                            when sales_flat_order_item.name like 'Independent Trading%' then 'Independent Trading Company'
                            when sales_flat_order_item.name like 'Gildan%' then 'Gildan'
                            when sales_flat_order_item.name like 'Flexfit%' then 'Flexfit'
                            when sales_flat_order_item.name like 'B%+C%' then 'Bella + Canvas'
                            end) as Brand,
                            sum(sales_flat_order_item.row_total) as Revenue,
                            sum(sales_flat_order_item.qty_ordered) as Qty from sales_flat_order_item,sales_flat_order
                            where year(sales_flat_order_item.updated_at)=2016 and month(sales_flat_order_item.updated_at)=2 and
                            sales_flat_order.entity_id=sales_flat_order_item.order_id and
                            sales_flat_order.`status`='complete'
                            group by Brand ")

msalebrand16feb=fetch(msalebrand16feb,n=-1)
msalebrand16feb[1,1]<-"Others"

otherRevper16mar=round(((msalebrand16mar$CurrentMonthSales[1]-msalebrand16feb$Revenue[1])/msalebrand16feb$Revenue[1])*100,2)  ##Chage04/03/2017

otherQtyper16mar=round(((msalebrand16mar$CurrentmonthQty[1]-msalebrand16feb$Qty[1])/msalebrand16feb$Qty[1])*100,2)          ### Chage04/03/2017


flexfitRevInper16mar=round(((msalebrand16mar$CurrentMonthSales[2]-msalebrand16feb$Revenue[2])/msalebrand16feb$Revenue[2])*100,2)    ### Revenue difference in percentage

flexfitQtyDeper16mar=round(((msalebrand16mar$CurrentmonthQty[2]-msalebrand16feb$Qty[2])/msalebrand16feb$Qty[2])*100,2)               ###### Qty difference in percentage


gildanRevDeper16mar=round(((msalebrand16mar$CurrentMonthSales[3]-msalebrand16feb$Revenue[3])/msalebrand16feb$Revenue[3])*100,2)

gildanQtyDeper16mar=round(((msalebrand16mar$CurrentmonthQty[3]-msalebrand16feb$Qty[3])/msalebrand16feb$Qty[3])*100,2)


indiRevDeper16mar=round(((msalebrand16mar$CurrentMonthSales[4]-msalebrand16feb$Revenue[4])/msalebrand16feb$Revenue[4])*100,2)

indiQtyDeper16mar=round(((msalebrand16mar$CurrentmonthQty[4]-msalebrand16feb$Qty[4])/msalebrand16feb$Qty[4])*100,2)



nextRevInper16mar=round(((msalebrand16mar$CurrentMonthSales[5]-msalebrand16feb$Revenue[5])/msalebrand16feb$Revenue[5])*100,2)

nextQtyInper16mar=round(((msalebrand16mar$CurrentmonthQty[5]-msalebrand16feb$Qty[5])/msalebrand16feb$Qty[5])*100,2)



yupRevDeper16mar=round(((msalebrand16mar$CurrentMonthSales[6]-msalebrand16feb$Revenue[6])/msalebrand16feb$Revenue[6])*100,2)

yupQtyDeper16mar=round(((msalebrand16mar$CurrentmonthQty[6]-msalebrand16feb$Qty[6])/msalebrand16feb$Qty[6])*100,2)



SalesGrowth<-c(paste(-38.04,downArrow),paste(1.45,upArrow),paste(-23.27,downArrow),paste(-14.47,downArrow),paste(3.9,upArrow),paste(-25.63,downArrow)) 
QuantityGrowth<-c(paste(-31.05,downArrow),paste(-1.44,downArrow),paste(-30.22,downArrow),paste(-13.28,downArrow),paste(3.39,upArrow),paste(-27.16,downArrow)) 

LastMonthSales<-msalebrand16feb$Revenue
LastmonthQty<-msalebrand16feb$Qty
msalebrand16mar<-cbind(msalebrand16mar,SalesGrowth,QuantityGrowth,LastmonthQty,LastMonthSales)
bellacanvas<-c("Bella Canvas",1383.69,357,100,100,0,0)             ##### Chage04/03/2017
msalebrand16mar<-rbind(msalebrand16mar,bellacanvas)                ####Chage04/03/2017

##########calculation of kpi to find the growth/Fall in percentages in the year(2016-2015)###################################
y20156=dbSendQuery(mydb,'select sum(grand_total) as Revenue ,
                   
                   Year(created_at) as Year
                   from sales_flat_order 
                   where Year(created_at)>=2015 group by  Year')
yper201516=fetch(y20156,n=-1)
ydata2015=yper201516$Revenue[1]
ydata2016=yper201516$Revenue[2]
difference=ydata2016-ydata2015
mincreaseorfallperyear2016=(difference/ydata2015)*100

##########calculation of kpi to find the growth/Fall in percentages in the year(2015-2014)###################################
y201415=dbSendQuery(mydb,'select sum(grand_total) as Revenue ,
                    
                    Year(created_at) as Year
                    from sales_flat_order 
                    where (Year(created_at)>=2014 and Year(created_at)<=2015) group by  Year')
yper201415=fetch(y201415,n=-1)
ydata2014=yper201415$Revenue[1]
ydata2015=yper201415$Revenue[2]
difference=ydata2015-ydata2014
mincreaseorfallperyear2016=(difference/ydata2014)*100


############################finding the number of visitors in all years ##################
ywebtraffic=dbSendQuery(mydb,'select count(*) as visitors,
                        year(log_visitor.first_visit_at) as year
                        from log_visitor 
                        group by year(log_visitor.first_visit_at)
                        ')
yearwebtraffic=fetch(ywebtraffic,n=-1)
#print(yearwebtraffic)

#################calculating the growth/fall in percentages b/w (2012-2013)################
trafficin2012=yearwebtraffic$visitors[1]
trafficin2013=yearwebtraffic$visitors[2]
webtrafficgrowthin201213=round(((trafficin2013-trafficin2012)/trafficin2012),2)*100

#################calculating the growth/fall in percentages b/w (2013-2014)################
trafficin2013=yearwebtraffic$visitors[2]
trafficin2014=yearwebtraffic$visitors[3]
webtrafficgrowthin201314=round(((trafficin2014-trafficin2013)/trafficin2013),2)*100

#################calculating the growth/fall in percentages b/w (2014-2015)################
trafficin2014=yearwebtraffic$visitors[3]
trafficin2015=yearwebtraffic$visitors[4]
webtrafficgrowthin201415=round(((trafficin2015-trafficin2014)/trafficin2014),2)*100

#################calculating the growth/fall in percentages b/w (2015-2016)################
trafficin2015=yearwebtraffic$visitors[4]
trafficin2016=yearwebtraffic$visitors[5]
webtrafficgrowthin201516=round(((trafficin2016-trafficin2015)/trafficin2015),2)*100
########################top customer for current month#############
mtopcustomer=dbSendQuery(mydb,"select sales_flat_order_address.firstname as Name,sales_flat_order_address.lastname ,sum(sales_flat_order.grand_total) as Revenue 
                         from sales_flat_order_address,sales_flat_order
                         where sales_flat_order_address.parent_id=sales_flat_order.entity_id and sales_flat_order.`status`='complete' 
                         and year(sales_flat_order.updated_at)=2016 and month(sales_flat_order.updated_at)=3
                         group by Name order by Revenue desc limit 1
                         ;")
mtopcust=fetch(mtopcustomer,n=-1)
topcustomercurrentmonth<-mtopcust$Name
topcustomerlname<-mtopcust$lastname
########################top customer for current year#############
ytopcustomer=dbSendQuery(mydb,"select sales_flat_order_address.firstname as Name,sales_flat_order_address.lastname ,sum(sales_flat_order.grand_total) as Revenue 
                         from sales_flat_order_address,sales_flat_order
                         where sales_flat_order_address.parent_id=sales_flat_order.entity_id and sales_flat_order.`status`='complete' 
                         and year(sales_flat_order.updated_at)=2016 
                         group by Name order by Revenue desc limit 1
                         ;")
ytopcust=fetch(ytopcustomer,n=-1)
topcustomercurrentyear<-ytopcust$Name

###############top customer for current month by items order########################
mtopcustomerbyitem=dbSendQuery(mydb,"select sales_flat_order_address.firstname as Name,sales_flat_order_address.lastname ,sales_flat_order.total_qty_ordered as Itemcount 
                               from sales_flat_order_address,sales_flat_order
                               where sales_flat_order_address.parent_id=sales_flat_order.entity_id and sales_flat_order.`status`='complete' 
                               and year(sales_flat_order.updated_at)=2016 and month(sales_flat_order.updated_at)=3
                               group by Name order by Itemcount desc limit 1
                               ;")
mtopcustbyitem=fetch(mtopcustomerbyitem,n=-1)
topcustomercurrentmonthbyitem<-mtopcustbyitem$Name
#################top customer for current year by items order########################
ytopcustomerbyitem=dbSendQuery(mydb,"select sales_flat_order_address.firstname as Name,sales_flat_order_address.lastname ,sales_flat_order.total_qty_ordered as Itemcount 
                               from sales_flat_order_address,sales_flat_order
                               where sales_flat_order_address.parent_id=sales_flat_order.entity_id and sales_flat_order.`status`='complete' 
                               and year(sales_flat_order.updated_at)=2016 
                               group by Name order by Itemcount desc limit 1
                               ;")
ytopcustbyitem=fetch(ytopcustomerbyitem,n=-1)
topcustomerforcurrentyearbyitem<-ytopcustbyitem$Name
################ New Customer Revenue % ####################################
mnewCustmerval=dbSendQuery(mydb,"SELECT COUNT(*) AS grand_count,sum(Grand_Total) as Revenue FROM( SELECT customer_email,
                           SUM(sales_flat_order.grand_total) as Grand_Total 
                           FROM sales_flat_order WHERE sales_flat_order.status='complete' 
                           AND year(sales_flat_order.updated_at)=2016 and 
                           month(sales_flat_order.updated_at)=3 GROUP BY 
                           customer_email HAVING COUNT(*) = 1)s")

mnewCustmerRev=fetch(mnewCustmerval,n=-1)
mtotalrev<-dbSendQuery(mydb,"select sum(grand_total) as Total from sales_flat_order 
                       where `status`='complete' and 
                       year(updated_at)=2016 and month(updated_at)=3;")
mtotalrev<-fetch(mtotalrev,n=-1)

mNewCustmerper=round(((mnewCustmerRev$`sum(Grand_Total)`/mtotalrev$Total)*100),2)

mRepeatCustmerval=dbSendQuery(mydb,"SELECT COUNT(*) AS grand_count,sum(Grand_Total) as Revenue FROM( SELECT customer_email,
                              SUM(sales_flat_order.grand_total) as Grand_Total 
                              FROM sales_flat_order WHERE sales_flat_order.status='complete' 
                              AND year(sales_flat_order.updated_at)=2016 and 
                              month(sales_flat_order.updated_at)=3 GROUP BY 
                              customer_email HAVING COUNT(*) > 1)s")
mRepeatCustmerRev<-fetch(mRepeatCustmerval,n=-1)

mRepeatCustmerper<-round(((mRepeatCustmerRev$`sum(Grand_Total)`/mtotalrev$Total)*100),2)

# print(mRepeatCustmerper)
####################Order picking per cuurent year##############
ordercurrentyear=dbSendQuery(mydb,'select count(*) as ordercount from sales_flat_order where year(updated_at)>=2015  and status NOT LIKE "canceled"
                             AND sales_flat_order.status NOT LIKE "closed"
                             AND sales_flat_order.status NOT LIKE "fraud"
                             AND sales_flat_order.status NOT LIKE "holded"
                             AND sales_flat_order.status NOT LIKE "paypal_canceled_reversal" group by year(updated_at)')
orderperyear=fetch(ordercurrentyear,n=-1)
# print(orderperyear)
order15=orderperyear$ordercount[1]
order16=orderperyear$ordercount[2]
# orderrate=((order16-order15)/order15)*100
################################quarter wise year calculations######################################################

#####################-----------------------growth/fall in sales in the years(2016 & 2015) up to 3 months----------------#################---
quartersales=dbSendQuery(mydb,'select year(sales_flat_order.created_at) as year,
                         sum(sales_flat_order.grand_total) as sales 
                         from sales_flat_order
                         where (month(sales_flat_order.created_at)>=1 and month(sales_flat_order.created_at)<=3)
                         and year(sales_flat_order.created_at)>=2015  group by year ;')

yquartersalesin201516=fetch(quartersales,n=-1)

quartersalesin2015=yquartersalesin201516$sales[1]
quartersalesin2016=yquartersalesin201516$sales[2]
salesq1<-cbind(quartersalesin2015,quartersalesin2016)
# quartersalesinyear201516=round(((quartersalesin2016-quartersalesin2015)/quartersalesin2015),2)*100  


#######################-------------------comparision ofnumber of visitors in the current year(2016) with previousyear(2015)---------------
quartervisitors201516=dbSendQuery(mydb,'
                                  select count(*) as visitors ,year(log_visitor.first_visit_at) as year 
                                  from log_visitor
                                  where year(log_visitor.first_visit_at) >=2015
                                  and (month(log_visitor.first_visit_at)>=1 and month(log_visitor.first_visit_at)<=3)
                                  
                                  group by year')
yvisitorsinquarter201516=fetch(quartervisitors201516,n=-1)

quartervisitorsinyear2015=yvisitorsinquarter201516$visitors[1]
quartervisitorsinyear2016=yvisitorsinquarter201516$visitors[2]
visitorsq1<-cbind(quartervisitorsinyear2016,quartervisitorsinyear2015)

################--------------------Order picking per (2015-2016) only for quarter-------------------##############

orderquarteryear=dbSendQuery(mydb,'select count(*) as ordercount ,year(sales_flat_order.updated_at) as year
                             from sales_flat_order where year(updated_at)>=2015  and status NOT LIKE "canceled"
                             AND sales_flat_order.status NOT LIKE "closed"
                             AND sales_flat_order.status NOT LIKE "fraud"
                             AND sales_flat_order.status NOT LIKE "holded"
                             AND sales_flat_order.status NOT LIKE "paypal_canceled_reversal" 
                             and (month(sales_flat_order.updated_at)>=1 and month(sales_flat_order.updated_at)<=3)
                             group by year(updated_at)')
orderquarterperyear201516=fetch(orderquarteryear,n=-1)
quarterorder2015=orderquarterperyear201516$ordercount[1]
quarterorder2016=orderquarterperyear201516$ordercount[2]
q1order<-cbind(quarterorder2016,quarterorder2015)
# orderratein201516=((quarterorder2016-quarterorder2015)/quarterorder2015)*100


##############-----------------avg order value for the years 2015-2016(quarterwise)-------------------##########################
YAvg_Order201516=dbSendQuery(mydb,'select sum(grand_total)/count(*) as AvgOrderValue ,year(sales_flat_order.updated_at) as year
                             from sales_flat_order where status="complete" and year(sales_flat_order.updated_at)>=2015
                             and (month(sales_flat_order.updated_at)>=1 and month(sales_flat_order.updated_at)<=3)
                             
                             group by year')
YAvg_Value201516=fetch(YAvg_Order201516,n=-1)

yavgvalue2015=YAvg_Value201516$AvgOrderValue[1]
yavgvalue2016=YAvg_Value201516$AvgOrderValue[2]
q1avgorder<-cbind(yavgvalue2016,yavgvalue2015)
# Avg_Inc201516=((yavgvalue2016-yavgvalue2015)/yavgvalue2015)*100




#########(for inventory)

###########-----------------Average inventory sold in a year per month(quarter wise)-----------------------
yavgInvent2016=dbSendQuery(mydb,'select sum(sales_flat_order.total_qty_ordered) as AvgInventory,
                           year(sales_flat_order.created_at ) as year
                           from  sales_flat_order
                           where sales_flat_order.status= "complete" and year(sales_flat_order.created_at)=2016 
                           and (month(sales_flat_order.created_at)>=1 and month(sales_flat_order.created_at)<=3)
                           group by year ;')

yInvent2016=fetch(yavgInvent2016,n=-1)

yavgInvent2015=dbSendQuery(mydb,'select sum(sales_flat_order.total_qty_ordered) as AvgInventory,
                           year(sales_flat_order.created_at ) as year
                           from  sales_flat_order
                           where sales_flat_order.status= "complete" and year(sales_flat_order.created_at)=2015 
                           and (month(sales_flat_order.created_at)>=1 and month(sales_flat_order.created_at)<=3)
                           group by year ;')

yInvent2015=fetch(yavgInvent2015,n=-1)

yavginvent2016=(yInvent2016$AvgInventory)/3
yavginvent2015=(yInvent2015$AvgInventory)/3

quartercomparisionof201516=((yavginvent2016-yavginvent2015)/yavginvent2015)*100

################################Prediction######################################
###############Revenue in quarter2(2013-2015) analysis########################
###############Revenue in quarter 1###############

Revenueinq1<-c(177305.1500,156696.6500,167589.9700)
Month<-c("Jan","Feb","March")
q1dataforRevenue<-data.frame(Revenueinq1,Month)


trendsq2=dbSendQuery(mydb,"select sum(grand_total) as Revenue ,Month(created_at) as Month,Year(created_at) as Year 
                     from sales_flat_order 
                     where (Month(created_at) >=4 and Month(created_at)<=6) 
                     and (Year(created_at)>=2013 and year(created_at)<=2015) 
                     group by  Year(created_at),month(created_at)")
trendsinq2201315=fetch(trendsq2,n=-1)

indexq2 <- sample(1:nrow(trendsinq2201315),size = 0.7*nrow(trendsinq2201315)) 
traindatainq2 <- trendsinq2201315[indexq2,] 
testdatainq2 <- trendsinq2201315 [-indexq2,]

lminq2<-lm(Revenue~Month+Year,traindatainq2)

predictioninq2<-predict(lminq2,testdatainq2)

p2<-predict(lminq2)

p2<-predict(lminq2,interval="confidence")
clowerlimit<-c(130613.20,149583.37,146447.67)
cupperlimit<-c(209495.79,213089.89,238789.86)

p2<-predict(lminq2,interval="prediction")
plowerlimit<-c(101319.770,116706.017,119813.433)
pupperlimit<-c(238789.2,245967.2,265424.1)

PredictedRevenueinq2<-c(170054.50,181336.63,192618.77)
Month<-c("April","May","June")

q2dataforRevenue<-data.frame(PredictedRevenueinq2,Month,plowerlimit,pupperlimit)


###############Revenue in quarter3(2013-2015) analysis########################
trendsq3=dbSendQuery(mydb,"select sum(grand_total) as Revenue ,Month(created_at) as Month,Year(created_at) as Year 
                     from sales_flat_order 
                     where (Month(created_at) >=7 and Month(created_at)<=9) 
                     and (Year(created_at)>=2013 and year(created_at)<=2015) 
                     group by  Year(created_at),month(created_at)")
trendsinq3201315=fetch(trendsq3,n=-1)

indexq3 <- sample(1:nrow(trendsinq3201315),size = 0.7*nrow(trendsinq3201315)) 
traindatainq3 <- trendsinq3201315[indexq3,] 
testdatainq3<- trendsinq3201315 [-indexq3,]

lminq3<-lm(Revenue~Month+Year,traindatainq3)

predictioninq3<-predict(lminq3,testdatainq3)

p3<-predict(lminq3)

p3<-predict(lminq3,interval="confidence")
clowerlimit<-c(173923.21,191267.30,185963.48)
cupperlimit<-c(254740.0,256331.0,280570.0)

p3<-predict(lminq3,interval="prediction")
plowerlimit<-c(143911.48,157583.78,158676.15)
pupperlimit<-c(284751.8,290014.6,307857.3)




PredictedRevenueinq3<-c(214331.63,223799.17,233266.72)
Month<-c("July","August","September")

q3dataforRevenue<-data.frame(PredictedRevenueinq3,Month,plowerlimit,pupperlimit)


###############Revenue in quarter4(2013-2015) analysis########################
trendsq4=dbSendQuery(mydb,"select sum(grand_total) as Revenue ,Month(created_at) as Month,Year(created_at) as Year 
                     from sales_flat_order 
                     where (Month(created_at) >=10 and Month(created_at)<=12) 
                     and (Year(created_at)>=2013 and year(created_at)<=2015) 
                     group by  Year(created_at),month(created_at)")
trendsinq4201315=fetch(trendsq4,n=-1)

indexq4 <- sample(1:nrow(trendsinq4201315),size = 0.7*nrow(trendsinq4201315)) 
traindatainq4 <- trendsinq4201315[indexq4,] 
testdatainq4<- trendsinq4201315 [-indexq4,]

lminq4<-lm(Revenue~Month+Year,traindatainq4)

predictioninq4<-predict(lminq3,testdatainq4)

p4<-predict(lminq4)

p4<-predict(lminq4,interval="confidence")
clowerlimit<-c(173732.273,169118.619,141787.799)
cupperlimit<- c(281460.1,248517.0,238291.1)

p4<-predict(lminq4,interval="prediction")
plowerlimit<-c(138624.5448,127634.9472,104348.9918)
pupperlimit<- c(316567.9,290000.7,275729.9)


PredictedRevenueinq4<-c(227596.21,208817.83,190039.46)
Month<-c("October","November","December")

q4dataforRevenue<-data.frame(PredictedRevenueinq4,Month,plowerlimit,pupperlimit)



###############Total revenues in all quarters(sum)##########

TotalRevenueinQ1<-sum(Revenueinq1)
TotalRevenueinQ2<-sum(PredictedRevenueinq2)
TotalRevenueinQ3<-sum(PredictedRevenueinq3)
TotalRevenueinQ4<-sum(PredictedRevenueinq4)

  ##########number of visitors in q1##############

visitorsq1<-c(55371,59321,49380)
Month<-c("Jan","Feb","March")
q1dataforVisitors<-data.frame(visitorsq1,Month)


###########number of visitors in q2(2013-15)#####################
visitorsq2=dbSendQuery(mydb,'select count(*) as visitors,
                       year(log_visitor.first_visit_at) as year,
                       month(log_visitor.first_visit_at) as month
                       from log_visitor 
                       where (year(log_visitor.first_visit_at)>=2013 and year(log_visitor.first_visit_at)<=2015)
                       and (month(log_visitor.first_visit_at)>=4 and month(log_visitor.first_visit_at)<=6)
                       group by year(log_visitor.first_visit_at),month(log_visitor.first_visit_at)
                       ')

visitorsinq2201315=fetch(visitorsq2,n=-1)

visitorsq2 <- sample(1:nrow(visitorsinq2201315),size = 0.7*nrow(visitorsinq2201315)) 
visitorstraindataq2 <- visitorsinq2201315[visitorsq2,] 
visitorstestdataq2<- visitorsinq2201315 [-visitorsq2,]

vislminq2<-lm(visitors~month+year,visitorstraindataq2)

vispredictioninq2<-predict(vislminq2,visitorstestdataq2)

p2<-predict(vislminq2)

p2<-predict(vislminq2,interval="confidence")
clowerlimit<-c(35301.33,39577.45,41736.79)
cupperlimit<-c(42623.28,44409.29,48312.09)


p2<-predict(vislminq2,interval="prediction")
plowerlimit<-c(33306.01,37050.95,39602.31)
pupperlimit<-c(44618.59,46935.80,50446.58)


PreictedVisitorsinq2<-c(38962.30,41993.37,45024.44)
Month<-c("April","May","June")
q2dataforVisitors<-data.frame(PreictedVisitorsinq2,Month,plowerlimit,pupperlimit)


###########number of visitors in q3(2013-15)#####################
visitorsq3=dbSendQuery(mydb,'select count(*) as visitors,
                       year(log_visitor.first_visit_at) as year,
                       month(log_visitor.first_visit_at) as month
                       from log_visitor 
                       where (year(log_visitor.first_visit_at)>=2013 and year(log_visitor.first_visit_at)<=2015)
                       and (month(log_visitor.first_visit_at)>=7 and month(log_visitor.first_visit_at)<=9)
                       group by year(log_visitor.first_visit_at),month(log_visitor.first_visit_at)
                       ')

visitorsinq3201315=fetch(visitorsq3,n=-1)

visitorsq3 <- sample(1:nrow(visitorsinq3201315),size = 0.7*nrow(visitorsinq3201315)) 
visitorstraindataq3 <- visitorsinq3201315[visitorsq3,] 
visitorstestdataq3<- visitorsinq3201315 [-visitorsq3,]

vislminq3<-lm(visitors~month+year,visitorstraindataq3)

vispredictioninq3<-predict(vislminq3,visitorstestdataq3)

p3<-predict(vislminq3)


p3<-predict(vislminq3,interval="confidence")
clowerlimit<-c(34383.21,39196.27,38697.67)
cupperlimit<-c(56947.29,57760.93,63886.23)



p3<-predict(vislminq3,interval="prediction")
plowerlimit<-c(25629.402,29496.699,30488.904)
pupperlimit<-c(65701.10,67460.50,72095.00)




PreictedVisitorsinq3<-c(45665.25,48478.60,51291.95)
Month<-c("July","August","September")
q3dataforVisitors<-data.frame(PreictedVisitorsinq3,Month,plowerlimit,pupperlimit)


###########number of visitors in q4(2013-15)#####################
visitorsq4=dbSendQuery(mydb,'select count(*) as visitors,
                       year(log_visitor.first_visit_at) as year,
                       month(log_visitor.first_visit_at) as month
                       from log_visitor 
                       where (year(log_visitor.first_visit_at)>=2013 and year(log_visitor.first_visit_at)<=2015)
                       and (month(log_visitor.first_visit_at)>=10 and month(log_visitor.first_visit_at)<=12)
                       group by year(log_visitor.first_visit_at),month(log_visitor.first_visit_at)
                       ')

visitorsinq4201315=fetch(visitorsq4,n=-1)

visitorsq4 <- sample(1:nrow(visitorsinq4201315),size = 0.7*nrow(visitorsinq4201315)) 
visitorstraindataq4 <- visitorsinq4201315[visitorsq4,] 
visitorstestdataq4<- visitorsinq4201315 [-visitorsq4,]

vislminq4<-lm(visitors~month+year,visitorstraindataq4)


vispredictioninq4<-predict(vislminq4,visitorstestdataq4)

p4<-predict(vislminq4)

p4<-predict(vislminq4,interval = "confidence")
clowerlimit<-c(32766.809,39195.568,25720.402)
cupperlimit<-c(101614.40,84628.92,87547.37)



p4<-predict(vislminq4,interval="prediction")
plowerlimit<-c(14005.040,15439.092,5650.064)
pupperlimit<-c(120376.17,108385.40,107617.70)


PreictedVisitorsinq4<-c(67190.60,61912.24,56633.88)
Month<-c("October","November","December")
q4dataforVisitors<-data.frame(PreictedVisitorsinq4,Month,plowerlimit,pupperlimit)


###############Total number of visitors in all quarters(sum)##########

totalNumberofVisitorsinQ1<-(sum(visitorsq1)/1000)
totalNumberofVisitorsinQ2<-(sum(PreictedVisitorsinq2)/1000)
totalNumberofVisitorsinQ3<-(sum(PreictedVisitorsinq3)/1000)
totalNumberofVisitorsinQ4<-(sum(PreictedVisitorsinq4)/1000)
##BenchMarking of Ecomerce Ration
ypVisits=dbSendQuery(mydb,"select count(*)  as Visitor,month(log_visitor.first_visit_at) as Month from log_visitor where year(log_visitor.first_visit_at)>=2015 group by month(log_visitor.first_visit_at);")
ypVisitsval=fetch(ypVisits,n=-1)
ypTransactions=dbSendQuery(mydb,"select count(*) as Count ,month(sales_flat_order.created_at) as Month from sales_flat_order where status='complete' and year(sales_flat_order.created_at)>=2015 group by month(sales_flat_order.created_at);")
ypTrValue=fetch(ypTransactions,n=-1)
ypERatio=(ypTrValue/ypVisitsval)*100


