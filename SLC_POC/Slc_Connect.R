library(RMySQL)
mydb = dbConnect(MySQL(),user='readonly',password='readonly123',dbname='slcawdb',host='183.82.106.91')


####current month analysis for sales
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
##Revenue of a perticular month in all years

RevenueMarch=dbSendQuery(mydb,'select sum(grand_total) as Revenue ,Month(created_at) as Month,Year(created_at) as Year from sales_flat_order where Month(created_at) =3 group by  Year(created_at)')
RevenueMarchVal=fetch(RevenueMarch,n=-1)

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

####inventory Turnover=Cost of Goods Sold  /  Average Inventory 
 ##per month
mturnover = dbSendQuery(mydb,'select sum(sales_flat_order.grand_total) as OrderTotal from
  sales_flat_order,sales_flat_invoice
                       where 
                       sales_flat_order.entity_id=sales_flat_invoice.order_id and
                      Year(sales_flat_order.created_at)=2016 and Month(sales_flat_order.created_at)=3 and
                       sales_flat_order.status="complete"')
mIturnover= fetch(mturnover, n=-1)
minventurnover<-sum(mIturnover$OrderTotal)
####Inventory Turnover per  year

yturnover = dbSendQuery(mydb,'select sum(sales_flat_order.grand_total) as OrderTotal from
                        sales_flat_order,sales_flat_invoice
                        where 
                        sales_flat_order.entity_id=sales_flat_invoice.order_id and
Year(sales_flat_order.created_at)=2016 and 
                        sales_flat_order.status="complete"')
yIturnover= fetch(yturnover, n=-1)
yinventurnover<-sum(yIturnover$OrderTotal)
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
sales_flat_order.`status`,sum(sales_flat_shipment.total_qty) as UnitsShipped,sales_flat_shipment.created_at from
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
sales_flat_order.`status`,sum(sales_flat_shipment.total_qty) as UnitsShipped,sales_flat_shipment.created_at from
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
