-- 1) Find employees with the same salary (unique pairs) using self-join
-- Returns each pair once (e1.emp_id < e2.emp_id)
SELECT e1.emp_id AS emp1_id, e1.name AS emp1_name,
       e2.emp_id AS emp2_id, e2.name AS emp2_name,
       e1.salary
FROM employees e1
JOIN employees e2
  ON e1.salary = e2.salary
 AND e1.emp_id < e2.emp_id
ORDER BY e1.salary, e1.emp_id;
