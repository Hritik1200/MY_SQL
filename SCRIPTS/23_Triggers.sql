/* ==============================================================================
   SQL Triggers
-------------------------------------------------------------------------------
   This script demonstrates the creation of a logging table, a trigger, and
   an insert operation into the Sales.Employees table that fires the trigger.
   The trigger logs details of newly added employees into the Sales.EmployeeLogs table.
=================================================================================
*/
-- Step 1: Create Log Table
create table trg_employee_logs (
logid int auto_increment primary key,
log_message varchar(100),
log_date datetime
);

rename table trg_employee_logs to employee_logs;
alter table employee_logs
modify column log_date datetime;


-- Step 2: Create Trigger on Employees Table
DELIMITER //

CREATE TRIGGER trg_employee_logs
AFTER INSERT ON ctas_employees
FOR EACH ROW
BEGIN
    INSERT INTO employee_logs (logid, log_message, log_date)
    VALUES (NEW.employeeid, 'new employee added', NOW());
END //

DELIMITER ;



-- Step 3: Insert New Data Into Employees
insert into ctas_employees (employeeid,firstname,gender)
values (7,'B','M'),
(8,'C','F');

-- Check the Logs
select * from employee_logs;



