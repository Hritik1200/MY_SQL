/* ============================================================================== 
   SQL Aggregate Functions
-------------------------------------------------------------------------------
   This document provides an overview of SQL aggregate functions, which allow 
   performing calculations on multiple rows of data to generate summary results.

   Table of Contents:
     1. Basic Aggregate Functions
        - COUNT
        - SUM
        - AVG
        - MAX
        - MIN
     2. Grouped Aggregations
        - GROUP BY
=================================================================================
*/

/* ============================================================================== 
   BASIC AGGREGATE FUNCTIONS
=============================================================================== */

-- Find the total number of customers
select count(*)'total_customers' from customers;

-- Find the total sales of all orders
select sum(sales) 'total_sales' from orders;


-- Find the average sales of all orders
select avg(sales) 'avg_sales' from orders;

-- Find the highest score among customers
select max(score) 'highest_score' from customers;


-- Find the lowest score among customers
select min(score)'lowest_score' from customers;

/* ============================================================================== 
   GROUPED AGGREGATIONS - GROUP BY
=============================================================================== */

-- Find the number of orders, total sales, average sales, highest sales, and lowest sales per customer
select customerid,count(*)'total_orders',
sum(sales)'total_sales',avg(sales)'avg_sales',
max(sales)'highest_sales',min(sales)'lowest_sales'
from orders
group by customerid;

