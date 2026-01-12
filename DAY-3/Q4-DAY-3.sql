-- 4) Find employees with salary > average salary (using subquery)
SELECT *
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);