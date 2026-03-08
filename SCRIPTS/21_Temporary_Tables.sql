/* ==============================================================================
   SQL Temporary Tables
-------------------------------------------------------------------------------
   This script provides a generic example of data migration using a temporary
   table. 
=================================================================================
*/

/* ==============================================================================
   Step 1: Create Temporary Table (#Orders)
============================================================================== */
create temporary table salesdb.orders_temp as
(
select * from orders);
-- we can make changes in it and it will not effect original data and it 
-- will be  deleted once session ends

/* inserting values in temp tabale */
insert into orders_temp (orderid)
values (11),
		(12);
select * from orders_temp;

/*deleting values from teporary table*/
/* ==============================================================================
   Step 2: Clean Data in Temporary Table
============================================================================== */
SET SQL_SAFE_UPDATES = 0;

delete from orders_temp
where orderstatus = "Delivered";

select * from orders_temp;
-- If you want the column at the beginning:-- 
alter table orders_temp
add temp_column1 varchar(50) first;
select * from orders_temp;
-- default new column will be last column

/* altering table structure */
-- If you want the column after a specific field:
-- use after and column name
	alter table orders_temp
	add temp_column bigint after salespersonid;
 
 --  drop column 
 alter table orders_temp
 drop column temp_column1;

select * from orders_temp;

/* ==============================================================================
   Step 3: Load Cleaned Data into Permanent Table (Sales.OrdersTest)
============================================================================== */
-- ____________________ CTAS______________________--
create table salesdb.orders_delivered as
(select * from orders_temp);

select * from orders_delivered;
