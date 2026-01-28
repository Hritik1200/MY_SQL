/* ============================================================================== 
   SQL String Functions
-------------------------------------------------------------------------------
   This document provides an overview of SQL string functions, which allow 
   manipulation, transformation, and extraction of text data efficiently.

   Table of Contents:
     1. Manipulations
        - CONCAT
        - LOWER
        - UPPER
	- TRIM
	- REPLACE
     2. Calculation
        - LEN
     3. Substring Extraction
        - LEFT
        - RIGHT
        - SUBSTRING
=================================================================================
*/

/* ============================================================================== 
   CONCAT() - String Concatenation
=============================================================================== */

-- Concatenate first name and country into one column
select first_name,country,concat(first_name,'',country) as 'Firstname with country' from customers;
select first_name,country,concat(first_name,' ',country) as 'Firstname with country' from customers;
select first_name,country,concat(first_name,'_',country) as 'Firstname with country' from customers;
select first_name,country,concat(first_name,' From ',country) as 'Firstname with country' from customers;

/* combine multipe strings into one using concat 
   the semicolom in between is for spacing if we leave blank between semicolom it wil just give space
   we can put signs also eg(-,_) we can write also something 
   
/* ============================================================================== 
   LOWER() & UPPER() - Case Transformation
=============================================================================== */

-- Convert the first name to lowercase
select first_name,country,concat(first_name,'_',country) as 'Firstname with country',
lower(first_name) as 'Low_name' from customers;
/* converts all characters to Lower case using Lower*/

-- Convert the first name to uppercase

select first_name,country,concat(first_name,'_',country) as 'Firstname with country',
lower(first_name) as 'Low_Name',upper(first_name) as 'Uppper_name' from customers;
/* we can convert all characters to uppercase using UPPER

/* ============================================================================== 
   TRIM() - Remove White Spaces
=============================================================================== */

-- Find customers whose first name contains leading or trailing spaces
select first_name from customers;
select first_name,trim(first_name) as 'Trim' from customers;

select first_name,length(first_name) from customers;

select first_name,length(first_name) as  'length before trim' ,length(trim(first_name)) as 'length after trim' from customers;

select first_name,
length(first_name) as  'length before trim' ,
length(trim(first_name)) as 'length after trim',
length(first_name)-length(trim(first_name)) as 'space removed count' from customers;

select first_name from customers
where first_name != trim(first_name);

select first_name,
length(first_name) as  'length before trim' ,
length(trim(first_name)) as 'length after trim',
length(first_name)-length(trim(first_name)) as 'space removed count' from customers
where length(first_name)!=length(trim(first_name));

-- this is the easiest to check if there is space in any character
select first_name from customers
where first_name != trim(first_name);

/* ============================================================================== 
   REPLACE() - Replace or Remove old value with new one
=============================================================================== */
-- Remove dashes (-) from a phone number
select '123-456-7890' as 'Phone_number',
replace('123-456-7890','-','/') as 'replace (-) with (/)',
replace('123-456-7890','-','') as 'replace (-) with (nothing/blank)';
/* replace specific character with new character 
or blank */

-- Replace File Extence from txt to csv
select 'report.txt' as 'old file name',
replace('report.txt','.txt','.csv')as 'new file name';
-- change file type

/* ============================================================================== 
   LEN() - String Length & Trimming
=============================================================================== */

-- Calculate the length of each customer's first name
select first_name,length(first_name) as 'length of firstname' from customers;

	
/* ============================================================================== 
   LEFT() & RIGHT() - Substring Extraction
=============================================================================== */
-- Retrieve the first two characters of each first name
select first_name,left(first_name,2) as 'extract first 2 characters using (left)' from customers;
/* extract specific number of characters from the start
it also counts space egin john there is space at starting it only give j */

select first_name,left(trim(first_name),2) as 'extract first 2 characters using (left) after trim' from customers;

-- Retrieve the last two characters of each first name
select first_name,right(first_name,2) as 'extract last 2 characters using (left)' from customers;
-- extract specific number of caracters from the end

/* ============================================================================== 
   SUBSTRING() - Extracting Substrings
=============================================================================== */

-- Retrieve a list of customers' first names after removing the first character
select first_name,
substring(trim(first_name),2,length(first_name)) as 'sub_name' from customers;
/* extract a part of string from specified position 
in this we split first word of firstname and 
use length function so we dont have to specify the lenth of last word  to split 
*/


/* ==============================================================================
   NESTING FUNCTIONS
===============================================================================*/

-- Nesting
SELECT
first_name, 
UPPER(LOWER(first_name)) AS nesting
FROM customers

-- it first became lower than became upper
