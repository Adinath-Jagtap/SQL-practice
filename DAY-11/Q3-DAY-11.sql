-- 3) Find top 3 products by revenue in each category
-- Schema (example)
-- CREATE TABLE products    (product_id INTEGER PRIMARY KEY, product_name TEXT, category_id INTEGER);
-- CREATE TABLE categories  (category_id INTEGER PRIMARY KEY, category_name TEXT);
-- CREATE TABLE order_items (order_item_id INTEGER PRIMARY KEY, order_id INTEGER, product_id INTEGER, quantity INTEGER, price NUMERIC);
-- revenue for an item = quantity * price

-- Step 1: compute total revenue per product
-- Step 2: rank products inside each category and keep top 3
WITH product_revenue AS (
  SELECT
    p.product_id,
    p.product_name,
    p.category_id,
    SUM(oi.quantity * oi.price) AS revenue
  FROM products p
  JOIN order_items oi ON p.product_id = oi.product_id
  GROUP BY p.product_id, p.product_name, p.category_id
),

ranked AS (
  SELECT
    pr.*,
    ROW_NUMBER() OVER (PARTITION BY pr.category_id ORDER BY pr.revenue DESC) AS rn
  FROM product_revenue pr
)

SELECT
  r.category_id,
  c.category_name,
  r.product_id,
  r.product_name,
  r.revenue
FROM ranked r
LEFT JOIN categories c ON c.category_id = r.category_id
WHERE r.rn <= 3
ORDER BY r.category_id, r.rn;
