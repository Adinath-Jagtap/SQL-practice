-- Every employee paired with every department
SELECT
    e.name,
    d.dept_name
FROM employees e
CROSS JOIN departments d;
