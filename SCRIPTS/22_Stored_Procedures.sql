/* ==============================================================================
   SQL Stored Procedures 
-------------------------------------------------------------------------------
   This script shows how to work with stored procedures in SQL Server,
   starting from basic implementations and advancing to more sophisticated
   techniques.

   Table of Contents:
     1. Basics (Creation and Execution)
     2. Parameters
     3. Multiple Queries
     4. Variables
     5. Control Flow with IF/ELSE
     6. Error Handling with TRY/CATCH
=================================================================================
*/




/* ==============================================================================
   Basic Stored Procedure
============================================================================== */

-- Define the Stored Procedure
-- MYSQL
-- step 1: write a query
-- for usa customers find the total number of customers and the average score

select count(*) totalcustomers,avg(score) avg_score from salesdb.customers
where country = 'USA';

-- step 2 : turning the query in stored procedure
DELIMITER //
CREATE PROCEDURE customer_avg_score()
BEGIN
    SELECT 
        COUNT(*) AS totalcustomers, 
        AVG(score) AS avg_score 
    FROM salesdb.customers
    WHERE country = 'USA';
END //

DELIMITER ;

-- step 3 : execute the stored procedure
call customer_avg_score();


/* ==============================================================================
   Parameters in Stored Procedure
============================================================================== */

-- Edit the Stored Procedure
-- mysql doesnt have alter sored procedure
-- we have to drop existing one

DROP PROCEDURE customer_avg_score;
DROP PROCEDURE IF EXISTS customer_avg_score;

-- recreating it
DELIMITER //
CREATE PROCEDURE customer_avg_score ( in 
country varchar(50))
BEGIN
    SELECT 
        COUNT(*) AS totalcustomers, 
        AVG(score) AS avg_score 
    FROM salesdb.customers
    WHERE country = country;
END //

DELIMITER ;


call customer_avg_score('Germany');

-- SQL SERVER
alter PROCEDURE customer_avg_score @country nvarchar (50)
AS
BEGIN
    SELECT 
        COUNT(*) AS totalcustomers, 
        AVG(score) AS avg_score 
    FROM salesdb.customers
    WHERE country = @country
END
GO;

EXEC customer_avg_score @country = 'USA';

drop procedure customer_avg_score;

/* ==============================================================================
   Multiple Queries in Stored Procedure
============================================================================== */
DELIMITER //
create procedure GET_SCORE_COUNTRY (IN F_COUNTRY VARCHAR(50))
BEGIN
	SELECT COUNT(*) AS TOTALCUSTOMERS,
    AVG(SCORE) AS AVG_SCORE
    FROM CUSTOMERS
    WHERE COUNTRY = F_COUNTRY COLLATE utf8mb4_0900_ai_ci;
    
    SELECT COUNT(ORDERID) AS TOTALORDERS,
    SUM(SALES) TOTALSALES FROM ORDERS A
    JOIN CUSTOMERS B 
    ON A.CUSTOMERID = B.CUSTOMERID
    WHERE B.COUNTRY = F_COUNTRY COLLATE utf8mb4_0900_ai_ci;
END //

DELIMITER ;
DROP PROCEDURE IF EXISTS GET_SCORE_COUNTRY;

CALL  GET_SCORE_COUNTRY ('GERMANY');


/* ==============================================================================
   Variables in Stored Procedure
============================================================================== */
DROP PROCEDURE IF EXISTS  GetCustomerSummary;
DELIMITER //

CREATE  PROCEDURE GetCustomerSummary (IN p_Country VARCHAR(50))
BEGIN
    -- Declare local variables (must be at the top of the BEGIN block)
    DECLARE v_TotalCustomers INT;
    DECLARE v_AvgScore DECIMAL(10,2);
                
    -- Query 1: Assign results to variables using INTO
    SELECT
        COUNT(*),
        AVG(Score)
    INTO v_TotalCustomers, v_AvgScore
    FROM Customers
    WHERE Country = p_Country COLLATE utf8mb4_0900_ai_ci;

    -- Replacement for PRINT: SELECT as a result set for debugging/logging
    SELECT CONCAT('Total Customers from ', p_Country, ': ', IFNULL(v_TotalCustomers, 0)) AS LogMessage1;
    SELECT CONCAT('Average Score from ', p_Country, ': ', IFNULL(v_AvgScore, 0)) AS LogMessage2;

    -- Query 2: Standard SELECT to return the final result set
    SELECT
        COUNT(o.OrderID) AS TotalOrders,
        SUM(o.Sales) AS TotalSales
    FROM Orders AS o
    JOIN Customers AS c ON c.CustomerID = o.CustomerID
    WHERE c.Country = p_Country COLLATE utf8mb4_0900_ai_ci;
END //

DELIMITER ;

CALL  GetCustomerSummary('GERMANY');

DROP PROCEDURE IF EXISTS GetCustomerSummary;

DELIMITER //

CREATE PROCEDURE GetCustomerSummary (IN p_Country VARCHAR(50))
BEGIN
    -- 1. Declare Local Variables (Must be at the very top of the BEGIN block)
    DECLARE v_TotalCustomers INT;
    DECLARE v_AvgScore FLOAT;
    
    -- Variables to capture error details
    DECLARE v_SqlState CHAR(5) DEFAULT '00000';
    DECLARE v_ErrNo INT DEFAULT 0;
    DECLARE v_ErrMsg TEXT DEFAULT '';

    -- 2. Declare the Exception Handler (The MySQL equivalent of BEGIN CATCH)
    -- EXIT HANDLER stops execution of the procedure and runs this block if an error occurs
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        -- Capture the error diagnostic information
        GET DIAGNOSTICS CONDITION 1 
            v_SqlState = RETURNED_SQLSTATE, 
            v_ErrNo = MYSQL_ERRNO, 
            v_ErrMsg = MESSAGE_TEXT;
            
        -- Replacement for PRINT statements
        SELECT 'An error occurred.' AS Error_Status;
        SELECT CONCAT('Error Message: ', v_ErrMsg) AS Error_Message;
        SELECT CONCAT('Error Number: ', v_ErrNo) AS Error_Number;
        SELECT CONCAT('SQL State: ', v_SqlState) AS Error_State;
    END;

    /* --------------------------------------------------------------------------
       Prepare & Cleanup Data (Simulating the T-SQL Default Parameter '@Country = 'USA'')
    -------------------------------------------------------------------------- */
    IF p_Country IS NULL OR p_Country = '' THEN
        SET p_Country = 'USA';
    END IF;

    -- Check if NULL scores exist
    IF EXISTS (SELECT 1 FROM Customers WHERE Score IS NULL AND Country = p_Country) THEN
        SELECT 'Updating NULL Scores to 0' AS Process_Log;
        
        UPDATE Customers
        SET Score = 0
        WHERE Score IS NULL AND Country = p_Country;
    ELSE
        SELECT 'No NULL Scores found' AS Process_Log;
    END IF;

    /* --------------------------------------------------------------------------
       Generating Reports
    -------------------------------------------------------------------------- */
    
    -- Query 1: Find the Total Nr. of Customers and the Average Score
    SELECT COUNT(*), AVG(Score)
    INTO v_TotalCustomers, v_AvgScore
    FROM Customers
    WHERE Country = p_Country;

    -- Print logs
    SELECT CONCAT('Total Customers from ', p_Country, ': ', IFNULL(v_TotalCustomers, 0)) AS LogMessage1;
    SELECT CONCAT('Average Score from ', p_Country, ': ', IFNULL(v_AvgScore, 0)) AS LogMessage2;

    -- Query 2: Find Total Orders and Sales (Including the intentional division by zero)
    SELECT
        COUNT(o.OrderID) AS TotalOrders,
        SUM(o.Sales) AS TotalSales,
        (1 / 0) AS FaultyCalculation  -- This triggers the SQLEXCEPTION handler
    FROM Orders AS o
    JOIN Customers AS c ON c.CustomerID = o.CustomerID
    WHERE c.Country = p_Country;

END //

DELIMITER ;

-- ==============================================================================
-- Execute Stored Procedure (MySQL Syntax)
-- ==============================================================================
CALL GetCustomerSummary('Germany');
CALL GetCustomerSummary('USA');
CALL GetCustomerSummary(NULL); -- This will default to 'USA' inside the code



