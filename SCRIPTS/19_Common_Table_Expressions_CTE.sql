/* ==============================================================================
   SQL Common Table Expressions (CTEs)
-------------------------------------------------------------------------------
   This script demonstrates the use of Common Table Expressions (CTEs) in SQL Server.
   It includes examples of non-recursive CTEs for data aggregation and segmentation,
   as well as recursive CTEs for generating sequences and building hierarchical data.

   Table of Contents:
     1. NON-RECURSIVE CTE
     2. RECURSIVE CTE | GENERATE SEQUENCE
     3. RECURSIVE CTE | BUILD HIERARCHY
===============================================================================

/* ==============================================================================
   NON-RECURSIVE CTE
===============================================================================*/


-- Step1: Find the total Sales Per Customer (Standalone CTE)

with cte_totalSales as -- syntax of cte
(
select customerid,sum(sales) total_sales from orders
group by customerid
) -- end of cte
-- Step2: Find the last order date for each customer (Standalone CTE)
,cte_lastorder as -- syntax of cte  -- multiple standalone cte use , to add another cte
(
select customerid,max(orderdate) last_order from orders
group by customerid
)
-- Step3: Rank Customers based on Total Sales Per Customer (Nested CTE)
, cte_customer_rank as
(
select customerid,total_sales,
rank() over(order by total_sales desc) customer_rank
from cte_totalSales
)
-- Step4: segment customers based on their total sales (Nested CTE)
, cte_segment as
(
select customerid,total_sales,
case when total_sales>100 then 'High'
when total_sales >80 then 'Medium'
else 'Low'
end cu_segment
from cte_totalSales
)
-- main query / outer query
select firstname,lastname,country,cte.total_sales,last_order,cr.customer_rank,se.cu_segment from customers c
left join cte_totalSales cte
on c.customerid =  cte.customerid -- joining cte with main query
left join cte_lastorder clo -- second cte
on clo.customerid =  c.customerid -- joining 2nd cte with main query
left join cte_customer_rank cr
on cr.customerid = c.customerid
left join cte_segment se
on se.customerid = c.customerid
; 


/* ==============================================================================
   RECURSIVE CTE | GENERATE SEQUENCE
===============================================================================*/

/* TASK 2:
   Generate a sequence of numbers from 1 to 20.
*/
with RECURSIVE series as
    -- Anchor Query
(
select 1 as mynumber

union all
   -- Recursive Query
select mynumber + 1 from series
where mynumber < 200
)
-- main query
select * from series;


/* TASK 3:
   Generate a sequence of numbers from 1 to 1000.
*/
SET SESSION cte_max_recursion_depth = 10000; -- my sql have ifferent syntax to increse rcursive limit
with recursive ser_1000 as
(
select 1 start 
union all
select start +1  from ser_1000
where start <4000
)
select * from ser_1000;
-- option (maxrecursion 1000) for sql server


/* ==============================================================================
   RECURSIVE CTE | BUILD HIERARCHY
===============================================================================*/

/* TASK 4:
   Build the employee hierarchy by displaying each employee's level within the organization.
   - Anchor Query: Select employees with no manager.
   - Recursive Query: Select subordinates and increment the level.
*/
with recursive flow_level as
(-- anchor query
select employeeid,firstname,managerid,1 as level
from employees 
where managerid is null

union all
-- recursive query
select e.employeeid,e.firstname,e.managerid,level +1
from employees e inner join flow_level f
on e.managerid = f.employeeid
)
select * from flow_level;









