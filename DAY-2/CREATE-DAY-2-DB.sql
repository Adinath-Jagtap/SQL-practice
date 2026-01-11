CREATE TABLE departments (
    dept_id INTEGER,
    dept_name TEXT
);

CREATE TABLE employees (
    emp_id INTEGER,
    name TEXT,
    salary INTEGER,
    dept_id INTEGER
);

CREATE TABLE sales (
    sale_id INTEGER,
    region TEXT,
    amount INTEGER,
    emp_id INTEGER,
    sale_date DATE
);


INSERT INTO departments VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Sales');

INSERT INTO employees VALUES
(1, 'Amit', 40000, 1),
(2, 'Riya', 60000, 2),
(3, 'Ankit', 35000, 2),
(4, 'Sneha', 55000, 3),
(5, 'Arjun', 45000, 3);

INSERT INTO sales VALUES
(1, 'West', 5000, 4, '2025-01-05'),
(2, 'East', 8000, 4, '2025-01-10'),
(3, 'West', 3000, 5, '2025-01-12'),
(4, 'North', 12000, 2, '2025-01-15'),
(5, 'East', 7000, 5, '2025-01-20');
