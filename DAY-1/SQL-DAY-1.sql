/*
================================================================================
DAY 1: SQL BASICS
================================================================================
*/

-- =============================================================================
-- SQL INTRODUCTION
-- =============================================================================
/*
SQL (Structured Query Language): Language for managing relational databases
- Used to store, retrieve, update, and delete data
- Standard language for RDBMS (MySQL, PostgreSQL, SQL Server, Oracle)
- Declarative language - you specify WHAT you want, not HOW to get it

Why Learn SQL?
- Essential for data analysis and data science
- Used in backend development
- Required for database management
- Powerful for handling large datasets
- Industry standard across companies

SQL Statement Types:
- DQL (Data Query Language): SELECT
- DML (Data Manipulation Language): INSERT, UPDATE, DELETE
- DDL (Data Definition Language): CREATE, ALTER, DROP
- DCL (Data Control Language): GRANT, REVOKE
- TCL (Transaction Control Language): COMMIT, ROLLBACK

SQL is NOT case-sensitive for keywords, but:
- Write keywords in UPPERCASE for readability (convention)
- Table/column names may be case-sensitive depending on RDBMS
*/


-- =============================================================================
-- DATABASE & TABLE BASICS
-- =============================================================================

-- Create a sample database
CREATE DATABASE company_db;

-- Use the database
USE company_db;

-- Create a sample table for practice
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    city VARCHAR(50),
    salary DECIMAL(10, 2),
    department VARCHAR(50),
    hire_date DATE
);

-- Insert sample data
INSERT INTO employees VALUES
(1, 'Amit', 'Sharma', 28, 'Mumbai', 45000, 'IT', '2020-01-15'),
(2, 'Priya', 'Patel', 32, 'Delhi', 55000, 'HR', '2019-03-20'),
(3, 'Rajesh', 'Kumar', 25, 'Bangalore', 42000, 'IT', '2021-06-10'),
(4, 'Anjali', 'Singh', 30, 'Mumbai', 60000, 'Finance', '2018-11-05'),
(5, 'Arjun', 'Reddy', 27, 'Hyderabad', 48000, 'IT', '2020-08-12'),
(6, 'Neha', 'Gupta', 35, 'Delhi', 70000, 'Finance', '2017-02-28'),
(7, 'Vikram', 'Joshi', 29, 'Pune', 52000, 'HR', '2019-09-15'),
(8, 'Anita', 'Desai', 26, 'Mumbai', 46000, 'IT', '2021-01-20'),
(9, 'Karan', 'Mehta', 33, 'Bangalore', 65000, 'Finance', '2018-07-08'),
(10, 'Deepa', 'Iyer', 31, 'Chennai', 58000, 'HR', '2019-05-17');


-- =============================================================================
-- SELECT ALL COLUMNS
-- =============================================================================
/*
SELECT Statement: Retrieve data from database
- Most commonly used SQL statement
- * (asterisk) means all columns
- FROM specifies which table to query
*/

-- Basic syntax
-- SELECT * FROM table_name;

-- Example: Get all data from employees table
SELECT * FROM employees;

/*
Result: Returns all 10 rows with all 8 columns
+-------------+------------+-----------+-----+-----------+--------+------------+------------+
| employee_id | first_name | last_name | age | city      | salary | department | hire_date  |
+-------------+------------+-----------+-----+-----------+--------+------------+------------+
| 1           | Amit       | Sharma    | 28  | Mumbai    | 45000  | IT         | 2020-01-15 |
| 2           | Priya      | Patel     | 32  | Delhi     | 55000  | HR         | 2019-03-20 |
| ...         | ...        | ...       | ... | ...       | ...    | ...        | ...        |
+-------------+------------+-----------+-----+-----------+--------+------------+------------+
*/

-- Another example with different table
-- Assuming we have a products table
/*
SELECT * FROM products;
SELECT * FROM customers;
SELECT * FROM orders;
*/

-- Good Practice Note:
-- Use SELECT * carefully in production - it retrieves all columns
-- which can be slow for large tables. Better to specify needed columns.


-- =============================================================================
-- SELECT SPECIFIC COLUMNS
-- =============================================================================
/*
Selecting Specific Columns: Better performance and readability
- List column names separated by commas
- Only retrieves the columns you need
- Reduces data transfer and improves speed
*/

-- Basic syntax
-- SELECT column1, column2, column3 FROM table_name;

-- Example: Get only name and age
SELECT first_name, last_name, age 
FROM employees;

/*
Result:
+------------+-----------+-----+
| first_name | last_name | age |
+------------+-----------+-----+
| Amit       | Sharma    | 28  |
| Priya      | Patel     | 32  |
| Rajesh     | Kumar     | 25  |
| ...        | ...       | ... |
+------------+-----------+-----+
*/

-- Example: Get name and salary
SELECT first_name, last_name, salary 
FROM employees;

-- Example: Multiple columns in different order
SELECT city, first_name, age, salary 
FROM employees;

-- Example: Single column
SELECT first_name 
FROM employees;

-- Example: Column aliases (rename columns in output)
SELECT 
    first_name AS 'First Name',
    last_name AS 'Last Name',
    salary AS 'Annual Salary'
FROM employees;

/*
Result:
+------------+-----------+---------------+
| First Name | Last Name | Annual Salary |
+------------+-----------+---------------+
| Amit       | Sharma    | 45000         |
| Priya      | Patel     | 55000         |
| ...        | ...       | ...           |
+------------+-----------+---------------+
*/

-- Calculate values in SELECT
SELECT 
    first_name,
    salary,
    salary * 12 AS annual_salary
FROM employees;


-- =============================================================================
-- WHERE CLAUSE - FILTERING ROWS
-- =============================================================================
/*
WHERE Clause: Filter rows based on conditions
- Used with comparison operators: =, !=, <, >, <=, >=
- Placed after FROM clause
- Only returns rows that match the condition
*/

-- Basic syntax
-- SELECT columns FROM table_name WHERE condition;

-- Example: Filter where age is greater than 25
SELECT * 
FROM employees 
WHERE age > 25;

/*
Result: Returns only employees with age > 25
+-------------+------------+-----------+-----+-----------+--------+------------+------------+
| employee_id | first_name | last_name | age | city      | salary | department | hire_date  |
+-------------+------------+-----------+-----+-----------+--------+------------+------------+
| 1           | Amit       | Sharma    | 28  | Mumbai    | 45000  | IT         | 2020-01-15 |
| 2           | Priya      | Patel     | 32  | Delhi     | 55000  | HR         | 2019-03-20 |
| 8           | Anita      | Desai     | 26  | Mumbai    | 46000  | IT         | 2021-01-20 |
| ...         | ...        | ...       | ... | ...       | ...    | ...        | ...        |
+-------------+------------+-----------+-----+-----------+--------+------------+------------+
*/

-- More examples with different operators

-- Equal to
SELECT first_name, age 
FROM employees 
WHERE age = 30;

-- Not equal to
SELECT first_name, department 
FROM employees 
WHERE department != 'IT';

-- Less than
SELECT first_name, salary 
FROM employees 
WHERE salary < 50000;

-- Greater than or equal to
SELECT first_name, age 
FROM employees 
WHERE age >= 30;

-- Less than or equal to
SELECT first_name, salary 
FROM employees 
WHERE salary <= 55000;

-- String comparison (exact match)
SELECT * 
FROM employees 
WHERE department = 'IT';

-- Numeric comparison
SELECT first_name, last_name, salary 
FROM employees 
WHERE salary > 60000;


-- =============================================================================
-- OR CONDITION
-- =============================================================================
/*
OR Operator: Match rows that satisfy at least ONE condition
- Returns true if ANY condition is true
- Used to provide multiple options
- Can chain multiple OR conditions
*/

-- Basic syntax
-- SELECT columns FROM table WHERE condition1 OR condition2;

-- Example: Get employees from Mumbai OR Delhi
SELECT first_name, last_name, city 
FROM employees 
WHERE city = 'Mumbai' OR city = 'Delhi';

/*
Result:
+------------+-----------+--------+
| first_name | last_name | city   |
+------------+-----------+--------+
| Amit       | Sharma    | Mumbai |
| Priya      | Patel     | Delhi  |
| Anjali     | Singh     | Mumbai |
| Neha       | Gupta     | Delhi  |
| Anita      | Desai     | Mumbai |
+------------+-----------+--------+
*/

-- More OR examples

-- Multiple values for same column
SELECT first_name, department 
FROM employees 
WHERE department = 'IT' OR department = 'HR';

-- Different columns
SELECT first_name, age, salary 
FROM employees 
WHERE age < 28 OR salary > 60000;

-- Three OR conditions
SELECT first_name, city 
FROM employees 
WHERE city = 'Mumbai' OR city = 'Delhi' OR city = 'Bangalore';

-- Combining with specific columns
SELECT first_name, last_name, city, department 
FROM employees 
WHERE city = 'Mumbai' OR department = 'Finance';

-- Alternative: IN operator (cleaner for multiple values)
SELECT first_name, city 
FROM employees 
WHERE city IN ('Mumbai', 'Delhi');

-- NOT IN operator
SELECT first_name, city 
FROM employees 
WHERE city NOT IN ('Mumbai', 'Delhi');


-- =============================================================================
-- ORDER BY - SORTING RESULTS
-- =============================================================================
/*
ORDER BY Clause: Sort query results
- ASC: Ascending order (default, smallest to largest)
- DESC: Descending order (largest to smallest)
- Can sort by multiple columns
- Placed at the end of query
*/

-- Basic syntax
-- SELECT columns FROM table ORDER BY column [ASC|DESC];

-- Example: Sort by salary in descending order
SELECT first_name, last_name, salary 
FROM employees 
ORDER BY salary DESC;

/*
Result: Highest salary first
+------------+-----------+--------+
| first_name | last_name | salary |
+------------+-----------+--------+
| Neha       | Gupta     | 70000  |
| Karan      | Mehta     | 65000  |
| Anjali     | Singh     | 60000  |
| Deepa      | Iyer      | 58000  |
| ...        | ...       | ...    |
+------------+-----------+--------+
*/

-- More ORDER BY examples

-- Ascending order (default)
SELECT first_name, age 
FROM employees 
ORDER BY age ASC;

-- Or simply
SELECT first_name, age 
FROM employees 
ORDER BY age;

-- Sort by text column
SELECT first_name, last_name 
FROM employees 
ORDER BY last_name ASC;

-- Sort by multiple columns
SELECT first_name, department, salary 
FROM employees 
ORDER BY department ASC, salary DESC;
-- First sorts by department (A-Z), then by salary (high to low) within each department

-- Sort by column position (not recommended, use column names instead)
SELECT first_name, salary 
FROM employees 
ORDER BY 2 DESC;  -- Sorts by 2nd column (salary)

-- Combine with WHERE
SELECT first_name, city, salary 
FROM employees 
WHERE city = 'Mumbai'
ORDER BY salary DESC;

-- Sort dates
SELECT first_name, hire_date 
FROM employees 
ORDER BY hire_date DESC;  -- Most recent first


-- =============================================================================
-- LIMIT - RESTRICTING NUMBER OF ROWS
-- =============================================================================
/*
LIMIT Clause: Restrict number of rows returned
- Useful for large datasets
- Often used with ORDER BY to get "top N" results
- MySQL/PostgreSQL: LIMIT n
- SQL Server: TOP n
- Oracle: ROWNUM or FETCH FIRST
*/

-- Basic syntax (MySQL/PostgreSQL)
-- SELECT columns FROM table LIMIT n;

-- Example: Get top 10 records
SELECT * 
FROM employees 
LIMIT 10;

-- Example: Get top 5 highest paid employees
SELECT first_name, last_name, salary 
FROM employees 
ORDER BY salary DESC 
LIMIT 5;

/*
Result: Top 5 salaries
+------------+-----------+--------+
| first_name | last_name | salary |
+------------+-----------+--------+
| Neha       | Gupta     | 70000  |
| Karan      | Mehta     | 65000  |
| Anjali     | Singh     | 60000  |
| Deepa      | Iyer      | 58000  |
| Priya      | Patel     | 55000  |
+------------+-----------+--------+
*/

-- More LIMIT examples

-- Get first 3 employees
SELECT first_name, last_name 
FROM employees 
LIMIT 3;

-- Get top 3 youngest employees
SELECT first_name, age 
FROM employees 
ORDER BY age ASC 
LIMIT 3;

-- LIMIT with OFFSET (skip first n rows)
SELECT first_name, salary 
FROM employees 
ORDER BY salary DESC 
LIMIT 5 OFFSET 3;  -- Skip first 3, get next 5

-- Alternative syntax for OFFSET
SELECT first_name, salary 
FROM employees 
ORDER BY salary DESC 
LIMIT 3, 5;  -- Skip 3, get 5 (MySQL syntax)

-- Get top 10 employees from specific city
SELECT first_name, city, salary 
FROM employees 
WHERE city = 'Mumbai'
ORDER BY salary DESC 
LIMIT 10;

-- Pagination example (page 2, 5 records per page)
SELECT first_name, salary 
FROM employees 
ORDER BY employee_id 
LIMIT 5 OFFSET 5;


-- =============================================================================
-- AND CONDITION
-- =============================================================================
/*
AND Operator: Match rows that satisfy ALL conditions
- Returns true only if BOTH/ALL conditions are true
- More restrictive than OR
- Can chain multiple AND conditions
*/

-- Basic syntax
-- SELECT columns FROM table WHERE condition1 AND condition2;

-- Example: Get employees where age > 20 AND salary < 50000
SELECT first_name, age, salary 
FROM employees 
WHERE age > 20 AND salary < 50000;

/*
Result: Only rows matching BOTH conditions
+------------+-----+--------+
| first_name | age | salary |
+------------+-----+--------+
| Amit       | 28  | 45000  |
| Rajesh     | 25  | 42000  |
| Arjun      | 27  | 48000  |
| Anita      | 26  | 46000  |
+------------+-----+--------+
*/

-- More AND examples

-- Two conditions on different columns
SELECT first_name, city, department 
FROM employees 
WHERE city = 'Mumbai' AND department = 'IT';

-- Three AND conditions
SELECT first_name, age, salary, department 
FROM employees 
WHERE age > 25 AND salary > 45000 AND department = 'IT';

-- Combining numeric comparisons
SELECT first_name, age, salary 
FROM employees 
WHERE age >= 25 AND age <= 30 AND salary > 45000;

-- String and numeric conditions
SELECT first_name, city, salary 
FROM employees 
WHERE city = 'Delhi' AND salary > 50000;

-- Alternative to AND for range: BETWEEN
SELECT first_name, age 
FROM employees 
WHERE age BETWEEN 25 AND 30;
-- Equivalent to: WHERE age >= 25 AND age <= 30


-- =============================================================================
-- LIKE - PATTERN MATCHING
-- =============================================================================
/*
LIKE Operator: Pattern matching in strings
- % (percent): Matches any sequence of characters (0 or more)
- _ (underscore): Matches exactly one character
- Case sensitivity depends on database configuration
*/

-- Basic syntax
-- SELECT columns FROM table WHERE column LIKE 'pattern';

-- Example: Get records where name starts with 'A'
SELECT first_name, last_name 
FROM employees 
WHERE first_name LIKE 'A%';

/*
Result: All names starting with 'A'
+------------+-----------+
| first_name | last_name |
+------------+-----------+
| Amit       | Sharma    |
| Anjali     | Singh     |
| Arjun      | Reddy     |
| Anita      | Desai     |
+------------+-----------+
*/

-- More LIKE examples

-- Names ending with 'a'
SELECT first_name 
FROM employees 
WHERE first_name LIKE '%a';

-- Names containing 'ar' anywhere
SELECT first_name 
FROM employees 
WHERE first_name LIKE '%ar%';

-- Names with exactly 5 characters
SELECT first_name 
FROM employees 
WHERE first_name LIKE '_____';  -- 5 underscores

-- Names starting with 'A' and ending with 'i'
SELECT first_name 
FROM employees 
WHERE first_name LIKE 'A%i';

-- Second character is 'r'
SELECT first_name 
FROM employees 
WHERE first_name LIKE '_r%';

-- NOT LIKE (negation)
SELECT first_name 
FROM employees 
WHERE first_name NOT LIKE 'A%';

-- Case-insensitive search (if needed)
SELECT first_name 
FROM employees 
WHERE LOWER(first_name) LIKE 'a%';

-- Multiple LIKE conditions
SELECT first_name 
FROM employees 
WHERE first_name LIKE 'A%' OR first_name LIKE 'P%';

-- Combine LIKE with other conditions
SELECT first_name, city, salary 
FROM employees 
WHERE first_name LIKE 'A%' AND salary > 45000;


-- =============================================================================
-- COUNT - COUNTING ROWS
-- =============================================================================
/*
COUNT(): Aggregate function to count rows
- COUNT(*): Counts all rows
- COUNT(column): Counts non-NULL values in column
- COUNT(DISTINCT column): Counts unique values
- Returns a single number
*/

-- Basic syntax
-- SELECT COUNT(*) FROM table_name;

-- Example: Count total number of rows
SELECT COUNT(*) AS total_employees 
FROM employees;

/*
Result:
+------------------+
| total_employees  |
+------------------+
| 10               |
+------------------+
*/

-- More COUNT examples

-- Count without alias
SELECT COUNT(*) 
FROM employees;

-- Count with WHERE condition
SELECT COUNT(*) AS mumbai_employees 
FROM employees 
WHERE city = 'Mumbai';

-- Count specific column
SELECT COUNT(first_name) 
FROM employees;

-- Count rows matching condition
SELECT COUNT(*) AS high_earners 
FROM employees 
WHERE salary > 55000;

-- Count by department
SELECT department, COUNT(*) AS employee_count 
FROM employees 
GROUP BY department;

/*
Result:
+------------+----------------+
| department | employee_count |
+------------+----------------+
| IT         | 4              |
| HR         | 3              |
| Finance    | 3              |
+------------+----------------+
*/

-- Count with multiple conditions
SELECT COUNT(*) AS result 
FROM employees 
WHERE city = 'Mumbai' AND department = 'IT';

-- Count distinct values
SELECT COUNT(DISTINCT city) AS unique_cities 
FROM employees;

-- Count distinct departments
SELECT COUNT(DISTINCT department) AS unique_departments 
FROM employees;


-- =============================================================================
-- DISTINCT - UNIQUE VALUES
-- =============================================================================
/*
DISTINCT Keyword: Get unique values only
- Removes duplicate rows from result
- Can be used with single or multiple columns
- Useful for finding all unique values
*/

-- Basic syntax
-- SELECT DISTINCT column FROM table_name;

-- Example: Get distinct values from city column
SELECT DISTINCT city 
FROM employees;

/*
Result: Unique cities only
+-----------+
| city      |
+-----------+
| Mumbai    |
| Delhi     |
| Bangalore |
| Hyderabad |
| Pune      |
| Chennai   |
+-----------+
*/

-- More DISTINCT examples

-- Unique departments
SELECT DISTINCT department 
FROM employees;

/*
Result:
+------------+
| department |
+------------+
| IT         |
| HR         |
| Finance    |
+------------+
*/

-- Unique ages
SELECT DISTINCT age 
FROM employees 
ORDER BY age;

-- DISTINCT with multiple columns
SELECT DISTINCT city, department 
FROM employees 
ORDER BY city, department;

-- DISTINCT with COUNT
SELECT COUNT(DISTINCT city) AS unique_cities 
FROM employees;

-- DISTINCT with WHERE
SELECT DISTINCT department 
FROM employees 
WHERE salary > 50000;

-- Get all unique salary values
SELECT DISTINCT salary 
FROM employees 
ORDER BY salary DESC;

-- Combine DISTINCT with calculations
SELECT DISTINCT YEAR(hire_date) AS hire_year 
FROM employees 
ORDER BY hire_year;


-- =============================================================================
-- COMBINING MULTIPLE CLAUSES
-- =============================================================================
/*
SQL Query Execution Order:
1. FROM - Choose table
2. WHERE - Filter rows
3. GROUP BY - Group rows
4. HAVING - Filter groups
5. SELECT - Choose columns
6. DISTINCT - Remove duplicates
7. ORDER BY - Sort results
8. LIMIT - Restrict rows returned

Note: Write queries in this order:
SELECT → FROM → WHERE → GROUP BY → HAVING → ORDER BY → LIMIT
*/

-- Example: Complex query with multiple clauses
SELECT first_name, last_name, city, salary 
FROM employees 
WHERE salary > 45000 AND city IN ('Mumbai', 'Delhi')
ORDER BY salary DESC 
LIMIT 5;

-- Another example
SELECT DISTINCT department, city 
FROM employees 
WHERE age > 27
ORDER BY department, city;

-- Example with COUNT and WHERE
SELECT COUNT(*) AS high_earners 
FROM employees 
WHERE salary > 50000 AND department = 'Finance';

-- Example with all major clauses
SELECT department, city, COUNT(*) AS emp_count 
FROM employees 
WHERE age > 25
GROUP BY department, city 
HAVING COUNT(*) > 0
ORDER BY emp_count DESC 
LIMIT 10;


-- =============================================================================
-- KEY TAKEAWAYS - SQL BASICS
-- =============================================================================
/*
📌 SELECT STATEMENT:
- SELECT * for all columns
- SELECT column1, column2 for specific columns
- Use column aliases: SELECT name AS 'Full Name'
- Always specify needed columns for better performance

📌 WHERE CLAUSE:
- Filters rows based on conditions
- Comparison operators: =, !=, <, >, <=, >=
- Placed after FROM, before ORDER BY
- Case-sensitive for strings (depends on database)

📌 OR vs AND:
- OR: Returns rows matching ANY condition
- AND: Returns rows matching ALL conditions
- Can combine: WHERE (A OR B) AND C
- Use parentheses for complex conditions

📌 ORDER BY:
- ASC: Ascending (smallest to largest) - default
- DESC: Descending (largest to smallest)
- Can sort by multiple columns
- Always placed near end of query

📌 LIMIT:
- Restricts number of rows returned
- Useful with ORDER BY for "top N" queries
- OFFSET skips first n rows
- Syntax varies: LIMIT (MySQL), TOP (SQL Server)

📌 LIKE OPERATOR:
- % matches any characters (0 or more)
- _ matches exactly one character
- Use for pattern matching in strings
- NOT LIKE for negation

📌 COUNT FUNCTION:
- COUNT(*) counts all rows
- COUNT(column) counts non-NULL values
- COUNT(DISTINCT column) counts unique values
- Returns single number

📌 DISTINCT:
- Removes duplicate values
- Use for finding unique values
- Can apply to single or multiple columns
- Combine with COUNT for unique count

📌 BEST PRACTICES:
- Use specific column names instead of SELECT *
- Add WHERE clauses to filter unnecessary data
- Use LIMIT for testing queries on large tables
- Write SQL keywords in UPPERCASE
- Indent and format queries for readability
- Always end statements with semicolon
- Test queries on small datasets first

📌 QUERY ORDER:
- Write: SELECT → FROM → WHERE → ORDER BY → LIMIT
- Execution: FROM → WHERE → SELECT → ORDER BY → LIMIT
- Remember this sequence for complex queries

💡 COMMON PATTERNS:
- Top N: SELECT * FROM table ORDER BY column DESC LIMIT N
- Count rows: SELECT COUNT(*) FROM table WHERE condition
- Unique values: SELECT DISTINCT column FROM table
- Pattern match: SELECT * FROM table WHERE column LIKE 'A%'
- Range: SELECT * FROM table WHERE column BETWEEN x AND y
- Multiple values: SELECT * FROM table WHERE column IN (val1, val2)
*/