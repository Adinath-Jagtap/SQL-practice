-- 4) Delete employees with salary less than 36000 (example condition)
-- WARNING: this removes rows permanently; use SELECT first to preview
SELECT 'STEP 4: To be deleted (preview)', * FROM employees WHERE salary < 36000;

-- Now perform delete
DELETE FROM employees
WHERE salary < 36000;

-- Show remaining rows
SELECT 'STEP 4: Remaining rows after delete' AS step, * FROM employees ORDER BY emp_id;