-- 3) Use window function to find difference from previous row
-- Example: for sales table ordered by sale_date, compute difference in amount from previous sale
SELECT sale_id, sale_date, amount,
       amount - LAG(amount) OVER (ORDER BY sale_date, sale_id) AS diff_from_prev
FROM sales
ORDER BY sale_date, sale_id;