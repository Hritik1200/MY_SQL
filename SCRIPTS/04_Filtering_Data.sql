/* ============================================================================== 
   SQL Filtering Data
-------------------------------------------------------------------------------
   This document provides an overview of SQL filtering techniques using WHERE 
   and various operators for precise data retrieval.

   Table of Contents:
     1. Comparison Operators
        - =, <>, >, >=, <, <=
     2. Logical Operators
        - AND, OR, NOT
     3. Range Filtering
        - BETWEEN
     4. Set Filtering
        - IN
     5. Pattern Matching
        - LIKE
=================================================================================
*/

/* ============================================================================== 
   COMPARISON OPERATORS
=============================================================================== */

-- Retrieve all customers from Germany.
select * from customers 
where country = 'Germany';

-- Retrieve all customers who are not from Germany.
select * from customers
where country !='Germany';
-- or this is also not equal
select * from customers
where country <>'Germany';

-- Retrieve all customers with a score greater than 500.
select * from customers
where score > 500;

-- Retrieve all customers with a score of 500 or more.
select * from customers
where score>= 500;

-- Retrieve all customers with a score of 500 or less.
select * from customers
where score <= 500;

/* ============================================================================== 
   LOGICAL OPERATORS
=============================================================================== */

/* Combining conditions using AND, OR, and NOT */

-- Retrieve all customers who are from the USA and have a score greater than 500.
select * from customers
where country = 'USA' and score >500;

-- Retrieve all customers who are either from the USA or have a score greater than 500.
select * from customers
where country ='USA' or score> 500;

-- Retrieve all customers with a score not less than 500.
select * from customers
where not score< 500;
-- using not operator  it will reverse the condition

	/* ============================================================================== 
   RANGE FILTERING - BETWEEN
=============================================================================== */

-- Retrieve all customers whose score falls in the range between 100 and 500.

select * from customers
where score between 100 and 500;

/* ============================================================================== 
   RANGE FILTERING - BETWEEN
=============================================================================== */

-- Retrieve all customers whose score falls in the range between 100 and 500.
select * from customers
where score between 100 and 500;

-- better than between operator 
select * from customers
where score>= 100 and score<= 500;
/* ============================================================================== 
   SET FILTERING - IN
=============================================================================== */

-- Retrieve all customers from either Germany or the USA.
select * from customers
where country ='Germany' or country = 'USA';

-- use in operator instead of or if there are multiple values to include in the same column
select * from customers
where country in('Germany','USA');

select * from customers
where country not in ('Germany','USA');
-- using not in operator do opposite of in operator it will exclude

/* ============================================================================== 
   PATTERN MATCHING - LIKE
=============================================================================== */

-- Find all customers whose first name starts with 'M'.
select * from customers
where first_name like 'M%';

-- Find all customers whose first name ends with 'n'.
select * from customers 
where first_name like '%n';

-- Find all customers whose first name contains 'r'.
select* from customers
where first_name like '%r%';

-- Find all customers whose first name has 'r' in the third position.
select * from customers 
where first_name like '__r%';

/* if only use undrscore it will search for only words matching the number of underscores you put so 
put % sign according to you where you awant begining or ending/*



