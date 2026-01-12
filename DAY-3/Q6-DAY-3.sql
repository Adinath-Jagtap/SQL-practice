-- 6) Correlated subquery: employees earning more than their dept average
SELECT e.*
FROM employees e
WHERE e.salary > (
  SELECT AVG(s2.salary)
  FROM employees s2
  WHERE s2.dept_id = e.dept_id
);