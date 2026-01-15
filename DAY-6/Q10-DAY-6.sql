-- Get names from:
-- (1) Employees with salary > 50000
-- (2) Employees working in IT department

SELECT e.name
FROM employees e
WHERE e.salary > 50000

UNION

SELECT e.name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_name = 'IT';
