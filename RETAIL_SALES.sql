-- SQL Retail Sales Analysis - project 

-- CREATE TABLE 
CREATE TABLE retail_sales 
	(
		transactions_id INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,
		customer_id INT,
		gender VARCHAR(15),
		age INT,
		category VARCHAR(50),
		quantiy INT,
		price_per_unit FLOAT,
		cogs FLOAT,
		total_sale FLOAT
	);

SELECT * FROM retail_sales;

-- count records

SELECT COUNT(*) FROM retail_sales;

SELECT * FROM retail_sales 
WHERE transactions_id is null;


SELECT * FROM retail_sales
Where sale_date is null;

SELECT * FROM retail_sales
Where sale_time is null;

SELECT * FROM retail_sales
WHERE transactions_id is null
	OR
	sale_date is null
	OR
	sale_time is null
	OR
	customer_id is null
	OR
	gender is null
	OR
	age is null
	OR
	category is null
	OR
	quantiy is null
	OR
	price_per_unit is null
	OR
	cogs is null
	OR
	total_sale is null;

-- DELETE NULL VALUES
DELETE FROM retail_sales
WHERE transactions_id is null
	OR
	sale_date is null
	OR
	sale_time is null
	OR
	customer_id is null
	OR
	gender is null
	OR
	age is null
	OR
	category is null
	OR
	quantiy is null
	OR
	price_per_unit is null
	OR
	cogs is null
	OR
	total_sale is null;

-- DATA EXPLORATION 

-- HOW MANY SALES WE HAVE?
SELECT COUNT(*) as total_sales FROM retail_sales;

-- HOW MANY CUSTOMERS WE HAVE?

SELECT COUNT(DISTINCT customer_id) as total_sales FROM retail_sales;

-- HOW MANY CATEGORIES WE HAVE?

SELECT DISTINCT category FROM retail_sales;

-- DATA ANALYSIS & BUSINESS KEY PROBLEMS & ANSWERS.

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT * FROM retail_sales 
WHERE sale_date = '2022-11-05';
 

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022

SELECT * FROM retail_sales 
WHERE category = 'Clothing' and
quantiy >=4 and 
to_char(sale_date,'yyyy-mm') = '2022-11';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category,sum(total_sale) as total_sales,count(*) as total_orders from retail_sales
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT ROUND(AVG(age),2) as average_age from retail_sales
where category ='Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * from retail_sales
 where total_sale >1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT  category,gender, COUNT(transactions_id) as total_number_of_transactions from retail_sales
group by category, gender
order by category ;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT * FROM
(
SELECT 
	extract(year from sale_date) as year,
	extract(month from sale_date) as month,
	avg(total_sale) as avg_sales,
	RANK()OVER(PARTITION BY EXTRACT(YEAR FROM sale_date)ORDER BY AVG(total_sale) DESC) AS Ranking
	from retail_sales
	group by 1, 2
	) AS T1
	WHERE RANKING =1
	order by 1,3 desc;
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT customer_id,sum(total_sale) as total_sales FROM retail_sales
group by customer_id
order by total_sales desc limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT category,
count(customer_id) as unq_cus FROM retail_sales
group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sales
as(
SELECT * ,
CASE 
	WHEN EXTRACT(Hour from sale_time)<12 THEN 'MORNING'
	WHEN EXTRACT(Hour from sale_time) between 12 and 17 THEN 'Afternoon'
	ELSE 'Evening'
END AS SHIFT
FROM retail_sales
)
SELECT shift, count(*) as total_orders FROM hourly_sales
GROUP BY Shift;

-- END OF PROJECT

