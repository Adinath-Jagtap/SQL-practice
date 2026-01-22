-- Uses window function RANK() or ROW_NUMBER() depending on whether you want ties handled.
-- RANK() will give the same rank to ties and leave gaps; DENSE_RANK() won't leave gaps.
SELECT
  emp_id,
  name,
  dept_id,
  salary,
  RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS dept_salary_rank
FROM employees
ORDER BY dept_id, dept_salary_rank;
