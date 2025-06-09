-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

DESCRIBE retail_sales;

SELECT*
FROM retail_sales;

-- 1. cleaning and exploring the retail_sails data base

-- checking how many rows in the table have null values
-- transaction_id because since it is primary key it can't be null

DELETE
FROM retail_sales
WHERE transaction_id = null; 

SELECT*
FROM retail_sales
WHERE customer_id = null;
-- there is no row with null customer_id, so we can analyze all customer behavior

-- checking for duplicates/IF there exist we are going to delete it
SELECT*,count(transaction_id) as duplicates
FROM retail_sales
GROUP BY transaction_id
Having duplicates > 1;



SELECT*
FROM retail_sales
WHERE price_per_unit = null;
-- there is no row with null price_per unit, so we can calculate the total_sales for all rows

-- rather than checking by using single query for every column let us use single query

SELECT COUNT(*) AS rows_with_nulls
FROM retail_sales
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;
-- from this we get the insight that every rows doesn't have null values

-- standardizing categorical values

SELECT DISTINCT category FROM retail_sales;
SELECT DISTINCT gender FROM retail_sales;

-- BOTH ARE IN STANDARD FROM SOO WE NEED TO DO ANY STANDARDATIONS

SELECT*
FROM retail_sales;

-- After cleaning the table we need to create another clean table it is recommended
CREATE TABLE sales_clean AS
SELECT * FROM retail_sales;

-- TOTAL NUMBER OF TRANSACTION
SELECT count(*)
FROM sales_clean;
-- What is the total sales revenue?
SELECT SUM(total_sale) AS total_revenue
FROM sales_clean;
-- What is the average profit per transaction?
SELECT 
  SUM(total_sale - cogs) AS total_profit,
  SUM(total_sale - cogs) / COUNT(transaction_id) AS avg_profit_per_transaction
FROM sales_clean;

-- How many customers are male vs female, and what’s their total spending?

SELECT gender, COUNT(DISTINCT customer_id) 
AS distinct_customers, SUM(total_sale) AS total_spending
FROM sales_clean
GROUP BY gender;

-- Which product category has the highest total units sold?

SELECT*
FROM sales_clean;
-- Which product category has the highest total units sold?

SELECT category ,sum(quantity) As total_sold_units
FROM sales_clean
GROUP BY category
ORDER BY total_sold_units
LIMIT 1;


-- Which product category brings in the most revenue?
SELECT category ,sum(total_sale) As total_revenue
FROM sales_clean
GROUP BY category
ORDER BY total_revenue
LIMIT 1;

-- Which product has the highest profit margin?

SELECT category , ((sum(total_sale)-sum(cogs))/sum(total_sale))*100 
AS Profit_Margin
FROM sales_clean
GROUP BY category
ORDER BY Profit_Margin
LIMIT 1;

-- At what hour of the day are most sales made?

SELECT hour(sale_time) as sale_hour , 
count(*) as total_transaction
FROM sales_clean
GROUP BY sale_hour
ORDER BY total_transaction DESC;

-- On which day of the week is revenue the highest?

SELECT month(sale_date) AS day_of_the_month, sum(total_sale) as total_revenue
FROM sales_clean
GROUP BY day_of_the_month
ORDER BY total_revenue DESC;

-- How does total revenue change over time (daily, weekly, or monthly)?

SELECT 
  sale_date,
  SUM(total_sale) AS total_revenue
FROM sales_clean
GROUP BY sale_date
ORDER BY total_revenue;

-- weekly revenue trend

SELECT WEEK(sale_date) AS weeks ,YEAR(sale_date) AS years, SUM(total_sale) AS total_revenue
FROM sales_clean
GROUP BY years, weeks
ORDER BY total_revenue DESC;

 -- monthly revnue trend
SELECT month(sale_date) AS months ,YEAR(sale_date) AS years, SUM(total_sale) AS total_revenue
FROM sales_clean
GROUP BY years, months
ORDER BY total_revenue DESC;

-- ANALYSING CUSTOMER_BEHAVIOR
    -- What is the age distribution of customers?
SELECT AGE, count(customer_id) AS  customer_by_same_age
FROM sales_clean
GROUP BY age
ORDER BY age;
      -- the above query gave us customers with the same age but let us make it customers with the same age group
      -- Which customer age group generates the most revenue?
      
      SELECT 
  CASE
    WHEN age BETWEEN 18 AND 25 THEN '18-25'
    WHEN age BETWEEN 26 AND 35 THEN '26-35'
    WHEN age BETWEEN 36 AND 45 THEN '36-45'
    WHEN age BETWEEN 46 AND 60 THEN '46-60'
    ELSE '60+'
  END AS age_group, sum(total_sale) as revenue_by_group ,
  COUNT(customer_id) AS customer_count
FROM sales_clean
GROUP BY age_group
ORDER BY age_group, revenue_by_group DESC ;

-- Do male or female customers spend more on average?
SELECT gender, count(*) AS total_transactions,
SUM(total_sale) AS total_sale,AVG(total_sale) AS revenue_total
FROM sales_clean
GROUP BY gender
ORDER BY revenue_total DESC;






      































  








   
