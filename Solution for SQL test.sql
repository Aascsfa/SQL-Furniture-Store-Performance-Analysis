

select * from Customer1 c;
select * from Employees1 e;
select * from Orders1 o;
select * from Product p;

-- QUESTION 1:
/* How can you write a SQL query to calculate the total sales of furniture products,
grouped by each quarter of the year, and order the results chronologically? */
# Extra1: Check the column type of ship -> not date 
SHOW COLUMNS FROM orders1 LIKE 'order_date';

# Extra2: Convert to date
-- Ensure the data is in the correct format
UPDATE orders1
SET order_date = STR_TO_DATE(order_date, '%d/%m/%Y')
WHERE order_date IS NOT NULL;
-- Modify the column type to DATE
ALTER TABLE orders1
MODIFY order_date DATE;


-- solution 1
select concat('Q', quarter, '-', year) as Quarter_Year, Total_Sales
from(
	select QUARTER(o.order_date) as quarter, YEAR(o.order_date) as year, sum(sales) as Total_Sales 
	from orders1 o
	inner join Product p on o.product_id = p.id
	where Name = 'Furniture'
	group by YEAR(o.order_date), QUARTER(o.order_date)
	order by YEAR(o.order_date), QUARTER(o.order_date)
	) as op
;

-- solution 2
SELECT 
    CONCAT('Q', quarter_info.Quarter, '-', quarter_info.Year) AS Quarter_Year,
    quarter_info.Total_Sales
FROM (
    SELECT 
        QUARTER(o.order_date) AS Quarter,
        YEAR(o.order_date) AS Year,
        SUM(o.sales) AS Total_Sales
    FROM orders1 o
    INNER JOIN Product p ON o.product_id = p.id
    WHERE p.Name = 'Furniture'
    GROUP BY Year, Quarter
) AS quarter_info
ORDER BY quarter_info.Year, quarter_info.Quarter;


-- QUESTION 2:
/* How can you analyze the impact of different discount levels on sales performance across product categories, 
specifically looking at the number of orders and total profit generated for each discount classification?

Discount level condition:
No Discount = 0
0 < Low Discount < 0.2
0.2 < Medium Discount < 0.5
High Discount > 0.5 */

select category,
	case
		when discount = 0 THEN "No Discount"
		when discount > 0 AND discount < 0.2 THEN "Low Discount"
		when discount >= 0.2 AND discount < 0.5 THEN "Medium Discount"
		when discount >= 0.5 THEN "High Discount"
	End as Discount_Level,
	count(*) as Total_Orders, round(sum(profit),2) as Total_Profit
from orders1 o
inner join product p on o.product_id = p.id
group by category, Discount_Level
order by category, Discount_Level
;



-- QUESTION 3:
/* How can you determine the top-performing product categories within each customer segment based on sales and profit, 
focusing specifically on those categories that rank within the top two for profitability? */


-- Solution
WITH Ranked_Categories AS(
	select c.segment, p.category, sum(o.sales) as Total_Sale, Sum(o.Profit) as Total_Profit, 
	RANK() OVER (PARTITION BY segment ORDER BY SUM(profit) DESC) AS Profit_Rank,
	RANK() OVER (PARTITION BY segment ORDER BY SUM(Sales) DESC) AS Sales_Rank
from orders1 o
inner join product p
on  o.product_id = p.id
inner join customer1 c
on o.customer_id = c.id
group by segment, category
order by SUM(PROFIT) DESC
)


Select segment, category, Sales_Rank,Profit_Rank from Ranked_Categories
Where Profit_Rank <= 2
order by segment
;
select segment, category, sum(sales) as Total_Sale, Sum(Profit) as Total_Profit, 
	RANK() OVER (PARTITION BY segment ORDER BY SUM(profit) DESC) AS Profit_Rank,
	RANK() OVER (PARTITION BY segment ORDER BY SUM(Sales) DESC) AS Sales_Rank
from orders1 o
inner join product p
on  o.product_id = p.id
inner join customer1 c
on o.customer_id = c.id
group by segment, category
order by segment, SUM(PROFIT) DESC
;

-- QUESTION 4
/*
How can you create a report that displays each employee's performance across different product categories, 
showing not only the total profit per category but also what percentage of 
their total profit each category represents, with the results ordered by the 
percentage in descending order for each employee?
*/
WITH employee_performance AS(
	select o.ID_EMPLOYEE, category, sum(profit) as Rounded_Total_Profit
	from 
		orders1 o
	inner join
		employees1 e on o.ID_EMPLOYEE = e.ID_EMPLOYEE
	inner join
		product p on o.product_id = p.id
	group by
		o.ID_EMPLOYEE,category
	order by o.ID_EMPLOYEE
)
,
employee_totalprofit AS(

	select o.id_employee, sum(profit) as Employee_Total_Profit
	from 
		orders1 o
	group by id_employee
	order by id_employee
)
select e.id_employee, category, round(Rounded_Total_Profit,2) as Rounded_Total_Profit, round(Rounded_Total_Profit/Employee_Total_Profit *100,2) as Profit_Percentage 
from employee_performance p
inner join employee_totalprofit e
on p.id_employee = e.id_employee
order by  e.id_employee, profit_percentage DESC
;

-- QUESTION 5:
/*
How can you develop a user-defined function in SQL Server 
to calculate the profitability ratio for each product category an employee has sold, 
and then apply this function to generate a report that 
ranks each employee's product categories by their profitability ratio?
*/


-- Solution 1: using user-defined function
DELIMITER //
CREATE FUNCTION Calculate_Profit_Ratio (profit Decimal, sale Decimal)
RETURNS decimal
DETERMINISTIC
BEGIN
    RETURN profit/sale;
END //
DELIMITER ;

With employee_performance as(
	select o.id_employee, category, round(sum(sales),2) as Total_Sales, round(sum(profit),2) as Total_Profit, 
			Calculate_Profit_Ratio(Total_Profit,Total_Sales) as Profitability_Ratio
    from orders1 o
	inner join employees1 e
	on o.id_employee = e.id_employee
	inner join product p
	on o.product_id = p.id
	group by o.id_employee, category
	order by o.id_employee, category
)

select id_employee, category, Total_Sales, Total_Profit, Profitability_Ratio
from employee_performance
order by id_employee, Profitability_Ratio
;

-- Solution 2: Simple 
With employee_performance as(
	select o.id_employee, category, round(sum(sales),2) as Total_Sales, round(sum(profit),2) as Total_Profit 
    from orders1 o
	inner join employees1 e
	on o.id_employee = e.id_employee
	inner join product p
	on o.product_id = p.id
	group by o.id_employee, category
	order by o.id_employee, category
)

select id_employee, category, Total_Sales, Total_Profit, Round(Total_Profit/Total_Sales,2) as Profitability_Ratio
from employee_performance
order by id_employee, Total_Profit/Total_Sales DESC
;

