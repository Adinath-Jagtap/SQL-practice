-- Employee name, department name, project name
-- Only for employees earning more than 45000
SELECT
    e.name,
    d.dept_name,
    p.project_name,
    e.salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
JOIN projects p ON d.dept_id = p.dept_id
WHERE e.salary > 45000;
