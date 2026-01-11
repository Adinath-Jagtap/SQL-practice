-- 2. LEFT JOIN (all employees, matching departments)
SELECT e.name, d.dept_name
FROM employees e
LEFT JOIN departments d
ON e.dept_id = d.dept_id;