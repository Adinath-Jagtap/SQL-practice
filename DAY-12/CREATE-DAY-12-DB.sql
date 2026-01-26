-- Sample table (for testing)
CREATE TABLE employees (
  emp_id   INTEGER PRIMARY KEY,
  name     TEXT,
  dept_id  INTEGER,
  salary   INTEGER
);

INSERT INTO employees (emp_id, name, dept_id, salary) VALUES
(1,'Amit',1,40000),
(2,'Riya',2,60000),
(3,'Ankit',2,35000),
(4,'Sneha',3,55000),
(5,'Arjun',3,45000),
(6,'Nita',1,30000),
(7,'Karan',2,60000);