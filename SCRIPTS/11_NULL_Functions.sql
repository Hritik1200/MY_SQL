/* ==============================================================================
   SQL NULL Functions
-------------------------------------------------------------------------------
   This script highlights essential SQL functions for managing NULL values.
   It demonstrates how to handle NULLs in data aggregation, mathematical operations,
   sorting, and comparisons. These techniques help maintain data integrity 
   and ensure accurate query results.

   Table of Contents:
     1. Handle NULL - Data Aggregation
     2. Handle NULL - Mathematical Operators
     3. Handle NULL - Sorting Data
     4. NULLIF - Division by Zero
     5. IS NULL - IS NOT NULL
     6. LEFT ANTI JOIN
     7. NULLs vs Empty String vs Blank Spaces
===============================================================================
*/

/* ==============================================================================
   HANDLE NULL - DATA AGGREGATION
===============================================================================*/

/* TASK 1: 
   Find the average scores of the customers.
   Uses COALESCE to replace NULL Score with 0.
*/
select customerid,score,
avg(score) over() 'with null avg()',
coalesce(score,0) 'replace null with zero',-- replace null with zero
avg(coalesce(score,0)) over() 'avgscore after removing null'from customers
-- over() is a window function
;

/* ==============================================================================
   HANDLE NULL - MATHEMATICAL OPERATORS
===============================================================================*/

/* TASK 2: 
   Display the full name of customers in a single field by merging their
   first and last names, and add 10 bonus points to each customer's score.
*/

select firstname,lastname,score,
concat(firstname,' ',lastname) 'full_name before replace',-- not compulsory just for understanding
coalesce(lastname,'')'replace lastname with blank ',-- not compulsory just for understanding
concat(firstname,' ',coalesce(lastname,'')) 'merge after replace',-- final output
(score+10)'bonus points before replace',-- not compulsory just for understanding
coalesce(score,0)'replace with zero',-- not compulsory just for understanding
coalesce(score,0)+10 'after replace'-- final output
from customers;


/* ==============================================================================
   HANDLE NULL - SORTING DATA
===============================================================================*/

/* TASK 3: 
   Sort the customers from lowest to highest scores,
   with NULL values appearing last.
*/
select customerid,score from customers
order by 
case when score is null then 1 else 0 end,score asc;
-- if value is null it will replace it with 1 and other with 0 zero
-- used case function to put condition 

/* ==============================================================================
   NULLIF - DIVISION BY ZERO
===============================================================================*/

/* TASK 4: 
   Find the sales price for each order by dividing sales by quantity.
   Uses NULLIF to avoid division by zero.
*/
select orderid,sales,quantity,
(sales/quantity) 'total',-- it will give error dividing with zero
sales/nullif(quantity,0) 'total'-- it will replace zero with null and will not give error
 from orders;
 
 
/* ==============================================================================
   IS NULL - IS NOT NULL
===============================================================================*/

/* TASK 5: 
   Identify the customers who have no scores 
*/
select * from customers
where score is null;

/* TASK 6: 
   Identify the customers who have scores 
*/
select * from customers 
where score is not null;


/* ==============================================================================
   LEFT ANTI JOIN
===============================================================================*/

/* TASK 7: 
   List all details for customers who have not placed any orders 
*/
select a.*,b.orderid from customers a left join orders b
on a.customerid = b.customerid
where b.customerid is null;


/* ==============================================================================
   NULLs vs EMPTY STRING vs BLANK SPACES
===============================================================================*/

/* TASK 8: 
   Demonstrate differences between NULL, empty strings, and blank spaces 
*/
WITH Orders AS (
    SELECT 1 AS Id, 'A' AS Category UNION
    SELECT 2, NULL UNION
    SELECT 3, '' UNION
    SELECT 4, '  '
)
SELECT 
    *,
    DATALENGTH(Category) AS LenCategory,
    TRIM(Category) AS Policy1,
    NULLIF(TRIM(Category), '') AS Policy2,
    COALESCE(NULLIF(TRIM(Category), ''), 'unknown') AS Policy3
FROM Orders;

-- does not work in mysql
