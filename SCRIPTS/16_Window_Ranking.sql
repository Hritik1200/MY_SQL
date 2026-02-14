/* ==============================================================================
   SQL Window Ranking Functions
-------------------------------------------------------------------------------
   These functions allow you to rank and order rows within a result set 
   without the need for complex joins or subqueries. They enable you to assign 
   unique or non-unique rankings, group rows into buckets, and analyze data 
   distributions on ordered data.

   Table of Contents:
     1. ROW_NUMBER
     2. RANK
     3. DENSE_RANK
     4. NTILE
     5. CUME_DIST
=================================================================================
*/

/* ============================================================
   SQL WINDOW RANKING | ROW_NUMBER, RANK, DENSE_RANK
   ============================================================ */

/* TASK 1:
   Rank Orders Based on Sales from Highest to Lowest
*/
select orderid,productid,sales,
row_number() over(order by sales desc) row_number_rank,-- row_number function gives unique rank according to row number
rank() over(order by sales desc) rank_function, -- rank function gives same rank to same value and skips rank according to row number
dense_rank() over(order by sales desc) dense_rank_function
from orders;


/* TASK 2:
   Use Case | Top-N Analysis: Find the Highest Sale for Each Product
*/

select * from(
select orderid,productid,sales,
row_number() over(partition by productid order by sales desc) 'top_n_analysis'
from orders)a
where top_n_analysis = 1;



/* TASK 3:
   Use Case | Bottom-N Analysis: Find the Lowest 2 Customers Based on Their Total Sales
*/
-- with subquery
select * from(
select customerid,sum(sales),
row_number() over(order by sum(sales) asc) bottom_n_analysis
from orders
group by customerid
)a where bottom_n_analysis <=2;

-- without subquery
select customerid,sum(sales),
row_number() over(order by sum(sales) asc) bottom_n_analysis
from orders
group by customerid
limit 2;

/* TASK 4:
   Use Case | Assign Unique IDs to the Rows of the 'Order Archive'
*/
select *,row_number() over(order by orderid) unique_id from orders_archive;

/* TASK 5:
   Use Case | Identify Duplicates:
   Identify Duplicate Rows in 'Order Archive' and return a clean result without any duplicates
*/
select * from(
select *,row_number() over(partition by orderid order by creationtime desc) as dublicates from orders_archive)a
where dublicates>1;

/* ============================================================
   SQL WINDOW RANKING | NTILE
   ============================================================ */

/* TASK 6:
   Divide Orders into Groups Based on Sales
*/
select orderid,sales,productid,
ntile(1) over(order by sales desc) one_group, 
ntile(2) over(order by sales desc) two_group,
ntile(3) over(order by sales desc) three_group,
ntile(4) over(order by sales desc) four_bucket,
ntile(2) over(partition by productid order by sales desc) twobucketbyproductid
from orders;


/* TASK 7:
   Segment all Orders into 3 Categories: High, Medium, and Low Sales.
*/
select *,
case
	when categories = 1 then 'high'
    when categories = 2 then 'medium'
    when categories = 3 then 'low'
end categories2 
from(
select orderid,sales,
ntile(3) over(order by sales desc) categories
from orders)a;

/* TASK 8:
   Divide Orders into Groups for Processing
*/
select *,ntile(5) over(order by orderid) bucket from orders;

-- it will help to transfer data in multiple small data
/* ============================================================
   SQL WINDOW RANKING | CUME_DIST
   ============================================================ */

/* TASK 9:
   Find Products that Fall Within the Highest 40% of the Prices
*/
select *,concat(dist_rank*100,'%') as percentage from(
select product,price,
cume_dist() over(order by price desc) dist_rank from products)a
where dist_rank <=0.4;

-- PERCENT_RANK()
select *,concat(per_rank*100,'%') percentage from(
SELECT product,price,
percent_rank() over(order by price desc) per_rank
 from products)a;
 
