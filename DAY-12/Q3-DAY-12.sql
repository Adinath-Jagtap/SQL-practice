-- 3) Categorize employees by salary range using CASE
-- Example buckets: Low (<40000), Medium (40000-54999), High (>=55000)
SELECT emp_id,
       name,
       salary,
       CASE
         WHEN salary IS NULL THEN 'Unknown'
         WHEN salary < 40000 THEN 'Low'
         WHEN salary BETWEEN 40000 AND 54999 THEN 'Medium'
         ELSE 'High'
       END AS salary_category
FROM employees
ORDER BY salary DESC;