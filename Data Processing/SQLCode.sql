-- Coffee Shop Analysis  

SELECT 
    COUNT(DISTINCT transaction_id) AS number_of_sales,
    SUM(transaction_qty * unit_price) AS total_revenue,
    SUM(transaction_qty) AS number_of_units_sold,
    transaction_time,

-- DATES bucket
    TO_DATE(transaction_date, 'YYYY/MM/DD') AS purchase_date,
    TO_CHAR(TO_DATE(transaction_date, 'YYYY/MM/DD'), 'YYYYMM') AS month_id,
    DAYNAME(TO_DATE(transaction_date, 'YYYY/MM/DD')) AS day_of_the_week,
    MONTHNAME(TO_DATE(transaction_date, 'YYYY/MM/DD')) AS month_name,

--Time bucket  
CASE 
    WHEN transaction_time BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
    WHEN transaction_time BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
    WHEN transaction_time BETWEEN '18:00:00' AND '20:59:59' THEN 'Evening'
    ELSE 'Night'
END AS time_bucket,

CASE
    WHEN SUM(transaction_qty * unit_price) BETWEEN 0 AND 20 THEN 'Low Spender'
    WHEN SUM(transaction_qty * unit_price) BETWEEN 21 AND 40 THEN 'Medium Spender'
    WHEN SUM(transaction_qty * unit_price) BETWEEN 41 AND 60 THEN 'High Spender'
    ELSE 'Very High Spender'
END AS spender_bucket,

-- Extra columns needed since they're in the GROUP BY clause:

    store_location,
    product_category,
    product_detail,
    product_type
    
FROM coffeeshopdb.coffeeshopschema.coffeeshop
GROUP BY 
    month_id,
    purchase_date,
    day_of_the_week,
    store_location,
    product_category,
    product_detail,
    product_type,
    month_name,
    transaction_time
  --  spender_bucket
    
HAVING total_revenue > 0; 
