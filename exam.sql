-- 1. Grouping users by city and state and use COUNT function.

SELECT
	customer_city,
	customer_state,
	COUNT(*) AS [City_count]
FROM dbo.customers
GROUP BY customer_city, customer_state
ORDER BY COUNT(*) DESC;

-- 2. Grouping orders by day.

SELECT
	CAST(order_purchase_timestamp as date) AS [Days],
	COUNT(*) AS [Count]
FROM dbo.orders
GROUP BY cast(order_purchase_timestamp as date)
ORDER BY COUNT(*) DESC;

-- 3. Most popular product categories.

-- 3.1 Spanish name product category

SELECT
	p.product_category_name,
	COUNT(*) AS [Category_count]
FROM dbo.products AS p
INNER JOIN dbo.order_items AS oi ON p.product_id = oi.product_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
ORDER BY Category_count DESC;

-- 3.2 English name product category

SELECT
	t.product_category_name_english,
	COUNT(*) AS [Category_count]
FROM dbo.products AS p
INNER JOIN dbo.order_items AS oi ON p.product_id = oi.product_id
INNER JOIN dbo.product_category_name_translation AS t ON p.product_category_name = t.product_category_name 
WHERE p.product_category_name IS NOT NULL
GROUP BY t.product_category_name_english
ORDER BY Category_count DESC;

-- 4. How days is between delivered customer date and estimated delivery date

SELECT
	DATEPART(YEAR, order_purchase_timestamp) AS [order_year],
	DATEPART(MONTH, order_purchase_timestamp) AS [order_month],
	AVG(DATEDIFF(DAY, order_estimated_delivery_date, order_delivered_customer_date)) AS [date diff]
FROM dbo.orders 
WHERE order_status = 'delivered' AND order_delivered_customer_date != ''
GROUP BY DATEPART(YEAR, order_purchase_timestamp),
		 DATEPART(MONTH, order_purchase_timestamp)
ORDER BY order_year ASC, order_month ASC;

-- 5. What are the top 10 best-selling products by category?

SELECT TOP 10
	pc.product_category_name_english,
	COUNT(*) AS [Count product in Category]
FROM dbo.product_category_name_translation AS pc
LEFT JOIN dbo.products AS p ON pc.product_category_name_english = p.product_category_name
GROUP BY pc.product_category_name_english
ORDER BY [Count product in Category] DESC;

-- 6. How many users are there in a given state?

SELECT
	g.geolocation_state,
	c.customer_city,
	COUNT(g.geolocation_state) AS [Customers in a state]
FROM dbo.geolocation AS g
LEFT JOIN dbo.customers AS c ON g.geolocation_zip_code_prefix = c.customer_zip_code_prefix
GROUP BY g.geolocation_state, c.customer_city
ORDER BY COUNT(g.geolocation_state) DESC;
