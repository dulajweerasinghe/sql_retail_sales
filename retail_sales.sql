-- SQL Retail Sales Analysis - Project 01 --

create database sql_project_01;


-- Create Table --
DROP TABLE IF EXISTS retail_sales;
create table retail_sales (
	transactions_id INT PRIMARY KEY,
	sale_date DATE,	
	sale_time TIME,	
	customer_id INT,	
	gender VARCHAR(15),
	age INT,	
	category VARCHAR(20),
	quantiy INT,
	price_per_unit FLOAT,	
	cogs FLOAT,	
	total_sale FLOAT
	);
	
select *
from retail_sales
limit 10;

-- Data Cleaning --
-- count --
select count(*)
from retail_sales;

-- Finding Null Data --
select *
from retail_sales
where transactions_id IS NULL
	
select *
from retail_sales
where sale_date IS NULL;
		
select *
from retail_sales
where sale_time IS NULL;	
	
select *
from retail_sales
where customer_id IS NULL;	

-- Finding Null with one line --

select *
from retail_sales
where 
	transactions_id IS NULL
	or
	sale_date IS NULL
	or
	sale_time IS NULL
	or
	customer_id IS NULL
	or
	gender IS NULL
	or
	category IS NULL
	or
	quantiy IS NULL
	or
	price_per_unit IS NULL
	or
	cogs IS NULL
	or
	total_sale IS NULL;
	
-- Delete Null ROWS --
-- Data Cleaning --
DELETE FROM retail_sales
where 
	transactions_id IS NULL
	or
	sale_date IS NULL
	or
	sale_time IS NULL
	or
	customer_id IS NULL
	or
	gender IS NULL
	or
	category IS NULL
	or
	quantiy IS NULL
	or
	price_per_unit IS NULL
	or
	cogs IS NULL
	or
	total_sale IS NULL;
	
-- Get the Count --

select count(*)
from retail_sales;

-- Data Exploration --

-- How Many sales do we have? --

select count(*) as total_sale
FROM retail_sales;

-- How Many Unique customers do we have --

select count(DISTINCT customer_id) as total_sale
FROM retail_sales;

-- How Many Category do we have --

select DISTINCT category
FROM retail_sales;

-- Business Key Problems & Answers -- 
	
-- 01. Write a SQL query to retrieve all columns for sales made on '2022-11-05:

select *
from retail_sales
where sale_date = '2022-11-05';

-- 02. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

-- Step 01
select category, sum(quantiy)
FROM retail_sales
where category = 'Clothing'
group by 1;

-- Step 02
select *
FROM retail_sales
where category = 'Clothing'
	and TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';

-- Step 03
select *
FROM retail_sales
where category = 'Clothing'
	and TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	and quantiy >= 4;


-- 03. Write a SQL query to calculate the total sales (total_sale) for each category.:

select category,
		sum(total_sale) as net_sale,
		count(*) as  total_orders
from retail_sales
Group by 1;

-- 04. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

-- Step 01
select *
from retail_sales
where category ='Beauty';

-- Step 02

select ROUND(AVG(age),2) as avg_age
from retail_sales
where category = 'Beauty';

-- 05. Write a SQL query to find all transactions where the total_sale is greater than 1000.:

select *
from retail_sales
where total_sale > 1000;

-- 06. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

-- Step 01

select category,
	   gender,
	   count(*) as total_transactions
From retail_sales
Group by 1, 2
order by 1;

-- 07. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

-- Step 01
select 
	EXTRACT (YEAR FROM sale_date) as year,
	Extract (MONTH FROM sale_date) as month,
	AVG(total_sale) as avg_sale
FROM retail_sales 
Group by 1,2
ORDER BY 1,3 DESC;

-- Step 02
SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    AVG(total_sale) AS avg_sale,
    RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales 
GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
-- ORDER BY year, month;

-- Step 03
-- MAKE A SUB TABLE & FInd rank = 1;

SELECT  *
FROM (
SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    AVG(total_sale) AS avg_sale,
    RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales 
GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
) as t1
where rank = 1

-- Step 04

SELECT 
	year,
	month,
	avg_sale,
	rank
FROM (
SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    AVG(total_sale) AS avg_sale,
    RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales 
GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
) as t1
where rank = 1

-- 08. Write a SQL query to find the top 5 customers based on the highest total sales: 

select *
From retail_sales;

-- Step 01

SELECT 
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- 09. Write a SQL query to find the number of unique customers who purchased items from each category.:

SELECT 
	category,
    COUNT(DISTINCT customer_id) as cnt_unique_customer
    
FROM retail_sales
GROUP BY 1;

-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

select *
From retail_sales;

-- step 01

select *,
	Case
		WHEN EXTRACT (HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 and 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales;

-- Step 02
with hourly_sale
as (
select *,
	Case
		WHEN EXTRACT (HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 and 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
) 
SELECT
	shift,
	COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift;


---- END OF THE PROJECT --- 





	
	
	