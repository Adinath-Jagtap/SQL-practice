-- Calculates running total of salary inside each department
SELECT
    emp_id,
    name,
    dept_id,
    salary,
    SUM(salary) OVER (
        PARTITION BY dept_id
        ORDER BY salary DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS dept_running_total
FROM employees
ORDER BY dept_id, salary DESC;
