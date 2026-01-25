/* ============================================================================== 
   MULTIPLE TABLE JOINS (4 Tables)
=============================================================================== */

/* Task: Using SalesDB, Retrieve a list of all orders, along with the related customer, product, 
   and employee details. For each order, display:
   - Order ID
   - Customer's name
   - Product name
   - Sales amount
   - Product price
   - Salesperson's name */

USE SalesDB;

select a.orderid,a.sales,b.firstname as 'customer.f',b.lastname as 'customer.l',
c.product,c.price,d.firstname as 'Employee.F',d.lastname as 'Employee.L' from
orders as a left join customers as b
on a.customerid = b.customerid
left join products as c
on a.productid = c.productid
left join employees as d
on a.salespersonid = d.employeeid ;
