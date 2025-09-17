# Customer Retention Analysis

## Project Overview
This project focuses on **analyzing customer retention** using SQL, Excel, and Tableau Public. The goal is to identify **churned customers**, understand retention trends by **cohort, region, and segment**, and visualize insights in an **interactive dashboard**.

**Tools Used:**
- Microsoft Excel / Google Sheets (data cleaning, pivot tables)
- SQL (customer analysis queries)
- Tableau Public (interactive dashboard visualization)

---

## Data Description
- `customers_inr_12000.csv` → 12,000+ customer records in **Indian Rupees**  
- `support_tickets_aggregation.csv` → Aggregated support ticket data  
- `Customer Retention Analysis.xlsx` → Cleaned dataset, pivot tables, and calculations  

**MS Excel/Google Sheets Screenshots:**

<img width="1440" height="900" alt="Screenshot 2025-09-17 at 16 28 37" src="https://github.com/user-attachments/assets/7370fad3-c03a-426f-852d-ee38da151a07" />
<img width="1440" height="900" alt="Screenshot 2025-09-17 at 16 28 44" src="https://github.com/user-attachments/assets/44bdb4d0-ed43-4d34-9fcf-1b5771ea7eb3" />
<img width="1440" height="900" alt="Screenshot 2025-09-17 at 16 28 52" src="https://github.com/user-attachments/assets/6c240856-7cb5-4a58-a649-1ce5e3529319" />
<img width="1440" height="900" alt="Screenshot 2025-09-17 at 16 29 02" src="https://github.com/user-attachments/assets/2cbd4ca4-2d86-4833-abe9-8f0da9b58843" />
<img width="1440" height="900" alt="Screenshot 2025-09-17 at 16 29 25" src="https://github.com/user-attachments/assets/9cd03b3a-eafe-4229-b12e-8cc39e53ecdf" />
<img width="1440" height="900" alt="Screenshot 2025-09-17 at 16 29 34" src="https://github.com/user-attachments/assets/e4127a86-b4a9-4b5e-89c1-f9bada5c4ba6" />
<img width="1440" height="900" alt="Screenshot 2025-09-17 at 16 29 43" src="https://github.com/user-attachments/assets/f3ac52dc-4bcc-4951-be6c-b94dabeb90d1" />
<img width="1440" height="900" alt="Screenshot 2025-09-17 at 16 29 50" src="https://github.com/user-attachments/assets/a63f30f6-03dc-481a-9b46-683bae4ec0bc" />

> **Note:** The data used in this project is **dummy/simulated** for educational purposes and does not contain any real customer information.

---

## SQL Queries
We performed the following analyses using SQL:

```sql
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

-- 2. Load CSV into table
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
```

## Dashboard

We built an interactive Tableau Public dashboard with four visuals:
- Churn Trend Over Time → Line chart showing how churn changes month by month
- Churn % by Region → Bar chart highlighting high-risk regions
- Retention by Segment → Bar chart showing loyalty of Premium, Standard, and Budget customers
- Avg Satisfaction vs Churn → Scatter plot showing correlation between satisfaction and churn

**Dashboard Link:** [Customer Retention Analysis](https://public.tableau.com/views/CustomerRetentionAnalysis_17581009286650/Dashboard1)

**Dashboard Screenshot:**

<img width="1440" height="900" alt="Screenshot 2025-09-17 at 16 36 06" src="https://github.com/user-attachments/assets/99da694c-b1c7-445f-99e9-f4b54ed50cef" />

## Key Insights
	•	Customers in the North region have the lowest churn
	•	Premium segment shows the highest retention rates
	•	Higher customer satisfaction strongly correlates with lower churn
	•	Cohort analysis highlights that customers joining in certain months are more likely to churn after 6 months

## How to Run This Project
	1.	Download all CSV and Excel files from the data/ folder
	2.	Open Customer Retention Analysis.xlsx to explore cleaned data and pivot tables
	3.	Run the SQL queries in sql/customer_retention_queries.sql on your MySQL or MariaDB instance
	4.	Open the Tableau Public dashboard link to view interactive visualizations

**Note:** This project demonstrates **end-to-end customer retention analysis**, suitable for a fresher data analyst portfolio.
The data used is **dummy/simulated** and does not contain any real customer information.
