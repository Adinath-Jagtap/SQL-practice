-- 3) Subquery in FROM clause (derived table)
SELECT sub.dept_id, AVG(sub.salary) AS avg_salary
FROM (
  SELECT dept_id, salary FROM employees
) AS sub
GROUP BY sub.dept_id;
