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


/* ==============================================================================
   FORMAT()
===============================================================================*/

/* TASK 9:
   Format CreationTime into various string representations.
*/
select orderid,creationTime,
date_format(creationTime,'%Y-%M-%D') as capital,
date_format(creationTime,'%d-%m-%y') as small,
date_format(creationTime,'%D') day,
date_format(creationTime,'%M') month,
date_format(creationTime,'%Y') year
from salesdb.orders;


/* TASK 10:
   Display CreationTime using a custom format:
   Example: Day Wed Jan Q1 2025 12:34:56 PM
*/
select orderid,creationTime,
concat('Day',' ',date_format(creationTime,'%a %b')-- %a for short weekname and %b for short monthname
-- %W for full weekname %M fro ful monthname
,' ',
'Q',extract(quarter from creationTime),' ',
date_format(creationTime,'%Y %h:%i:%s %p ')) as custom_format from salesdb.orders;


/* TASK 11:
   How many orders were placed each year, formatted by month and year (e.g., "Jan 25")?
*/
select date_format(creationTime,'%b %Y') as 'month and year',count(*)as orders from salesdb.orders
group by date_format(creationTime,'%b %Y');

/* ==============================================================================
   CONVERT()
===============================================================================*/

/* TASK 12:
   Demonstrate conversion using CONVERT.
*/
select convert(123,signed) 'string to int',
-- signed keyword is used to convert string to integer to opposie is unsigned;
convert('2026-02-03',date) 'string to date',
creationTime,
convert(creationTime,date) 'datetime to date',
convert(creationTime,char) 'datetime to sring'  from salesdb.orders;

/* ==============================================================================
   CAST()
===============================================================================*/

/* TASK 13:
   Convert data types using CAST.
*/
select 
cast('123' as signed) 'string to integer',
cast(123 as char)'int to string',
cast('2026-02-03' as date) 'string to date',
cast('2026-02-03' as datetime) 'sring to datetime',
creationTime,
cast(creationTime as date)'datetime to date' from salesdb.orders;



/* TASK 14:
   Perform date arithmetic on OrderDate.
*/
select orderdate,date_add(orderdate,interval 2 year) 'two years later',
date_add(orderdate,interval -4 year)'four years before',
date_add(orderdate,interval 2 day)'two days after',
date_add(orderdate,interval 3 month)'three months later',
date_add(orderdate,interval -10 day) 'ten days before' from  orders;

/* TASK 15:
   Calculate the age of employees.
*/
select birthdate,datediff(now(),birthdate) 'age of empoyee' from employees;
-- datediff is only returns days in result not year in mysql

-- datediff() ALTERNATIVE TIMESTAMPDIFF()
-- TIMESTAMPDIFF()-- 
select birthdate,timestampdiff(year,birthdate,now()) 'age'from employees;
-- we used now() function to get current date also can use curdate()
select birthdate,timestampdiff(year,birthdate,curdate()) 'age' from employees;


/* TASK 16:
   Find the average shipping duration in days for each month.
*/
select orderdate,shipdate,datediff(shipdate,orderdate) 'sipping duration' from orders;
-- only shipping duration

select month(orderdate),round(avg(datediff(shipdate,orderdate)),0) 'avg shipping duration'from orders
group by month(orderdate);
-- average shipping duration
-- use round function if average days are in decimal

/* TASK 17:
   Time Gap Analysis: Find the number of days between each order and the previous order.
*/
select orderdate 'current orderdate',
lag(orderdate) over (order by orderdate) 'previous orderdate',
datediff(orderdate,lag(orderdate) over (order by orderdate)) 'no of days'
 from orders;
 -- used lag() function to get previous orderdate and compare diff between current orderdate;
 
 /* ==============================================================================
   ISDATE()
===============================================================================*/

/* TASK 18:
   Validate OrderDate using ISDATE and convert valid dates.
*/
select isdate('123');
-- is date function is not in mysql



