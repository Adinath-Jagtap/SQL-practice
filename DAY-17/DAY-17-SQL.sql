-- =============================================================================
-- SQL PRACTICE QUESTIONS (3)
-- =============================================================================
/*
1. Find employees with the same salary (SELF JOIN)
   - Example idea: SELECT e1.* FROM employees e1 JOIN employees e2 ON e1.salary = e2.salary AND e1.emp_id <> e2.emp_id;

2. Calculate median salary by department
   - Approach: use window functions or aggregation depending on DB:
     - In PostgreSQL: SELECT dept, percentile_cont(0.5) WITHIN GROUP (ORDER BY salary) AS median_salary FROM employees GROUP BY dept;
     - Or use ROW_NUMBER()/COUNT() technique with CTEs for DBs without percentile_cont.

3. Find gaps in sequential data (missing IDs)
   - Example: SELECT t.id + 1 AS missing_start, MIN(t2.id) - 1 AS missing_end
     FROM table t LEFT JOIN table t2 ON t2.id = (SELECT MIN(id2) FROM table WHERE id2 > t.id)
     GROUP BY t.id HAVING t.id + 1 < MIN(t2.id);
   - Simpler pattern: use a numbers table or generate_series() and LEFT JOIN to detect missing ids.
*/
