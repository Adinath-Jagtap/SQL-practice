-- ============================================================================
-- SQL JOINS & AGGREGATES - BEGINNER'S GUIDE
-- ============================================================================

-- ============================================================================
-- SECTION 1: UNDERSTANDING JOINS
-- ============================================================================

/*
WHAT ARE JOINS?
- Joins combine rows from two or more tables based on a related column
- Think of it like matching puzzle pieces - we connect tables where values match
- The "related column" is usually a Foreign Key in one table that references 
  a Primary Key in another table
*/

-- ----------------------------------------------------------------------------
-- 1.1 INNER JOIN
-- ----------------------------------------------------------------------------

/*
INNER JOIN - Returns only matching records from both tables

SYNTAX:
    SELECT columns
    FROM table1
    INNER JOIN table2
    ON table1.column = table2.column;

EXAMPLE SCENARIO:
    Table: employees               Table: departments
    emp_id | name     | dept_id    dept_id | dept_name
    1      | Alice    | 10         10      | Sales
    2      | Bob      | 20         20      | Marketing
    3      | Charlie  | 10         30      | HR
    4      | David    | 99         

    INNER JOIN will return:
    Alice - Sales
    Bob - Marketing
    Charlie - Sales
    (David is excluded because dept_id 99 doesn't exist in departments table)

KEY POINTS:
- Only shows records where there's a match in BOTH tables
- If no match exists, that row is excluded
- Most commonly used type of join
*/

-- Basic INNER JOIN example:
SELECT employees.name, departments.dept_name
FROM employees
INNER JOIN departments
ON employees.dept_id = departments.dept_id;

-- You can use table aliases to make queries shorter:
SELECT e.name, d.dept_name
FROM employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id;


-- ----------------------------------------------------------------------------
-- 1.2 LEFT JOIN (also called LEFT OUTER JOIN)
-- ----------------------------------------------------------------------------

/*
LEFT JOIN - Returns ALL records from the left table, and matching records from right

SYNTAX:
    SELECT columns
    FROM table1
    LEFT JOIN table2
    ON table1.column = table2.column;

Using same tables as above:
    LEFT JOIN will return:
    Alice - Sales
    Bob - Marketing
    Charlie - Sales
    David - NULL
    (David appears because we keep ALL from left table, even without a match)

KEY POINTS:
- ALL rows from the LEFT table (table1) are included
- Matching rows from the RIGHT table (table2) are added where they exist
- If no match exists, NULL values appear for the right table's columns
- Useful when you want to see "everything from table A, plus related info from table B"
*/

-- Basic LEFT JOIN example:
SELECT e.name, d.dept_name
FROM employees e
LEFT JOIN departments d
ON e.dept_id = d.dept_id;

-- This would show all employees, even those without a valid department


-- ----------------------------------------------------------------------------
-- 1.3 RIGHT JOIN & FULL JOIN (for reference)
-- ----------------------------------------------------------------------------

/*
RIGHT JOIN - Opposite of LEFT JOIN (all from right table, matching from left)
FULL JOIN - Returns all records when there's a match in either table

NOTE: RIGHT JOIN is rarely used (you can just swap tables and use LEFT JOIN)
      FULL JOIN is not supported in all databases (like MySQL)
      For beginners, focus on INNER JOIN and LEFT JOIN first!
*/


-- ----------------------------------------------------------------------------
-- 1.4 JOINING THREE TABLES
-- ----------------------------------------------------------------------------

/*
You can join multiple tables by chaining JOIN statements

EXAMPLE SCENARIO:
    employees -> departments -> locations
    
    An employee belongs to a department
    A department is in a location
*/

SELECT e.name, d.dept_name, l.city
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id
INNER JOIN locations l ON d.location_id = l.location_id;

/*
KEY POINTS:
- Each JOIN connects two tables
- Order matters: start with your main table, then add related tables
- Make sure each ON condition connects the right columns
*/


-- ============================================================================
-- SECTION 2: AGGREGATE FUNCTIONS
-- ============================================================================

/*
WHAT ARE AGGREGATE FUNCTIONS?
- Functions that perform calculations on multiple rows and return a single value
- Common ones: COUNT(), SUM(), AVG(), MAX(), MIN()
- They "aggregate" or combine data
*/

-- ----------------------------------------------------------------------------
-- 2.1 COUNT() - Counting rows
-- ----------------------------------------------------------------------------

/*
COUNT() - Returns the number of rows

SYNTAX:
    COUNT(*)              - Counts all rows (including NULLs)
    COUNT(column_name)    - Counts non-NULL values in that column
    COUNT(DISTINCT column) - Counts unique non-NULL values
*/

-- Count all employees:
SELECT COUNT(*) AS total_employees
FROM employees;

-- Count employees who have a department assigned:
SELECT COUNT(dept_id) AS employees_with_dept
FROM employees;

-- Count how many different departments exist:
SELECT COUNT(DISTINCT dept_id) AS unique_departments
FROM employees;


-- ----------------------------------------------------------------------------
-- 2.2 SUM() - Adding up values
-- ----------------------------------------------------------------------------

/*
SUM() - Adds up all values in a numeric column

EXAMPLE:
    If you have a sales table with amounts: 100, 200, 150
    SUM(amount) would return 450
*/

-- Calculate total sales:
SELECT SUM(amount) AS total_sales
FROM sales;


-- ----------------------------------------------------------------------------
-- 2.3 AVG() - Calculating average
-- ----------------------------------------------------------------------------

/*
AVG() - Calculates the average (mean) of numeric values
- Formula: SUM of all values / COUNT of values
- Ignores NULL values
*/

-- Calculate average salary:
SELECT AVG(salary) AS average_salary
FROM employees;


-- ----------------------------------------------------------------------------
-- 2.4 MAX() and MIN() - Finding extremes
-- ----------------------------------------------------------------------------

/*
MAX() - Returns the highest value
MIN() - Returns the lowest value

Works with:
- Numbers (highest/lowest number)
- Dates (latest/earliest date)
- Text (alphabetically last/first)
*/

-- Find highest and lowest salary:
SELECT MAX(salary) AS highest_salary,
       MIN(salary) AS lowest_salary
FROM employees;


-- ============================================================================
-- SECTION 3: GROUP BY - Grouping Data
-- ============================================================================

/*
GROUP BY - Groups rows with the same values into summary rows

WHEN TO USE:
- When you want calculations "per category"
- Examples: "per department", "per region", "per month"

IMPORTANT RULE:
- If you use GROUP BY, every column in SELECT must either be:
  1. In the GROUP BY clause, OR
  2. Inside an aggregate function (COUNT, SUM, AVG, etc.)
*/

-- ----------------------------------------------------------------------------
-- 3.1 Basic GROUP BY with COUNT
-- ----------------------------------------------------------------------------

/*
Count how many employees in each department
*/

SELECT dept_id, COUNT(*) AS employee_count
FROM employees
GROUP BY dept_id;

/*
RESULT EXAMPLE:
dept_id | employee_count
10      | 5
20      | 3
30      | 7

This groups all employees by their dept_id and counts each group
*/


-- ----------------------------------------------------------------------------
-- 3.2 GROUP BY with SUM
-- ----------------------------------------------------------------------------

/*
Calculate total sales per region
*/

SELECT region, SUM(sales_amount) AS total_sales
FROM sales
GROUP BY region;


-- ----------------------------------------------------------------------------
-- 3.3 GROUP BY with AVG
-- ----------------------------------------------------------------------------

/*
Calculate average salary per department
*/

SELECT dept_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY dept_id;


-- ----------------------------------------------------------------------------
-- 3.4 GROUP BY with MAX and MIN
-- ----------------------------------------------------------------------------

/*
Find highest and lowest price per category
*/

SELECT category, 
       MAX(price) AS max_price,
       MIN(price) AS min_price
FROM products
GROUP BY category;


-- ----------------------------------------------------------------------------
-- 3.5 GROUP BY with Multiple Columns
-- ----------------------------------------------------------------------------

/*
You can group by more than one column
This creates subgroups
*/

-- Sales per region AND per year:
SELECT region, year, SUM(sales_amount) AS total_sales
FROM sales
GROUP BY region, year;

/*
RESULT EXAMPLE:
region | year | total_sales
North  | 2023 | 50000
North  | 2024 | 60000
South  | 2023 | 45000
South  | 2024 | 55000

Each unique combination of region + year gets its own row
*/


-- ----------------------------------------------------------------------------
-- 3.6 COUNT(DISTINCT) with GROUP BY
-- ----------------------------------------------------------------------------

/*
Count unique values per group
*/

-- How many different products were sold in each region?
SELECT region, COUNT(DISTINCT product_id) AS unique_products
FROM sales
GROUP BY region;


-- ============================================================================
-- SECTION 4: HAVING - Filtering Grouped Results
-- ============================================================================

/*
HAVING - Filters results AFTER grouping (like WHERE, but for groups)

WHERE vs HAVING:
- WHERE filters individual rows BEFORE grouping
- HAVING filters groups AFTER aggregation

SYNTAX:
    SELECT column, AGGREGATE(column)
    FROM table
    WHERE condition          -- filters rows first
    GROUP BY column
    HAVING condition;        -- filters groups after
*/

-- ----------------------------------------------------------------------------
-- 4.1 Basic HAVING Example
-- ----------------------------------------------------------------------------

/*
Find departments with more than 5 employees
*/

SELECT dept_id, COUNT(*) AS employee_count
FROM employees
GROUP BY dept_id
HAVING COUNT(*) > 5;

/*
This will only show departments where the count is greater than 5
*/


-- ----------------------------------------------------------------------------
-- 4.2 HAVING with SUM
-- ----------------------------------------------------------------------------

/*
Find regions where total sales exceed 10000
*/

SELECT region, SUM(sales_amount) AS total_sales
FROM sales
GROUP BY region
HAVING SUM(sales_amount) > 10000;


-- ----------------------------------------------------------------------------
-- 4.3 HAVING with AVG
-- ----------------------------------------------------------------------------

/*
Find departments with average salary above 50000
*/

SELECT dept_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY dept_id
HAVING AVG(salary) > 50000;


-- ----------------------------------------------------------------------------
-- 4.4 Combining WHERE and HAVING
-- ----------------------------------------------------------------------------

/*
WHERE filters before grouping
HAVING filters after grouping
*/

-- Find departments (except dept 99) with more than 3 employees:
SELECT dept_id, COUNT(*) AS employee_count
FROM employees
WHERE dept_id != 99           -- Filter individual rows first
GROUP BY dept_id
HAVING COUNT(*) > 3;          -- Then filter the grouped results


-- ============================================================================
-- SECTION 5: COMBINING JOINS WITH AGGREGATES
-- ============================================================================

/*
You can combine everything you've learned!
Join tables, then group and aggregate the results
*/

-- ----------------------------------------------------------------------------
-- 5.1 JOIN + GROUP BY
-- ----------------------------------------------------------------------------

/*
Count employees per department name (not just ID)
*/

SELECT d.dept_name, COUNT(e.emp_id) AS employee_count
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name;


-- ----------------------------------------------------------------------------
-- 5.2 JOIN + WHERE + GROUP BY
-- ----------------------------------------------------------------------------

/*
Total sales per region for the year 2024
*/

SELECT r.region_name, SUM(s.amount) AS total_sales
FROM sales s
INNER JOIN regions r ON s.region_id = r.region_id
WHERE s.sale_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY r.region_name;


-- ----------------------------------------------------------------------------
-- 5.3 Multiple JOINS + GROUP BY + HAVING
-- ----------------------------------------------------------------------------

/*
Find product categories with average price > 100 in specific stores
*/

SELECT c.category_name, 
       s.store_name,
       AVG(p.price) AS avg_price
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
INNER JOIN stores s ON p.store_id = s.store_id
WHERE s.store_name IN ('Store A', 'Store B')
GROUP BY c.category_name, s.store_name
HAVING AVG(p.price) > 100;


-- ============================================================================
-- SECTION 6: QUERY EXECUTION ORDER (Important to understand!)
-- ============================================================================

/*
SQL executes clauses in this order (not the order you write them!):

1. FROM       - Get the tables
2. JOIN       - Combine tables
3. WHERE      - Filter individual rows
4. GROUP BY   - Group the filtered rows
5. HAVING     - Filter the groups
6. SELECT     - Choose columns to display
7. ORDER BY   - Sort the results (not covered here, but comes last)

This is why:
- WHERE comes before GROUP BY (filters rows first)
- HAVING comes after GROUP BY (filters groups)
- You can't use column aliases from SELECT in WHERE (SELECT happens later!)
*/


-- ============================================================================
-- QUICK REFERENCE CHEAT SHEET
-- ============================================================================

/*
JOINS:
- INNER JOIN: Only matching records from both tables
- LEFT JOIN:  All from left table + matching from right (NULL if no match)

AGGREGATE FUNCTIONS:
- COUNT(*)         - Count all rows
- COUNT(column)    - Count non-NULL values
- COUNT(DISTINCT)  - Count unique values
- SUM(column)      - Add up values
- AVG(column)      - Calculate average
- MAX(column)      - Find highest value
- MIN(column)      - Find lowest value

GROUPING:
- GROUP BY: Creates groups for aggregation
- HAVING:   Filters groups (use after GROUP BY)
- WHERE:    Filters rows (use before GROUP BY)

TYPICAL PATTERN:
SELECT column, AGGREGATE(column)
FROM table1
JOIN table2 ON condition
WHERE row_filter
GROUP BY column
HAVING group_filter;
*/


-- ============================================================================
-- COMMON BEGINNER MISTAKES TO AVOID
-- ============================================================================

/*
1. MISTAKE: Forgetting GROUP BY when using aggregates
   WRONG:   SELECT dept_id, COUNT(*) FROM employees;
   RIGHT:   SELECT dept_id, COUNT(*) FROM employees GROUP BY dept_id;

2. MISTAKE: Using WHERE instead of HAVING for aggregates
   WRONG:   SELECT dept_id, COUNT(*) FROM employees 
            WHERE COUNT(*) > 5 GROUP BY dept_id;
   RIGHT:   SELECT dept_id, COUNT(*) FROM employees 
            GROUP BY dept_id HAVING COUNT(*) > 5;

3. MISTAKE: Selecting columns not in GROUP BY or aggregate
   WRONG:   SELECT dept_id, name, COUNT(*) FROM employees GROUP BY dept_id;
   RIGHT:   SELECT dept_id, COUNT(*) FROM employees GROUP BY dept_id;

4. MISTAKE: Forgetting the ON condition in JOIN
   WRONG:   SELECT * FROM employees INNER JOIN departments;
   RIGHT:   SELECT * FROM employees INNER JOIN departments 
            ON employees.dept_id = departments.dept_id;

5. MISTAKE: Using COUNT(*) when you mean COUNT(DISTINCT column)
   Be clear: Do you want all rows or unique values?
*/

-- ============================================================================
-- PRACTICE TIPS
-- ============================================================================

/*
1. Start simple: Master INNER JOIN before LEFT JOIN
2. Practice one concept at a time before combining
3. Always check your ON conditions in JOINs
4. Use meaningful aliases (e for employees, d for departments)
5. Test queries on small datasets first
6. Read the query execution order again - it really helps!
7. Draw out the tables on paper to visualize joins
8. Remember: GROUP BY groups data, HAVING filters groups, WHERE filters rows
*/

-- ============================================================================
-- SQL PRACTICE QUESTIONS - JOINS & AGGREGATES (Day 2)
-- ============================================================================
/*
1. Perform an INNER JOIN between two tables
2. Use LEFT JOIN to return all records from the left table and matching rows from the right table
3. Count total records per group using GROUP BY and COUNT()
4. Calculate average salary per department using GROUP BY and AVG()
5. Find maximum and minimum values per category using MAX() and MIN()
6. Compute the sum of sales per region using GROUP BY and SUM()
7. Filter grouped results with HAVING (e.g., HAVING SUM(sales) > 10000)
8. Join three tables together with appropriate ON conditions
9. Count distinct values per group using COUNT(DISTINCT column_name)
10. Combine JOINs with WHERE conditions (e.g., joins + WHERE date BETWEEN ... AND ...)
*/
