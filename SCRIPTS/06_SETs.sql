/* ==============================================================================
   SQL SET Operations
-------------------------------------------------------------------------------
   SQL set operations enable you to combine results from multiple queries
   into a single result set. This script demonstrates the rules and usage of
   set operations, including UNION, UNION ALL, EXCEPT, and INTERSECT.
   
   Table of Contents:
     1. SQL Operation Rules
     2. UNION
     3. UNION ALL
     4. EXCEPT
     5. INTERSECT
=================================================================================
*/

/* ==============================================================================
   RULES OF SET OPERATIONS
===============================================================================*/

/* RULE: Data Types
   The data types of columns in each query should match.*/
   
select firstname,lastname from salesdb.customers
union
select firstname,lastname from salesdb.employees;
-- if we use schema name of database while selecting table  we dont need to select databaase

/* RULE: Data Types (Example)
   The data types of columns in each query should match.
*/
select customerid,lastname from customers -- 1st query
union
select firstname,lastname from employees; -- 2nd query;

/* this is not valid because customer id is an int datatype 
   and in 2nd query firstname is varchar datatype */
   
/* RULE: Column Order
   The order of the columns in each query must be the same.
*/

select lastname,customerid from customers
union
select employeeid,lastname from employees;
/* this is not valid because if we select same datatype column and same nuber of column
   order of column should also be same
   in 1st query customerid is in 2nd position
   and in 2nd query employeeid is on 1st position
   this will give ismatch result;
   
   /* RULE: Column Aliases
   The column names in the result set are determined by the column names
   specified in the first SELECT statement.
*/
select customerid as 'id',lastname as 'Last_Name' from customers
union
select employeeid,lastname from employees;
/* we can give alise in 1st query only one time
we cannot give alias in 2nd query also
it will consider only alias of first query*/

/* RULE: Correct Columns
   Ensure that the correct columns are used to maintain data consistency.
*/
SELECT
    FirstName,
    LastName
FROM Customers
UNION
SELECT
    LastName,
    FirstName
FROM Employees;

/* if we fulfill all coditions we can still get wrong result
  like in this 1st query have firstname in 1st position
  and in 2nd query firstname in 2nd position it will still give result so 
  we have to check correct position of column while selection
  or it will give bad mismatch result*/
  
/* ==============================================================================
   SETS: UNION, UNION ALL, EXCEPT, INTERSECT
===============================================================================*/

/* TASK 1: 
   Combine the data from Employees and Customers into one table using UNION 
*/
select firstname,lastname from customers
union
select firstname,lastname from employees;
/* union remove duplicates from both table in result

/* TASK 2: 
   Combine the data from Employees and Customers into one table, including duplicates, using UNION ALL 
*/

select firstname,lastname from customers
union all
select firstname,lastname from employees;
-- union all give all data from both tables including duplicates

/* TASK 3: 
   Find employees who are NOT customers using EXCEPT 
*/
select firstname,lastname from employees
except
select firstname,lastname from customers;

-- alternative Find customers who are NOT employees using EXCEPT

select firstname,lastname from customers
except
select firstname,lastname from employees;

-- except removes common data and give result of remaning data of 1st table of 1st query

/* TASK 4: 
   Find employees who are also customers using INTERSECT 
*/
select firstname,lastname from customers
INTERSECT
select firstname,lastname from employees;
-- only common rows in both tables 

/* TASK 5: 
   Combine order data from Orders and OrdersArchive into one report without duplicates 
*/
select 
'Orders' as 'SourceTable',
orderid,productid, customerid,
 salespersonid, orderdate, shipdate,
 orderstatus, shipaddress, billaddress,
 quantity, sales, creationtime 
 from orders
union
select 
'Orders_archive' as 'SourceTable',
orderid, productid, customerid
, salespersonid, orderdate, shipdate
, orderstatus, shipaddress, billaddress
, quantity, sales, creationtime 
from orders_archive
order by orderid asc;

