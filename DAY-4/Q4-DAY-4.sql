-- First, rank employees inside each department
WITH ranked AS (
    SELECT
        emp_id,
        name,
        dept_id,
        salary,
        ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rn
    FROM employees
)
-- Then, select only top 3 from each department
SELECT
    emp_id,
    name,
    dept_id,
    salary
FROM ranked
WHERE rn <= 3
ORDER BY dept_id, rn;
