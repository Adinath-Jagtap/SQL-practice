-- Start a transaction
BEGIN;

-- Make a change
UPDATE employees
SET salary = salary + 1000
WHERE dept_id = 2;

-- If everything is OK
COMMIT;

-- If something goes wrong, use:
-- ROLLBACK;
