-- ============================================================================
-- SQL ADVANCED JOINS & SET OPERATIONS - COMPACT GUIDE
-- ============================================================================

-- ============================================================================
-- SECTION 1: SELF JOIN
-- ============================================================================

/*
SELF JOIN: Join a table to itself
USE CASES: Hierarchies, comparisons within same table

SYNTAX:
    SELECT a.col, b.col
    FROM table a
    INNER JOIN table b ON a.key = b.key;
*/

-- Employee-Manager relationship
SELECT e.emp_id, e.name AS employee,
       m.emp_id AS manager_id, m.name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id;

-- Find employees in same department
SELECT e1.name AS employee1, e2.name AS employee2, e1.dept_id
FROM employees e1
INNER JOIN employees e2 ON e1.dept_id = e2.dept_id
WHERE e1.emp_id < e2.emp_id;  -- Avoid duplicates

-- Find employees earning more than their manager
SELECT e.name AS employee, e.salary,
       m.name AS manager, m.salary AS manager_salary
FROM employees e
INNER JOIN employees m ON e.manager_id = m.emp_id
WHERE e.salary > m.salary;


-- ============================================================================
-- SECTION 2: CROSS JOIN
-- ============================================================================

/*
CROSS JOIN: Cartesian product - every row from table1 with every row from table2
Result rows = table1_rows × table2_rows

USE CASES: Generate combinations, test data, scheduling
*/

-- Basic CROSS JOIN
SELECT p.product_name, s.store_name
FROM products p
CROSS JOIN stores s;

-- Alternative syntax (implicit)
SELECT p.product_name, s.store_name
FROM products p, stores s;

-- Practical example: All possible shift assignments
SELECT e.name, s.shift_time
FROM employees e
CROSS JOIN shifts s;

-- CROSS JOIN with filter
SELECT p.product_name, c.color
FROM products p
CROSS JOIN colors c
WHERE p.category = 'Clothing';


-- ============================================================================
-- SECTION 3: FULL OUTER JOIN
-- ============================================================================

/*
FULL OUTER JOIN: Returns ALL rows from both tables
- Matching rows paired together
- Non-matching rows from left table (NULL for right)
- Non-matching rows from right table (NULL for left)

NOTE: Not supported in MySQL (use UNION of LEFT and RIGHT JOIN)
*/

-- Basic FULL OUTER JOIN
SELECT e.name, d.dept_name
FROM employees e
FULL OUTER JOIN departments d ON e.dept_id = d.dept_id;

-- MySQL alternative (UNION of LEFT and RIGHT)
SELECT e.name, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
UNION
SELECT e.name, d.dept_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id;

-- Find unmatched records from both sides
SELECT e.emp_id, e.name, d.dept_id, d.dept_name
FROM employees e
FULL OUTER JOIN departments d ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL OR d.dept_id IS NULL;


-- ============================================================================
-- SECTION 4: UNION
-- ============================================================================

/*
UNION: Combines results from multiple SELECT queries
- Removes duplicate rows
- Column count and types must match
- Uses first query's column names

SYNTAX:
    SELECT columns FROM table1
    UNION
    SELECT columns FROM table2;
*/

-- Combine customers and suppliers
SELECT name, email FROM customers
UNION
SELECT name, email FROM suppliers;

-- Combine with WHERE
SELECT emp_id, name, 'Employee' AS type
FROM employees
WHERE dept_id = 10
UNION
SELECT contractor_id, name, 'Contractor' AS type
FROM contractors
WHERE dept_id = 10;

-- Combine with ORDER BY (at the end)
SELECT product_name, price FROM products_2023
UNION
SELECT product_name, price FROM products_2024
ORDER BY price DESC;

-- Combine three queries
SELECT name FROM customers
UNION
SELECT name FROM suppliers
UNION
SELECT name FROM partners;


-- ============================================================================
-- SECTION 5: UNION ALL
-- ============================================================================

/*
UNION ALL: Combines results INCLUDING duplicates
- Faster than UNION (no duplicate removal)
- Use when duplicates are acceptable or expected
*/

-- Keep all records including duplicates
SELECT product_name FROM sales_2023
UNION ALL
SELECT product_name FROM sales_2024;

-- Compare UNION vs UNION ALL
-- UNION (removes duplicates)
SELECT dept_id FROM employees
UNION
SELECT dept_id FROM contractors;
-- Result: 10, 20, 30

-- UNION ALL (keeps duplicates)
SELECT dept_id FROM employees
UNION ALL
SELECT dept_id FROM contractors;
-- Result: 10, 20, 30, 10, 20, 10, 30, 30 (if duplicates exist)

-- Aggregate from multiple tables
SELECT SUM(total) AS combined_total
FROM (
    SELECT amount AS total FROM sales_2023
    UNION ALL
    SELECT amount AS total FROM sales_2024
) AS combined_sales;


-- ============================================================================
-- SECTION 6: INTERSECT
-- ============================================================================

/*
INTERSECT: Returns only rows present in BOTH queries
- Automatically removes duplicates
- Column count and types must match

NOTE: Not supported in MySQL (use INNER JOIN or IN subquery)
*/

-- Basic INTERSECT
SELECT emp_id FROM employees_2023
INTERSECT
SELECT emp_id FROM employees_2024;
-- Returns employees present in both years

-- MySQL alternative using IN
SELECT emp_id FROM employees_2023
WHERE emp_id IN (SELECT emp_id FROM employees_2024);

-- MySQL alternative using INNER JOIN
SELECT DISTINCT e1.emp_id
FROM employees_2023 e1
INNER JOIN employees_2024 e2 ON e1.emp_id = e2.emp_id;

-- Find customers who are also suppliers
SELECT email FROM customers
INTERSECT
SELECT email FROM suppliers;


-- ============================================================================
-- SECTION 7: EXCEPT (MINUS)
-- ============================================================================

/*
EXCEPT (MINUS in Oracle): Returns rows from first query NOT in second query
- Removes duplicates
- Order matters: A EXCEPT B ≠ B EXCEPT A

NOTE: Not supported in MySQL (use LEFT JOIN or NOT IN)
*/

-- Basic EXCEPT
SELECT emp_id FROM employees_2023
EXCEPT
SELECT emp_id FROM employees_2024;
-- Returns employees who left (in 2023 but not 2024)

-- MySQL alternative using NOT IN
SELECT emp_id FROM employees_2023
WHERE emp_id NOT IN (SELECT emp_id FROM employees_2024);

-- MySQL alternative using LEFT JOIN
SELECT e1.emp_id
FROM employees_2023 e1
LEFT JOIN employees_2024 e2 ON e1.emp_id = e2.emp_id
WHERE e2.emp_id IS NULL;

-- Find customers who never ordered
SELECT customer_id FROM customers
EXCEPT
SELECT customer_id FROM orders;

-- Opposite direction
SELECT emp_id FROM employees_2024
EXCEPT
SELECT emp_id FROM employees_2023;
-- Returns new hires (in 2024 but not 2023)


-- ============================================================================
-- SECTION 8: COMPLEX MULTI-TABLE JOINS
-- ============================================================================

/*
Combine multiple tables with various conditions
*/

-- Join 4 tables with multiple conditions
SELECT 
    o.order_id,
    c.customer_name,
    p.product_name,
    o.quantity,
    o.order_date,
    s.store_name
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN products p ON o.product_id = p.product_id
LEFT JOIN stores s ON o.store_id = s.store_id
WHERE o.order_date >= '2024-01-01'
  AND c.country = 'USA'
  AND p.category = 'Electronics';

-- Multiple join conditions
SELECT e.name, d.dept_name, l.city
FROM employees e
INNER JOIN departments d 
    ON e.dept_id = d.dept_id 
    AND e.location_id = d.location_id
INNER JOIN locations l 
    ON d.location_id = l.location_id;

-- Join with OR conditions
SELECT e.name, d.dept_name, p.project_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
LEFT JOIN projects p 
    ON e.emp_id = p.lead_id OR e.emp_id = p.backup_lead_id;

-- Self join with additional table
SELECT 
    e.name AS employee,
    m.name AS manager,
    d.dept_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id
INNER JOIN departments d ON e.dept_id = d.dept_id
WHERE d.location = 'New York';


-- ============================================================================
-- SECTION 9: JOINING WITH SUBQUERIES (DERIVED TABLES)
-- ============================================================================

/*
Join a table with query results (derived table/inline view)
Subquery must have an alias
*/

-- Basic derived table join
SELECT e.name, e.salary, dept_avg.avg_salary
FROM employees e
INNER JOIN (
    SELECT dept_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY dept_id
) AS dept_avg ON e.dept_id = dept_avg.dept_id;

-- Multiple derived tables
SELECT 
    sales_summary.region,
    sales_summary.total_sales,
    cost_summary.total_costs,
    sales_summary.total_sales - cost_summary.total_costs AS profit
FROM (
    SELECT region, SUM(amount) AS total_sales
    FROM sales
    GROUP BY region
) AS sales_summary
INNER JOIN (
    SELECT region, SUM(amount) AS total_costs
    FROM costs
    GROUP BY region
) AS cost_summary ON sales_summary.region = cost_summary.region;

-- Join with filtered subquery
SELECT p.product_name, top_sellers.total_sold
FROM products p
INNER JOIN (
    SELECT product_id, SUM(quantity) AS total_sold
    FROM order_items
    WHERE order_date >= '2024-01-01'
    GROUP BY product_id
    HAVING SUM(quantity) > 100
) AS top_sellers ON p.product_id = top_sellers.product_id;

-- Nested derived tables
SELECT *
FROM (
    SELECT e.name, e.salary, d.dept_name
    FROM employees e
    INNER JOIN departments d ON e.dept_id = d.dept_id
) AS emp_dept
WHERE salary > 50000;


-- ============================================================================
-- SECTION 10: COMBINING JOINS WITH UNIONS
-- ============================================================================

/*
Use JOIN and UNION together in workflows
*/

-- Union of joined results
SELECT e.name, d.dept_name, 'Full-Time' AS employment_type
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id
WHERE e.is_full_time = TRUE
UNION
SELECT c.name, d.dept_name, 'Contractor' AS employment_type
FROM contractors c
INNER JOIN departments d ON c.dept_id = d.dept_id;

-- Join the result of a UNION
SELECT combined.name, combined.total_sales, r.region_name
FROM (
    SELECT customer_id, SUM(amount) AS total_sales
    FROM sales_2023
    GROUP BY customer_id
    UNION ALL
    SELECT customer_id, SUM(amount) AS total_sales
    FROM sales_2024
    GROUP BY customer_id
) AS combined
INNER JOIN customers c ON combined.customer_id = c.customer_id
INNER JOIN regions r ON c.region_id = r.region_id;

-- Complex: Join, Union, Subquery
WITH current_employees AS (
    SELECT e.emp_id, e.name, d.dept_name
    FROM employees e
    INNER JOIN departments d ON e.dept_id = d.dept_id
    WHERE e.status = 'Active'
),
former_employees AS (
    SELECT e.emp_id, e.name, d.dept_name
    FROM employees_archive e
    INNER JOIN departments d ON e.dept_id = d.dept_id
)
SELECT * FROM current_employees
UNION ALL
SELECT * FROM former_employees
ORDER BY name;


-- ============================================================================
-- PRACTICAL EXAMPLES
-- ============================================================================

-- Example 1: Employee hierarchy with levels
WITH RECURSIVE emp_hierarchy AS (
    -- Base: Top-level managers
    SELECT emp_id, name, manager_id, 1 AS level
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive: Employees reporting to previous level
    SELECT e.emp_id, e.name, e.manager_id, eh.level + 1
    FROM employees e
    INNER JOIN emp_hierarchy eh ON e.manager_id = eh.emp_id
)
SELECT * FROM emp_hierarchy;

-- Example 2: Find products sold in all stores
SELECT p.product_name
FROM products p
WHERE NOT EXISTS (
    SELECT s.store_id
    FROM stores s
    EXCEPT
    SELECT DISTINCT si.store_id
    FROM store_inventory si
    WHERE si.product_id = p.product_id
);

-- Example 3: Cross join for scheduling matrix
SELECT 
    e.name AS employee,
    d.day_name AS day,
    s.shift_name AS shift
FROM employees e
CROSS JOIN days d
CROSS JOIN shifts s
WHERE e.dept_id = 10
ORDER BY e.name, d.day_order, s.shift_order;

-- Example 4: Compare sales across regions
SELECT 
    r1.region_name AS region1,
    r2.region_name AS region2,
    r1.total_sales AS sales1,
    r2.total_sales AS sales2,
    r1.total_sales - r2.total_sales AS difference
FROM (
    SELECT region_id, region_name, SUM(amount) AS total_sales
    FROM sales
    GROUP BY region_id, region_name
) r1
CROSS JOIN (
    SELECT region_id, region_name, SUM(amount) AS total_sales
    FROM sales
    GROUP BY region_id, region_name
) r2
WHERE r1.region_id < r2.region_id;


-- ============================================================================
-- QUICK REFERENCE
-- ============================================================================

/*
SELF JOIN:
    SELECT a.*, b.*
    FROM table a JOIN table b ON a.col = b.col;

CROSS JOIN:
    SELECT * FROM table1 CROSS JOIN table2;
    -- OR --
    SELECT * FROM table1, table2;

FULL OUTER JOIN:
    SELECT * FROM t1 FULL OUTER JOIN t2 ON t1.id = t2.id;
    -- MySQL: Use UNION of LEFT and RIGHT JOIN

UNION (no duplicates):
    SELECT col FROM t1
    UNION
    SELECT col FROM t2;

UNION ALL (with duplicates):
    SELECT col FROM t1
    UNION ALL
    SELECT col FROM t2;

INTERSECT (common rows):
    SELECT col FROM t1
    INTERSECT
    SELECT col FROM t2;
    -- MySQL: Use INNER JOIN or IN

EXCEPT (difference):
    SELECT col FROM t1
    EXCEPT
    SELECT col FROM t2;
    -- MySQL: Use LEFT JOIN WHERE NULL or NOT IN

DERIVED TABLE JOIN:
    SELECT t1.*, sub.calc
    FROM t1
    JOIN (SELECT id, SUM(amt) AS calc FROM t2 GROUP BY id) sub
    ON t1.id = sub.id;
*/


-- ============================================================================
-- COMMON MISTAKES
-- ============================================================================

/*
1. MISTAKE: CROSS JOIN without filter (huge result set)
   WRONG:   SELECT * FROM products CROSS JOIN customers;
            -- Returns millions of useless rows
   RIGHT:   Add WHERE conditions or use appropriate join type

2. MISTAKE: Column mismatch in UNION
   WRONG:   SELECT id, name FROM t1 UNION SELECT name FROM t2;
   RIGHT:   SELECT id, name FROM t1 UNION SELECT id, name FROM t2;

3. MISTAKE: Forgetting alias for derived table
   WRONG:   SELECT * FROM (SELECT * FROM employees WHERE dept_id = 10);
   RIGHT:   SELECT * FROM (SELECT * FROM employees WHERE dept_id = 10) AS sub;

4. MISTAKE: Wrong EXCEPT direction
   A EXCEPT B: Rows in A but not in B
   B EXCEPT A: Rows in B but not in A
   These are NOT the same!

5. MISTAKE: Using UNION when UNION ALL is sufficient
   UNION removes duplicates (slower)
   UNION ALL keeps duplicates (faster)
   Use UNION ALL when duplicates are acceptable

6. MISTAKE: Self join without proper condition
   WRONG:   SELECT * FROM emp e1 JOIN emp e2 ON e1.dept = e2.dept;
            -- Returns too many rows including self-pairs
   RIGHT:   Add WHERE e1.emp_id < e2.emp_id to avoid duplicates
*/


-- ============================================================================
-- PERFORMANCE TIPS
-- ============================================================================

/*
1. INDEXES: Create indexes on join columns
   CREATE INDEX idx_dept ON employees(dept_id);

2. UNION ALL vs UNION: Use UNION ALL when duplicates don't matter (faster)

3. DERIVED TABLES: Consider CTEs for better readability and potential optimization

4. CROSS JOIN: Use sparingly; result grows exponentially

5. SUBQUERY PLACEMENT: Sometimes JOIN is faster than subquery in WHERE

6. INTERSECT/EXCEPT: If not supported, INNER JOIN often faster than IN subquery
*/