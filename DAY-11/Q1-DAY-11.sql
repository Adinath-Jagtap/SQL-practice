-- 1) Find customers who never ordered
-- Schema (example)
-- CREATE TABLE customers (customer_id INTEGER PRIMARY KEY, name TEXT);
-- CREATE TABLE orders    (order_id INTEGER PRIMARY KEY, customer_id INTEGER, order_date DATE, amount NUMERIC);

-- Method: LEFT JOIN customers to orders and pick rows where order is NULL
SELECT c.customer_id, c.name
FROM customers c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Alternative (using NOT EXISTS)
SELECT c.customer_id, c.name
FROM customers c
WHERE NOT EXISTS (
  SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id
);
