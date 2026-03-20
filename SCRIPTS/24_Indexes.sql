/* ==============================================================================
   SQL Indexing in MySQL (Converted from SQL Server)
   Compatible with MySQL 8.0+
================================================================================= */


/* ==============================================================================
   1. Create Table (Equivalent of SELECT INTO)
============================================================================== */

-- MySQL does not support SELECT INTO like SQL Server
-- Instead we use CREATE TABLE ... AS SELECT

CREATE TABLE DBCustomers AS
SELECT *
FROM Customers;


/* ==============================================================================
   2. Test Query (Check performance manually using EXPLAIN)
============================================================================== */

EXPLAIN SELECT *
FROM DBCustomers
WHERE CustomerID = 1;


/* ==============================================================================
   3. Clustered Index (MySQL Equivalent)
============================================================================== */

-- MySQL does not allow explicit clustered index
-- PRIMARY KEY automatically becomes clustered index (InnoDB)

ALTER TABLE DBCustomers
ADD PRIMARY KEY (CustomerID);

-- Trying to add another PRIMARY KEY will fail
-- (same concept as second clustered index in SQL Server)


/* ==============================================================================
   4. Drop Index
============================================================================== */

-- Drop PRIMARY KEY (Clustered index equivalent)
ALTER TABLE DBCustomers DROP PRIMARY KEY;


/* ==============================================================================
   5. Non-Clustered Indexes
============================================================================== */

-- Query before index
EXPLAIN SELECT *
FROM DBCustomers
WHERE LastName = 'Brown';

-- Create index on LastName
CREATE INDEX idx_DBCustomers_LastName
ON DBCustomers (LastName);

-- Create index on FirstName
CREATE INDEX idx_DBCustomers_FirstName
ON DBCustomers (FirstName);


/* ==============================================================================
   6. Composite Index
============================================================================== */

-- Composite index (order matters!)
CREATE INDEX idx_DBCustomers_CountryScore
ON DBCustomers (Country, Score);

-- Uses index (correct order)
EXPLAIN SELECT *
FROM DBCustomers
WHERE Country = 'USA'
  AND Score > 500;

-- Might NOT use index properly (wrong order)
EXPLAIN SELECT *
FROM DBCustomers
WHERE Score > 500
  AND Country = 'USA';


/* ==============================================================================
   7. Leftmost Prefix Rule (Important Concept)
============================================================================== */

-- Index (A, B)
-- Works for:
-- WHERE A = ?
-- WHERE A = ? AND B = ?

-- Does NOT work efficiently for:
-- WHERE B = ?


/* ==============================================================================
   8. Columnstore Index (NOT SUPPORTED IN MYSQL)
============================================================================== */

-- ❌ MySQL does not support columnstore indexes
-- Alternative:
-- Use InnoDB + proper indexing
-- OR use external tools (like ClickHouse, BigQuery)


/* ==============================================================================
   9. Unique Index
============================================================================== */

-- Unique index on Product
CREATE UNIQUE INDEX idx_Products_Product
ON Products (Product);

-- Insert duplicate → will FAIL
INSERT INTO Products (ProductID, Product)
VALUES (106, 'Caps');


/* ==============================================================================
   10. Filtered Index (NOT SUPPORTED)
============================================================================== */

-- ❌ MySQL does not support filtered indexes

-- Alternative: Create index on column
CREATE INDEX idx_Customers_Country
ON Customers (Country);

-- MySQL will still use it for:
SELECT *
FROM Customers
WHERE Country = 'USA';

-- Advanced workaround (generated column)
-- CREATE COLUMN + INDEX if needed


/* ==============================================================================
   11. Monitor Indexes
============================================================================== */

-- Show all indexes on table
SHOW INDEX FROM DBCustomers;

-- Detailed table info
SHOW CREATE TABLE DBCustomers;


/* ==============================================================================
   12. Index Usage (Approximation)
============================================================================== */

-- MySQL does not provide exact usage stats like SQL Server

-- Use EXPLAIN to check index usage
EXPLAIN SELECT *
FROM DBCustomers
WHERE LastName = 'Brown';


/* ==============================================================================
   13. Missing Indexes (Manual Detection)
============================================================================== */

-- MySQL does not track missing indexes automatically

-- You identify manually using:
EXPLAIN SELECT *
FROM DBCustomers
WHERE Score > 500;


/* ==============================================================================
   14. Duplicate Index Detection
============================================================================== */

-- Find duplicate indexes (basic approach)
SELECT 
    TABLE_NAME,
    INDEX_NAME,
    COLUMN_NAME
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = DATABASE()
ORDER BY TABLE_NAME, COLUMN_NAME;


/* ==============================================================================
   15. Update Statistics
============================================================================== */

-- MySQL automatically maintains stats
-- But you can force update:

ANALYZE TABLE DBCustomers;


/* ==============================================================================
   16. Fragmentation (Optimization)
============================================================================== */

-- Check table status
SHOW TABLE STATUS LIKE 'DBCustomers';

-- Rebuild table (similar to rebuild index)
OPTIMIZE TABLE DBCustomers;


/* ==============================================================================
   SUMMARY
============================================================================== */

-- SQL Server vs MySQL Key Differences:

-- 1. Clustered Index:
--    SQL Server → Explicit
--    MySQL → PRIMARY KEY

-- 2. Columnstore:
--    SQL Server → Supported
--    MySQL → ❌ Not supported

-- 3. Filtered Index:
--    SQL Server → Supported
--    MySQL → ❌ Not supported

-- 4. Monitoring:
--    SQL Server → DMVs
--    MySQL → Limited (EXPLAIN + INFORMATION_SCHEMA)







/* ==============================================================================
   SQL Indexing
-------------------------------------------------------------------------------
   This script demonstrates various index types in SQL Server including clustered,
   non-clustered, columnstore, unique, and filtered indexes. It provides examples 
   of creating a heap table, applying different index types, and testing their 
   usage with sample queries.

   Table of Contents:
	   Index Types:
			 - Clustered and Non-Clustered Indexes
			 - Leftmost Prefix Rule Explanation
			 - Columnstore Indexes
			 - Unique Indexes
			 - Filtered Indexes
		Index Monitoring:
			 - Monitor Index Usage
			 - Monitor Missing Indexes
			 - Monitor Duplicate Indexes
			 - Update Statistics
			 - Fragmentations
=================================================================================
*/

/* ==============================================================================
   Clustered and Non-Clustered Indexes
============================================================================== */

-- Create a Heap Table as a copy of Sales.Customers 
create table ctas_customers as
(
select * from customers
);

-- Test Query: Select Data and Check the Execution Plan
SELECT *
FROM ctas_customers
WHERE CustomerID = 1;

-- Create a Clustered Index on Sales.DBCustomers using CustomerID
create clustered index inx_salesdb_cutomersid on customers (customerid); -- sql server syntax
drop index  inx_salesdb_cutomersid on salesdb.customers


-- Attempt to create a second Clustered Index on the same table (will fail) 
CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID
ON Sales.DBCustomers (CustomerID);

-- ONLY ONE INDEX PER TABLE
-- mysql (innodb) syntax to create  clustered index
alter table ctas_customers
add primary key (customerid); -- primary key means clusterd index


-- Drop the Clustered Index 
alter table ctas_customers
drop primary key ;

-- Test Query: Select Data with a Filter on LastName
select * from ctas_customers
where lastname = "Brown";

-- Create a Non-Clustered Index on LastName
create index idx_ctascustomers_lastname on ctas_customers (lastname);
-- mysql dont need nonclustered keyword 

-- Create an additional Non-Clustered Index on FirstName
create index idx_ctascustomers_firstname on ctas_customers (firstname);

-- we can create multiple nonclusterd index

-- Create a Composite (Composed) Index on Country and Score 
create index idx_ctascustomers_country_score on ctas_customers (country,score);
-- order should be same of columns selected in index and query like country 1st and score 2nd
-- Query that uses the Composite Index
select * from ctas_customers
where country = "USA" and score >500;


-- Query that likely won't use the Composite Index due to column order
select * from ctas_customers
where score >500 and country = "USA";
-- this query will not use composite index because score is 1st column and country is 2nd column

/* ==============================================================================
   Leftmost Prefix Rule Explanation
-------------------------------------------------------------------------------
   For a composite index defined on columns (A, B, C, D), the index can be
   utilized by queries that filter on:
     - Column A only,
     - Columns A and B,
     - Columns A, B, and C.
   However, queries that filter on:
     - Column B only,
     - Columns A and C,
     - Columns A, B, and D,
   will not be able to fully utilize the index due to the leftmost prefix rule.
=================================================================================
*/
select * from ctas_customers
where country = "USA";
-- country is left column so it uses index but if we use score it will not use index
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
-- ============================================================================================================-- 
use salesdb;
-- creating ctas
create table ctas_customers as
(
select * from customers);

select * from ctas_customers;

-- creating index nonclustered
create index index_ctas_customers_customerid on ctas_customers (customerid);

-- drop index for nonclustered
drop index index_ctas_customers_customerid on ctas_customers;

-- creating index clustered
alter table ctas_customers
add primary key (customerid,firstname);

-- droping clustered index
alter table ctas_customers
drop primary key;

-- creating columnstore index
create index columnstore


/* ==============================================================================
   Unique Indexes
============================================================================== */
-- Attempt to create a Unique Index on the Category column in Sales.Products.
   Note: This may fail if duplicate values exist.;
select * from products;
create unique index idx_customers_category on products (category);
-- this query will not work because category have duplicate values

-- Create a Unique Index on the Product column in Sales.Products
create unique index idx_product on products (product);

-- Test Insert: Attempt to insert a duplicate value (should fail if the constraint is enforced)
insert into products(productid,product)
values (106,'caps');
-- caps is already in products so it will give error

/* ==============================================================================
   Filtered Indexes
============================================================================== */

-- Test Query: Select Customers where Country is 'USA' 
select * from customers
where country = 'USA';

-- Create a Non-Clustered Filtered Index on the Country column for rows where Country = 'USA'
create index idx_customer_USA on customers (country)
where country = 'usa';
-- mysql not support where clause while creating index

/* ==============================================================================
   Index Monitoring
-------------------------------------------------------------------------------
     - List indexes and monitor their usage.
     - Report missing and duplicate indexes.
     - Retrieve and update statistics.
     - Check index fragmentation and perform index maintenance (reorganize/rebuild).
=================================================================================
*/

/* ==============================================================================
   Monitor Index Usage
============================================================================== */

-- List all indexes on a specific table
select * from sys.indexes;

SHOW INDEXES FROM products; -- mysql

/* ==============================================================================
   Monitor Missing Indexes
============================================================================== */
SELECT * 
FROM sys.dm_db_missing_index_details;

-- Check Index Usage mysql
explain select * from products;

/* ==============================================================================
   Monitor Duplicate Indexes
============================================================================== */
SELECT table_name,index_name,column_name,index_type,count(*) over(partition by table_name,column_name) column_count
FROM information_schema.statistics
WHERE table_schema = 'salesdb'
order by column_count desc;

select* from ctas_customers;
-- creating clustered index
alter table ctas_customers
add primary key (firstname);

-- creating nonclustered index
create unique index idx_ctas_customers_score on ctas_customers(lastname);

-- drop duplicate index
-- syntax to drop primary key
alter table ctas_customers
drop primary key;
-- syntax to drop nonclustered index
drop  index idx_ctas_customers_score on ctas_customers;

SELECT 
    NAME, 
    NUM_ROWS, 
    MODIFIED_COUNTER, 
    STATS_INITIALIZED 
FROM INFORMATION_SCHEMA.INNODB_TABLESTATS 
WHERE name = 'salesdb';







