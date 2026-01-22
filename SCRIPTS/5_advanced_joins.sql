/* ============================================================================== 
   ADVANCED JOINS
=============================================================================== */

-- LEFT ANTI JOIN
/* Get all customers who haven't placed any order */
select * from customers as a left join orders as b
on a.id = b.customer_id
where b.customer_id is null;
-- if we want data only from left table which is not in right table

-- RIGHT ANTI JOIN
/* Get all orders without matching customers */

select * from customers as a right join orders as b
on a.id = b.customer_id
where a.id is null;
-- if we want data only from right table which is not in left table

-- Alternative to RIGHT ANTI JOIN using LEFT JOIN
/* Get all orders without matching customers */
select * from  orders as a left join customers as b
on a.customer_id= b.id
where b.id is null;


-- FULL ANTI JOIN
/* Find customers without orders and orders without customers */

select * from customers as a   full join orders as b 
on a.id = b.customer_id
where a.id is null
or 
b.customer_is is null;

-- full join not work in my sql

-- Alternative to INNER JOIN using LEFT JOIN
/* Get all customers along with their orders, 
   but only for customers who have placed an order */
   
select * from customers as a left join orders as b
on a.id = b.customer_id
where b.customer_id is not null;

/* if i used only left join all rows of left table will be in result 
with using where i want onlt data which is not null in right table
so sql will return only mathching rows


-- CROSS JOIN
/* Generate all possible combinations of customers and orders */

select * from customers cross join orders;
-- cobine every row from left with every row from right
-- all possible combinations - cartesian join
-- multipying left table rows with right table rows
-- no need for condition to join 
-- like in this id 1 is matched with every row in order table

