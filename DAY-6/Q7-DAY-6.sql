-- Names present in employees but not in departments
SELECT name FROM employees
EXCEPT
SELECT dept_name FROM departments;
