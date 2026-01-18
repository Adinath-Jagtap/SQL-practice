-- Use CTE to calculate average salary per department
WITH dept_avg AS (
    SELECT dept_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY dept_id
)
SELECT
    e.name,
    e.salary,
    d.avg_salary
FROM employees e
JOIN dept_avg d ON e.dept_id = d.dept_id;
