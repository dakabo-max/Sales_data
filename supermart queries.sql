
-- 1. Display the first 5 rows from the dataset.
SELECT 
    *
FROM
    supermarket
LIMIT 5;

-- 2. Display the last 5 rows from the dataset.
SELECT 
    *
FROM
    supermarket
ORDER BY 'Invoice ID' DESC
LIMIT 5;


-- 3. Display random 5 rows from the dataset.
SELECT 
    *
FROM
    supermarket
ORDER BY RAND()
LIMIT 5;

-- 4. Display count, min, max, avg, and std values for a column in the dataset.
SELECT 
COUNT(gross_income),
MIN(gross_income),
MAX(gross_income),
AVG(gross_income),
STD(gross_income)
FROM supermarket;


-- 5. Find the number of missing values.
SELECT 
    COUNT(*)
FROM
    supermarket
WHERE
    Branch IS NULL;

-- 6. Count the number of occurrences of each city.
SELECT 
    City, COUNT(City)
FROM
    supermarket
GROUP BY City;

-- 7. Find the most frequently used payment method.
SELECT 
    Payment, COUNT(Payment) AS CONT
FROM
    supermarket
GROUP BY Payment
ORDER BY CONT DESC;

-- 8. Does The Cost of Goods Sold Affect The Ratings That The Customers Provide? 
SELECT 
    Rating, cogs
FROM
    supermarket;
-- Copy the outcome and paste in excel then use a scatter plot to visualize it.

-- 9. Find the most profitable branch as per gross income.
SELECT 
    Branch, ROUND(SUM(gross_income), 2) AS gross_inc
FROM
    supermarket
GROUP BY Branch
ORDER BY gross_inc DESC;

SELECT gross_income 
FROM supermarket;

-- 10.  Find the most used payment method city-wise.
SELECT 
    *
FROM
    supermarket;
SELECT 
    City, Payment, COUNT(Payment) AS CONT
FROM
    supermarket
GROUP BY City , Payment
ORDER BY city;

-- 11. Find the product line purchased in the highest quantity.
SELECT 
    Product_line, SUM(Quantity)
FROM
    supermarket
GROUP BY Product_line
ORDER BY Product_line DESC;


-- 12. Display the daily sales by day of the week.
SELECT DAYNAME(date), DAYOFWEEK(date), ROUND(SUM(Total),2)
FROM supermarket
GROUP BY DAYNAME(date), DAYOFWEEK(date);



-- 13. Find the month with the highest sales.
SELECT 
    MONTHNAME(date), ROUND(SUM(Total), 2) AS total
FROM
    supermarket
GROUP BY MONTHNAME(date)
ORDER BY total DESC;


-- 14. Find the time at which sales are highest.


SELECT 
    HOUR(time), ROUND(SUM(Total), 2) AS total
FROM
    supermarket
GROUP BY HOUR(time)
ORDER BY total DESC;



-- 15. Which gender spends more on average?
SELECT 
    Gender, AVG(Total)
FROM
    supermarket
GROUP BY Gender;