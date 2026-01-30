-- 2) Count records per category
SELECT category, COUNT(*) AS total_count
FROM products
GROUP BY category;
