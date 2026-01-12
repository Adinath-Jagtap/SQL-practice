-- 1) Subquery in WHERE clause (filter using IN with subquery)
SELECT *
FROM employees
WHERE dept_id IN (
    SELECT dept_id FROM departments WHERE dept_name IN ('IT','Sales')
);
