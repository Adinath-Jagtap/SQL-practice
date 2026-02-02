-- =============================================================================
-- SQL PRACTICE QUESTIONS - DATE & ANALYTICS (3)
-- =============================================================================
/*
1. Find customers who placed orders in both 2024 and 2025
   - Example approach: GROUP BY customer_id HAVING
     SUM(CASE WHEN EXTRACT(YEAR FROM order_date) = 2024 THEN 1 ELSE 0 END) > 0
     AND SUM(CASE WHEN EXTRACT(YEAR FROM order_date) = 2025 THEN 1 ELSE 0 END) > 0

2. Calculate year-over-year (YoY) growth percentage
   - Example approach: aggregate sales by year then compute
     ((sales_current_year - sales_previous_year) / sales_previous_year) * 100

3. Find products that were never ordered
   - Example approach: LEFT JOIN products p TO order_items oi (or orders) and filter WHERE oi.product_id IS NULL
*/