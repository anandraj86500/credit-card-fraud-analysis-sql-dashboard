CREATE TABLE credit_card_fraud_detections (
    sr_no INT,
    trans_date DATE,
    trans_time VARCHAR(20),
    cc_num VARCHAR(30),  
    merchant VARCHAR(255),
    category VARCHAR(100),
    amt DECIMAL(10,2),
    first VARCHAR(100),
    last VARCHAR(100),
    gender VARCHAR(10),
    street VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(50),
    zip INT,
    lat DECIMAL(10,6),
    long DECIMAL(10,6),
    city_pop INT,
    job VARCHAR(255),
    dob DATE,
    trans_num VARCHAR(100),
    unix_time BIGINT,
    merch_lat DECIMAL(10,6),
    merch_long DECIMAL(10,6),
    is_fraud VARCHAR(10),
    hour_of_day INT,
    amount_category VARCHAR(50),
    age_group VARCHAR(50),
    fraud_status VARCHAR(50)
);

select * from credit_card_fraud_detections;

--Overall Summary & Statistics
  SELECT COUNT(*) AS total_transactions,
       COUNT(CASE WHEN fraud_status='Fraud' THEN 1 END) AS total_fraud,
       COUNT(CASE WHEN fraud_status='No Fraud' THEN 1 END) AS total_non_fraud,
       ROUND(COUNT(CASE WHEN fraud_status='Fraud' THEN 1 END)*100.0/NULLIF(COUNT(*),0),2) AS fraud_percentage,
       ROUND(AVG(amt),2) AS avg_transaction_amount,
       MIN(amt) AS min_transaction_amount,
       MAX(amt) AS max_transaction_amount,
       SUM(amt) AS total_transaction_amount,
       COUNT(DISTINCT category) AS unique_categories,
       COUNT(DISTINCT state) AS unique_states,
       COUNT(DISTINCT city) AS unique_cities
FROM credit_card_fraud_detections;

--Category-wise Fraud Analysis
SELECT category,
       COUNT(*) AS total_transactions,
       COUNT(CASE WHEN fraud_status='Fraud' THEN 1 END) AS fraud_count,
       ROUND(COUNT(CASE WHEN fraud_status='Fraud' THEN 1 END)*100.0/NULLIF(COUNT(*),0),2) AS fraud_percentage
FROM credit_card_fraud_detections
GROUP BY category
ORDER BY fraud_count DESC;

--Top 10 States with Highest Fraud
SELECT state,
       COUNT(CASE WHEN fraud_status='Fraud' THEN 1 END) AS fraud_count
FROM credit_card_fraud_detections
GROUP BY state
ORDER BY fraud_count DESC
LIMIT 10;

--Gender-wise Fraud Comparison Query
SELECT gender,
       COUNT(*) AS total_transactions,
       COUNT(CASE WHEN fraud_status='Fraud' THEN 1 END) AS fraud_count,
       ROUND(COUNT(CASE WHEN fraud_status='Fraud' THEN 1 END)*100.0/NULLIF(COUNT(*),0),2) AS fraud_percentage
FROM credit_card_fraud_detections
GROUP BY gender
ORDER BY fraud_percentage DESC;

--Transaction Amount Range Analysis
SELECT amount_category,
       COUNT(*) AS total_transactions,
       COUNT(CASE WHEN fraud_status='Fraud' THEN 1 END) AS fraud_count,
       ROUND(COUNT(CASE WHEN fraud_status='Fraud' THEN 1 END)*100.0/NULLIF(COUNT(*),0),2) AS fraud_percentage
FROM credit_card_fraud_detections
GROUP BY amount_category
ORDER BY fraud_percentage DESC;

--Top 10 Cities by Fraud Count
SELECT city,
       COUNT(CASE WHEN fraud_status='Fraud' THEN 1 END) AS fraud_count
FROM credit_card_fraud_detections
GROUP BY city
ORDER BY fraud_count DESC
LIMIT 10;

--Top 15 High-Risk Jobs
SELECT job,
       COUNT(*) AS total_transactions,
       COUNT(CASE WHEN fraud_status='Fraud' THEN 1 END) AS fraud_count,
       ROUND(
           COUNT(CASE WHEN fraud_status='Fraud' THEN 1 END)*100.0
           / NULLIF(COUNT(*),0),
       2) AS fraud_percentage
FROM credit_card_fraud_detections
GROUP BY job
HAVING COUNT(*) >= 100   
ORDER BY fraud_percentage DESC, fraud_count DESC
LIMIT 15;

--ZIP-wise Fraud Analysis
SELECT zip,
       COUNT(*) AS total_transactions,
       COUNT(CASE WHEN fraud_status='Fraud' THEN 1 END) AS fraud_count,
       ROUND(COUNT(CASE WHEN fraud_status='Fraud' THEN 1 END)*100.0/NULLIF(COUNT(*),0),2) AS fraud_percentage
FROM credit_card_fraud_detections
GROUP BY zip
HAVING COUNT(*) >= 50  
ORDER BY fraud_percentage DESC
LIMIT 15;

--Top Merchants with Most Fraud Transactions
SELECT merchant,
       COUNT(*) AS total_transactions,
       COUNT(CASE WHEN fraud_status='Fraud' THEN 1 END) AS fraud_count,
       ROUND(COUNT(CASE WHEN fraud_status='Fraud' THEN 1 END)*100.0/NULLIF(COUNT(*),0),2) AS fraud_percentage
FROM credit_card_fraud_detections
GROUP BY merchant
HAVING COUNT(*) >= 50   -- low data वाले merchants हटाने के लिए
ORDER BY fraud_percentage DESC, fraud_count DESC
LIMIT 15;

--Business Impact & ROI
SELECT 
    ROUND(SUM(amt),2) AS total_transaction_value,
    
    ROUND(SUM(CASE WHEN fraud_status='Fraud' THEN amt ELSE 0 END),2) AS total_fraud_loss,
    
    ROUND(SUM(CASE WHEN fraud_status='Fraud' THEN amt ELSE 0 END)*100.0/NULLIF(SUM(amt),0),2) AS fraud_loss_percentage,
    
    ROUND(SUM(CASE WHEN fraud_status='Fraud' THEN amt ELSE 0 END)*0.8,2) AS potential_savings,
    
    ROUND((SUM(CASE WHEN fraud_status='Fraud' THEN amt ELSE 0 END)*0.8 - 500000),2) AS net_profit,
    
    ROUND(((SUM(CASE WHEN fraud_status='Fraud' THEN amt ELSE 0 END)*0.8 - 500000)*100.0/500000),2) AS roi_percentage

FROM credit_card_fraud_detections;

--Top 20 Highest Fraud Transactions
SELECT trans_num,
       trans_date,
       trans_time,
       cc_num,
       merchant,
       category,
       amt,
       city,
       state
FROM credit_card_fraud_detections
WHERE fraud_status='Fraud'
ORDER BY amt DESC
LIMIT 20;
   