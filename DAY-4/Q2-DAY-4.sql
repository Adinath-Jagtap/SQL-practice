-- PARTITION BY dept_id resets ranking for each department
-- ORDER BY salary DESC ranks highest salary as 1
SELECT
    emp_id,
    name,
    dept_id,
    salary,
    RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS dept_rank
FROM employees;