-- ============================================================================
-- SQL WINDOW FUNCTIONS - BEGINNER'S GUIDE
-- ============================================================================

-- ============================================================================
-- SECTION 1: WHAT ARE WINDOW FUNCTIONS?
-- ============================================================================

/*
WINDOW FUNCTIONS (also called ANALYTIC FUNCTIONS):
- Perform calculations across a set of rows related to the current row
- Unlike GROUP BY, they DON'T collapse rows into groups
- Each row retains its identity while getting additional calculated columns
- Think of them as "adding calculated columns without grouping"

KEY DIFFERENCE FROM GROUP BY:

GROUP BY (collapses rows):
    dept_id | avg_salary
    10      | 50000
    20      | 60000
    
WINDOW FUNCTION (keeps all rows):
    emp_id | name  | dept_id | salary | avg_salary
    1      | Alice | 10      | 55000  | 50000
    2      | Bob   | 10      | 45000  | 50000
    3      | Carol | 20      | 60000  | 60000

SEE THE DIFFERENCE?
- GROUP BY: 2 rows (one per department)
- WINDOW FUNCTION: 3 rows (all employees kept, avg added)

BASIC SYNTAX:
    function_name(column) OVER (
        PARTITION BY column    -- Optional: divide into groups
        ORDER BY column        -- Optional: define order
        ROWS/RANGE clause      -- Optional: define window frame
    )
*/


-- ============================================================================
-- SECTION 2: UNDERSTANDING THE OVER() CLAUSE
-- ============================================================================

/*
The OVER() clause defines the "window" of rows to operate on

COMPONENTS:

1. PARTITION BY - Divides rows into groups (like GROUP BY, but doesn't collapse)
2. ORDER BY - Defines the order of rows within each partition
3. FRAME - Specifies which rows within the partition to include (ROWS/RANGE)

EXAMPLES OF OVER() VARIATIONS:

OVER()                              -- All rows (entire table)
OVER(ORDER BY date)                 -- All rows up to current, ordered by date
OVER(PARTITION BY dept)             -- Each department separately
OVER(PARTITION BY dept ORDER BY salary) -- Each dept, ordered by salary
*/


-- ============================================================================
-- SECTION 3: RANKING FUNCTIONS
-- ============================================================================

/*
Ranking functions assign ranks to rows based on a specified order
Three main types: ROW_NUMBER(), RANK(), DENSE_RANK()
*/

-- ----------------------------------------------------------------------------
-- 3.1 ROW_NUMBER() - Sequential Numbers
-- ----------------------------------------------------------------------------

/*
ROW_NUMBER():
- Assigns unique sequential integers
- Even if values are tied, each row gets a different number
- No gaps in the sequence

SYNTAX:
    ROW_NUMBER() OVER (ORDER BY column)
*/

-- EXAMPLE: Assign row numbers to employees by salary (highest first)
SELECT emp_id,
       name,
       salary,
       ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num
FROM employees;

/*
SAMPLE DATA:
emp_id | name    | salary
1      | Alice   | 80000
2      | Bob     | 80000  -- Note: same salary as Alice
3      | Carol   | 75000
4      | David   | 70000

RESULT:
emp_id | name    | salary | row_num
1      | Alice   | 80000  | 1      ← First because of emp_id or arbitrary order
2      | Bob     | 80000  | 2      ← Gets 2 even though tied
3      | Carol   | 75000  | 3
4      | David   | 70000  | 4

KEY POINT: Alice and Bob have the same salary but different row numbers
*/


-- ----------------------------------------------------------------------------
-- 3.2 RANK() - Ranking with Gaps
-- ----------------------------------------------------------------------------

/*
RANK():
- Assigns ranks with gaps when there are ties
- Tied values get the same rank
- Next rank skips numbers (1, 2, 2, 4 - notice 3 is skipped)

SYNTAX:
    RANK() OVER (ORDER BY column)
*/

-- EXAMPLE: Rank employees by salary
SELECT emp_id,
       name,
       salary,
       RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;

/*
Using same data as before:

RESULT:
emp_id | name    | salary | salary_rank
1      | Alice   | 80000  | 1      ← Highest salary
2      | Bob     | 80000  | 1      ← Tied for first
3      | Carol   | 75000  | 3      ← Notice: skips 2!
4      | David   | 70000  | 4

KEY POINT: Alice and Bob both get rank 1, next rank is 3 (gap!)
*/


-- ----------------------------------------------------------------------------
-- 3.3 DENSE_RANK() - Ranking without Gaps
-- ----------------------------------------------------------------------------

/*
DENSE_RANK():
- Assigns ranks without gaps
- Tied values get the same rank
- Next rank is consecutive (1, 2, 2, 3 - no gap)

SYNTAX:
    DENSE_RANK() OVER (ORDER BY column)
*/

-- EXAMPLE: Dense rank employees by salary
SELECT emp_id,
       name,
       salary,
       DENSE_RANK() OVER (ORDER BY salary DESC) AS salary_dense_rank
FROM employees;

/*
Using same data:

RESULT:
emp_id | name    | salary | salary_dense_rank
1      | Alice   | 80000  | 1
2      | Bob     | 80000  | 1
3      | Carol   | 75000  | 2      ← Notice: no gap, goes to 2
4      | David   | 70000  | 3

KEY POINT: No gaps in ranking sequence
*/


-- ----------------------------------------------------------------------------
-- 3.4 Comparing All Three Ranking Functions
-- ----------------------------------------------------------------------------

/*
Let's see all three side by side to understand the differences
*/

SELECT emp_id,
       name,
       salary,
       ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num,
       RANK() OVER (ORDER BY salary DESC) AS rank_num,
       DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rank_num
FROM employees;

/*
RESULT COMPARISON:
name    | salary | row_num | rank_num | dense_rank_num
Alice   | 80000  | 1       | 1        | 1
Bob     | 80000  | 2       | 1        | 1      ← Same as Alice
Carol   | 75000  | 3       | 3        | 2      ← rank skips 2, dense doesn't
David   | 70000  | 4       | 4        | 3
Eve     | 70000  | 5       | 4        | 3      ← tied with David
Frank   | 65000  | 6       | 6        | 4      ← rank skips 5, dense doesn't

WHEN TO USE WHICH?
- ROW_NUMBER(): When you need unique numbers (pagination, unique IDs)
- RANK(): When you want standard ranking (Olympics style: 1st, 1st, 3rd)
- DENSE_RANK(): When gaps don't make sense (university grades: A, A, B not A, A, C)
*/


-- ============================================================================
-- SECTION 4: PARTITION BY - Grouping Within Windows
-- ============================================================================

/*
PARTITION BY divides the result set into groups
Window functions are applied separately to each partition
Think of it as "GROUP BY but keeping all rows"
*/

-- ----------------------------------------------------------------------------
-- 4.1 Ranking Within Departments
-- ----------------------------------------------------------------------------

/*
EXAMPLE: Rank employees by salary within each department
*/

SELECT emp_id,
       name,
       dept_id,
       salary,
       RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS dept_salary_rank
FROM employees;

/*
SAMPLE DATA:
emp_id | name    | dept_id | salary
1      | Alice   | 10      | 80000
2      | Bob     | 10      | 75000
3      | Carol   | 10      | 70000
4      | David   | 20      | 85000
5      | Eve     | 20      | 80000
6      | Frank   | 20      | 75000

RESULT:
emp_id | name    | dept_id | salary | dept_salary_rank
1      | Alice   | 10      | 80000  | 1      ← Rank 1 in dept 10
2      | Bob     | 10      | 75000  | 2      ← Rank 2 in dept 10
3      | Carol   | 10      | 70000  | 3      ← Rank 3 in dept 10
4      | David   | 20      | 85000  | 1      ← Rank 1 in dept 20 (new partition!)
5      | Eve     | 20      | 80000  | 2      ← Rank 2 in dept 20
6      | Frank   | 20      | 75000  | 3      ← Rank 3 in dept 20

KEY POINT: Ranking restarts at 1 for each department
*/


-- ----------------------------------------------------------------------------
-- 4.2 Finding Top N Per Group
-- ----------------------------------------------------------------------------

/*
COMMON USE CASE: Get top 3 highest-paid employees per department

APPROACH: Use window function in CTE, then filter
*/

WITH ranked_employees AS (
    SELECT emp_id,
           name,
           dept_id,
           salary,
           RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS salary_rank
    FROM employees
)
SELECT emp_id, name, dept_id, salary
FROM ranked_employees
WHERE salary_rank <= 3;

/*
WHY USE CTE?
- Can't use window function directly in WHERE clause
- Must first calculate ranks, then filter
- CTE makes this clean and readable

ALTERNATIVE: Use subquery
*/

SELECT emp_id, name, dept_id, salary
FROM (
    SELECT emp_id, name, dept_id, salary,
           RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS salary_rank
    FROM employees
) AS ranked
WHERE salary_rank <= 3;


-- ----------------------------------------------------------------------------
-- 4.3 Multiple PARTITION BY Columns
-- ----------------------------------------------------------------------------

/*
You can partition by multiple columns
*/

-- EXAMPLE: Rank employees by salary within department AND job title
SELECT emp_id,
       name,
       dept_id,
       job_title,
       salary,
       RANK() OVER (PARTITION BY dept_id, job_title 
                    ORDER BY salary DESC) AS rank_within_dept_title
FROM employees;

/*
This creates separate rankings for each unique combination of dept_id and job_title
Example partitions:
- Dept 10, Manager
- Dept 10, Developer
- Dept 20, Manager
- Dept 20, Developer
*/


-- ============================================================================
-- SECTION 5: AGGREGATE WINDOW FUNCTIONS
-- ============================================================================

/*
You can use aggregate functions (SUM, AVG, COUNT, MAX, MIN) as window functions
Unlike GROUP BY, rows are NOT collapsed
*/

-- ----------------------------------------------------------------------------
-- 5.1 Running Total (Cumulative Sum)
-- ----------------------------------------------------------------------------

/*
RUNNING TOTAL: Sum of all values up to and including current row

SYNTAX:
    SUM(column) OVER (ORDER BY column 
                      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
    
Simplified (same result):
    SUM(column) OVER (ORDER BY column)
*/

-- EXAMPLE: Calculate running total of daily sales
SELECT sale_date,
       daily_sales,
       SUM(daily_sales) OVER (ORDER BY sale_date) AS running_total
FROM daily_sales;

/*
SAMPLE DATA:
sale_date   | daily_sales
2024-01-01  | 100
2024-01-02  | 150
2024-01-03  | 200
2024-01-04  | 120

RESULT:
sale_date   | daily_sales | running_total
2024-01-01  | 100         | 100           ← 100
2024-01-02  | 150         | 250           ← 100 + 150
2024-01-03  | 200         | 450           ← 100 + 150 + 200
2024-01-04  | 120         | 570           ← 100 + 150 + 200 + 120

HOW IT WORKS:
Row 1: SUM of rows from start to row 1 = 100
Row 2: SUM of rows from start to row 2 = 100 + 150 = 250
Row 3: SUM of rows from start to row 3 = 250 + 200 = 450
Row 4: SUM of rows from start to row 4 = 450 + 120 = 570
*/


-- ----------------------------------------------------------------------------
-- 5.2 Running Total Per Group
-- ----------------------------------------------------------------------------

/*
Combine PARTITION BY with running total
*/

-- EXAMPLE: Running total of sales per region
SELECT region,
       sale_date,
       daily_sales,
       SUM(daily_sales) OVER (PARTITION BY region 
                              ORDER BY sale_date) AS regional_running_total
FROM daily_sales;

/*
RESULT:
region | sale_date   | daily_sales | regional_running_total
North  | 2024-01-01  | 100         | 100
North  | 2024-01-02  | 150         | 250
South  | 2024-01-01  | 80          | 80      ← Resets for new partition!
South  | 2024-01-02  | 120         | 200

Running total calculated separately for each region
*/


-- ----------------------------------------------------------------------------
-- 5.3 Moving Average (Rolling Average)
-- ----------------------------------------------------------------------------

/*
MOVING AVERAGE: Average of current row and N previous rows

SYNTAX:
    AVG(column) OVER (ORDER BY column 
                      ROWS BETWEEN N PRECEDING AND CURRENT ROW)
*/

-- EXAMPLE: 3-day moving average of sales
SELECT sale_date,
       daily_sales,
       AVG(daily_sales) OVER (ORDER BY sale_date 
                              ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_3day
FROM daily_sales;

/*
SAMPLE DATA:
sale_date   | daily_sales
2024-01-01  | 100
2024-01-02  | 150
2024-01-03  | 200
2024-01-04  | 120
2024-01-05  | 180

RESULT:
sale_date   | daily_sales | moving_avg_3day
2024-01-01  | 100         | 100.00         ← Only 1 row: (100)/1
2024-01-02  | 150         | 125.00         ← 2 rows: (100+150)/2
2024-01-03  | 200         | 150.00         ← 3 rows: (100+150+200)/3
2024-01-04  | 120         | 156.67         ← 3 rows: (150+200+120)/3
2024-01-05  | 180         | 166.67         ← 3 rows: (200+120+180)/3

EXPLANATION OF DAY 4:
- 2 PRECEDING = look back 2 rows
- Include: row 2 (150), row 3 (200), row 4 (120)
- Average: (150 + 200 + 120) / 3 = 156.67
*/


-- ----------------------------------------------------------------------------
-- 5.4 Other Aggregate Window Functions
-- ----------------------------------------------------------------------------

/*
All aggregate functions work as window functions
*/

-- MAX and MIN over a window
SELECT emp_id,
       name,
       dept_id,
       salary,
       MAX(salary) OVER (PARTITION BY dept_id) AS max_dept_salary,
       MIN(salary) OVER (PARTITION BY dept_id) AS min_dept_salary,
       salary - MIN(salary) OVER (PARTITION BY dept_id) AS diff_from_min
FROM employees;

-- COUNT over a window
SELECT emp_id,
       name,
       dept_id,
       COUNT(*) OVER (PARTITION BY dept_id) AS dept_employee_count
FROM employees;


-- ============================================================================
-- SECTION 6: FRAME SPECIFICATION (ROWS and RANGE)
-- ============================================================================

/*
FRAME: Defines exactly which rows in the partition to include

TWO TYPES:
1. ROWS - Physical rows (count actual rows)
2. RANGE - Logical range (based on values)

FRAME BOUNDARIES:
- UNBOUNDED PRECEDING - Start of partition
- N PRECEDING - N rows before current
- CURRENT ROW - The current row
- N FOLLOWING - N rows after current
- UNBOUNDED FOLLOWING - End of partition
*/

-- ----------------------------------------------------------------------------
-- 6.1 ROWS Frame Examples
-- ----------------------------------------------------------------------------

/*
ROWS: Count physical rows
*/

-- Last 3 rows including current:
SELECT sale_date,
       daily_sales,
       SUM(daily_sales) OVER (ORDER BY sale_date 
                              ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS sum_last_3
FROM daily_sales;

-- Next 2 rows after current:
SELECT sale_date,
       daily_sales,
       SUM(daily_sales) OVER (ORDER BY sale_date 
                              ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS sum_next_3
FROM daily_sales;

-- Centered window (1 before, current, 1 after):
SELECT sale_date,
       daily_sales,
       AVG(daily_sales) OVER (ORDER BY sale_date 
                              ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS centered_avg
FROM daily_sales;

-- All rows from start to current (running total):
SELECT sale_date,
       daily_sales,
       SUM(daily_sales) OVER (ORDER BY sale_date 
                              ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM daily_sales;

-- All rows in partition:
SELECT sale_date,
       daily_sales,
       SUM(daily_sales) OVER (ORDER BY sale_date 
                              ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS total
FROM daily_sales;


-- ----------------------------------------------------------------------------
-- 6.2 Default Frame Behavior
-- ----------------------------------------------------------------------------

/*
When you don't specify a frame, defaults depend on ORDER BY:

WITH ORDER BY:
    Default = RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    
WITHOUT ORDER BY:
    Default = ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    (entire partition)
*/

-- These are equivalent:
SELECT SUM(salary) OVER (ORDER BY emp_id);
SELECT SUM(salary) OVER (ORDER BY emp_id 
                         RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW);


-- ============================================================================
-- SECTION 7: LAG AND LEAD FUNCTIONS
-- ============================================================================

/*
LAG and LEAD access data from other rows without self-joins
- LAG: Access previous row(s)
- LEAD: Access next row(s)
*/

-- ----------------------------------------------------------------------------
-- 7.1 LAG() - Access Previous Row
-- ----------------------------------------------------------------------------

/*
LAG():
- Returns value from a previous row
- Useful for comparing current row with previous

SYNTAX:
    LAG(column, offset, default) OVER (ORDER BY column)
    
    column: which column to get
    offset: how many rows back (default: 1)
    default: value if no previous row exists (default: NULL)
*/

-- EXAMPLE: Compare each day's sales with previous day
SELECT sale_date,
       daily_sales,
       LAG(daily_sales, 1) OVER (ORDER BY sale_date) AS previous_day_sales,
       daily_sales - LAG(daily_sales, 1) OVER (ORDER BY sale_date) AS daily_change
FROM daily_sales;

/*
SAMPLE DATA:
sale_date   | daily_sales
2024-01-01  | 100
2024-01-02  | 150
2024-01-03  | 130
2024-01-04  | 180

RESULT:
sale_date   | daily_sales | previous_day_sales | daily_change
2024-01-01  | 100         | NULL               | NULL
2024-01-02  | 150         | 100                | 50      ← 150 - 100
2024-01-03  | 130         | 150                | -20     ← 130 - 150
2024-01-04  | 180         | 130                | 50      ← 180 - 130
*/


-- ----------------------------------------------------------------------------
-- 7.2 LEAD() - Access Next Row
-- ----------------------------------------------------------------------------

/*
LEAD():
- Returns value from a following row
- Mirror image of LAG

SYNTAX:
    LEAD(column, offset, default) OVER (ORDER BY column)
*/

-- EXAMPLE: See next day's sales
SELECT sale_date,
       daily_sales,
       LEAD(daily_sales, 1) OVER (ORDER BY sale_date) AS next_day_sales,
       LEAD(daily_sales, 1) OVER (ORDER BY sale_date) - daily_sales AS next_day_change
FROM daily_sales;

/*
RESULT:
sale_date   | daily_sales | next_day_sales | next_day_change
2024-01-01  | 100         | 150            | 50
2024-01-02  | 150         | 130            | -20
2024-01-03  | 130         | 180            | 50
2024-01-04  | 180         | NULL           | NULL
*/


-- ----------------------------------------------------------------------------
-- 7.3 LAG and LEAD with PARTITION BY
-- ----------------------------------------------------------------------------

/*
Use PARTITION BY to compare within groups
*/

-- EXAMPLE: Compare salary with previous person in same department
SELECT emp_id,
       name,
       dept_id,
       salary,
       LAG(salary) OVER (PARTITION BY dept_id ORDER BY salary) AS previous_salary_in_dept,
       salary - LAG(salary) OVER (PARTITION BY dept_id ORDER BY salary) AS salary_gap
FROM employees;


-- ----------------------------------------------------------------------------
-- 7.4 Multiple Offsets
-- ----------------------------------------------------------------------------

/*
You can look back/forward multiple rows
*/

-- EXAMPLE: Compare with 1 and 2 days ago
SELECT sale_date,
       daily_sales,
       LAG(daily_sales, 1) OVER (ORDER BY sale_date) AS one_day_ago,
       LAG(daily_sales, 2) OVER (ORDER BY sale_date) AS two_days_ago
FROM daily_sales;


-- ----------------------------------------------------------------------------
-- 7.5 Using Default Values
-- ----------------------------------------------------------------------------

/*
Provide default value for when previous/next row doesn't exist
*/

SELECT sale_date,
       daily_sales,
       LAG(daily_sales, 1, 0) OVER (ORDER BY sale_date) AS previous_day,
       daily_sales - LAG(daily_sales, 1, 0) OVER (ORDER BY sale_date) AS change
FROM daily_sales;

/*
Now first row shows:
sale_date   | daily_sales | previous_day | change
2024-01-01  | 100         | 0            | 100    ← Instead of NULL
*/


-- ============================================================================
-- SECTION 8: PRACTICAL EXAMPLES
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 8.1 Year-over-Year Comparison
-- ----------------------------------------------------------------------------

/*
Compare sales with same period last year
*/

WITH monthly_sales AS (
    SELECT YEAR(sale_date) AS year,
           MONTH(sale_date) AS month,
           SUM(amount) AS total_sales
    FROM sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
)
SELECT year,
       month,
       total_sales,
       LAG(total_sales, 12) OVER (ORDER BY year, month) AS same_month_last_year,
       total_sales - LAG(total_sales, 12) OVER (ORDER BY year, month) AS yoy_change,
       ROUND(100.0 * (total_sales - LAG(total_sales, 12) OVER (ORDER BY year, month)) 
             / LAG(total_sales, 12) OVER (ORDER BY year, month), 2) AS yoy_pct_change
FROM monthly_sales;


-- ----------------------------------------------------------------------------
-- 8.2 Identifying Gaps in Sequences
-- ----------------------------------------------------------------------------

/*
Find missing dates in a sequence
*/

SELECT sale_date,
       LEAD(sale_date) OVER (ORDER BY sale_date) AS next_date,
       DATEDIFF(LEAD(sale_date) OVER (ORDER BY sale_date), sale_date) AS days_gap
FROM daily_sales
WHERE DATEDIFF(LEAD(sale_date) OVER (ORDER BY sale_date), sale_date) > 1;


-- ----------------------------------------------------------------------------
-- 8.3 Percentile Ranking
-- ----------------------------------------------------------------------------

/*
Show where each employee stands percentile-wise
*/

SELECT emp_id,
       name,
       salary,
       PERCENT_RANK() OVER (ORDER BY salary) AS percentile_rank,
       ROUND(100 * PERCENT_RANK() OVER (ORDER BY salary), 2) AS percentile
FROM employees;

/*
PERCENT_RANK: Returns value between 0 and 1
- 0 = lowest value
- 1 = highest value
- 0.5 = median
*/


-- ----------------------------------------------------------------------------
-- 8.4 Quartiles
-- ----------------------------------------------------------------------------

/*
Divide data into 4 equal groups
*/

SELECT emp_id,
       name,
       salary,
       NTILE(4) OVER (ORDER BY salary) AS salary_quartile
FROM employees;

/*
NTILE(4) divides into 4 groups:
- Quartile 1: Lowest 25%
- Quartile 2: 25-50%
- Quartile 3: 50-75%
- Quartile 4: Highest 25%
*/


-- ----------------------------------------------------------------------------
-- 8.5 First and Last Values
-- ----------------------------------------------------------------------------

/*
Get first and last values in a partition
*/

SELECT dept_id,
       emp_id,
       name,
       salary,
       FIRST_VALUE(salary) OVER (PARTITION BY dept_id ORDER BY salary DESC) AS highest_in_dept,
       LAST_VALUE(salary) OVER (PARTITION BY dept_id ORDER BY salary DESC
                                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS lowest_in_dept
FROM employees;

/*
Note: LAST_VALUE needs full frame specification or it only looks at current row!
*/


-- ============================================================================
-- SECTION 9: COMBINING EVERYTHING
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 9.1 Complex Real-World Example
-- ----------------------------------------------------------------------------

/*
SCENARIO: Sales report with multiple insights
- Running total
- Rank by sales
- Compare with previous month
- Show percentage of total
- Moving 3-month average
*/

WITH monthly_sales AS (
    SELECT DATE_TRUNC('month', sale_date) AS month,
           region,
           SUM(amount) AS monthly_total
    FROM sales
    GROUP BY DATE_TRUNC('month', sale_date), region
)
SELECT month,
       region,
       monthly_total,
       
       -- Running total
       SUM(monthly_total) OVER (PARTITION BY region 
                                ORDER BY month) AS running_total,
       
       -- Rank within region
       RANK() OVER (PARTITION BY region 
                    ORDER BY monthly_total DESC) AS sales_rank,
       
       -- Previous month comparison
       LAG(monthly_total) OVER (PARTITION BY region 
                                ORDER BY month) AS prev_month,
       monthly_total - LAG(monthly_total) OVER (PARTITION BY region 
                                                 ORDER BY month) AS month_over_month,
       
       -- Percentage of total
       ROUND(100.0 * monthly_total / SUM(monthly_total) OVER (PARTITION BY region), 2) AS pct_of_total,
       
       -- Moving average
       AVG(monthly_total) OVER (PARTITION BY region 
                                ORDER BY month 
                                ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_3m
FROM monthly_sales
ORDER BY region, month;


-- ============================================================================
-- SECTION 10: PERFORMANCE CONSIDERATIONS
-- ============================================================================

/*
PERFORMANCE TIPS:

1. INDEXES:
   - Index columns used in ORDER BY and PARTITION BY
   - Window functions can be resource-intensive

2. FRAME SPECIFICATION:
   - Smaller frames = better performance
   - ROWS usually faster than RANGE
   - Avoid UNBOUNDED FOLLOWING when possible

3. MULTIPLE WINDOW FUNCTIONS:
   - Reuse OVER clauses when possible
   - Some databases optimize identical OVER clauses

4. ALTERNATIVES:
   - Self-joins can sometimes be faster for simple cases
   - Consider materialized views for frequently-used calculations

5. PARTITION SIZE:
   - Smaller partitions = better performance
   - Be strategic with PARTITION BY columns
*/


-- ============================================================================
-- QUICK REFERENCE CHEAT SHEET
-- ============================================================================

/*
RANKING FUNCTIONS:
    ROW_NUMBER() - Unique sequential numbers (1, 2, 3, 4)
    RANK()       - Ranking with gaps (1, 2, 2, 4)
    DENSE_RANK() - Ranking without gaps (1, 2, 2, 3)
    NTILE(n)     - Divide into n groups

AGGREGATE FUNCTIONS AS WINDOW FUNCTIONS:
    SUM()   - Running totals, moving sums
    AVG()   - Moving averages
    COUNT() - Running counts
    MAX()   - Maximum up to current row
    MIN()   - Minimum up to current row

VALUE FUNCTIONS:
    LAG(col, n)    - Value from n rows back
    LEAD(col, n)   - Value from n rows ahead
    FIRST_VALUE()  - First value in window
    LAST_VALUE()   - Last value in window

OVER CLAUSE:
    OVER()                              - All rows
    OVER(ORDER BY col)                  - Ordered rows
    OVER(PARTITION BY col)              - Separate groups
    OVER(PARTITION BY col ORDER BY col) - Groups with order

FRAME SPECIFICATION:
    ROWS BETWEEN ... AND ...
    - UNBOUNDED PRECEDING
    - N PRECEDING
    - CURRENT ROW
    - N FOLLOWING
    - UNBOUNDED FOLLOWING
*/


-- ============================================================================
-- COMMON BEGINNER MISTAKES
-- ============================================================================

/*
1. MISTAKE: Using window function in WHERE
   WRONG:   SELECT * FROM employees WHERE ROW_NUMBER() OVER(...) = 1;
   RIGHT:   Use CTE: WITH ranked AS (SELECT ..., ROW_NUMBER()...) 
            SELECT * FROM ranked WHERE row_num = 1;

2. MISTAKE: Forgetting ORDER BY in window
   WRONG:   SUM(sales) OVER (PARTITION BY region)  -- Order matters for cumulative!
   RIGHT:   SUM(sales) OVER (PARTITION BY region ORDER BY date)

3. MISTAKE: Wrong frame for LAST_VALUE
   WRONG:   LAST_VALUE(sal) OVER (ORDER BY sal)  -- Only sees current row!
   RIGHT:   LAST_VALUE(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING 
                                   AND UNBOUNDED FOLLOWING)

4. MISTAKE: Confusing ROW_NUMBER with RANK
   Remember: ROW_NUMBER is always unique, RANK handles ties

5. MISTAKE: Using aggregate without OVER for window function
   WRONG:   SELECT name, salary, MAX(salary) FROM employees;
   RIGHT:   SELECT name, salary, MAX(salary) OVER() FROM employees;

6. MISTAKE: Incorrect LAG/LEAD offset
   LAG(col, 1) looks back 1 row (not forward!)
   LEAD(col, 1) looks forward 1 row (not back!)
*/

-- PRACTICE TIPS:

-- Start with small datasets to see results clearly
-- Draw out the table to understand partitions visually
-- Test each OVER clause component separately
-- Compare window functions with GROUP BY to understand difference
-- Use CTEs to make complex queries readable

-- =============================================================================
-- SQL PRACTICE QUESTIONS - WINDOW FUNCTIONS (Day 4)
-- =============================================================================
/*
1. Use ROW_NUMBER() OVER (ORDER BY ...) to assign sequential row numbers
2. Use RANK() OVER (PARTITION BY department ORDER BY salary DESC) to rank employees by salary within each department
3. Use DENSE_RANK() OVER (...) to rank without gaps when there are ties
4. Find the top 3 salaries per department using RANK() or ROW_NUMBER() (with a subquery/CTE)
5. Calculate a running total using SUM(value) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
6. Compute a moving average using AVG(value) OVER (ORDER BY date ROWS BETWEEN N PRECEDING AND CURRENT ROW)
7. Use LEAD(column, 1) OVER (ORDER BY ...) to access the next row's value
8. Use LAG(column, 1) OVER (ORDER BY ...) to access the previous row's value
9. Use PARTITION BY with window functions to operate per group (e.g., PARTITION BY department)
10. Combine RANK/ROW_NUMBER with filtering (via CTE or subquery) to get top N rows per group
*/
