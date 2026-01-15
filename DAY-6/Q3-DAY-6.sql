-- Returns all rows from both tables, matched where possible
-- PostgreSQL / MySQL 8+:
SELECT
    e.name,
    d.dept_name
FROM employees e
FULL OUTER JOIN departments d
    ON e.dept_id = d.dept_id;

-- SQLite alternative (simulate FULL OUTER JOIN):
-- SELECT e.name, d.dept_name
-- FROM employees e LEFT JOIN departments d ON e.dept_id = d.dept_id
-- UNION
-- SELECT e.name, d.dept_name
-- FROM employees e RIGHT JOIN departments d ON e.dept_id = d.dept_id;
