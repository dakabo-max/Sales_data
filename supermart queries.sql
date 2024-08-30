-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

-- Data cleaning
SELECT
	*
FROM sales;


-- Add the time_of_day column
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;


ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

-- For this to work turn off safe mode for update
-- Edit > Preferences > SQL Edito > scroll down and toggle safe mode
-- Reconnect to MySQL: Query > Reconnect to server
UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);


-- Add day_name column
SELECT
	date,
	DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);


-- Add month_name column
SELECT
	date,
	MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

# Answering Data related question
## Product

--  How many unique product lines does the data have?
SELECT 
     COUNT(DISTINCT product_line) AS count
FROM sales;

--  What is the most common payment method?
SELECT
    payment, 
    COUNT(payment) AS count
FROM sales
GROUP BY payment
ORDER BY count DESC;

-- What is the most selling product line?
SELECT 
	product_line, 
	COUNT(quantity) AS count 
FROM sales
GROUP BY product_line
ORDER BY count DESC;

-- What is the total revenue by month?
SELECT 
   month_name, 
   SUM(total) AS total_revenue 
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- What month had the largest COGS?
SELECT 
   month_name, 
   SUM(cogs) sum_cogs
FROM sales
GROUP BY month_name
ORDER BY sum_cogs DESC;

-- What product line had the largest revenue?
SELECT 
   product_line, 
   ROUND(SUM(total),2) AS total_revenue 
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- What is the city with the largest revenue?
SELECT 
   city, 
   ROUND(SUM(total),2) AS total_revenue 
FROM sales
GROUP BY city
ORDER BY total_revenue DESC;

-- What product line had the largest VAT?
SELECT 
   product_line, 
   ROUND(AVG(tax_pct),2) AS vat
FROM sales
GROUP BY product_line
ORDER BY vat DESC;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT 
   product_line, 
CASE
    WHEN (unit_price * quantity) > (unit_price * quantity) THEN 'GOOD'
    ELSE 'BAD'
END AS category
FROM sales
GROUP BY product_line, category;

-- Which branch sold more products than average product sold?
SELECT 
   branch, 
   SUM(quantity) AS sum_quantity
FROM sales
GROUP BY branch
HAVING SUM(quantity) >  AVG(quantity);

-- What is the most common product line by gender?
SELECT 
   gender, 
   product_line,
   COUNT(gender)
FROM sales
GROUP BY gender, product_line
ORDER BY product_line DESC;

-- What is the average rating of each product line?
SELECT 
   product_line, 
   ROUND(AVG(rating),2) 
FROM sales
GROUP BY product_line;


## Sales

-- Number of sales made in each time of the day per weekday
SELECT 
   time_of_day, 
   day_name,
   COUNT(total) AS count
FROM sales
GROUP BY time_of_day, day_name
ORDER BY day_name;

-- Which of the customer types brings the most revenue?
SELECT 
	customer_type, 
    ROUND(SUM(total),2) AS revenue
FROM sales
GROUP BY customer_type
ORDER BY revenue DESC;

-- Which city has the largest tax percent/ VAT (**Value Added Tax**)?
SELECT 
   city, 
   ROUND(AVG(tax_pct), 2) AS vat
FROM SALES
GROUP BY city
ORDER BY vat DESC;

-- Which customer type pays the most in VAT?
SELECT 
   customer_type, 
   ROUND(SUM(tax_pct),2) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax DESC;


-- Display the first 5 rows from the dataset.
SELECT * 
FROM sales
LIMIT 5;

-- Display the last 5 rows from the dataset.
SELECT * 
FROM sales
ORDER BY invoice_id DESC
LIMIT 5;

-- Display random 5 rows from the dataset.
SELECT * 
FROM sales
ORDER BY  RAND()
LIMIT 5;

-- Display count, min, max, avg, and std values for a column in the dataset.
SELECT 
   ROUND(COUNT(total),2) AS total_count, 
   ROUND(MIN(total),2) AS min_total, 
   ROUND(MAX(total),2) AS max_total, 
   ROUND(AVG(total),2) AS avg_total, 
   ROUND(STD(total),2) AS std_total 
FROM sales;

-- Find the number of missing values.
SELECT 
   COUNT(*) AS missing_values
FROM sales
WHERE Branch IS NULL;

-- Count the number of occurrences of each city.
SELECT 
   city, 
   COUNT(*) 
FROM sales
GROUP BY city;


-- Does The Cost of Goods Sold Affect The Ratings That The Customers Provide? 
SELECT * FROM sales;

SELECT 
   cogs, 
   rating  
FROM sales;
-- Copy the outcome and paste in excel then use a scatter plot to visualize it.

-- Find the most profitable branch as per gross income.
SELECT 
   branch, 
   ROUND(SUM(gross_income),2) AS income
FROM sales
GROUP BY branch
ORDER BY income DESC;

--   Find the most used payment method city-wise.
SELECT 
   city, 
   payment,
   COUNT(payment)
FROM sales
GROUP BY city, payment
ORDER BY payment DESC;

-- Find the product line purchased in the highest quantity.
SELECT 
   product_line, 
   SUM(quantity) AS quantity
FROM sales
GROUP BY product_line;


-- Display the daily sales by day of the week.
SELECT 
   day_name, 
   ROUND(SUM(total),2) AS sales
FROM sales
GROUP BY day_name
ORDER BY sales DESC;

-- Find the month with the highest sales.
SELECT 
   month_name, 
   ROUND(SUM(total),2) AS sales
FROM sales
GROUP BY month_name
ORDER BY sales DESC;


-- Find the time at which sales are highest.
SELECT 
   time AS time_per_hr, 
   ROUND(SUM(total),2) AS total_sales
FROM sales
GROUP BY time_per_hr
ORDER BY total_sales DESC;

-- Which gender spends more on average?
SELECT 
   gender, 
   ROUND(AVG(total),2) AS avg_sales
FROM sales
GROUP BY gender
ORDER BY avg_sales DESC;



