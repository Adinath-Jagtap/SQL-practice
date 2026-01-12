-- 8) Multiple CTEs in one query (dept_avg and emp_count), then join them
WITH
dept_avg AS (
  SELECT dept_id, AVG(salary) AS avg_salary
  FROM employees
  GROUP BY dept_id
),
emp_count AS (
  SELECT dept_id, COUNT(*) AS num_employees
  FROM employees
  GROUP BY dept_id
)
SELECT da.dept_id, da.avg_salary, ec.num_employees
FROM dept_avg da
JOIN emp_count ec ON da.dept_id = ec.dept_id;
