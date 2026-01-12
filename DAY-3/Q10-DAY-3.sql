-- 10) Use a CTE together with JOINs:
-- Build a CTE that finds departments with avg salary, then join to departments table
WITH dept_avg AS (
  SELECT dept_id, AVG(salary) AS avg_salary
  FROM employees
  GROUP BY dept_id
)
SELECT d.dept_name, da.avg_salary, COUNT(e.emp_id) AS employee_count
FROM dept_avg da
JOIN departments d ON da.dept_id = d.dept_id
LEFT JOIN employees e ON e.dept_id = d.dept_id
GROUP BY d.dept_name, da.avg_salary;
