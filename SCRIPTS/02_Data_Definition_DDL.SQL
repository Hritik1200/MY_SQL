/* ==============================================================================
   SQL Data Definition Language (DDL)
-------------------------------------------------------------------------------
   This guide covers the essential DDL commands used for defining and managing
   database structures, including creating, modifying, and deleting tables.

   Table of Contents:
     1. CREATE - Creating Tables
     2. ALTER - Modifying Table Structure
     3. DROP - Removing Tables
=================================================================================
*/

/* ============================================================================== 
   CREATE
=============================================================================== */

/* Create a new table called persons 
   with columns: id, person_name, birth_date, and phone */
   
create table persons(
id int not null,
person_name varchar(50) not null,
birth_date date,
phone varchar(15) not null	,
constraint pk_person primary key(id));



/* ============================================================================== 
   ALTER
=============================================================================== */

-- Add a new column called email to the persons table

ALTER TABLE persons
ADD EMAIL varchar(50) unique NOT NULL;


-- Remove the column phone from the persons table

ALTER TABLE PERSONS
DROP COLUMN BIRTH_DATE;
-- while dropping column we don't need to specify datatype


/* ============================================================================== 
   DROP
=============================================================================== */

-- Delete the table persons from the database

drop table persons;


