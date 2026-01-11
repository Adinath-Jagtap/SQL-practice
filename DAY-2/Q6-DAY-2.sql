-- 6. Sum of sales per region
SELECT region, SUM(amount) AS total_sales
FROM sales
GROUP BY region;