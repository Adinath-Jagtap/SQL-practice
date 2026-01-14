-- 2) Insert 5 rows into employees
-- Use explicit column list for clarity
INSERT INTO employees (emp_id, name, age, city, salary) VALUES
(1, 'Amit', 24, 'Mumbai', 40000),
(2, 'Riya', 28, 'Delhi', 60000),
(3, 'Ankit', 22, 'Pune', 35000),
(4, 'Sneha', 30, 'Mumbai', 55000),
(5, 'Arjun', 26, 'Delhi', 45000);

-- Confirm rows were inserted
SELECT 'STEP 2: All rows after insert' AS step, * FROM employees ORDER BY emp_id;