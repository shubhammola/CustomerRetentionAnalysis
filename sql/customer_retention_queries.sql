-- ===============================
-- Customer Retention Analysis SQL
-- ===============================

-- 1. Create customers table (structure only)
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    region VARCHAR(50),
    segment VARCHAR(50),
    first_purchase_date DATE,
    last_purchase_date DATE,
    total_spent DECIMAL(10,2),
    avg_satisfaction DECIMAL(3,2),
    churn_180d BOOLEAN
);

-- 2. Load CSV into table (on MacBook)
LOAD DATA INFILE '/path/to/customers_inr_12000.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customer_id, name, region, segment, first_purchase_date, last_purchase_date, total_spent, avg_satisfaction, churn_180d);

-- 3. Churned customers (no purchase in last 180 days)
SELECT customer_id, last_purchase_date
FROM customers
WHERE DATEDIFF(CURDATE(), last_purchase_date) > 180;

-- 4. Cohort analysis (group by month of first purchase)
SELECT DATE_FORMAT(first_purchase_date, '%Y-%m') AS cohort_month,
       COUNT(customer_id) AS total_customers,
       SUM(CASE WHEN DATEDIFF(CURDATE(), last_purchase_date) > 180 THEN 1 ELSE 0 END) AS churned_customers,
       ROUND(SUM(CASE WHEN DATEDIFF(CURDATE(), last_purchase_date) > 180 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY cohort_month
ORDER BY cohort_month;

-- 5. Region-wise churn
SELECT region,
       COUNT(customer_id) AS total_customers,
       SUM(CASE WHEN DATEDIFF(CURDATE(), last_purchase_date) > 180 THEN 1 ELSE 0 END) AS churned_customers,
       ROUND(SUM(CASE WHEN DATEDIFF(CURDATE(), last_purchase_date) > 180 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY region;

-- 6. Average satisfaction by segment
SELECT segment,
       ROUND(AVG(avg_satisfaction), 2) AS avg_satisfaction,
       ROUND(AVG(churn_180d), 2) AS churn_rate
FROM customers
GROUP BY segment;