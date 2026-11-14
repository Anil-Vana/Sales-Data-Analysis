
USE sales_analysis;

-- ============================================================
-- 01. Overall Business KPIs
-- ============================================================
SELECT
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    COUNT(DISTINCT `Customer ID`) AS Total_Customers,
    ROUND(SUM(Sales) / NULLIF(COUNT(DISTINCT `Order ID`), 0), 2) AS Average_Order_Value,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS Profit_Margin_Percentage
FROM sales;


-- ============================================================
-- 02. Sales and Profit by Category
-- ============================================================
SELECT
    Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS Profit_Margin
FROM sales
GROUP BY Category
ORDER BY Total_Sales DESC;


-- ============================================================
-- 03. Sales by Sub-Category
-- ============================================================
SELECT
    `Sub-Category`,
    Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity
FROM sales
GROUP BY `Sub-Category`, Category
ORDER BY Total_Sales DESC;


-- ============================================================
-- 04. Sales and Profit by Customer Segment
-- ============================================================
SELECT
    Segment,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    COUNT(DISTINCT `Customer ID`) AS Total_Customers,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS Profit_Margin
FROM sales
GROUP BY Segment
ORDER BY Total_Sales DESC;


-- ============================================================
-- 05. Sales and Profit by Region
-- ============================================================
SELECT
    Region,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    COUNT(DISTINCT `Customer ID`) AS Total_Customers,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS Profit_Margin
FROM sales
GROUP BY Region
ORDER BY Total_Sales DESC;


-- ============================================================
-- 06. Yearly Sales and Profit
-- ============================================================
SELECT
    `Order Year`,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity,
    COUNT(DISTINCT `Order ID`) AS Total_Orders
FROM sales
GROUP BY `Order Year`
ORDER BY `Order Year`;


-- ============================================================
-- 07. Year-over-Year Sales and Profit Growth
-- ============================================================
WITH yearly_sales AS (
    SELECT
        `Order Year` AS Year,
        SUM(Sales) AS Total_Sales,
        SUM(Profit) AS Total_Profit
    FROM sales
    GROUP BY `Order Year`
),
yearly_growth AS (
    SELECT
        Year,
        Total_Sales,
        Total_Profit,
        LAG(Total_Sales) OVER (ORDER BY Year) AS Previous_Year_Sales,
        LAG(Total_Profit) OVER (ORDER BY Year) AS Previous_Year_Profit
    FROM yearly_sales
)
SELECT
    Year,
    Total_Sales,
    Total_Profit,
    ROUND(
        (Total_Sales - Previous_Year_Sales)
        / NULLIF(Previous_Year_Sales, 0) * 100,
        2
    ) AS Sales_Growth_Percentage,
    ROUND(
        (Total_Profit - Previous_Year_Profit)
        / NULLIF(Previous_Year_Profit, 0) * 100,
        2
    ) AS Profit_Growth_Percentage
FROM yearly_growth
ORDER BY Year;


-- ============================================================
-- 08. Top 10 Customers by Sales
-- ============================================================
SELECT
    `Customer ID`,
    `Customer Name`,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    COUNT(DISTINCT `Order ID`) AS Total_Orders
FROM sales
GROUP BY `Customer ID`, `Customer Name`
ORDER BY Total_Sales DESC
LIMIT 10;


-- ============================================================
-- 09. Top 10 Products by Sales
-- ============================================================
SELECT
    `Product ID`,
    `Product Name`,
    Category,
    `Sub-Category`,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity
FROM sales
GROUP BY
    `Product ID`,
    `Product Name`,
    Category,
    `Sub-Category`
ORDER BY Total_Sales DESC
LIMIT 10;


-- ============================================================
-- 10. Top 10 Products by Quantity Sold
-- ============================================================
SELECT
    `Product ID`,
    `Product Name`,
    Category,
    `Sub-Category`,
    SUM(Quantity) AS Total_Quantity,
    SUM(Sales) AS Total_Sales
FROM sales
GROUP BY
    `Product ID`,
    `Product Name`,
    Category,
    `Sub-Category`
ORDER BY Total_Quantity DESC
LIMIT 10;


-- ============================================================
-- 11. Top 10 Most Profitable Products
-- ============================================================
SELECT
    `Product ID`,
    `Product Name`,
    Category,
    `Sub-Category`,
    SUM(Profit) AS Total_Profit,
    SUM(Sales) AS Total_Sales,
    SUM(Quantity) AS Total_Quantity
FROM sales
GROUP BY
    `Product ID`,
    `Product Name`,
    Category,
    `Sub-Category`
ORDER BY Total_Profit DESC
LIMIT 10;


-- ============================================================
-- 12. Top 10 Loss-Making Products
-- ============================================================
SELECT
    `Product ID`,
    `Product Name`,
    Category,
    `Sub-Category`,
    SUM(Profit) AS Total_Profit,
    SUM(Sales) AS Total_Sales,
    SUM(Quantity) AS Total_Quantity
FROM sales
GROUP BY
    `Product ID`,
    `Product Name`,
    Category,
    `Sub-Category`
HAVING SUM(Profit) < 0
ORDER BY Total_Profit ASC
LIMIT 10;


-- ============================================================
-- 13. Monthly Sales and Profit Trend
-- ============================================================
SELECT
    `Order Year`,
    `Order Month`,
    `Order Month Name`,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity
FROM sales
GROUP BY
    `Order Year`,
    `Order Month`,
    `Order Month Name`
ORDER BY
    `Order Year`,
    `Order Month`;


-- ============================================================
-- 14. Shipping Performance Analysis
-- ============================================================
SELECT
    `Shipping Performance`,
    COUNT(*) AS Total_Records,
    AVG(`Shipping Duration`) AS Average_Shipping_Days,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM sales
GROUP BY `Shipping Performance`
ORDER BY Total_Records DESC;


-- ============================================================
-- 15. Discount Analysis
-- ============================================================
SELECT
    Discount,
    COUNT(*) AS Total_Records,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    AVG(Profit) AS Average_Profit
FROM sales
GROUP BY Discount
ORDER BY Discount;


-- ============================================================
-- 16. Profit Margin by Category and Sub-Category
-- ============================================================
SELECT
    Category,
    `Sub-Category`,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS Profit_Margin_Percentage
FROM sales
GROUP BY Category, `Sub-Category`
ORDER BY Profit_Margin_Percentage DESC;


-- ============================================================
-- 17. Average Order Value and Margin by Segment
-- ============================================================
SELECT
    Segment,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    ROUND(SUM(Sales) / NULLIF(COUNT(DISTINCT `Order ID`), 0), 2) AS Average_Order_Value,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS Profit_Margin_Percentage
FROM sales
GROUP BY Segment
ORDER BY Profit_Margin_Percentage DESC;


-- ============================================================
-- 18. Region Sales and Profit Contribution
-- ============================================================
WITH overall_totals AS (
    SELECT
        SUM(Sales) AS Overall_Sales,
        SUM(Profit) AS Overall_Profit
    FROM sales
)
SELECT
    s.Region,
    SUM(s.Sales) AS Total_Sales,
    SUM(s.Profit) AS Total_Profit,
    ROUND(SUM(s.Sales) / NULLIF(o.Overall_Sales, 0) * 100, 2)
        AS Sales_Contribution_Percentage,
    ROUND(SUM(s.Profit) / NULLIF(o.Overall_Profit, 0) * 100, 2)
        AS Profit_Contribution_Percentage
FROM sales AS s
CROSS JOIN overall_totals AS o
GROUP BY s.Region, o.Overall_Sales, o.Overall_Profit
ORDER BY Total_Sales DESC;


-- ============================================================
-- 19. Top 10 States/Provinces by Sales
-- ============================================================
SELECT
    `State/Province`,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS Profit_Margin_Percentage
FROM sales
GROUP BY `State/Province`
ORDER BY Total_Sales DESC
LIMIT 10;


-- ============================================================
-- 20. Top 10 Cities by Sales
-- ============================================================
SELECT
    City,
    `State/Province`,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    COUNT(DISTINCT `Order ID`) AS Total_Orders
FROM sales
GROUP BY City, `State/Province`
ORDER BY Total_Sales DESC
LIMIT 10;


-- ============================================================
-- 21. Top 10 Customers by Number of Orders
-- ============================================================
SELECT
    `Customer ID`,
    `Customer Name`,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM sales
GROUP BY `Customer ID`, `Customer Name`
ORDER BY Total_Orders DESC
LIMIT 10;


-- ============================================================
-- 22. Yearly Sales and Profit by Category
-- ============================================================
SELECT
    `Order Year`,
    Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS Profit_Margin_Percentage
FROM sales
GROUP BY `Order Year`, Category
ORDER BY `Order Year`, Total_Sales DESC;


-- ============================================================
-- 23. Yearly Sales and Profit by Customer Segment
-- ============================================================
SELECT
    `Order Year`,
    Segment,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS Profit_Margin_Percentage
FROM sales
GROUP BY `Order Year`, Segment
ORDER BY `Order Year`, Total_Sales DESC;


-- ============================================================
-- 24. Yearly Sales and Profit by Region
-- ============================================================
SELECT
    `Order Year`,
    Region,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS Profit_Margin_Percentage
FROM sales
GROUP BY `Order Year`, Region
ORDER BY `Order Year`, Total_Sales DESC;
