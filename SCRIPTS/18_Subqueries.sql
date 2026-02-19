/* ==============================================================================
   SQL Subquery Functions
-------------------------------------------------------------------------------
   This script demonstrates various subquery techniques in SQL.
   It covers result types, subqueries in the FROM clause, in SELECT, in JOIN clauses,
   with comparison operators, IN, ANY, correlated subqueries, and EXISTS.
   
   Table of Contents:
     1. SUBQUERY - RESULT TYPES
     2. SUBQUERY - FROM CLAUSE
     3. SUBQUERY - SELECT
     4. SUBQUERY - JOIN CLAUSE
     5. SUBQUERY - COMPARISON OPERATORS 
     6. SUBQUERY - IN OPERATOR
     7. SUBQUERY - ANY OPERATOR
     8. SUBQUERY - CORRELATED 
     9. SUBQUERY - EXISTS OPERATOR
===============================================================================
*/

/* ==============================================================================
   SUBQUERY | RESULT TYPES
===============================================================================*/

/* Scalar Query */
SELECT
    AVG(Sales)
FROM Sales.Orders;

/* Row Query */
SELECT
    CustomerID
FROM Sales.Orders;

/* Table Query */
SELECT
    OrderID,
    OrderDate
FROM Sales.Orders;

/* ==============================================================================
   SUBQUERY | FROM CLAUSE
===============================================================================*/

/* TASK 1:
   Find the products that have a price higher than the average price of all products.
*/

-- Main Query
SELECT
*
FROM (
    -- Subquery
    SELECT
        ProductID,
        Price,
        AVG(Price) OVER () AS AvgPrice
    FROM Sales.Products
) AS t
WHERE Price > AvgPrice;

/* TASK 2:
   Rank Customers based on their total amount of sales.
*/
-- Main Query
SELECT
    *,
    RANK() OVER (ORDER BY TotalSales DESC) AS CustomerRank
FROM (
    -- Subquery
    SELECT
        CustomerID,
        SUM(Sales) AS TotalSales
    FROM Sales.Orders
    GROUP BY CustomerID
) AS t;

/* ==============================================================================
   SUBQUERY | SELECT
===============================================================================*/

/* TASK 3:
   Show the product IDs, product names, prices, and the total number of orders.
*/
-- Main Query
SELECT
    ProductID,
    Product,
    Price,
    (SELECT COUNT(*) FROM Sales.Orders) AS TotalOrders -- Subquery
FROM Sales.Products;

/* ==============================================================================
   SUBQUERY | JOIN CLAUSE
===============================================================================*/

/* TASK 4:
   Show customer details along with their total sales.
*/
-- Main Query
SELECT
    c.*,
    t.TotalSales
FROM Sales.Customers AS c
LEFT JOIN ( 
    -- Subquery
    SELECT
        CustomerID,
        SUM(Sales) AS TotalSales
    FROM Sales.Orders
    GROUP BY CustomerID
) AS t
    ON c.CustomerID = t.CustomerID;

/* TASK 5:
   Show all customer details and the total orders of each customer.
*/
-- Main Query
SELECT
    c.*,
    o.TotalOrders
FROM Customers AS c
LEFT JOIN (
    -- Subquery
    SELECT
        CustomerID,
        COUNT(*) AS TotalOrders
    FROM Orders
    GROUP BY CustomerID
) AS o
    ON c.CustomerID = o.CustomerID;
    
/* ==============================================================================
   SUBQUERY | COMPARISON OPERATORS
===============================================================================*/

/* TASK 6:
   Find the products that have a price higher than the average price of all products.
*/
-- Main Query
select product,price from products
where price > (select avg(price) from products);

select productid,price,(select avg(price) from products) from products
where price >(select avg(price) from products);


/* ==============================================================================
   SUBQUERY | IN OPERATOR
===============================================================================*/

/* TASK 7:
   Show the details of orders made by customers in Germany.
*/
-- Main Query
select * from orders
where customerid in (select customerid from customers where country = "Germany");


/* TASK 8:
   Show the details of orders made by customers not in Germany.
*/
-- Main Query
select * from orders
where customerid not in (select customerid from customers where country = "Germany");

select * from orders
where customerid  in (select customerid from customers where country != "Germany");

/* ==============================================================================
   SUBQUERY | ANY OPERATOR
===============================================================================*/

/* TASK 9:
   Find female employees whose salaries are greater than the salaries of any male employees.
*/

select employeeid,firstname,salary,gender from employees
where gender = "F" and salary > any(select salary from employees
where gender ="M");
-- any operator checks if female salary is greater than any one of the male employee

-- ALL OPERATOR 
select * from employees
where gender = "F" and salary > all (select salary from employees where gender = "M");
-- all operator checks if the salary of female is greater than all male employees and there is none

/* ==============================================================================
   CORRELATED SUBQUERY
===============================================================================*/

/* TASK 10:
   Show all customer details and the total orders for each customer using a correlated subquery.
*/
select *,(select count(*) from orders o where c.customerid = o.customerid) total_orders from customers c;

/* ==============================================================================
   SUBQUERY | EXISTS OPERATOR
===============================================================================*/

/* TASK 11:
   Show the details of orders made by customers in Germany.
*/
select * from orders o
where exists (select 1 from customers c where country = "Germany" and o.customerid = c.customerid);


/* TASK 12:
   Show the details of orders made by customers not in Germany.
*/
select * from orders o
where not exists(select 1 from customers c 
				where country = "Germany"
                and o.customerid = c.customerid);


-- alternative
select * from orders o
where exists(
				select 1 from customers c
				where country != "Germany"
                and o.customerid = c.customerid);
