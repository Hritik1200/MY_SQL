/* ==============================================================================
   SQL Joins 
-------------------------------------------------------------------------------
   This document provides an overview of SQL joins, which allow combining data
   from multiple tables to retrieve meaningful insights.

   Table of Contents:
     1. Basic Joins
        - INNER JOIN
        - LEFT JOIN
        - RIGHT JOIN
        - FULL JOIN
     2. Advanced Joins
        - LEFT ANTI JOIN
        - RIGHT ANTI JOIN
        - ALTERNATIVE INNER JOIN
        - FULL ANTI JOIN
        - CROSS JOIN
     3. Multiple Table Joins (4 Tables)
=================================================================================
*/

/* ============================================================================== 
   BASIC JOINS 
=============================================================================== */

-- No Join
/* Retrieve all data from customers and orders as separate results */
select * from customers;

select*from orders;

-- INNER JOIN
/* Get all customers along with their orders, 
   but only for customers who have placed an order */

select * from customers as a inner join orders as b
on a.id = b.customer_id;

select id,first_name,order_id,sales from customers as a join orders as b
on id = customer_id;

-- LEFT JOIN
/* Get all customers along with their orders, 
   including those without orders */

select * from customers as a left join orders as b
on a.id = b.customer_id;

-- RIGHT JOIN
/* Get all customers along with their orders, 
   including orders without matching customers */
   
select * from customers as a right join orders as b
on a.id = b.customer_id;

-- FULL JOIN
/* Get all customers and all orders, even if there’s no match */

select * from customers as a full join orders as b
on a.id  =b.customer_id;

-- full join not work in my sql 

-- Alternative to RIGHT JOIN using LEFT JOIN
/* Get all customers along with their orders, 
   including orders without matching customers */
   
select * from orders as a left join customers as b
on a.customer_id = b.id;
