SELECT * FROM sales.salesss;
-----------------------------------------------------------------
-- TOTAL SHIPPING FEES FOR EACH SHIPPING COMPANIES

WITH TOTAL_SHIPPING_FEE AS (
SELECT `SHIPPER NAME`,`Shipping Fee`,
DENSE_RANK () OVER ( PARTITION BY  `SHIPPER NAME`
ORDER BY `Shipping Fee`) AS RANKS,
ROUND( sum(`Shipping Fee`)) AS "TOTAL_SHIPPING_FEE"         
FROM sales.salesss
GROUP BY `Shipper Name`
)
SELECT `SHIPPER NAME`,TOTAL_SHIPPING_FEE
FROM TOTAL_SHIPPING_FEE;

-----------------------------------------------------------------
-- TOTAL QUANTITY FOR EACH PRODUCTS

WITH PRODUCT_QUANTITY AS (
SELECT CATEGORY, SUM(`Quantity`) AS "TOTAL_QUANTITY",
DENSE_RANK () OVER (PARTITION BY CATEGORY 
ORDER BY `Quantity` ) AS RANKS
FROM sales.salesss
GROUP BY CATEGORY
)
SELECT CATEGORY,TOTAL_QUANTITY
FROM PRODUCT_QUANTITY
WHERE RANKS = 1
ORDER BY TOTAL_QUANTITY DESC;
-----------------------------------------------------------------
-- TOTAL REVENUE FOR EACH PRODUCTS

with PRODUCT_REVENUE AS (
SELECT CATEGORY, SUM(`Revenue`) AS "TOTAL_REVENUE",
DENSE_RANK () OVER (PARTITION BY CATEGORY
ORDER BY `Revenue`) AS RANKS
FROM sales.salesss
GROUP BY CATEGORY
)
SELECT CATEGORY,TOTAL_REVENUE
FROM PRODUCT_REVENUE
WHERE RANKS =1
ORDER BY TOTAL_REVENUE DESC;
--------------------------------------------------------------------
-- COUNTS OF PAYMENT TYPE USED BY EACH CUSTOMERS

with customers_payment as (
SELECT `Customer Name`,`Payment Type`, COUNT(`Payment Type`) AS "PAYMENT_COUNT",
DENSE_RANK () OVER (PARTITION BY `Customer Name`
ORDER BY `Customer Name`) AS RANKS
FROM sales.salesss
GROUP BY `Payment Type`,`Customer Name`
)
SELECT `Customer Name`,`Payment Type`,PAYMENT_COUNT
FROM customers_payment
WHERE RANKS =1
ORDER BY PAYMENT_COUNT DESC
LIMIT 5 ;
-----------------------------------------------------------------------
-- TOTAL QUANTITY EACH CUSTOMERS BOUGHT
with customers_quantity as (
SELECT `Customer Name`, SUM(`Quantity`) AS "QUANTITY_COUNT",
DENSE_RANK () OVER (PARTITION BY `Customer Name`
ORDER BY `Quantity`) AS RANKS
FROM sales.salesss
GROUP BY `Customer Name`

)
SELECT `Customer Name`,QUANTITY_COUNT
FROM customers_quantity
WHERE RANKS =1
ORDER BY QUANTITY_COUNT DESC
LIMIT 5;
----------------------------------------------------------------------
-- Products sold by each salespersons
WITH salesperson as (
select `Salesperson`,`Category`, COUNT(`Category`) AS "PRODUCT_SALES_COUNT",
DENSE_RANK () OVER (PARTITION BY `Salesperson`
ORDER BY `Salesperson`) AS RANKS
FROM sales.salesss
GROUP BY `Salesperson`
)
SELECT `Salesperson`,PRODUCT_SALES_COUNT
FROM salesperson
WHERE RANKS = 1
ORDER BY PRODUCT_SALES_COUNT DESC;
---------------------------------------------------------------------------------
-- Top  salesperson revenue
with Salesperson_Revenue AS (
SELECT `Salesperson`, SUM(`Revenue`) AS "Total_Salesperson_Revenue",
DENSE_RANK () OVER (PARTITION BY `Salesperson`
ORDER BY `Revenue`) AS RANKS
FROM sales.salesss
GROUP BY `Salesperson`
)
SELECT`Salesperson`,Total_Salesperson_Revenue
FROM Salesperson_Revenue
WHERE RANKS =1
ORDER BY Total_Salesperson_Revenue DESC;
-------------------------------------------------------------------------------------
-- Total Number of salesperson
SELECT COUNT(DISTINCT(`Salesperson`) )AS "TOTAL_SALESPERSON"
FROM sales.salesss;
--------------------------------------------------------------------------------------
-- total number of sales by each salesperson to customers
with customer_count as (
SELECT `Salesperson`, count(`Customer Name`) as "Customer_count",
dense_rank () over ( partition by `Salesperson`
order by count(`Customer Name`)) as ranks
from sales.salesss
GROUP BY `Salesperson`
)
SELECT `Salesperson`,Customer_count
from customer_count
ORDER BY Customer_count desc;

-----------------------------------------------------------------------------------------
-- Total number of sales by each salesperson to region

with region_count as (
select `Salesperson`,`Region`, count(`Region`) "Region_count",
DENSE_RANK () over (PARTITION BY `Salesperson`,`Region`
ORDER BY count(`Region`)) as ranks
from sales.salesss
GROUP BY `Salesperson`,`Region`
)
SELECT `Salesperson`, `Region`, Region_count
from region_count
ORDER BY region_count desc;
-----------------------------------------------------------------------------------------
-- Highest sales in the cities

with city_count as (
SELECT `City`, count(`City`) as "City_count",
DENSE_RANK () over ( PARTITION BY  `City`
ORDER BY count(`City`) ) as ranks 
FROM sales.salesss
GROUP BY `City`
)
SELECT `City`,City_count
from city_count
ORDER BY city_count desc;
