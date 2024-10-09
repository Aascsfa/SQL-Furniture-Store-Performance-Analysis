-- ------------------------------------------------------------------------------------------------------------------------
-- Project: Analyzing Sales Performance Drivers and Employee Performance in Furniture Store
-- ------------------------------------------------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------------------------------------------
-- Session 1 - Explore the table and attributes
-- ------------------------------------------------------------------------------------------------------------------------
SHOW TABLES;

-- 1.1 Customer1
DESCRIBE Customer1; -- All text, only Postal_code is INT;
SELECT * FROM Customer1 LIMIT 5;

/* 
													OUTPUT
+------------+------------------+-----------+---------------+------------------+---------------+-------------+--------+
| ID         | NAME             | SEGMENT   | COUNTRY       | CITY             | STATE         | POSTAL_CODE | REGION |
+------------+------------------+-----------+---------------+------------------+---------------+-------------+--------+
| CG-12520   | Claire Gute      | Consumer  | United States | Henderson        | Kentucky      | 42420       | South  |
| DV-13045   | Darrin Van Huff  | Corporate | United States | Los Angeles      | California    | 90036       | West   |
| SO-20335   | Sean O'Donnell   | Consumer  | United States | Fort Lauderdale  | Florida       | 33311       | South  |
| BH-11710   | Brosina Hoffman  | Consumer  | United States | Los Angeles      | California    | 90032       | West   |
| AA-10480   | Andrew Allen     | Consumer  | United States | Concord          | North Carolina| 28027       | South  |
+------------+------------------+-----------+---------------+------------------+---------------+-------------+--------+
The customer1 table holds customer details, focusing on segmentation and geographic location. The SEGMENT column can be 
particularly useful for customer analysis, allowing segmentation of sales and performance. Geographic attributes like 
COUNTRY, CITY, STATE, and REGION can help analyze sales trends by location. */

-- 1.2 Employees1
DESCRIBE Employees1; -- ID_EMPLOYEE is int and the other columns are text.
SELECT * FROM Employees1 LIMIT 5;
/* 
							OUTPUT
+------------+-----------------+---------------+--------+
| ID_EMPLOYEE| NAME            | CITY          | REGION |
+------------+-----------------+---------------+--------+
| 1          | John Doe        | New York      | East   |
| 2          | Jane Smith      | Los Angeles   | West   |
| 3          | Michael Johnson | Chicago       | Central|
| 4          | Emily Davis     | Houston       | South  |
| 5          | David Wilson    | Phoenix       | West   |
+------------+-----------------+---------------+--------+
- The employees1 table contains details about the employees who handle orders and their location (CITY and REGION). 
- This table can be linked with orders1 to analyze employee performance based on sales and profit contributions. */

-- 1.3 Orders1
DESCRIBE Orders1;
SELECT * FROM Orders1 LIMIT 5;
/* 												
												OUTPUT
+---------+----------------+------------+------------+---------------+-------------+----------------+---------+
| ROW_ID  | ORDER_ID       | order_date | ship_date  | SHIP_MODE     | CUSTOMER_ID | PRODUCT_ID     | SALES   |
+---------+----------------+------------+------------+---------------+-------------+----------------+---------+
| 1       | CA-2016-152156 | 2016-11-08 | 2016-11-11 | Second Class  | CG-12520    | FUR-BO-10001798| 261.96  |
| 2       | CA-2016-152156 | 2016-11-08 | 2016-11-11 | Second Class  | CG-12520    | FUR-CH-10000454| 731.94  |
| 3       | CA-2016-138688 | 2016-06-12 | 2016-06-16 | Second Class  | DV-13045    | OFF-LA-10000240| 14.62   |
| 4       | US-2015-108966 | 2015-10-11 | 2015-10-18 | Standard Class| SO-20335    | FUR-TA-10000577| 957.57  |
| 5       | US-2015-108966 | 2015-10-11 | 2015-10-18 | Standard Class| SO-20335    | OFF-ST-10000760| 22.368  |
+---------+----------------+------------+------------+---------------+-------------+----------------+---------+
+----------+----------+------------+------------+
| QUANTITY | DISCOUNT | PROFIT     | ID_EMPLOYEE|
| 2        | 0        | 41.9136    | 7          |
| 3        | 0        | 219.582    | 1          |
| 2        | 0        | 6.8714     | 6          |
| 5        | 0.45     | -383.031   | 8          |
| 2        | 0.2      | 2.5164     | 9          |
+----------+----------+------------+------------+
The orders1 table tracks all orders placed by customers and contains key transactional data. This table can be joined with 
product1 to get product details, customer1 to analyze customer purchasing behavior, and employees1 to evaluate performance. 
*/

-- 1.4 Product
DESCRIBE Product; -- all text
SELECT * FROM Product LIMIT 5;
/* 
													OUTPUT
+--------------------+-----------------+--------------------+------------------------------------------------------------+
| ID                 | product_category| product_subcategory|  product_name                                              |
+--------------------+-----------------+--------------------+------------------------------------------------------------+
| FUR-BO-10001798    | Furniture       | Bookcases          | Bush Somerset Collection Bookcase                          |
| FUR-CH-10000454    | Furniture       | Chairs             | Hon Deluxe Fabric Upholstered Stacking Chairs, Rounded Back|
| OFF-LA-10000240    | Office Supplies | Labels             | Self-Adhesive Address Labels for Typewriters by Universal  |
| FUR-TA-10000577    | Furniture       | Tables             | Bretford CR4500 Series Slim Rectangular Table              |
| OFF-ST-10000760    | Office Supplies | Storage            | Eldon Fold N Roll Cart System                              |
+--------------------+-----------------+--------------------+------------------------------------------------------------+

The product1 table stores details about each product sold by the furniture store. The CATEGORY and SUBCATEGORY fields are 
key to analyzing which product types contribute most to sales and profit. Grouping sales and profit by these fields will
help the business optimize inventory and marketing efforts. */
-- NOTE: Columns Name, Category and subcategory name should be changed. This will be done in session 2.3

-- ------------------------------------------------------------------------------------------------------------------------
-- Section 2: Data Preprocessing
-- ------------------------------------------------------------------------------------------------------------------------

-- 2.1 order_date
-- The column type of order_date is a string, not a DATE type
-- Change the format 
UPDATE orders1
SET order_date = STR_TO_DATE(order_date, '%d/%m/%Y') -- converts the string date format to a proper MySQL DATE format. 
WHERE order_date IS NOT NULL; -- ensure no null 

-- Modify the column type to DATE
ALTER TABLE orders1
MODIFY order_date DATE;

-- 2.2 ship_date
-- Perform similar step on ship_date

UPDATE orders1
SET ship_date = STR_TO_DATE(ship_date, '%d/%m/%Y') -- Converts string date to MySQL DATE format
WHERE ship_date IS NOT NULL; -- Ensures only non-null values are processed

ALTER TABLE orders1
MODIFY ship_date DATE; -- Changes the column type from text to DATE

-- 2.3 Alter table name
-- Name should be renamed to product_category , and category should be renamed to product_name
ALTER TABLE product RENAME COLUMN Name TO product_category;

ALTER TABLE product RENAME COLUMN Category TO product_subcategory;

ALTER TABLE product RENAME COLUMN subcategory TO product_name;


-- ------------------------------------------------------------------------------------------------------------------------
-- Section 3: Function, Store Procedures and Variables
-- ------------------------------------------------------------------------------------------------------------------------
-- Create User Define Function, Store Procedures and Variables  to calculate, format and reuse through out the project 

-- 3.1 Calculate Profit Percentage
-- User just need to input the profit and sale, the function will return the decimal profitability in percentage (no format)
DELIMITER //
CREATE FUNCTION Cal_Profit_Per (profit decimal, sale decimal)
RETURNS DECIMAL (10,2)
DETERMINISTIC
BEGIN
    RETURN (profit / sale) * 100;
END //
DELIMITER ;

-- 3.2 Calculate Profit Percentage with format
/* User just need to input the profit and sale, the function will return the string profitability in percentage (with %), 
Sometimes, this value still need to be used for further analysis, hence should be kept in original format. */ 
DELIMITER //
CREATE FUNCTION Cal_Profit_Per_format (profit decimal, sale decimal)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    RETURN CONCAT(ROUND((profit / sale) * 100,2), "%");
END //
DELIMITER ;


-- 3.3 Calculate Percentage of total
/* User just need to input the one part and total, the function will return the string profitability in percentage (with %). */
DELIMITER //
CREATE FUNCTION Cal_per_format (one_part decimal, total decimal)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    RETURN CONCAT(ROUND((one_part / total) * 100,2), "%");
END //
DELIMITER ;


-- 3.4 Dynamic Report on Sales, Profit, and profit Margin by Product Category
/* Input category name and number of products to display (N), the function will output the top N products by profit and includes
 the profit margin for each product. */ 
DELIMITER //
CREATE PROCEDURE GetTopProductsByProfit(IN category_name VARCHAR(100), IN limit_num INT)
BEGIN
    SELECT p.product_name, p.product_category,
        ROUND(SUM(o.sales), 2) AS Total_Sales,
        ROUND(SUM(o.profit), 2) AS Total_Profit,
        -- Calculate profit margin as (Total_Profit / Total_Sales) * 100
        CASE
            WHEN SUM(o.sales) > 0 THEN ROUND((SUM(o.profit) / SUM(o.sales)) * 100, 2)
            ELSE 0  -- Return 0 or another value when Total_Sales is 0
        END AS Profit_Margin
    FROM orders1 o
    INNER JOIN product p ON o.product_id = p.id
    WHERE p.product_category = category_name
    GROUP BY p.product_name, p.product_category
    ORDER BY Total_Profit DESC
    LIMIT limit_num;
END //
DELIMITER ;

DELIMITER //

-- 3.5 Store Procedures: Get Top Buyers by Sales for a Given Subcategory
/* Input subcategory name and number of products to display (N), the function will output the N top buyers by sales, and includes
 the sales profit, and sale rank of each customer */ 
CREATE PROCEDURE GetTopBuyersBySubcategory(IN subcategory_name VARCHAR(100), IN limit_num INT)
BEGIN
    SELECT 
        c.name AS Customer_Name,
        p.product_subcategory AS Subcategory,
        ROUND(SUM(o.sales), 2) AS Total_Sales,
        ROUND(SUM(o.profit), 2) AS Total_Profit,
        RANK() OVER (ORDER BY SUM(o.sales) DESC) AS Sales_Rank
    FROM orders1 o
    INNER JOIN customer1 c ON o.customer_id = c.id
    INNER JOIN product p ON o.product_id = p.id
    WHERE p.product_subcategory = subcategory_name
    GROUP BY c.name, p.product_subcategory
    ORDER BY Total_Sales DESC
    LIMIT limit_num;
END //

DELIMITER ;

-- 3.6 Store Procedures: Get Customer Information
/*Input customer_Id, the procedures will return the customer ID, name, region, country, last purchase date, total order and sales*/
DELIMITER //

CREATE PROCEDURE GetCustomerDetails(IN Customer_ID VARCHAR(100))
BEGIN
    SELECT 
        c.id AS Customer_ID,          -- Customer ID
        c.name AS Customer_Name,      -- Customer Name
        c.region AS Region,           -- Customer Region
        c.country AS Country,         -- Customer Country
        MAX(o.order_date) AS Last_Purchase_Date, -- Last purchase date
        COUNT(o.order_id) AS Total_Orders,      -- Total number of orders
        ROUND(SUM(o.sales), 2) AS Total_Sales   -- Total sales amount
    FROM customer1 c
    INNER JOIN orders1 o ON c.id = o.customer_id
    WHERE c.id = Customer_ID    -- Input customer name
    GROUP BY c.id, c.name, c.region, c.country;
END //

DELIMITER ;

-- 3.7 Assuming the current date as the last order date. This variable can be changed in the future to get the actual date
SET @get_current_date = (SELECT MAX(order_date) FROM orders1);
SET @get_last_date = (SELECT MAX(order_date) FROM orders1);
SET @get_first_date = (SELECT MIN(order_date) FROM orders1);

-- 3.8 Store Procedures: Procedure for Monthly Sales Report
-- Input the month and year, this procedurewill return the total order, sales and profit for that period
DELIMITER //

CREATE PROCEDURE GetMonthlySalesReport(IN report_month INT, IN report_year INT)
BEGIN
    -- Variable to store the count of rows
    DECLARE row_count INT;

    -- Count the rows that match the given month and year
    SELECT COUNT(*) INTO row_count
    FROM orders1
    WHERE MONTH(order_date) = report_month AND YEAR(order_date) = report_year;

    IF row_count = 0 THEN  -- If no rows found, return a custom message
        SELECT 'Please enter a valid year' AS Warning,
        @get_first_date as Start_date, @get_last_date as End_Date;
    ELSE -- ELSE, if rows are found, return the sales report
        SELECT 
            MONTH(order_date) AS Month, 
            YEAR(order_date) AS Year,
            COUNT(order_id) AS Total_Orders, 
            ROUND(SUM(sales), 2) AS Total_Sales,
            ROUND(SUM(profit), 2) AS Total_Profit
        FROM orders1
        WHERE MONTH(order_date) = report_month AND YEAR(order_date) = report_year
        GROUP BY Month, Year;
    END IF;
END //

DELIMITER ;

-- 3.9 Store Procedures: Get Sales By Location (region, state or city)
/* Choose location type first: region, state or city; then user can choose location name. The procedures then provide 
the sale report by the particular location, including total sale, profit, customers and orders */
DELIMITER //

CREATE PROCEDURE GetSalesByLocation(IN location_type VARCHAR(50), IN location_name VARCHAR(100))
BEGIN
    DECLARE total_rows INT DEFAULT 0;  -- Declare a variable to store the row count
    
    -- Check if the input location_type is valid ('region', 'state', or 'city')
    IF location_type NOT IN ('region', 'state', 'city') THEN
        -- If the location_type is invalid, return an error message
        SELECT 'Please use "region", "state", or "city"' AS Invalid_Location;
    ELSE
        -- Prepare and execute the query to get row count
        SET @count_query = CONCAT(
            'SELECT COUNT(*) INTO @total_rows FROM customer1 WHERE ', location_type, ' = "', location_name, '"');
        
        -- Execute the query to check if rows exist
        PREPARE stmt_check FROM @count_query;-- PREPARE: Compiles the dynamic SQL query stored in @query
        EXECUTE stmt_check; -- EXECUTE: Runs the prepared statement
        DEALLOCATE PREPARE stmt_check; -- DEALLOCATE: Frees resources after executing the query

        -- Check if no rows were returned
        IF @total_rows = 0 THEN
            -- If no rows were returned, display an error message
            SELECT CONCAT('No data found for the specified ', location_type, '.') AS Error_Message,
				   CONCAT("SELECT DISTINCT ", location_type, " FROM customer1;") AS Check_for_valid_location;
        ELSE
            -- If rows were found, execute the query to return the sales and profit
            SET @query = CONCAT(
				'SELECT c.', location_type, ', 
					ROUND(SUM(o.sales), 2) AS Total_Sales, 
					ROUND(SUM(o.profit), 2) AS Total_Profit, 
					COUNT(DISTINCT o.Customer_ID) as Total_Customers,
					COUNT(o.Order_ID) as Total_Orders
                FROM orders1 o 
                INNER JOIN customer1 c ON o.customer_id = c.id 
                WHERE c.', location_type, ' = "', location_name,'"  
                GROUP BY c.', location_type);					-- ensure the location name is wrapped around by ""
            
            PREPARE stmt FROM @query;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
        END IF;
    END IF;
END //

DELIMITER ;


-- ------------------------------------------------------------------------------------------------------------------------
-- Section 4: Sales Trends and Seasonality:
-- ------------------------------------------------------------------------------------------------------------------------

-- 4.1 Trend over year
/* First, let's examine the trend of sales and profit over year to examine the overall performance of the business. Focus 
on the changes over year for both sales and profit*/

-- Step 1: Aggregate yearly sales, profit, and profit margin for each year
WITH Yearly_Sales_Profit AS (
    SELECT 
        YEAR(o.order_date) AS year, 
        ROUND(SUM(o.sales), 2) AS Total_Sales, 
        ROUND(SUM(o.profit), 2) AS Total_Profit,
        Cal_Profit_Per_format(SUM(o.profit), SUM(o.sales)) AS Profit_Margin
    FROM orders1 o
    INNER JOIN product p ON o.product_id = p.id
    GROUP BY YEAR(o.order_date)
    ORDER BY YEAR(o.order_date)
),
-- Step 2: Calculate the lag values (previous year’s sales, profit, and profit margin)
Sales_Profit_With_Lag AS (
    SELECT 
        year, Total_Sales, Total_Profit, Profit_Margin,
        LAG(Total_Sales, 1) OVER (ORDER BY year) AS Previous_Year_Sales,
        LAG(Total_Profit, 1) OVER (ORDER BY year) AS Previous_Year_Profit,
        LAG(Profit_Margin, 1) OVER (ORDER BY year) AS Previous_Year_Profit_Margin
    FROM Yearly_Sales_Profit
)
-- Step 3: Calculate Year-over-Year (YoY) changes and format them as percentages
SELECT 
    year, Total_Sales,
    CASE -- Calculate and format the sales YoY change as a percentage
        WHEN Previous_Year_Sales IS NOT NULL 
        THEN CONCAT(ROUND((Total_Sales / Previous_Year_Sales -1) * 100, 2), '%')
        ELSE 'N/A' 
    END AS Sales_YoY, -- Profit Year-over-Year change
    Total_Profit,
    CASE  -- Calculate and format the profit YoY change as a percentage
        WHEN Previous_Year_Profit IS NOT NULL 
        THEN CONCAT(ROUND((Total_Profit / Previous_Year_Profit-1) * 100, 2), '%')
        ELSE 'N/A'
    END AS Profit_YoY,
    Profit_Margin,
    CASE     -- Calculate and format the profit margin change from the previous year as a percentage
        WHEN Previous_Year_Profit_Margin IS NOT NULL 
        THEN CONCAT(ROUND(((Profit_Margin/Previous_Year_Profit_Margin)-1)*100,  2), '%')
        ELSE 'N/A'
    END AS Profit_Margin_Change
FROM Sales_Profit_With_Lag;

/* 
											OUTPUT
+--------+-------------+-----------+--------------+------------+---------------+---------------------+
| Year   | Total Sales | Sales YoY | Total Profit | Profit YoY | Profit Margin | Profit Margin Change|
+--------+-------------+-----------+--------------+------------+---------------+---------------------+
| 2014   | 484,247.50  | N/A       | 49,543.97    | N/A        | 10.23%        | N/A                 |
| 2015   | 470,532.51  | -2.83%    | 61,618.60    | 24.37%     | 13.10%        | 28.05%              |
| 2016   | 609,205.60  | 29.47%    | 81,795.17    | 32.74%     | 13.43%        | 2.52%               |
| 2017   | 733,215.26  | 20.36%    | 93,439.27    | 14.24%     | 12.74%        | -5.14%              |
+--------+-------------+-----------+--------------+------------+---------------+---------------------+

This table shows the total sales and profit from 2014 to 2017, along with the Year-over-Year (YoY) changes in sales, 
profit, profit margin, and profit margin change.

Over the period of 4 years, the store has significantly grown sales from $484,247 to over $733,215. In 2015, despite 
a slight drop in sales (-2.83%), profit rose by 24.37%, suggesting improvements in operational efficiency or cost management. 
In 2016, both sales and profits experienced strong growth, with sales increasing by 29.47% YoY and profits rising by 32.74%, 
marking this as the business's peak year.

In 2017, sales continued to rise (20.36%), but profit growth slowed to 14.24%, with the profit margin slightly declining 
to 12.74%, which may indicate rising operational costs or increased discount usage.

Based on these yearly trends, I have decided to explore quarterly sales patterns to identify potential seasonal factors 
(see Section 4.2). Additionally, I plan to investigate the factors contributing to the lower profit margins in 2014 and the 
slower profit growth in 2017 (see Section 5, particularly 5.2). */

-- ------------------------------------------------------------------------------------------------------------------------

-- 4.2. Quarter and Year Sales
/* Calculate the total sales of furniture products by quarter and year and order the results chronologically. */

SELECT CONCAT('Q', quarter, '-', year) AS Quarter_Year, Total_Sales, Total_Profit, 
	   Cal_Profit_Per_format(Total_Profit, Total_Sales) as Profit_Margin
FROM (
    SELECT 	# This inner query return the sales of unformated quarter and year
        QUARTER(o.order_date) AS quarter, 
        YEAR(o.order_date) AS year, 
        ROUND(SUM(sales), 2) AS Total_Sales,
		ROUND(SUM(profit), 2) AS Total_Profit
    FROM orders1 o
    INNER JOIN Product p ON o.product_id = p.id
    GROUP BY YEAR(o.order_date), QUARTER(o.order_date)
    ORDER BY YEAR(o.order_date), QUARTER(o.order_date)) AS op;

/* 
                              OUTPUT                            
+--------------+----------------+---------------+---------------+
| Quarter_Year | Total_Sales    | Total_Profit  | Profit_Margin |
+--------------+----------------+---------------+---------------+
| Q1-2014      |  74,447.80     |  3,811.23     |     5.12%     |
| Q2-2014      |  86,538.76     |  11,204.07    |    12.95%     |
| Q3-2014      | 143,633.21     |  12,804.72    |     8.92%     |
| Q4-2014      | 179,627.73     |  21,723.95    |    12.09%     |
| Q1-2015      |  68,851.74     |   9,264.94    |    13.46%     |
| Q2-2015      |  89,124.19     |  12,190.92    |    13.68%     |
| Q3-2015      | 130,259.58     |  16,853.62    |    12.94%     |
| Q4-2015      | 182,297.01     |  23,309.12    |    12.79%     |
| Q1-2016      |  93,237.18     |  11,441.37    |    12.27%     |
| Q2-2016      | 136,082.30     |  16,390.34    |    12.04%     |
| Q3-2016      | 143,787.36     |  15,823.60    |    11.01%     |
| Q4-2016      | 236,098.75     |  38,139.86    |    16.15%     |
| Q1-2017      | 123,144.86     |  23,506.20    |    19.09%     |
| Q2-2017      | 133,764.37     |  15,499.21    |    11.59%     |
| Q3-2017      | 196,251.96     |  26,985.13    |    13.75%     |
| Q4-2017      | 280,054.07     |  27,448.73    |     9.80%     |
+--------------+----------------+---------------+---------------+

Over the period from 2014 to 2017, the quarterly sales show a clear upward trend, with total sales increasing each year. 
There is a noticeable pattern of a significant spike in sales during the fourth quarter (Q4) of each year, indicating strong 
seasonality, likely driven by holiday shopping or end-of-year promotions. In contrast, the first quarter (Q1) consistently 
experiences the lowest sales, suggesting a post-holiday slowdown.

In 2014, profit was notably impacted by the first quarter, where total profit reached only $3,811 (a 5.12% profit margin), 
and the third quarter, with a profit margin of 8.92%. For most quarters, the profit margin averaged between 11% and 13%. 
Interestingly, two consecutive periods saw profitability outperform the average, with profit margins reaching 16.15% in 
Q4-2016, and 19.1% in Q1-2017. These periods warrant further investigation into the sales strategies to achieve such high
 margins (5.2).

The peak sales during Q4-2017 came with significantly low profitability, which is a stark contrast to previous high-sales 
periods.  This anomaly merits a deeper analysis to understand the factors contributing to this low profitability despite 
the high revenue. */

-- ------------------------------------------------------------------------------------------------------------------------

-- 4.3. Monthly Sales
/* In order to study the sales further, I have created a automated report where user can call and input month and year to
return. the report, which contain format the period, total order placed, sales, profit and also the total promotion used. 
Moreover, if the customer enter an invalid date, return a message to notify that the date is invalid, and provide them the
correct period to enter as well. */

-- User just need to enter month, then year to get the report which include 
CALL GetMonthlySalesReport(12,2015);

/*
                           OUTPUT                           
+-------+------+--------------+--------------+--------------+
| Month | Year | Total_Orders | Total_Sales  | Total_Profit |
+-------+------+--------------+--------------+--------------+
|  12   | 2015 |     316      |   74,919.52  |   8,016.97   |
+-------+------+--------------+--------------+--------------+
*/


-- ------------------------------------------------------------------------------------------------------------------------
-- Section 5: Sales and Profit accorss category
-- ------------------------------------------------------------------------------------------------------------------------
/* Let's have a look at the profitability accross product category. */
-- 5.1 Overview of Sales and Profit accorss category
SELECT 
    product_category,
    COUNT(*) AS Total_Orders, 
    ROUND(SUM(sales), 2) AS Total_Sales,
	ROUND(SUM(profit), 2) AS Total_Profit,
    Cal_Profit_Per_format(SUM(profit),SUM(sales)) as Profit_Margin
FROM orders1 o
INNER JOIN product p ON o.product_id = p.id
GROUP BY product_category
ORDER BY product_category;
/*
									   OUTPUT                                                 
+------------------+--------------+--------------+--------------+---------------+
| product_category | Total_Orders | Total_Sales  | Total_Profit | Profit_Margin |
+------------------+--------------+--------------+--------------+---------------+
| Furniture        |     2121     |  741,999.80  |   18,451.27  |    2.49%      |
| Office Supplies  |     6026     |  719,047.03  |  122,490.80  |   17.04%      |
| Technology       |     1847     |  836,154.03  |  145,454.95  |   17.40%      |
+------------------+--------------+--------------+--------------+---------------+

Sales of the three main product categories are approximately $700,000 to $800,000 each. While Furniture contributes 
significantly to sales volume, it lags behind in profitability of 2.5%. In contrast, Technology & Office Supplies are much  
more efficient in converting sales into profits (>17%). Office supply also shows a remarkable order quantity of 6000 orders, 
accounted for 60% of total orders. 

Section 5.2 will take one stepp deeper to investigate the performance of each product_subcategory. */

-- ------------------------------------------------------------------------------------------------------------------------

-- 5.2 Performance review accros product subcategories, ranked by sales and ordered by product_category and profit margin.
SELECT 
    p.product_category, 
    p.product_subcategory,
    COUNT(*) AS Total_Orders, 
    ROUND(SUM(o.sales), 2) AS Total_Sales,
    ROUND(SUM(o.profit), 2) AS Total_Profit,
    Cal_Profit_Per_format(SUM(o.profit), SUM(o.sales)) AS Profit_Margin,
    RANK() OVER (PARTITION BY p.product_category ORDER BY SUM(o.sales) DESC) AS Sales_Rank  
    -- Rank products by total sales within each category
FROM orders1 o
INNER JOIN product p ON o.product_id = p.id
GROUP BY p.product_category, p.product_subcategory
ORDER BY p.product_category, Cal_Profit_Per(SUM(o.profit), SUM(o.sales)) DESC;  -- Order by profit margin
/*
													 OUTPUT                                                 
+------------------+---------------------+--------------+--------------+--------------+---------------+------------+
| product_category | product_subcategory | Total_Orders | Total_Sales  | Total_Profit | Profit_Margin | Sales_Rank |
+------------------+---------------------+--------------+--------------+--------------+---------------+------------+
| Furniture        | Furnishings         |     957      |  91,705.16   |   13,059.14  |     14.24%    |     4      |
| Furniture        | Chairs              |     617      |  328,449.10  |   26,590.17  |     8.10%     |     1      |
| Furniture        | Bookcases           |     228      |  114,880.00  |   -3,472.56  |     -3.02%    |     3      |
| Furniture        | Tables              |     319      |  206,965.53  |  -17,725.48  |     -8.56%    |     2      |
| Office Supplies  | Labels              |     364      |  12,486.31   |    5,546.25  |     44.42%    |     8      |
| Office Supplies  | Paper               |    1370      |  78,479.21   |   34,053.57  |     43.39%    |     4      |
| Office Supplies  | Envelopes           |     254      |  16,476.40   |    6,964.18  |     42.27%    |     7      |
| Office Supplies  | Fasteners           |     217      |   3,024.28   |      949.52  |     31.42%    |     9      |
| Office Supplies  | Art                 |     796      |  27,118.79   |    6,527.79  |     24.07%    |     6      |
| Office Supplies  | Appliances          |     466      | 107,532.16   |   18,138.01  |     16.87%    |     3      |
| Office Supplies  | Binders             |    1523      | 203,412.73   |   30,221.76  |     14.86%    |     2      |
| Office Supplies  | Storage             |     846      | 223,843.61   |   21,278.83  |      9.51%    |     1      |
| Office Supplies  | Supplies            |     190      |  46,673.54   |   -1,189.10  |     -2.55%    |     5      |
| Technology       | Copiers             |      68      | 149,528.03   |   55,617.82  |     37.20%    |     4      |
| Technology       | Accessories         |     775      | 167,380.32   |   41,936.64  |     25.05%    |     3      |
| Technology       | Phones              |     889      | 330,007.05   |   44,515.73  |     13.49%    |     1      |
| Technology       | Machines            |     115      | 189,238.63   |    3,384.76  |      1.79%    |     2      |
+------------------+---------------------+--------------+--------------+--------------+---------------+------------+

Bookcases and Tables are struggling with negative profit margins of -3.02% and -8.56%. These subcategories are incurring 
losses despite significant sales, signaling an urgent need for pricing adjustments or cost control. Moreover, Tables also
contributed 207k in sale.

The Office Supplies and Technology categories are performing well overall:
- Office Supplies (Labels, Paper, Envelopes): These subcategories are driving high profit margins and should be the focal 
point of any promotions or marketing efforts aimed at boosting sales.
- Technology (Copiers, Accessories): These products offer significant profit potential. Promotions in this area can help 
increase high-margin sales while capitalizing on the already strong performance in these categories.           
	- Phones: With a 13.49% profit margin and the highest sales in the Technology category at $330,007.05, Phones represent 
    an  opportunity to push further promotions while maintaining solid profitability.

The next section, 5.3, will examine the contribution of sales and profit of the top 10 products across Tables sub-category. 
*/
 
-- ------------------------------------------------------------------------------------------------------------------------

-- 5.3 Filter top 10 sales across products within the Tables subcategory, rank them and include profit margin
SELECT product_name, Total_Sales, Sales_Rank, Profit_Margin
FROM (
    SELECT 
        p.product_name,
        COUNT(*) AS Total_Orders, 
        ROUND(SUM(o.sales), 2) AS Total_Sales,
        ROUND(SUM(o.profit), 2) AS Total_Profit,
        Cal_Profit_Per_format(SUM(o.profit), SUM(o.sales)) AS Profit_Margin,
        RANK() OVER (ORDER BY SUM(o.sales) DESC) AS Sales_Rank  -- Rank products by total sales within the Tables subcategory
    FROM orders1 o
    INNER JOIN product p ON o.product_id = p.id
    WHERE p.product_subcategory = 'Tables'  -- Filter for the Tables subcategory
    GROUP BY p.product_name
) AS ranked_table
WHERE Sales_Rank <= 10  -- Filter for the top 10 ranked products
ORDER BY Sales_Rank;
/*
											OUTPUT                                                 
+--------------------------------------------------+--------------+------------+---------------+
|                    product_name                  | Total_Sales  | Sales_Rank | Profit_Margin |
+--------------------------------------------------+--------------+------------+---------------+
| Bretford Rectangular Conference Table Tops       |  12,995.29   |     1      |    -2.52%     |
| Chromcraft Bull-Nose Wood Oval Conference Tables |   9,917.64   |     2      |   -29.00%     |
| Bush Advantage Collection Racetrack Conference   |   9,544.72   |     3      |   -20.26%     |
| Chromcraft Round Conference Tables               |   8,209.06   |     4      |    -2.31%     |
| Hon 94000 Series Round Tables                    |   7,404.50   |     5      |    -9.20%     |
| Bretford CR4500 Series Slim Rectangular Table    |   7,242.77   |     6      |    -7.36%     |
| Bevis Oval Conference Table, Walnut              |   6,942.07   |     7      |   -12.33%     |
| Bretford CR8500 Series Meeting Room Furniture    |   6,776.56   |     8      |     6.80%     |
| Balt Solid Wood Round Tables                     |   6,518.75   |     9      |   -18.42%     |
| Hon 5100 Series Wood Tables                      |   5,965.09   |    10      |    -4.01%     |
+--------------------------------------------------+--------------+------------+---------------+

The Tables subcategory within Furniture shows concerning trends, with the majority of products having negative profit 
margins despite generating substantial sales. Among the top 10 products, 9 report negative profit margins, with losses 
reaching as high as -29.00%(top 2). For products with consistently high sales but negative margins, pricing strategies must 
be revisited.

Products with consistently high sales but negative profit margins should have their pricing strategies revisited. Either
raising prices or finding ways to reduce production or operational costs could turn losses into profits.

For products with deeply negative margins (e.g., Chromcraft Bull-Nose Wood Oval Conference Tables at -29.00%), look into 
ways to reduce manufacturing or supply chain costs, or consider phasing out underperforming items if improvements are 
not feasible. */

-- ------------------------------------------------------------------------------------------------------------------------
-- Section 6: Discount levels on sales and profit performance 
-- ------------------------------------------------------------------------------------------------------------------------
/* 6.1 Analyze the impact of different discount levels on sales performance across product categories, specifically looking 
at the number of orders, total sale and total profit generated for each discount classification? 
Discount level condition:
- No Discount = 0
- 0 < Low Discount < 0.2
- 0.2 < Medium Discount < 0.5
- High Discount > 0.5  */

SELECT 
    product_category,
    CASE # This cased create a new column called Discount_Level, with the conditioon based on the discount from 0 to above 0.5
        WHEN DISCOUNT = 0 THEN 'No Discount'
        WHEN DISCOUNT > 0 AND DISCOUNT < 0.2 THEN 'Low Discount (<20%)'
        WHEN DISCOUNT >= 0.2 AND DISCOUNT < 0.5 THEN 'Medium Discount (20% - 50%)'
        WHEN DISCOUNT >= 0.5 THEN 'High Discount (>50%)'
    END AS Discount_Level,
    COUNT(*) AS Total_Orders, 
    ROUND(SUM(sales)) AS Total_Sales,
	ROUND(SUM(profit)) AS Total_Profit,
    Cal_Profit_Per_format(SUM(profit),SUM(sales)) as Profit_Margin
FROM orders1 o
INNER JOIN product p ON o.product_id = p.id
GROUP BY product_category, Discount_Level
ORDER BY product_category,
	FIELD(Discount_Level, 'High Discount (>50%)', 'Medium Discount (20% - 50%)', 'Low Discount (<20%)', 'No Discount');

/*
												OUTPUT                                                 
+------------------+----------------------------+--------------+--------------+--------------+---------------+
| product_category |       Discount_Level       | Total_Orders | Total_Sales  | Total_Profit | Profit_Margin |
+------------------+----------------------------+--------------+--------------+--------------+---------------+
| Furniture        | High Discount (>50%)       |     207      |  30,088.00   |  -22,711.00  |   -75.48%     |
| Furniture        | Medium Discount (20% - 50%)|     950      | 381,694.00   |  -25,501.00  |    -6.68%     |
| Furniture        | Low Discount (<20%)        |     128      |  74,193.00   |    8,530.00  |    11.50%     |
| Furniture        | No Discount                |     836      | 256,025.00   |   58,133.00  |    22.71%     |
| Office Supplies  | High Discount (>50%)       |     680      |  39,523.00   |  -47,140.00  |   -119.27%    |
| Office Supplies  | Medium Discount (20% - 50%)|    2,201     | 233,050.00   |   38,039.00  |    16.32%     |
| Office Supplies  | Low Discount (<20%)        |      16      |   4,324.00   |    1,086.00  |    25.12%     |
| Office Supplies  | No Discount                |    3,129     | 442,150.00   |  130,506.00  |    29.52%     |
| Technology       | High Discount (>50%)       |      35      |  53,537.00   |  -27,215.00  |   -50.83%     |
| Technology       | Medium Discount (20% - 50%)|     977      | 389,473.00   |   39,489.00  |    10.14%     |
| Technology       | Low Discount (<20%)        |       2      |   3,411.00   |      832.00  |    24.39%     |
| Technology       | No Discount                |     833      | 389,733.00   |  132,348.00  |    33.96%     |
+------------------+----------------------------+--------------+--------------+--------------+---------------+

- High discounts are eroding profitability across all categories, especially in Office Supplies and Furniture. These 
discounts should be minimized or only used strategically for clearance sales. The total lost from these three categories 
are over $100k, while we have only made 250k in profit through out these 4 years.
- Medium discounts work well for Office Supplies and Technology, but Furniture still suffers losses of -$25,501, implying 
that discount strategies in the furniture category should be carefully considered.
- For Low Discountm the Furniture categỏy had a positive impact, resulting in an 11.50% profit margin. Both Office Supplies
 and Technology performed well with low discounts, achieving 25.12% and 24.39% profit margins, respectively.
- All three categories performed best with no discounts. The Technology category had the highest profit margin at 33.96%, 
followed by Office Supplies at 29.52%, and Furniture at 22.71%. 

Despite the overall low profitability, Furniture sales with medium discounts ($381k) have attracted more orders and total
sales than the no-discount option ($256k). This suggests that customers are more motivated to purchase furniture when 
offered a discount, even if it slightly impacts the profit margin.

In contrast, for Office Supplies, the total sales without any discount ($440K) are nearly double those with a medium 
discount ($230K) and almost 10 times higher than sales with a high discount. This indicates that high discounts may 
not be necessary for this category. Moreover, as mentioned earlier, the profit margin for high discounts in Office Supplies
stands at a staggering -120%, resulting in a $47K loss.

For Technology, the situation is more balanced. The sales for both no discount and medium discount options are relatively 
close, around $390K. However, sales drop significantly to $54K when a high discount is applied. */

-- ------------------------------------------------------------------------------------------------------------------------

-- 6.2 Categorise the profitability margin, analyse the top 20 products on sale that impact on the loss of the company.
WITH Aggregated_Data AS (
    SELECT 
        p.product_name,
        CASE 
            WHEN o.discount = 0 THEN 'No Discount'
            WHEN o.discount BETWEEN 0 AND 0.2 THEN 'Low Discount'
            WHEN o.discount BETWEEN 0.2 AND 0.5 THEN 'Medium Discount'
            ELSE 'High Discount'
        END AS Discount_Product,
        ROUND(SUM(o.sales), 2) AS Total_Sales,
        ROUND(SUM(o.profit), 2) AS Total_Profit,
        -- Manually handle division by zero by checking if sales is greater than 0
        CASE 
            WHEN SUM(o.sales) > 0 THEN (SUM(o.profit) / SUM(o.sales)) * 100 
            ELSE 0  -- Return 0 or any other appropriate value when sales is 0
        END AS Profit_Margin_Ratio
    FROM orders1 o
    INNER JOIN product p ON o.product_id = p.id
    GROUP BY p.product_name, Discount_Product
)
SELECT 
    product_name, 
    Discount_Product, 
    Total_Sales, 
    Total_Profit,
    CONCAT(ROUND(Profit_Margin_Ratio, 2), '%') AS Profit_Margin,
    CASE 
		WHEN Profit_Margin_Ratio < -200 THEN 'Extreme Negative Profit'
		WHEN Profit_Margin_Ratio < -100 THEN 'Very Strong Negative Profit'
		WHEN Profit_Margin_Ratio < -50 THEN 'Strong Negative Profit'
        WHEN Profit_Margin_Ratio < 0 THEN 'Negative Profit'

    END AS Profit_Margin_Category,
    RANK() OVER (ORDER BY Profit_Margin_Ratio ASC) AS Profit_Rank  -- Ranking across all products
FROM Aggregated_Data
WHERE Total_Profit < 0
ORDER BY Total_Profit ASC
limit 20;

/*
																				OUTPUT                                                 
+------------------------------------------------------------+------------------+--------------+--------------+---------------+-----------------------------+--------------+
|                         product_name                       | Discount_Product | Total_Sales  | Total_Profit | Profit_Margin | Profit_Margin_Category      | Profit_Rank  |
+------------------------------------------------------------+------------------+--------------+--------------+---------------+-----------------------------+--------------+
| Cubify CubeX 3D Printer Double Head Print                  | High Discount    |  6,299.98    |  -9,239.97   |   -146.67%    | Very Strong Negative Profit |     87       |
| GBC DocuBind P400 Electric Binding System                  | High Discount    |  4,899.56    |  -6,859.39   |   -140%       | Very Strong Negative Profit |     99       |
| GBC Ibimaster 500 Manual ProClick Binding System           | High Discount    |  6,696.62    |  -5,098.57   |   -76.14%     | Strong Negative Profit      |    274       |
| GBC DocuBind TL300 Electric Binding System                 | High Discount    |  4,395.25    |  -4,162.03   |   -94.69%     | Strong Negative Profit      |    192       |
| Cubify CubeX 3D Printer Triple Head Print                  | Medium Discount  |  7,999.98    |  -3,839.99   |   -48%        | Negative Profit             |    376       |
| Fellowes PB500 Electric Punch Plastic Comb Binding Machine | High Discount    |  2,287.78    |  -3,431.67   |   -150%       | Very Strong Negative Profit |     83       |
| Lexmark MX611dhe Monochrome Laser Printer                  | High Discount    |  2,549.98    |  -3,399.98   |   -133.33%    | Very Strong Negative Profit |    108       |
| Chromcraft Bull-Nose Wood Oval Conference Tables & Bases   | Medium Discount  |  6,942.35    |  -3,008.35   |   -43.33%     | Negative Profit             |    394       |
| Ibico EPK-21 Electric Binding System                       | High Discount    |  1,889.99    |  -2,929.48   |   -155%       | Very Strong Negative Profit |     78       |
| Bush Advantage Collection Racetrack Conference Table       | Medium Discount  |  6,151.04    |  -2,545.26   |   -41.38%     | Negative Profit             |    401       |
| Riverside Palais Royal Lawyers Bookcase, Royale Cherry     | Medium Discount  |  5,479.70    |  -1,982.21   |   -36.17%     | Negative Profit             |    412       |
| Lexmark MX611dhe Monochrome Laser Printer                  | Medium Discount  | 11,219.93    |  -1,869.99   |   -16.67%     | Negative Profit             |    634       |
| Ibico Hi-Tech Manual Binding System                        | High Discount    |  1,189.46    |  -1,829.94   |   -153.85%    | Very Strong Negative Profit |     82       |
| Cisco TelePresence System EX90 Videoconferencing Unit      | Medium Discount  | 22,638.48    |  -1,811.08   |   -8%         | Negative Profit             |    713       |
| GBC DocuBind 300 Electric Binding Machine                  | High Discount    |  1,946.13    |  -1,609.50   |   -82.70%     | Strong Negative Profit      |    232       |
| Balt Solid Wood Round Tables                               | Medium Discount  |  2,946.83    |  -1,522.53   |   -51.67%     | Strong Negative Profit      |    366       |
| Swingline SM12-08 MicroCut Jam Free Shredder               | High Discount    |  1,529.07    |  -1,507.69   |   -98.60%     | Strong Negative Profit      |    182       |
| Martin Yale Chadless Opener Electric Letter Opener         | Low Discount     |  6,662.48    |  -1,499.06   |   -22.50%     | Negative Profit             |    518       |
| 3.6 Cubic Foot Counter Height Office Refrigerator          | High Discount    |    530.32    |  -1,378.82   |   -260%       | Extreme Negative Profit     |     26       |
| Bevis Oval Conference Table, Walnut                        | Medium Discount  |  3,444.94    |  -1,320.56   |   -38.33%     | Negative Profit             |    410       |
+------------------------------------------------------------+------------------+--------------+--------------+---------------+-----------------------------+--------------+
*/

/* High Discounts Lead to Large Losses: Reevaluate discount strategies for these products. High discounts are clearly not 
working for these items. Either reduce the discount or phase out discounts entirely, focusing instead on increasing sales 
through targeted promotions that do not rely on deep price cuts.

The 3.6 Cubic Foot Counter Height Office Refrigerator stands out with a massive -260% profit margin. This suggests a 
serious pricing issue or disproportionately high costs relative to sales.

Solution: 
- Cost Reduction: Focus on reducing costs, particularly for products that consistently appear with negative margins across 
different discount levels. Evaluate supplier contracts, material costs, and production efficiency for potential savings.
- Bundle High-Loss Items with Profitable Ones: Consider bundling these low-performing products with higher-margin
items to increase overall profitability while keeping the product offerings attractive to customers. */

-- ------------------------------------------------------------------------------------------------------------------------

-- 6.3 Total Discount Used Throughout the Year
SELECT 
    YEAR(o.order_date) AS Year,
    ROUND(SUM(o.sales * o.discount), 2) AS Total_Discount_Amount
FROM orders1 o
INNER JOIN product p ON o.product_id = p.id
GROUP BY YEAR(o.order_date)
ORDER BY Year;

/*
			OUTPUT                                                 
+------+----------------------+
| Year | Total_Discount_Amount|
+------+----------------------+
| 2014 |       77,556.80      |
| 2015 |       62,861.19      |
| 2016 |       80,911.57      |
| 2017 |      101,252.59      |
+------+----------------------+

The analysis of discount usage from 2014 to 2017 shows an increasing reliance on discounts, with the total discount amount 
rising from $77,556.80 in 2014 to $101,252.59 in 2017. This overuse of discounts is directly linked to the reduction in 
profit margins, as evident in the declining profitability despite rising sales. While discounts may have been used to 
stimulate sales, the excessive application, particularly in 2017, suggests that they eroded profits significantly.

To improve profitability, the company should reassess its discount strategies and focus on targeted, lower discount levels 
to maintain healthy profit margins.
*/


-- ------------------------------------------------------------------------------------------------------------------------
-- Section 7: Employee's Performance
-- ------------------------------------------------------------------------------------------------------------------------
-- 7.1 Sales Contribution for each category
/* Create a report that displays each employee's performance across different product categories, showing total sales per 
category, the percentage of their total sales each category represents, and ranking them based on their total sales across 
all employees. */
WITH employee_performance AS (
    SELECT 
        o.ID_EMPLOYEE, 
        p.product_category, 
        SUM(o.sales) AS Rounded_Total_Sales
    FROM orders1 o
    INNER JOIN employees1 e ON o.ID_EMPLOYEE = e.ID_EMPLOYEE
    INNER JOIN product p ON o.product_id = p.id
    GROUP BY o.ID_EMPLOYEE, p.product_category
    ORDER BY o.ID_EMPLOYEE
),
employee_totalsales AS (
    SELECT 
        o.ID_EMPLOYEE, 
        SUM(o.sales) AS Employee_Total_Sales
    FROM orders1 o
    GROUP BY o.ID_EMPLOYEE
    ORDER BY o.ID_EMPLOYEE
)
SELECT 
    e.ID_EMPLOYEE, 
    p.product_category, 
    ROUND(Rounded_Total_Sales, 2) AS Rounded_Total_Sales, 
    CONCAT(ROUND(Rounded_Total_Sales / Employee_Total_Sales * 100, 2), "%") AS Category_Sales_Percentage,
	RANK() OVER (partition by p.product_category ORDER BY Rounded_Total_Sales DESC) AS Sales_Rank

FROM employee_performance p
INNER JOIN employee_totalsales e ON p.ID_EMPLOYEE = e.ID_EMPLOYEE
ORDER BY Sales_Rank;
/*
												OUTPUT                                                 
+---------------+-------------------+--------------------+---------------------------+------------+
| ID_EMPLOYEE   | product_category  | Rounded_Total_Sales| Category_Sales_Percentage | Sales_Rank |
+---------------+-------------------+--------------------+---------------------------+------------+
| 6             | Furniture         |    151,804.02      |        31.87%             |     1      |
| 6             | Office Supplies   |    164,155.82      |        34.46%             |     1      |
| 8             | Technology        |    193,435.95      |        41.47%             |     1      |
| 8             | Furniture         |    135,328.53      |        29.01%             |     2      |
| 8             | Office Supplies   |    137,670.42      |        29.52%             |     2      |
| 6             | Technology        |    160,343.03      |        33.66%             |     2      |
| 9             | Furniture         |    125,022.26      |        35.83%             |     3      |
| 9             | Office Supplies   |     92,887.76      |        26.62%             |     3      |
| 9             | Technology        |    131,039.94      |        37.55%             |     3      |
| 4             | Furniture         |     82,376.43      |        34.94%             |     4      |
| 7             | Office Supplies   |     74,807.29      |        31.38%             |     4      |
| 7             | Technology        |     93,253.65      |        39.12%             |     4      |
| 7             | Furniture         |     70,304.76      |        29.49%             |     5      |
| 4             | Office Supplies   |     71,182.37      |        30.19%             |     5      |
| 4             | Technology        |     82,209.52      |        34.87%             |     5      |
| 5             | Furniture         |     65,448.80      |        32.55%             |     6      |
| 5             | Office Supplies   |     58,500.37      |        29.10%             |     6      |
| 5             | Technology        |     77,103.42      |        38.35%             |     6      |
| 2             | Furniture         |     48,111.98      |        37.18%             |     7      |
| 2             | Office Supplies   |     46,448.42      |        35.89%             |     7      |
| 1             | Technology        |     49,704.44      |        37.79%             |     7      |
| 1             | Furniture         |     41,795.43      |        31.78%             |     8      |
| 1             | Office Supplies   |     40,024.14      |        30.43%             |     8      |
| 2             | Technology        |     34,845.72      |        26.93%             |     8      |
| 3             | Furniture         |     21,807.58      |        31.42%             |     9      |
| 3             | Office Supplies   |     33,370.44      |        48.09%             |     9      |
| 3             | Technology        |     14,218.36      |        20.49%             |     9      |
+---------------+-------------------+--------------------+---------------------------+------------+

- Top Performers (Employee 6, 8, 9): These employees are well-rounded and could be considered for leadership / mentorship
roles within their respective categories. They excel across multiple categories and contribute significantly to overall sales.

- Mid-Level Performers (Employees 4, 7, 5): These employees could benefit from targeted training to improve their performance
in weaker categories. For instance, Employee 4 could work on improving their Technology sales...

- Lower Performers (Employee 1, 2, 3): These employees might need additional support or training in their lower-performing 
categories. For instance, Employee 1 could focus on improving their Furniture and Office Supplies performance, while 
Employee 3 should focus on improving their Technology and Furniture sales. */

-- ------------------------------------------------------------------------------------------------------------------------

-- 7.2 Identify employees that have utilized a lot of coupon or discount codes
SELECT 
    e.ID_EMPLOYEE, 
    e.NAME AS Employee_Name,
    ROUND(SUM(o.Sales), 2) as Total_Sales,
    ROUND(SUM(o.discount * o.Sales), 2) AS Total_Discount_Amount,
    ROUND(AVG(o.discount), 2) AS Average_Discount_Percentage,
    ROUND(SUM(o.discount * o.Sales) / SUM(o.Sales) ,2) AS Discount_Over_Sale,
	COUNT(o.ORDER_ID) AS Total_Orders_With_Discount, 
	(SELECT COUNT(*) FROM orders1 WHERE ID_EMPLOYEE = e.ID_EMPLOYEE) AS Total_Order,
    COUNT(o.ORDER_ID) / (SELECT COUNT(*) FROM orders1 WHERE ID_EMPLOYEE = e.ID_EMPLOYEE) * 100 AS Percentage_Orders_With_Discount
FROM orders1 o
INNER JOIN employees1 e ON o.ID_EMPLOYEE = e.ID_EMPLOYEE
WHERE o.discount > 0 -- Filter for orders with a discount
GROUP BY e.ID_EMPLOYEE, e.NAME
ORDER BY Total_Orders_With_Discount DESC, Total_Discount_Amount DESC;

/*

																						OUTPUT                                                 
+---------------+---------------+--------------+-----------------------+--------------------------+-------------------+--------------------------+---------------+-----------------------------+
| ID_EMPLOYEE   | Employee_Name | Total_Sales  | Total_Discount_Amount | Average_Discount_Percen. | Discount_Over_Sale| Total_Orders_With_Discou.| Total_Order   | Percentage_Orders_With_Disc.|
+---------------+---------------+--------------+-----------------------+--------------------------+-------------------+--------------------------+---------------+-----------------------------+
| 6             | Sarah Miller  | 254,998.54   |     66,842.67         |          0.29            |        0.26       |          1,028           |     1,939     |           53.02%            |
| 8             | Linda Taylor  | 265,983.74   |     81,034.98         |          0.31            |        0.30       |          1,027           |     1,960     |           52.40%            |
| 9             | Robert Anders.| 192,888.47   |     51,061.27         |          0.31            |        0.26       |           751            |     1,416     |           53.04%            |
| 4             | Emily Davis   | 124,029.70   |     32,669.90         |          0.31            |        0.26       |           640            |     1,251     |           51.16%            |
| 7             | James Brown   | 117,484.14   |     28,274.13         |          0.29            |        0.24       |           536            |     1,050     |           51.05%            |
| 5             | David Wilson  |  91,473.09   |     22,936.08         |          0.28            |        0.25       |           432            |       873     |           49.48%            |
| 2             | Jane Smith    |  65,759.24   |     16,782.51         |          0.31            |        0.26       |           347            |       650     |           53.38%            |
| 1             | John Doe      |  66,796.85   |     15,371.31         |          0.30            |        0.23       |           288            |       557     |           51.71%            |
| 3             | Michael Johns.|  29,878.63   |      7,609.30         |          0.32            |        0.25       |           147            |       298     |           49.33%            |
+---------------+---------------+--------------+-----------------------+--------------------------+-------------------+--------------------------+---------------+-----------------------------+

Linda Taylor’s discount-to-sales ratio of 30% is notably higher than that of other employees, who typically range between
23% and 26%. This higher ratio suggests that Linda relies more heavily on discounts to close sales compared to Sarah. While 
both employees generate significant total sales (with Linda slightly ahead at $265,983.74 compared to Sarah’s $254,998.54), 
Linda’s larger portion of sales driven by discounts may suggest that her customers are more sensitive to pricing or that
she frequently uses discounts as a key tactic in closing deals.

Monitor Linda’s discounting strategy to see if it’s necessary or if discounts can be reduced without harming sales, 
improving overall profitability.

For most employees, over half of their sales are tied to discount-driven orders. This reliance suggests that discounts 
are an essential tool in their sales strategy but could potentially affect profitability. */

-- 7.3 Identify employee that have not perform very well during the last quarter
WITH EmployeeSalesByYear AS (
    SELECT 
        e.ID_EMPLOYEE, e.NAME AS Employee_Name, YEAR(o.order_date) AS Year,
        ROUND(SUM(o.Sales), 2) AS Total_Sales
    FROM orders1 o
    INNER JOIN employees1 e ON o.ID_EMPLOYEE = e.ID_EMPLOYEE
    GROUP BY e.ID_EMPLOYEE, e.NAME, YEAR(o.order_date)
    ORDER BY e.ID_EMPLOYEE, YEAR(o.order_date)
),
SalesWithLogTrend AS (
    SELECT 
        ID_EMPLOYEE, Employee_Name, Year,Total_Sales,
        LAG(Total_Sales) OVER (PARTITION BY ID_EMPLOYEE ORDER BY Year) AS Previous_Year_Sales
    FROM EmployeeSalesByYear
)
SELECT 
    ID_EMPLOYEE, Employee_Name, Year, Total_Sales,
    CASE 
        WHEN Previous_Year_Sales IS NOT NULL THEN ROUND(LOG(Total_Sales / Previous_Year_Sales) * 100, 2)
        ELSE NULL 
    END AS YoY -- Year on Year performance
FROM SalesWithLogTrend
ORDER BY ID_EMPLOYEE, Year;

/* 
                           OUTPUT                                                 
+---------------+---------------+------+--------------+-------+
| ID_EMPLOYEE   | Employee_Name | Year | Total_Sales  |  YoY  |
+---------------+---------------+------+--------------+-------+
| 1             | John Doe      | 2014 |   31,332.55  |  NULL |
| 1             | John Doe      | 2015 |   34,190.88  |  8.73 |
| 1             | John Doe      | 2016 |   38,741.54  | 12.50 |
| 1             | John Doe      | 2017 |   27,259.04  | -35.15|
| 2             | Jane Smith    | 2014 |   30,657.20  |  NULL |
| 2             | Jane Smith    | 2015 |   25,891.05  | -16.90|
| 2             | Jane Smith    | 2016 |   28,956.49  | 11.19 |
| 2             | Jane Smith    | 2017 |   43,901.39  | 41.62 |
| 3             | Michael Johns.| 2014 |   15,933.46  |  NULL |
| 3             | Michael Johns.| 2015 |   13,021.36  | -20.18|
| 3             | Michael Johns.| 2016 |   16,024.57  | 20.75 |
| 3             | Michael Johns.| 2017 |   24,417.00  | 42.12 |
| 4             | Emily Davis   | 2014 |   48,501.89  |  NULL |
| 4             | Emily Davis   | 2015 |   55,070.78  | 12.70 |
| 4             | Emily Davis   | 2016 |   55,349.29  |  0.50 |
| 4             | Emily Davis   | 2017 |   76,846.36  | 32.81 |
| 5             | David Wilson  | 2014 |   38,763.71  |  NULL |
| 5             | David Wilson  | 2015 |   41,491.79  |  6.80 |
| 5             | David Wilson  | 2016 |   42,776.75  |  3.05 |
| 5             | David Wilson  | 2017 |   78,020.34  | 60.10 |
| 6             | Sarah Miller  | 2014 |  110,159.37  |  NULL |
| 6             | Sarah Miller  | 2015 |   83,044.96  | -28.25|
| 6             | Sarah Miller  | 2016 |  129,063.25  | 44.09 |
| 6             | Sarah Miller  | 2017 |  154,035.30  | 17.69 |
| 7             | James Brown   | 2014 |   39,846.92  |  NULL |
| 7             | James Brown   | 2015 |   53,819.28  | 30.06 |
| 7             | James Brown   | 2016 |   75,997.39  | 34.51 |
| 7             | James Brown   | 2017 |   68,702.11  | -10.09|
| 8             | Linda Taylor  | 2014 |  105,282.92  |  NULL |
| 8             | Linda Taylor  | 2015 |   96,566.20  | -8.64 |
| 8             | Linda Taylor  | 2016 |  134,730.16  | 33.30 |
| 8             | Linda Taylor  | 2017 |  129,855.63  | -3.69 |
| 9             | Robert Anders.| 2014 |   63,769.48  |  NULL |
| 9             | Robert Anders.| 2015 |   67,436.22  |  5.59 |
| 9             | Robert Anders.| 2016 |   87,566.17  | 26.12 |
| 9             | Robert Anders.| 2017 |  130,178.09  | 39.65 |
+---------------+---------------+------+--------------+-------+

High Growth but Low Total Sales
- Employees like Michael Johnson (2) and Jane Smith( 3) show significant YoY growth in their sales (42.12% and 41.62%, 
respectively in 2017), yet their total sales remain relatively low compared to top performers ($44k and $24k) . 
- Focusing on providing these employees. with additional support, such as training, improved tools, or incentives, could 
help capitalize on their growth potential and elevate their overall contribution.

Consistent Growth with High Total Sales
- Robert Anderson and Sarah Miller both display strong growth trends (39.65% and 17.69% YoY in 2017, respectively) and 
already have substantial total sales figures ($154k and $130k). For these employees, the strategy could involve scaling up 
their. successful tactics  by expanding their reach, allowing them to handle larger accounts, or incentivizing them with 
performance bonuses to drive even higher results.

Negative or Stagnant Trends: Sarah Miller had a significant drop in sales in 2015 (-28.25%), and although she rebounded 
strongly afterward, addressing what caused the initial decline can help prevent future dips.

Area of improvements:
- Total Sales (2017): $27,259.04 and YoY 2017: -35.15%
John Doe experienced a significant decline in 2017, after a solid growth in 2015 and 2016. His total sales are relatively 
low compared to other employees, making this decline even more concerning. To help him recover, it's essential to 
investigate potential external factors, customer engagement issues, or sales strategies that might have contributed to the 
drop. Providing personalized coaching and revisiting his sales targets could help him regain lost ground.

James Brown with Total Sales in 2017 of $68,702.11 (-10.09% Yoy)
After an impressive growth in 2015 and 2016, James Brown saw a notable decrease in 2017. Although his sales figures aren't
as low as John Doe's, a 10% drop is still a concern. James may need support in identifying why his customer base has shrunk
or whether his engagement strategies need updating. */

-- ------------------------------------------------------------------------------------------------------------------------
-- Section 8: Customers 
-- ------------------------------------------------------------------------------------------------------------------------
SELECT COUNT( DISTINCT id) from customer1;
-- 8.1 Identify the top 10 customers who contributed the most to sales for each product category to send out marketing 
-- email, display their rank within the category
WITH Customer_Sales AS (
    SELECT c.name, p.product_category, ROUND(SUM(o.sales),2) AS Total_Purchase,
		RANK() OVER (PARTITION BY p.product_category ORDER BY SUM(o.sales) DESC) AS Purchase_Rank
    FROM orders1 o
    INNER JOIN customer1 c ON o.customer_id = c.id
    INNER JOIN product p ON o.product_id = p.id
    GROUP BY c.name, p.product_category
)
SELECT name, product_category, Total_Purchase, Purchase_Rank
FROM Customer_Sales
WHERE Purchase_Rank <= 10
ORDER BY product_category, Purchase_Rank;

/*
                            OUTPUT
+-------------------+-------------------+----------------+---------------+
| Name              | Product Category  | Total Purchase | Purchase Rank |
+-------------------+-------------------+----------------+---------------+
| Joel Eaton        | Furniture         |    4,422.92    |       1       |
| Joseph Holt       | Furniture         |    4,297.64    |       2       |
| Tamara Willingham | Furniture         |    4,276.42    |       3       |
| Clay Ludtke       | Furniture         |    3,719.98    |       4       |
| Tracy Blumstein   | Furniture         |    3,631.59    |       5       |
| Ted Trevino       | Furniture         |    3,045.82    |       6       |
| Rick Bensley      | Furniture         |    2,985.63    |       7       |
| Pete Kriz         | Furniture         |    2,849.64    |       8       |
| Lena Creighton    | Furniture         |    2,641.16    |       9       |
| Gary Zandusky     | Furniture         |    2,589.29    |      10       |
| Jonathan Doherty  | Office Supplies   |    6,261.33    |       1       |
| Pete Kriz         | Office Supplies   |    5,762.12    |       2       |
| Cassandra Brandow | Office Supplies   |    4,530.07    |       3       |
| Lena Creighton    | Office Supplies   |    3,299.37    |       4       |
| Clay Ludtke       | Office Supplies   |    3,138.17    |       5       |
| Joseph Holt       | Office Supplies   |    2,625.46    |       6       |
| Mary Zewe         | Office Supplies   |    2,450.23    |       7       |
| Ruben Ausman      | Office Supplies   |    2,161.07    |       8       |
| Fred Hopkins      | Office Supplies   |    2,029.89    |       9       |
| Victoria Wilson   | Office Supplies   |    1,982.58    |      10       |
| Becky Martin      | Technology        |    8,382.08    |       1       |
| Karen Daniels     | Technology        |    5,589.53    |       2       |
| Max Jones         | Technology        |    4,633.39    |       3       |
| Jim Kriz          | Technology        |    4,150.97    |       4       |
| Robert Marley     | Technology        |    4,144.84    |       5       |
| Clay Ludtke       | Technology        |    4,022.40    |       6       |
| Erin Smith        | Technology        |    3,372.97    |       7       |
| Fred Hopkins      | Technology        |    3,179.90    |       8       |
| Alan Dominguez    | Technology        |    3,163.91    |       9       |
| Linda Cazamias    | Technology        |    3,068.25    |      10       |
+-------------------+-------------------+----------------+---------------+

To further narrow down the custommer segment for marketing purpose, we can design a procedure to return customer name and
detail of how they contribute toward each sub-category in section 8.2
*/

-- ------------------------------------------------------------------------------------------------------------------------

-- 8.2 Design a store procedure to get the top buyers for each sub-category, which provide the customer name, sub-category
-- chosen, total_sales, total_profit and sales_rank
CALL GetTopBuyersBySubcategory('Chairs', 10);
/*
									OUTPUT
+------------------+--------------+-------------+--------------+------------+
| Customer_Name    | Subcategory  | Total_Sales | Total_Profit | Sales_Rank |
+------------------+--------------+-------------+--------------+------------+
| Joel Eaton       | Chairs       |   4,156.63  |   -333.88    |     1      |
| Clay Ludtke      | Chairs       |   3,416.06  |    686.26    |     2      |
| Ted Trevino      | Chairs       |   2,795.07  |    199.09    |     3      |
| Tamara Willingham| Chairs       |   2,295.06  |     99.77    |     4      |
| Becky Martin     | Chairs       |   1,956.04  |    -27.56    |     5      |
| Justin Ellison   | Chairs       |   1,951.84  |    585.55    |     6      |
| Irene Maddox     | Chairs       |   1,819.86  |    163.79    |     7      |
| Alan Dominguez   | Chairs       |   1,497.71  |    242.62    |     8      |
| Fred Hopkins     | Chairs       |   1,448.82  |    209.27    |     9      |
| Linda Cazamias   | Chairs       |   1,330.03  |    -38.00    |    10      |
+------------------+--------------+-------------+--------------+------------+

Clearly, we can see that Joel Eaton is our top customer in the Chair Sub-category but he is eroding our profit. These type 
of customers are likely using a lot of discount codes or purchasing products with negative profit margins. This suggests 
the need to revisit our pricing and discount strategies for chairs or possibly adjust promotions to ensure we are not 
consistently selling these products at a loss. Additionally, monitoring and limiting high-discount purchases for top 
customers might help protect overall profitability. Identifying similar trends across other subcategories could uncover 
more opportunities for profit optimization.
*/

-- ------------------------------------------------------------------------------------------------------------------------

-- 8.3 Identify Top Buyers by Category that have never use discount code before to send out promotion email.
-- Condition: Only choose the customer who ranked less than 20
WITH Top_Customers AS (
    -- Get the buyers's rank by total sales for each category
    SELECT 
        c.name AS Customer_Name,
        p.product_category AS Category,
        ROUND(SUM(o.sales),2) AS Total_Sales,
        RANK() OVER (PARTITION BY p.product_category ORDER BY SUM(o.sales) DESC) AS Sales_Rank
    FROM orders1 o
    INNER JOIN customer1 c ON o.customer_id = c.id
    INNER JOIN product p ON o.product_id = p.id
    GROUP BY c.name, p.product_category

),
No_Discount_Customers AS (
    -- Identify customers who have never used a discount (all orders have discount = 0)
    SELECT 
        c.name AS Customer_Name,
        p.product_category AS Category,
        ROUND(SUM(o.sales)) AS Total_Sales,
        COUNT(*) AS Total_Orders,
        COUNT(CASE WHEN o.discount = 0 THEN 1 ELSE NULL END) AS No_Discount_Orders
    FROM orders1 o
    INNER JOIN customer1 c ON o.customer_id = c.id
    INNER JOIN product p ON o.product_id = p.id
    GROUP BY c.name, p.product_category
    HAVING COUNT(*) = COUNT(CASE WHEN o.discount = 0 THEN 1 ELSE NULL END)  -- Ensure all orders have discount = 0
)
-- Retrieve the top 20 buyers in each category who have never used a discount.
SELECT t.Customer_Name, t.Category, t.Total_Sales, Sales_Rank
FROM Top_Customers t
INNER JOIN No_Discount_Customers n ON t.Customer_Name = n.Customer_Name AND t.Category = n.Category
WHERE Sales_Rank <= 20
ORDER BY t.Category
;
/*							OUTPUT
+------------------+-----------------+-------------+------------+
| Customer_Name    |    Category     | Total_Sales | Sales_Rank |
+------------------+-----------------+-------------+------------+
| Nora Paige       | Furniture       |   2,195.38  |     15     |
| Fred Hopkins     | Technology      |   3,179.90  |      8     |
| Alan Dominguez   | Technology      |   3,163.91  |      9     |
+------------------+-----------------+-------------+------------+
There are only three customers that have never use discount code before among the top 20 of three categories. Office 
category does not have any presentations.

*/


-- ------------------------------------------------------------------------------------------------------------------------

-- 8.4 Identify Customers with No Purchases in the Last 3 Months, get their name and ID.
SELECT 
	c.ID,
    c.name AS Customer_Name,
    MAX(o.order_date) AS Last_Purchase_Date
FROM orders1 o
INNER JOIN customer1 c ON o.customer_id = c.id
GROUP BY c.ID, c.name
HAVING MAX(o.order_date) < DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
ORDER BY Last_Purchase_Date DESC;

/* 										
						OUTPUT
+---------+-------------------------+------------------+
|   ID    |     Customer_Name       |Last_Purchase_Date|
+---------+-------------------------+------------------+
| PO-18865| Patrick O'Donnell       |    2017-12-30    |
| KB-16600| Ken Brennan             |    2017-12-29    |
| BS-11755| Bruce Stewart           |    2017-12-29    |
| 		  | + 30 more ...	        |      			   |
+---------+-------------------------+------------------+

These customers with no recent purchases in the last 3 months can be targeted for re-engagement campaigns, such as 
offering personalized promotions or discounts to encourage them to return and make new purchases. */

-- ------------------------------------------------------------------------------------------------------------------------

-- 8.5 Design a Store Procedures to return customers details like name, location, and purchase history, requiring only the ID
CALL GetCustomerDetails('PO-18865');
/*
													OUTPUT
+------------+----------------------+---------+---------------+------------------+---------------+-------------+
| Customer_ID|    Customer_Name     |  Region |    Country    | Last_Purchase_Date| Total_Orders | Total_Sales |
+------------+----------------------+---------+---------------+------------------+---------------+-------------+
|  PO-18865  | Patrick O'Donnell    | Central | United States |    2017-12-30     |      13      |   2493.21   |
+------------+----------------------+---------+---------------+------------------+---------------+-------------+

If the email and phone number is provided, we can utilise this store procedures to get their contact and email seemlessly
*/

-- ------------------------------------------------------------------------------------------------------------------------
-- Section 9: Geography impact on Sales and Profitability
-- ------------------------------------------------------------------------------------------------------------------------
-- 9.1 Overall information about the geographic distribution
SELECT distinct country from customer1; -- 1 country: US
SELECT distinct region from customer1; -- 4 regions: North, East, South and West
SELECT distinct state from customer1; --  30 states
SELECT distinct city from customer1; --  63 cities

SELECT distinct country,region, state, city from customer1; -- allow the user to see the relationship between locations

-- ------------------------------------------------------------------------------------------------------------------------

-- 9.2 Sales Performance Analysis based on region
SELECT 
    c.region, 
    ROUND(SUM(o.sales), 2) AS Total_Sales, 
    ROUND(SUM(o.profit), 2) AS Total_Profit, 
    COUNT(DISTINCT o.customer_id) AS Total_Customers,  
    COUNT(o.order_id) AS Total_Orders ,
    Cal_Profit_Per_format(SUM(o.profit), SUM(o.sales)) as Profit_Margin
FROM orders1 o
INNER JOIN customer1 c ON o.customer_id = c.id
GROUP BY c.region;

/* 
										OUTPUT
+---------+--------------+--------------+-----------------+--------------+--------------+
|  Region | Total_Sales  | Total_Profit | Total_Customers | Total_Orders | Profit_Margin|
+---------+--------------+--------------+-----------------+--------------+--------------+
| Central | 113,095.36   |   13,090.94  |       34        |     487      |    11.58%    |
|  East   |  65,904.62   |    6,644.49  |       22        |     328      |    10.08%    |
|  South  |  46,834.20   |    4,523.25  |       12        |     190      |     9.66%    |
|  West   | 101,754.29   |   12,953.76  |       34        |     513      |    12.73%    |
+---------+--------------+--------------+-----------------+--------------+--------------+


The South region stands out as having the lowest customer base (12), but its profit margin is not drastically lower than
the other regions (9.66%). This indicates that while the region may have fewer customers, they might be contributing 
reasonably well to profitability on a per-customer basis. There’s potential to focus efforts on increasing the customer base 
in the South region, as it could yield solid profit growth with relatively modest effort.

The East region's profit margin of 10.08% is close to the other regions but lags in both total sales and customer count. 
Targeting this region with more aggressive marketing or promotional strategies could help elevate its performance without 
significantly impacting profitability. */

-- ------------------------------------------------------------------------------------------------------------------------

-- 9.2 Sales Performance Analysis based on state
SELECT 
    RANK () OVER (ORDER BY Cal_Profit_Per(SUM(o.profit), SUM(o.sales)) DESC ) as Profit_Margin_Rank,
    c.region, c.state,
    ROUND(SUM(o.sales), 2) AS Total_Sales, 
    ROUND(SUM(o.profit), 2) AS Total_Profit, 
    COUNT(DISTINCT o.customer_id) AS Total_Customers,  
    COUNT(o.order_id) AS Total_Orders ,
    Cal_Profit_Per_format(SUM(o.profit), SUM(o.sales)) as Profit_Margin
FROM orders1 o
INNER JOIN customer1 c ON o.customer_id = c.id
GROUP BY c.region, c.state;

/* 
Louisiana (South) ranks highest with a 31.83% profit margin, though its total sales are relatively modest. 
	- This suggests high operational efficiency with strong profitability, despite fewer orders.

California (West) has the highest total sales at $56,500.06 but a comparatively lower profit margin of 14.23%. 
	- While this still reflects solid performance, there may be opportunities to improve margins.

Michigan (Central), Ohio (East), Colorado (West), and Alabama (South) all have negative profit margins, meaning they are 
currently operating at a loss. These states require immediate attention to understand and resolve the causes of their poor 
financial performance. Additionally, operational reviews can be performned to identify inefficiencies and areas to reduce costs.

States like Louisiana and Wisconsin show high profit margins (> 20%), signaling efficient operations. Scaling operations in 
these states could yield higher returns. 

By studying the operational strategies, employee performance, and customer behavior in Louisiana (~ 32%), the company can
uncover key factors that drive higher profitability. These insights can then be used to develop best practices that could be 
scaled to other states, improving overall performance across the business. */

-- ------------------------------------------------------------------------------------------------------------------------

-- 9.3 Sales Performance Analysis based on city
SELECT 
    RANK () OVER (ORDER BY Cal_Profit_Per(SUM(o.profit), SUM(o.sales)) DESC ) AS Profit_Margin_Rank,
    c.region, c.state, c.city,  -- Include city in the SELECT clause
    ROUND(SUM(o.sales), 2) AS Total_Sales, 
    ROUND(SUM(o.profit), 2) AS Total_Profit, 
    COUNT(DISTINCT o.customer_id) AS Total_Customers,  
    COUNT(o.order_id) AS Total_Orders,
    Cal_Profit_Per_format(SUM(o.profit), SUM(o.sales)) AS Profit_Margin
FROM orders1 o
INNER JOIN customer1 c ON o.customer_id = c.id
GROUP BY c.region, c.state, c.city  -- Group by city along with state and region
ORDER BY Profit_Margin_Rank;

/* 
								OUTPUT
+--------------------+--------+-------------+--------------+--------------+-----------------+--------------+--------------+
| Profit_Margin_Rank | Region |    State    | Total_Sales  | Total_Profit | Total_Customers | Total_Orders | Profit_Margin|
+--------------------+--------+-------------+--------------+--------------+-----------------+--------------+--------------+
|         1          | South  |  Louisiana  |   5,979.10   |   1,902.54   |        1        |      11      |    31.83%    |
|         2          | Central|  Wisconsin  |  11,344.18   |   2,827.92   |        2        |      32      |    24.93%    |
|        						 				+28 more rows...													      |
+--------------------+--------+-------------+--------------+--------------+-----------------+--------------+--------------+

Scale Operations in High-Profit Cities: Focus on cities with high profitability like Monroe (31.83%), Decatur (31.33%), and 
Orland Park (31.00%) in the Central region are showing high profit margins. ith optimized costs and higher profitability, 
expanding services and inventory in these locations could further boost revenue and profits.

Cost Efficiency in Major Cities: Cities like Houston and New York City show strong sales but need operational adjustments 
to improve profit margins (~20%). These large markets offer broad customer bases, but potential cost inefficiencies or high
competition  could be impacting the margins.

Underperforming Cities with Negative Margins: Some major cities like San Antonio (-14.08%), Columbus (-12.24%), 
Phoenix (-10.46%), and Fort Lauderdale (-3.11%) are showing negative profit margins, despite decent sales figures. 
This suggests that these cities are incurring losses, likely due to high operating costs or inefficient sales strategies.
	- Review and Optimize Operations in underperforming cities. Consider reducing costs, adjusting pricing strategies, or 
	evaluating the local market competition to turn these losses into profits. 
	- Explore targeted promotions to attract more customers and boost sales without further eroding profit margins.*/

-- ------------------------------------------------------------------------------------------------------------------------

-- 9.4 Sales Performance Report on Location type
/* Write a store procedures, where user can input: 
- 1. Location type: region, state or city
- 2. Location name
The report will include total_sales, total_profit, total customers and total order placed within that location.
Moreover, handle all the user input error from location type to location name and instruct the user to use correct inputs.
*/

Call GetSalesByLocation('region','South');
/*								OUTPUT
+--------+--------------+--------------+----------------+---------------+
| Region | Total_Sales  | Total_Profit | Total_Customers | Total_Orders |
+--------+--------------+--------------+----------------+---------------+
| South  |  46,834.20   |   4,523.25   |      12        |     190       |
+--------+--------------+--------------+----------------+---------------+
*/
Call GetSalesByLocation('state','Texas');
/*
								OUTPUT
+-------+--------------+--------------+----------------+---------------+
| State | Total_Sales  | Total_Profit | Total_Customers | Total_Orders |
+-------+--------------+--------------+----------------+---------------+
| Texas |  38,359.22   |   3,846.63   |      12        |     164       |
+-------+--------------+--------------+----------------+---------------+
*/
Call GetSalesByLocation('city','Fort Lauderdale');
/*
								OUTPUT
+-------------------+--------------+--------------+-----------------+--------------+
|       City        | Total_Sales  | Total_Profit | Total_Customers | Total_Orders |
+-------------------+--------------+--------------+-----------------+--------------+
| Fort Lauderdale   |   2,602.58   |    -81.09    |       1         |      15      |
+-------------------+--------------+--------------+-----------------+--------------+
*/

-- ------------------------------------------------------------------------------------------------------------------------
-- Section 10: Conclusion
-- ------------------------------------------------------------------------------------------------------------------------
-- Conclusion
/*
The comprehensive analysis of the furniture and office supplies store's sales data has revealed significant insights into 
the drivers of profitability and areas for improvement. While high sales volumes are observed in certain product categories 
and regions, profitability is not always aligned due to factors such as excessive discounting and operational inefficiencies.

The Furniture category, despite strong sales, suffers from low or negative profit margins in subcategories like Tables and 
Bookcases. This indicates a pressing need to reevaluate pricing strategies and implement cost management measures. 
Additionally, the overuse of high discounts, particularly in the Office Supplies category, is eroding profit margins across 
the board. Adopting a more strategic approach to discounting can help maintain profit without sacrificing sales volume.

Geographical analysis shows that regions like California and Michigan, although generating substantial sales, have lower 
profit margins due to higher operational costs or inefficiencies. In contrast, cities like Monroe and Orland Park demonstrate 
high profit margins despite lower sales volumes, suggesting efficient operations and potential areas for growth.

Employee performance also plays a crucial role in overall profitability. Mid-level employees (Employees 4, 5, and 7) exhibit 
potential for increased performance with targeted training and development. Leveraging top-performing employees to mentor
others can further enhance sales and operational efficiency across the team.

By addressing these issues through targeted strategies—such as optimizing pricing, refining discount policies, improving 
operational efficiency, and investing in employee development—the company can significantly enhance its overall business 
performance. Focusing on these areas will not only improve profit margins but also contribute to sustainable growth and a 
stronger competitive position in the market.
*/



