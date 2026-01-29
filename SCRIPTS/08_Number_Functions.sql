/* ============================================================================== 
   SQL Number Functions Guide
-------------------------------------------------------------------------------
   This document provides an overview of SQL number functions, which allow 
   performing mathematical operations and formatting numerical values.

   Table of Contents:
     1. Rounding Functions
        - ROUND
     2. Absolute Value Function
        - ABS
=================================================================================
*/

/* ============================================================================== 
   ROUND() - Rounding Numbers
=============================================================================== */

-- Demonstrate rounding a number to different decimal places
select 3.516;

select 3.516,round(3.516,2) as 'round 2',-- 6 is greater thn 5 that's why it round 1 to 2
round(3.516,1) as 'round 1' ,-- 1 is smaller than 5 that's why it does not round 5
round(3.516,0) as 'round 0';-- 5 is equal that's why it round 3 to 4
-- 3.516
-- 0.123 numbering of upper if we type zero it gonna round 3

/* ============================================================================== 
   ABS() - Absolute Value
=============================================================================== */

-- Demonstrate absolute value function

select -10,
abs(-10) as 'negative to positive';
-- converts negative number to positive

