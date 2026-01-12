-- 2) Subquery in SELECT clause (compute a value per row)
SELECT
  name,
  salary,
  (SELECT MAX(salary) FROM employees) AS max_salary_overall
FROM employees;
