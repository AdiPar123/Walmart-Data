-- Create table
CREATE TABLE IF NOT EXISTS WSALES(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT,
    gross_income DECIMAL(12, 4),
    rating FLOAT
);

SELECT*FROM WSALES;

-- Add the time_of_day column
SELECT time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM WSALES;

ALTER TABLE WSALES ADD COLUMN time_of_day VARCHAR(20);
UPDATE WSALES
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

SELECT
	date,
	DAYNAME(date)
FROM WSALES;

ALTER TABLE WSALES ADD COLUMN day_name VARCHAR(10);

UPDATE WSALES
SET day_name = DAYNAME(date);

-- Add month_name column
SELECT
	date,
	MONTHNAME(date)
FROM WSALES;

ALTER TABLE WSALES ADD COLUMN month_name VARCHAR(10);

UPDATE WSALES
SET month_name = MONTHNAME(date);
-- How many unique cities does the data have?
SELECT 
	DISTINCT city
FROM WSALES;

-- In which city is each branch?
SELECT 
	DISTINCT city,
    branch
FROM WSALES;

-- How many unique product lines does the data have?
SELECT
	COUNT(DISTINCT product_line)
FROM WSALES;

-- Most common payment method?

SELECT payment, COUNT(payment) as cnt
FROM WSALES
GROUP BY payment
ORDER BY cnt DESC;

-- Most selling product_line ?
SELECT product_line, COUNT(product_line) as cnt
FROM WSALES
GROUP BY product_line
ORDER BY cnt DESC;

-- Total revenue by month ?
SELECT month_name AS month,
SUM(total) AS total_revenue
FROM WSALES
GROUP BY month_name
ORDER BY total_revenue DESC;

-- What month had largest COGS ?
SELECT month_name AS month, SUM(cogs) AS cogs
FROM WSALES
GROUP BY month_name
ORDER BY cogs DESC;

-- What product line had the largest revenue?

SELECT product_line, SUM(total) AS revenue
FROM WSALES
GROUP BY product_line
ORDER BY revenue DESC;

-- What is the city with the largest revenue?
SELECT branch,city, SUM(total) AS total_revenue
FROM WSALES
GROUP BY city, branch 
ORDER BY total_revenue;

-- What product line had the largest VAT?
SELECT product_line, AVG(tax_pct) as avg_tax
FROM WSALES
GROUP BY product_line
ORDER BY avg_tax DESC;

-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales
SELECT AVG(quantity) AS avg_qnty
FROM WSALES;

SELECT product_line,
CASE 
WHEN AVG(quantity) > 6 THEN "Good"
ELSE "Bad"
END AS remark
FROM WSALES
GROUP BY product_line;

-- Which branch sold more products than average product sold?

SELECT branch, SUM(quantity) AS qnty
FROM WSALES
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM WSALES);

-- What is the most common product line by gender?
SELECT product_line, gender,
COUNT(gender) AS total_cnt
FROM WSALES
GROUP BY product_line, gender
ORDER BY total_cnt;

-- What is the average rating of each product line
SELECT ROUND(AVG(rating),2) AS avg_rating, product_line
FROM WSALES
GROUP BY product_line
ORDER BY avg_rating DESC;

-- How many unique customer types does the data have?
SELECT
DISTINCT customer_type
FROM WSALES;

-- How many unique payment methods does the data have?
SELECT
DISTINCT payment
FROM WSALES;

-- What is the most common customer type?
SELECT customer_type, count(*) as count
FROM WSALES
GROUP BY customer_type
ORDER BY count DESC;

-- Which customer type buys the most?
SELECT customer_type,
COUNT(*)
FROM WSALES
GROUP BY customer_type;

-- What is the gender of most of the customers?
SELECT gender,
COUNT(*) as gender_cnt
FROM WSALES
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?
SELECT gender, branch,
COUNT(*) as gender_cnt
FROM WSALES
GROUP BY branch, gender
ORDER BY gender_cnt, gender ;

-- Which time of the day do customers give most ratings?
SELECT time_of_day, AVG(rating) AS avg_rating
FROM WSALES
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which day fo the week has the best avg ratings?
SELECT day_name,
AVG(rating) AS avg_rating
FROM WSALES
GROUP BY day_name 
ORDER BY avg_rating DESC;

-- Which day of the week has the best average ratings per branch?
SELECT day_name,
COUNT(day_name) total_sales
FROM WSALES
WHERE branch = "B"
GROUP BY day_name
ORDER BY total_sales DESC;

-- Number of sales made in each time of the day per weekday 
SELECT time_of_day,
COUNT(*) AS total_sales
FROM WSALES
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;

-- Which of the customer types brings the most revenue?
SELECT customer_type,
SUM(total) AS total_revenue
FROM WSALES
GROUP BY customer_type
ORDER BY total_revenue;

-- Which customer type pays the most in VAT?
SELECT customer_type,
AVG(tax_pct) AS total_tax
FROM WSALES
GROUP BY customer_type
ORDER BY total_tax;
