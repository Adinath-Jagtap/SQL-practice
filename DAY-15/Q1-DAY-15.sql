-- 1) Select top 10 records ordered by date (latest first)
SELECT *
FROM orders
ORDER BY order_date DESC
LIMIT 10;
