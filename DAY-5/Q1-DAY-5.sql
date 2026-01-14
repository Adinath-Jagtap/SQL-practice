-- 1) Create table 'employees' with emp_id as PRIMARY KEY
-- Safe to run repeatedly: drop the table first if it exists
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    emp_id    INTEGER PRIMARY KEY,  -- unique identifier for each employee
    name      TEXT NOT NULL,        -- employee name (not null)
    age       INTEGER,              -- age in years
    city      TEXT,                 -- city of residence
    salary    INTEGER               -- salary in whole units
);

-- Verify the table was created
SELECT * FROM employees;