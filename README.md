# Analyzing Sales Performance Drivers and Employee Performance in Furniture Store

## Abstract
This project presents a comprehensive analysis of sales performance and employee contributions in a furniture and office supplies store. By leveraging data from customers, employees, orders, and products over four years, we identified key factors affecting profitability, including product category performance, discount strategies, employee effectiveness,  customer behavior, and geographical trends. The insights derived inform strategic recommendations aimed at optimizing pricing, enhancing product offerings, refining discount policies, improving employee performance, and targeting high-potential markets to boost overall profitability and sustain growth.

## Executive Summary
The analysis revealed that while the Furniture category drives significant sales, it suffers from low profit margins, necessitating pricing strategy revisions. High discounts are eroding profitability across categories, especially in Office Supplies. Employee performance varies, with opportunities to uplift mid-level performers through targeted training. Customer analysis highlights re-engagement opportunities and potential for loyalty programs. Geographical insights suggest scaling operations in high-profit areas like Monroe, while optimizing costs in high-sales but low-profit regions like California. Implementing the recommended strategies is expected to enhance overall profitability & competitive positioning.


## Project Outline
Sections 1 to 3 establish the foundation for the analysis by first examining the database's structure and content. **Section 1** delves into the tables, columns, and data types, exploring how the Customer1, Employees1, Orders1, and Product tables interrelate, which is crucial for understanding the data's context. **Section 2** focuses on data preprocessing, performing essential tasks like converting date strings to proper DATE formats and renaming columns for consistency,  ensuring the dataset is clean and reliable for analysis. **Section 3** introduces user-defined functions and stored procedures to facilitate calculations and automate repetitive tasks, enhancing efficiency and reusability throughout the project. 

Together, these sections prepare the groundwork for the in-depth data analysis conducted in Sections 4 to 9, which investigates areas for sales improvement, leading up to the conclusions presented in Section 10.

## Key Findings (Section 5-9)

### Section 4: Sales Trends and Seasonality
- Over the four-year period, the company demonstrated a consistent upward trajectory in sales, with significant spikes in 
the fourth quarter (Q4) each year, indicating strong seasonality likely driven by holiday demand and year-end promotions. 
- Conversely, the first quarter (Q1) consistently registered the lowest sales, suggesting a post-holiday slowdown. This 
pattern underscores an opportunity to develop strategies to mitigate slower sales in Q1, such as targeted marketing 
campaigns or new product launches, while capitalizing on the high-demand period in Q4 through optimized inventory management 
and promotional efforts. 
- Additionally, the slowdown in profit growth and slight decrease in profit margins in 2017, despite rising sales, point 
to potential increases in costs or discounting practices, highlighting the need for a closer examination of cost management 
and pricing strategies.

### Section 5: Product Category Performance
- Furniture accounts for a significant portion of sales (33%) but suffers from a low profit margin of 2.5%, with
subcategories like Tables and Bookcases experiencing negative profit margins of -8.56% and -3.02%, respectively.
- Office Supplies and Technology categories demonstrate strong profitability, converting over 17% of sales into profit. 
Subcategories such as Labels, Paper, and Copiers are particularly lucrative.

### Section 6: Impact of Discount Strategies
- High discounts (>50%) across all categories lead to substantial losses, eroding overall profitability by over $100,000
in four years. Products sold without discounts consistently achieve the highest profit margins. For instance, the Technology
category realizes a 33.96% profit margin with no discounts.
- An over-reliance on discounts was identified among certain employees, notably Linda Taylor, whose discount-to-sales ratio
is 30%, exceeding the typical range and indicating a potential area for margin improvement.

### Section 7: Employee Performance Insights
- Top Performers: Employees like Sarah Miller and Robert Anderson not only generate high sales volumes but also maintain 
strong year-over-year growth (17.69% and 39.65% in 2017, respectively).
- Growth Opportunities: Employees such as Michael Johnson and Jane Smith exhibit significant YoY sales growth (42.12% and
41.62% in 2017) but have lower total sales, suggesting potential for development through targeted training and support.
- Areas of Concern: Declines in performance were noted for John Doe and James Brown, with YoY sales decreases of -35.15%
and -10.09% in 2017, respectively, highlighting the need for performance reviews and strategic interventions.

### Section 8: Customer Behavior and Opportunities
- Identified top customers by product category and subcategory, enabling targeted marketing campaigns to boost sales of 
high-margin products.
- Customers that did not purchase in the last three months present re-engagement opportunities through personalized promotions.
- A segment of customers who have never utilized discounts offers a potential to introduce value-added services or loyalty 
programs to enhance retention and increase spend.

### Section 9: Geographical Sales and Profitability Analysis:
- High-Profit Regions: States like Louisiana and cities like Monroe exhibit high profit margins (31.83%), indicating efficient 
operations and potential for scaling. 
- Underperforming Areas: Major markets such as California show high sales volumes ($56,500.06) but lower profit margins (14.23%), 
suggesting the need for cost optimization and efficiency improvements.
- Loss-Making Regions: Certain states and cities, including Michigan, Ohio, and Phoenix, are operating at a loss, necessitating 
immediate strategic reviews to address profitability challenges.

