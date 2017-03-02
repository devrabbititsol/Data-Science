library(RMySQL)
mydb = dbConnect(MySQL(),user='readonly',password='readonly123',dbname='slcawdb',host='183.82.106.91')

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
      ###avg order value for a year
YAvg_Order=dbSendQuery(mydb,'select sum(grand_total)/count(*) as AvgOrderValue from sales_flat_order where status="complete"')
YAvg_Value=fetch(YAvg_Order,n=-1)
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
#Calculating E-Commerce Ratio
  ##for a month
mVisits=dbSendQuery(mydb,"select count(*) from log_visitor where month(log_visitor.first_visit_at)=3 and year(log_visitor.first_visit_at)=2016")
mVisitsval=fetch(mVisits,n=-1)
mTransactions=dbSendQuery(mydb,"select count(*) from sales_flat_order where status='complete' and month(sales_flat_order.created_at)=3 and year(sales_flat_order.created_at)=2016")
mTrValue=fetch(mTransactions,n=-1)
mERatio=mTrValue/mVisitsval

    ##for a year
yVisits=dbSendQuery(mydb,"select count(*) from log_visitor where year(log_visitor.first_visit_at)=2016")
yVisitsval=fetch(yVisits,n=-1)
yTransactions=dbSendQuery(mydb,"select count(*) from sales_flat_order where status='complete'  and year(sales_flat_order.created_at)=2016")
yTrValue=fetch(yTransactions,n=-1)
yERatio=yTrValue/yVisitsval
############## new Customer per month ###################
mNewCust=dbSendQuery(mydb,'SELECT COUNT(*) AS grand_count FROM(
                      SELECT customer_email FROM sales_flat_order
                      WHERE sales_flat_order.status NOT LIKE "canceled"
                      AND sales_flat_order.status NOT LIKE "closed"
                      AND sales_flat_order.status NOT LIKE "fraud"
                      AND sales_flat_order.status NOT LIKE "holded"
                      AND sales_flat_order.status NOT LIKE "paypal_canceled_reversal"
                      AND year(sales_flat_order.updated_at)=2016 
                      GROUP BY customer_email HAVING COUNT(*) = 1) s')
mNewCustVal=fetch(mNewCust,n=-1)


###########increase % per month#####
monthdata=dbSendQuery(mydb,'select month(sales_flat_order.created_at) as month,sum(sales_flat_order.grand_total) as sale from sales_flat_order where 
                      year(sales_flat_order.created_at)=2016 and month(sales_flat_order.created_at)>=2 group by month;')


percentofmonthsdata=fetch(monthdata,n=-1)

febdata=percentofmonthsdata$sale[1]
marchdata=percentofmonthsdata$sale[2]
difference=marchdata-febdata
mincreaseper=(difference/febdata)*100
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
ymval<-cbind(yRevenue,yminc.annotation)

##### calculating top product in a month  

mTopProduct = dbSendQuery(mydb,'select sum(sales_flat_quote_item.qty) as TotalQty, 
                 sales_flat_quote_item.product_id, sales_flat_quote_item.name 
                 from sales_flat_quote_item,sales_flat_order_item 
                 where YEAR(sales_flat_quote_item.updated_at) = 2016 AND MONTH(sales_flat_quote_item.updated_at)=3 AND
		sales_flat_quote_item.product_id = sales_flat_order_item.product_id 
                 group by sales_flat_quote_item.product_id')

mtopproduct= fetch(mTopProduct, n=-1)  
maxQty<-max(mtopproduct$TotalQty)
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
#######################Average inventory sold in a month per day
 davgInvent=dbSendQuery(mydb,'select sum(sales_flat_order.total_qty_ordered) as AvgInventory,
year(sales_flat_order.created_at ) as year,month(sales_flat_order.created_at) as month
from  sales_flat_order
where sales_flat_order.status= "complete" and year(sales_flat_order.created_at)=2016 and month(sales_flat_order.created_at)=3;
')
 dInvent=fetch(davgInvent,n=-1)
 #######################Average inventory sold in a year per month
 yavgInvent=dbSendQuery(mydb,'select sum(sales_flat_order.total_qty_ordered) as AvgInventory,
year(sales_flat_order.created_at ) as year
from  sales_flat_order
where sales_flat_order.status= "complete" and year(sales_flat_order.created_at)=2016 ;
')
 yInvent=fetch(yavgInvent,n=-1)

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
###########Inventory Availability####################
availStock = dbSendQuery(mydb,'select cataloginventory_stock_status.product_id as Productid,cataloginventory_stock_status.qty as Quantity,catalog_product_entity_varchar.value as Productname
                         
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
                         where (sales_flat_invoice.total_qty)>=1000
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

percentages<-c(0,0,-26.93,2.7,0,0,-19.62)
row2016<-rbind(trends2016,percentages)

row2016$totalcustomers <- NULL
row2016$month <- NULL
row2016$day <- NULL
row2016$year <- NULL


rownames(row2016)[1]<-"Yesterday"
rownames(row2016)[2]<-"Today"
rownames(row2016)[3]<-"+/- in Percentage"
# ######################websiteconversion rate############
# webcon=dbSendQuery(mydb,'select count(*) from customer_entity;')
# wrate1=fetch(webcon,n=-1)
# webconrate=dbSendQuery(mydb,'select count(*) from sales_flat_order where status="complete";')
# wrate2=fetch(webconrate,n=-1)
# wrate=round(wrate1/wrate2,2)*100
###############website traffic growth##################
mwebgro=dbSendQuery(mydb,'select count(*) from log_visitor where month(log_visitor.last_visit_at)=2;')
mwgrowth1=fetch(mwebgro,n=-1)
mwebgrowth=dbSendQuery(mydb,'select count(*) from log_visitor where month(log_visitor.last_visit_at)=3;')
mwgrowth2=fetch(mwebgrowth,n=-1)
mwgrowth=round(((mwgrowth1-mwgrowth2)/mwgrowth1),2)*100

######################sales analysis for all years in feb and march######################
fbmanalysis=dbSendQuery(mydb,'select sum(grand_total) as Revenue ,Month(created_at) as Month,Year(created_at) as Year 
                        from sales_flat_order 
                        where (Month(created_at) >=2 and Month(created_at)<=3) 
                        and (Year(created_at)>=2013 and year(created_at)<=2016) group by  Year(created_at),month(created_at)')
febmarchanalysis=fetch(fbmanalysis,n=-1)


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
                     group by Brand order by Brand;")
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
                     group by Brand order by Brand;")
YBrandRevenue=fetch(YBRevenue,n=-1)
YBrandRevenue[1,2]<-"others"
# #######################################################
# mRepeatCust2016=dbSendQuery(mydb,'SELECT COUNT(*) AS grand_count FROM(
# SELECT customer_email FROM sales_flat_order
#                             WHERE sales_flat_order.status NOT LIKE "canceled"
#                             AND sales_flat_order.status NOT LIKE "closed"
#                             AND sales_flat_order.status NOT LIKE "fraud"
#                             AND sales_flat_order.status NOT LIKE "holded"
#                             AND sales_flat_order.status NOT LIKE "paypal_canceled_reversal"
#                             AND year(sales_flat_order.updated_at)=2016 
#                             AND month(sales_flat_order.updated_at)=3
#                             GROUP BY customer_email HAVING COUNT(*) > 1
# ) s')
# 
# mRepeatCustomer2016=fetch(mRepeatCust2016,n=-1)
# 
# mRepeatCust2015=dbSendQuery(mydb,'SELECT COUNT(*) AS grand_count FROM(
#                             SELECT customer_email FROM sales_flat_order
#                             WHERE sales_flat_order.status NOT LIKE "canceled"
#                             AND sales_flat_order.status NOT LIKE "closed"
#                             AND sales_flat_order.status NOT LIKE "fraud"
#                             AND sales_flat_order.status NOT LIKE "holded"
#                             AND sales_flat_order.status NOT LIKE "paypal_canceled_reversal"
#                             AND year(sales_flat_order.updated_at)=2015 
#                             AND month(sales_flat_order.updated_at)=3
#                             GROUP BY customer_email HAVING COUNT(*) > 1
# ) s')
# mRepeatCustomer2015=fetch(mRepeatCust2015,n=-1)
# 
# mRepeatCust2014=dbSendQuery(mydb,'SELECT COUNT(*) AS grand_count FROM(
#                             SELECT customer_email FROM sales_flat_order
#                             WHERE sales_flat_order.status NOT LIKE "canceled"
#                             AND sales_flat_order.status NOT LIKE "closed"
#                             AND sales_flat_order.status NOT LIKE "fraud"
#                             AND sales_flat_order.status NOT LIKE "holded"
#                             AND sales_flat_order.status NOT LIKE "paypal_canceled_reversal"
#                             AND year(sales_flat_order.updated_at)=2014 
#                             AND month(sales_flat_order.updated_at)=3
#                             GROUP BY customer_email HAVING COUNT(*) > 1
# ) s')
# mRepeatCustomer2014=fetch(mRepeatCust2014,n=-1)
# 
# mRepeatCust2013=dbSendQuery(mydb,'SELECT COUNT(*) AS grand_count FROM(
#                             SELECT customer_email FROM sales_flat_order
#                             WHERE sales_flat_order.status NOT LIKE "canceled"
#                             AND sales_flat_order.status NOT LIKE "closed"
#                             AND sales_flat_order.status NOT LIKE "fraud"
#                             AND sales_flat_order.status NOT LIKE "holded"
#                             AND sales_flat_order.status NOT LIKE "paypal_canceled_reversal"
#                             AND year(sales_flat_order.updated_at)=2013 
#                             AND month(sales_flat_order.updated_at)=3
#                             GROUP BY customer_email HAVING COUNT(*) > 1
# ) s')
# mRepeatCustomer2013=fetch(mRepeatCust2013,n=-1)
# year<-c(2013,2014,2015,2016)
# 
# grndcntforrep<-c(27,51,83,116)
# mRepeatCustomer<-cbind(year,grndcntforrep)
# grndcntforrep<-mRepeatCustomer$grndcntforrep
# 
# mNewCust2016=dbSendQuery(mydb,'SELECT COUNT(*) AS grand_count FROM(
#                          SELECT customer_email FROM sales_flat_order
#                          WHERE sales_flat_order.status NOT LIKE "canceled"
#                          AND sales_flat_order.status NOT LIKE "closed"
#                          AND sales_flat_order.status NOT LIKE "fraud"
#                          AND sales_flat_order.status NOT LIKE "holded"
#                          AND sales_flat_order.status NOT LIKE "paypal_canceled_reversal"
#                          AND year(sales_flat_order.updated_at)=2016 
#                          AND month(sales_flat_order.updated_at)=3
#                          GROUP BY customer_email HAVING COUNT(*) = 1) s')
# 
# mnewcustomer2016=fetch(mNewCust2016, n=-1)
# mNewCust2015=dbSendQuery(mydb,'SELECT COUNT(*) AS grand_count FROM(
#                          SELECT customer_email FROM sales_flat_order
#                          WHERE sales_flat_order.status NOT LIKE "canceled"
#                          AND sales_flat_order.status NOT LIKE "closed"
#                          AND sales_flat_order.status NOT LIKE "fraud"
#                          AND sales_flat_order.status NOT LIKE "holded"
#                          AND sales_flat_order.status NOT LIKE "paypal_canceled_reversal"
#                          AND year(sales_flat_order.updated_at)=2015 
#                          AND month(sales_flat_order.updated_at)=3
#                          GROUP BY customer_email HAVING COUNT(*) = 1) s')
# mnewcustomer2015=fetch(mNewCust2015, n=-1)
# mNewCust2014=dbSendQuery(mydb,'SELECT COUNT(*) AS grand_count FROM(
#                          SELECT customer_email FROM sales_flat_order
#                          WHERE sales_flat_order.status NOT LIKE "canceled"
#                          AND sales_flat_order.status NOT LIKE "closed"
#                          AND sales_flat_order.status NOT LIKE "fraud"
#                          AND sales_flat_order.status NOT LIKE "holded"
#                          AND sales_flat_order.status NOT LIKE "paypal_canceled_reversal"
#                          AND year(sales_flat_order.updated_at)=2014 
#                          AND month(sales_flat_order.updated_at)=3
#                          GROUP BY customer_email HAVING COUNT(*) = 1) s')
# mnewcustomer2014=fetch(mNewCust2014, n=-1)
# mNewCust2013=dbSendQuery(mydb,'SELECT COUNT(*) AS grand_count FROM(
#                          SELECT customer_email FROM sales_flat_order
#                          WHERE sales_flat_order.status NOT LIKE "canceled"
#                          AND sales_flat_order.status NOT LIKE "closed"
#                          AND sales_flat_order.status NOT LIKE "fraud"
#                          AND sales_flat_order.status NOT LIKE "holded"
#                          AND sales_flat_order.status NOT LIKE "paypal_canceled_reversal"
#                          AND year(sales_flat_order.updated_at)=2013
#                          AND month(sales_flat_order.updated_at)=3
#                          GROUP BY customer_email HAVING COUNT(*) = 1) s')
# mnewcustomer2013=fetch(mNewCust2013, n=-1)
# year1<-c(2013,2014,2015,2016)
# grndcntfornew<-c(20,64,67,102)
# grndcntforrep<-c(27,51,83,116)
# # mnewcustomer<-cbind(year,grndcntfornew)
# # year<-round(year1)
# newrepcustomer1<-c(grndcntfornew,grndcntforrep)
