use mydatabase;

/* ==============================================================================
   SELECT ALL COLUMNS
=============================================================================== */
-- Retrieve All Customer Data
select * from customers;


-- Retrieve All Order Data
select * from orders;

/* ==============================================================================
   SELECT FEW COLUMNS
=============================================================================== */


-- Retrieve each customer's name, country, and score.
select first_name,country,score from customers;

/* ==============================================================================
   WHERE
=============================================================================== */


-- Retrieve customers with a score not equal to 0
select first_name,score from customers
where score != 0;

-- Retrieve customers from Germany
select * from customers
where country = 'Germany';

-- Retrieve the name and country of customers from Germany
select first_name,country from customers
where country = 'Germany';


/* ==============================================================================
   ORDER BY
=============================================================================== */

/* Retrieve all customers and 
   sort the results by the highest score first. */
   
select * from customers
order by score desc;

/* Retrieve all customers and 
   sort the results by the lowest score first. */
   
select * from customers
order by score asc;

/* Retrieve all customers and 
   sort the results by the country. */
   
select * from customers
order by country asc;

/* Retrieve all customers and 
   sort the results by the country and then by the highest score. */
   
select * from customers
order by country asc,score desc;

/* Retrieve the name, country, and score of customers 
   whose score is not equal to 0
   and sort the results by the highest score first. */
   
select first_name,country,score from customers
where score !=0
order by score desc;

/* ==============================================================================
   GROUP BY
=============================================================================== */

-- Find the total score for each country

select country,sum(score) as 'total score' from customers
group by country;

/* This will not work because 'first_name' is neither part of the GROUP BY 
   nor wrapped in an aggregate function. SQL doesn't know how to handle this column. */
   
select first_name,country,sum(score) as 'toatal_score' from customers
group by country;

-- Find the total score and total number of customers for each country
select country,sum(score),count(id) from customers
group by country;


/* ==============================================================================
   HAVING
=============================================================================== */

/* Find the average score for each country
   and return only those countries with an average score greater than 430 */
   
select country,avg(score) as 'avg_score' from customers
group by country
having avg(score)>430;


/* Find the average score for each country
   considering only customers with a score not equal to 0
   and return only those countries with an average score greater than 430 */
   
select country,avg(score) as 'avg_score'from customers
where score !=0
group by country
having avg(score)>430;

/* ==============================================================================
   DISTINCT
=============================================================================== */

-- Return Unique list of all countries

select distinct(country) from customers;

/* ==============================================================================
   TOP
=============================================================================== */

-- MYSQL DOES NOT SUPPORT (TOP) CALUSE USE (LIMIT) CLAUSE

-- Retrieve only 3 Customers
select top 3 *  from customers;


-- Retrieve the Top 3 Customers with the Highest Scores
SELECT TOP 3 *
FROM customers
ORDER BY score DESC;


-- Retrieve the Lowest 2 Customers based on the score
SELECT TOP 2 *
FROM customers
ORDER BY score ASC

-- Get the Two Most Recent Orders
SELECT TOP 2 *
FROM orders
ORDER BY order_date DESC;

/* ==============================================================================
   All Together
=============================================================================== */

/* Calculate the average score for each country 
   considering only customers with a score not equal to 0
   and return only those countries with an average score greater than 430
   and sort the results by the highest average score first. */
   
select country,avg(score) from customers
where score != 0
group by country
having avg(score)>430
order by avg(score) desc
limit 3

	
