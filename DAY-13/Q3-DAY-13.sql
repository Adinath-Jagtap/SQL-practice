-- Delete records older than 1 Jan 2022
DELETE FROM employees
WHERE hire_date < '2022-01-01';
