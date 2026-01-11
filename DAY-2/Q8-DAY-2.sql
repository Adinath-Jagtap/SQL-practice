-- 8. Join three tables (employees + departments + sales)
SELECT e.name, d.dept_name, s.region, s.amount
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
JOIN sales s ON e.emp_id = s.emp_id;