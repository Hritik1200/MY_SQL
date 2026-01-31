/* ==============================================================================
   SQL Date & Time Functions
-------------------------------------------------------------------------------
   This script demonstrates various date and time functions in SQL.
   It covers functions such as GETDATE, DATETRUNC, DATENAME, DATEPART,
   YEAR, MONTH, DAY, EOMONTH, FORMAT, CONVERT, CAST, DATEADD, DATEDIFF,
   and ISDATE.
   
   Table of Contents:
     1. GETDATE | Date Values
     2. Date Part Extractions (DATETRUNC, DATENAME, DATEPART, YEAR, MONTH, DAY)
     3. DATETRUNC
     4. EOMONTH
     5. Date Parts
     6. FORMAT
     7. CONVERT
     8. CAST
     9. DATEADD / DATEDIFF
    10. ISDATE
===============================================================================
*/

/* ==============================================================================
   GETDATE() | DATE VALUES
===============================================================================*/

/* TASK 1:
   Display OrderID, CreationTime, a hard-coded date, and the current system date.
*/
select orderId,creationTime,'2026-01-29' as 'Hardcoded',now() as Today from salesdb.orders;
-- getdate() is not available in mysql so we are using [now()]
-- now() also returns curent date and time

-- Day(),month(),year() funtion
select orderid,creationtime,day(creationtime) as day,
month(creationtime),
year(creationtime) from salesdb.orders
order by day asc ;




/* ==============================================================================
   DATE PART EXTRACTIONS
   (DATETRUNC, DATENAME, DATEPART, YEAR, MONTH, DAY)
===============================================================================*/

/* TASK 2:
   Extract various parts of CreationTime using DATETRUNC, DATENAME, DATEPART,
   YEAR, MONTH, and DAY.
*/
select orderId,creationTime,
 -- DATETRUNC Examples alternative date_format()
 date_format(creationTime,'%y-%m-01 00-00-00'),
 date_format(creationTime, '%Y-%m-%d %H:00:00'),
  -- DATENAME Examples alternative date_format()
date_format(creationTime,'%Y') as year,
date_format(creationTime,'%M') as month_name,
date_format(creationtime,'%D') as day,
date_format(creationTime,'%W') as week_name,
-- date_format(creatime_time)
 -- DATEPART Examples alternative EXTARCT() examples
extract(year from creationTime) as year_ex,
extract(month from creationTime) as month_ex,
extract(day from creationTime) as day_ex,
extract(week from creationTime) as 'week-no_ex',
extract(quarter from creationTime) as quarter_Ex,
day(creationtime) as day,
month(creationtime),
year(creationtime) from salesdb.orders;
-- we dont have datepart in mysql there is alternative caled EXTRACT()
-- syntax datepart(part_name,column name)
-- syntax extract(part_name from column_name)

/* ==============================================================================
   DATETRUNC() DATA AGGREGATION
===============================================================================*/

/* TASK 3:
   Aggregate orders by year using DATETRUNC on CreationTime.
*/
-- ALTERNATIVE FOR DATETRUNC IS DATE_FORMAT()
select date_format(creationTime,'%y') creation,count(*) ordercount from salesdb.orders
group by date_format(creationTime,'%y');
-- select date_format(creationTime,'%y') from salesdb.orders;

/* ==============================================================================
   EOMONTH()
===============================================================================*/

/* TASK 4:
   Display OrderID, CreationTime, and the end-of-month date for CreationTime.
*/
-- EOMONTH() ALTERNATIVE LAST_DAY()
select orderId,creationTime,last_day(creationTime) end_of_month from salesdb.orders ;

/* ==============================================================================
   DATE PARTS | USE CASES
===============================================================================*/

/* TASK 5:
   How many orders were placed each year?
*/
select year(orderdate),count(*) total_orders from salesdb.orders
group by year(orderdate);

/* TASK 6:
   How many orders were placed each month?
*/
select month(orderdate),count(*) from salesdb.orders
group by month(orderdate);

/* TASK 7:
   How many orders were placed each month (using friendly month names)?
*/
-- Datename() alternative DATE_FORMAT() gives output in string
select date_format(orderdate,'%M'),count(*) from salesdb.orders
group by date_format(orderdate,'%M');


/* TASK 8:
   Show all orders that were placed during the month of February.
*/
select * from salesdb.orders
where month(orderDate)= 2;









