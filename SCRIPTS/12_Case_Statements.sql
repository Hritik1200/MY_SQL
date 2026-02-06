/* ==============================================================================
   SQL CASE Statement
-------------------------------------------------------------------------------
   This script demonstrates various use cases of the SQL CASE statement, including
   data categorization, mapping, quick form syntax, handling nulls, and conditional 
   aggregation.
   
   Table of Contents:
     1. Categorize Data
     2. Mapping
     3. Quick Form of Case Statement
     4. Handling Nulls
     5. Conditional Aggregation
=================================================================================
*/

/* ==============================================================================
   USE CASE: CATEGORIZE DATA
===============================================================================*/

/* TASK 1: 
   Create a report showing total sales for each category:
	   - High: Sales over 50
	   - Medium: Sales between 20 and 50
	   - Low: Sales 20 or less
   The results are sorted from highest to lowest total sales.
*/

select category,sum(sales) as total_sales 
from(
select sales,-- provide column name which will be used in when logic
case 
	when sales>	50 then 'high'
    when sales >20  then 'medium'
	else'low'
end 'category'
from orders) t -- given name to case statement table only one word
group by category
order by total_sales desc;


select employeeid,firstname,lastname,gender,
case 
	when gender = 'M' then 'MALE'
    when gender ='F' then 'FEMALE'
    else 'not available'
end 'gender full text'
from employees;

/* ==============================================================================
   USE CASE: MAPPING
===============================================================================*/

/* TASK 2: 
   Retrieve customer details with abbreviated country codes 
*/
select customerid,country,
case 
	when country = 'Germany' then 'GMN'
    when country = 'USA' then 'US'
    else 'N/A'
end country_code
from customers;

/* ==============================================================================
   QUICK FORM SYNTAX
===============================================================================*/

/* TASK 3: 
   Retrieve customer details with abbreviated country codes using quick form 
*/
SELECT
    CustomerID,
    FirstName,
    LastName,
    Country,
    CASE 
        WHEN Country = 'Germany' THEN 'DE'
        WHEN Country = 'USA'     THEN 'US'
        ELSE 'n/a'
    END AS CountryAbbr,
    CASE Country
        WHEN 'Germany' THEN 'DE'
        WHEN 'USA'     THEN 'US'
        ELSE 'n/a'
    END AS CountryAbbr2
FROM Salesdb.Customers;

/* ==============================================================================
   HANDLING NULLS
===============================================================================*/

/* TASK 4: 
   Calculate the average score of customers, treating NULL as 0,
   and provide CustomerID and LastName details.
*/
SELECT customerid,lastname,score,avg(score) over()'before zero',
avg(case
	when score is null then 0
    else score
end) over() avg_score
from customers;


/* ==============================================================================
   CONDITIONAL AGGREGATION
===============================================================================*/

/* TASK 5: 
   Count how many orders each customer made with sales greater than 30 
*/
select customerid,count(*)'total_orders',
sum(case
	when sales> 30 then 1
    else 0
end) 'total_orders >30'
from orders
group by customerid;
