/* ==============================================================================
   SQL Window Aggregate Functions
-------------------------------------------------------------------------------
   These functions allow you to perform aggregate calculations over a set 
   of rows without the need for complex subqueries. They enable you to compute 
   counts, sums, averages, minimums, and maximums while still retaining access 
   to individual row details.

   Table of Contents:
    1. COUNT
    2. SUM
    3. AVG
    4. MAX / MIN
    5. ROLLING SUM & AVERAGE Use Case
===============================================================================
*/

/* ============================================================
   SQL WINDOW AGGREGATION | COUNT
   ============================================================ */

/* TASK 1:
   Find the Total Number of Orders and the Total Number of Orders for Each Customer
*/

select count(*) from orders;
select customerid,orderdate,
count(*) over() total_orders,count(customerid) over(partition  by customerid) orders_each_customer 
from orders;

/* TASK 2:
   - Find the Total Number of Customers
   - Find the Total Number of Scores for Customers
   - Find the Total Number of Countries
*/
select * ,count(*) over() total_customer from customers;

select *,count(score) over() 'number-of_scores' from customers;

select *,count(*) over() total_customer,count(score) over() 'number-of_scores',count(country) over() total_country 
from customers;

/* TASK 3:
   Check whether the table 'OrdersArchive' contains any duplicate rows
*/
select orderid,count(*) over (partition by orderid) duplicates from orders_archive;

-- only duplicate with subquery
select * from(select orderid,count(*) over(partition by orderid) duplicate_check from orders_archive)a
where duplicate_check >1;


/* ============================================================
   SQL WINDOW AGGREGATION | SUM
   ============================================================ */

/* TASK 4:
   - Find the Total Sales Across All Orders 
   - Find the Total Sales for Each Product
*/
select orderid,productid,sum(sales) over() total_sales from orders;

select orderid,productid,sum(sales) over() total_sales,sum(sales) over(partition by productid) each_product
from orders;

/* TASK 5:
   Find the Percentage Contribution of Each Product's Sales to the Total Sales
*/
select orderid,productid,sales,
sum(sales) over() total_sales,
round(cast(sales as unsigned)/sum(sales) over() *100,2) percentage_of_total
 from orders;
 
 /* ============================================================
   SQL WINDOW AGGREGATION | AVG
   ============================================================ */

/* TASK 6:
   - Find the Average Sales Across All Orders 
   - Find the Average Sales for Each Product
*/
select orderid,orderdate,productid,avg(sales) over() avg_sales from orders;

select orderid,orderdate,productid,sales,avg(sales) over(partition by productid) from orders;


/* TASK 7:
   Find the Average Scores of Customers
*/

select customerid,score,
coalesce(score,0),
avg(score) over() ,
avg(coalesce(score,0))  over() avg_score from customers;

/* TASK 8:
   Find all orders where Sales exceed the average Sales across all orders
*/
select * from(
select orderid,orderdate,sales,avg(sales) over() avg_sales from orders)a
where sales> avg_sales;
-- subquery

/* ============================================================
   SQL WINDOW AGGREGATION | MAX / MIN
   ============================================================ */

/* TASK 9:
   Find the Highest and Lowest Sales across all orders
*/
select orderid,sales,
max(sales) over() highest_sales,
min(sales) over() lowest_sales  
from orders;

/* TASK 10:
   Find the Lowest Sales across all orders and by Product
*/
select orderid,sales,productid,
max(sales) over() highest_sales,
min(sales) over() min_sales,
max(sales) over(partition by productid),
min(sales) over(partition by productid) from orders;


/* TASK 11:
   Show the employees who have the highest salaries
*/
select* from (
select *,max(salary) over() highest_salary from employees)a
where salary = highest_salary;

/* TASK 12:
   Find the deviation of each Sale from the minimum and maximum Sales
*/
SELECT
    OrderID,
    OrderDate,
    ProductID,
    Sales,
    MAX(Sales) OVER () AS HighestSales,
    MIN(Sales) OVER () AS LowestSales,
    sales-min(sales) over()deviation_min,
    max(sales) over() -sales  deviation_max from orders;
    
    /* ============================================================
   Use Case | ROLLING SUM & AVERAGE
   ============================================================ */

/* TASK 13:
   Calculate the moving average of Sales for each Product over time
*/
select orderid,productid,orderdate,sales,
avg(sales) over(partition by productid) avg_sales,
avg(sales) over(partition by productid order by orderdate) moving_avg
from orders;
-- default frame clause rows between unbounded preceding and current row


/* TASK 14:
   Calculate the moving average of Sales for each Product over time,
   including only the next order
*/
select orderid,productid,sales,orderdate,
avg(sales) over(partition by productid order by orderdate rows between current row and 1 following) rolling_avg
from orders;
