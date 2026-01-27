-- Increase salary by 10% for IT department
UPDATE employees
SET salary = salary * 1.10
WHERE department = 'IT';
