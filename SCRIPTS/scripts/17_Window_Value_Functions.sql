/* ==============================================================================
   SQL Window Value Functions
-------------------------------------------------------------------------------
   These functions let you reference and compare values from other rows 
   in a result set without complex joins or subqueries, enabling advanced 
   analysis on ordered data.

   Table of Contents:
     1. LEAD
     2. LAG
     3. FIRST_VALUE
     4. LAST_VALUE
=================================================================================
*/

/* ============================================================
   SQL WINDOW VALUE | LEAD, LAG
   ============================================================ */

/* TASK 1:
   Analyze the Month-over-Month Performance by Finding the Percentage Change in Sales
   Between the Current and Previous Months
*/
select *,(current_monthsales-previous_month_sales ) month_over_month ,
round(cast((current_monthsales-previous_month_sales)as float) /previous_month_sales*100,1) percentage_change
from(
select month(orderdate) month,
sum(sales) current_monthsales,
lag(sum(sales)) over(order by month(orderdate)) previous_month_sales from orders
group by month(orderdate))a;

/* TASK 2:
   Customer Loyalty Analysis - Rank Customers Based on the Average Days Between Their Orders
*/
select customerid,avg(DaysUntilNextOrder) avg_days ,
rank() over(order by coalesce(avg(DaysUntilNextOrder),99999))

from(
select orderid,customerid,orderdate,
lead(orderdate) over(partition by customerid order by orderdate) next_order ,
datediff(lead(orderdate) over(partition by customerid order by orderdate),orderdate) DaysUntilNextOrder
from orders)a
group by customerid;


/* ============================================================
   SQL WINDOW VALUE | FIRST & LAST VALUE
   ============================================================ */

/* TASK 3:
   Find the Lowest and Highest Sales for Each Product,-
   and determine the difference between the current Sales and the lowest Sales for each Product.
*/
select orderid,productid,sales ,
first_value(sales) over(partition by productid order by sales) lowestsales1,
last_value(sales) over(partition by productid order by sales rows between current row and unbounded following) highest_sales1,
sales-first_value(sales) over(partition by productid order by sales) sales_diff,

-- alternative to get highest sales using first_value just make order by desc
first_value(sales) over(partition by productid order by sales desc) highest_sales,

-- alternative to get lowest and highest using min , max
min(sales) over(partition by productid) min_sales,
max(sales) over(partition by productid) max_sales
from orders;


