-- LAG gives value from the previous row based on ordering
SELECT
    emp_id,
    name,
    salary,
    LAG(salary, 1) OVER (ORDER BY salary) AS previous_salary
FROM employees
ORDER BY salary;
