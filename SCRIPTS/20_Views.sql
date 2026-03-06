/* ==============================================================================
   SQL Views
-------------------------------------------------------------------------------
   This script demonstrates various view use cases in SQL Server.
   It includes examples for creating, dropping, and modifying views, hiding
   query complexity, and implementing data security by controlling data access.

   Table of Contents:
     1. Create, Drop, Modify View
     2. USE CASE - HIDE COMPLEXITY
     3. USE CASE - DATA SECURITY
===============================================================================
*/

/* ==============================================================================
   CREATE, DROP, MODIFY VIEW
===============================================================================*/

/* TASK:
   Create a view that summarizes monthly sales by aggregating:
     - OrderMonth (truncated to month)
     - TotalSales, TotalOrders, and TotalQuantities.
*/

-- Create View
create view salesdb.view_total as
(
select month(orderdate) ordermonth,sum(sales) total_sales,count(orderid) total_order
from orders
group by ordermonth
);

-- Query the View

select *,sum(total_sales) over(order by ordermonth)running_total from view_total;

-- to drop view
drop view view_total;

-- Drop View if it exists
IF OBJECT_ID('Sales.V_Monthly_Summary', 'V') IS NOT NULL
    DROP VIEW Sales.V_Monthly_Summary;
GO

-- Re-create the view with modified logic
CREATE VIEW Sales.V_Monthly_Summary AS
SELECT 
    DATETRUNC(month, OrderDate) AS OrderMonth,
    SUM(Sales) AS TotalSales,
    COUNT(OrderID) AS TotalOrders
FROM Sales.Orders
GROUP BY DATETRUNC(month, OrderDate);
go; -- no need to write go in mysql while creating view


/* ==============================================================================
   VIEW USE CASE | HIDE COMPLEXITY
===============================================================================*/

/* TASK:
   Create a view that combines details from Orders, Products, Customers, and Employees.
   This view abstracts the complexity of multiple table joins.*/
-- creating view

create view salesdb.v_order_details_EU as
(
select a.orderid,a.orderdate,
b.product,b.category,
concat(coalesce(c.firstname,''),' ',coalesce(c.lastname,''))CustomerName,c.country,
concat(coalesce(d.firstname,''),' ',coalesce(d.lastname,''))EmployeeName,d.department
from orders a left join products b
on a.productid = b.productid
left join customers c
on a.customerid = c.customerid
left join employees d
on a.salespersonid = d.employeeid
);

-- retreving view table data
select * from v_order_details;
select customername from v_order_details;


/* ==============================================================================
   VIEW USE CASE | DATA SECURITY
===============================================================================*/

/* TASK:
   Create a view for the EU Sales Team that combines details from all tables,
   but excludes data related to the USA.
*/

create view salesdb.v_order_details_EU as
(
select a.orderid,a.orderdate,
b.product,b.category,
concat(coalesce(c.firstname,''),' ',coalesce(c.lastname,''))CustomerName,c.country,
concat(coalesce(d.firstname,''),' ',coalesce(d.lastname,''))EmployeeName,d.department
from orders a left join products b
on a.productid = b.productid
left join customers c
on a.customerid = c.customerid
left join employees d
on a.salespersonid = d.employeeid
where country !="USA"
);

select * from v_order_details_eu;



