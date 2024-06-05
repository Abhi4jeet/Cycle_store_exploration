-- total orders 

SELECT COUNT(order_id) AS Orders
FROM orders;

-- total customers
SELECT COUNT(customer_id) AS 'Total Customers'
FROM customers;

-- total items sold

SELECT SUM(quantity) AS 'Items Sold'
FROM order_items;

-- store wise sales

SELECT sale.store_id,stores.store_name,sale.Sales,sale.Revenue
FROM stores
JOIN
(SELECT 
orders.store_id, SUM(order_items.quantity) AS Sales,
ROUND(SUM((quantity*list_price)-discount),2) AS Revenue
FROM orders 
JOIN order_items
ON orders.order_id = order_items.order_id
GROUP BY 1) AS sale
ON stores.store_id = sale.store_id
ORDER BY sale.Revenue DESC;

-- total revenue

SELECT ROUND(SUM((quantity*list_price)-discount),2) AS Revenue
FROM order_items;

-- top 50 customer by revenue

SELECT 
CONCAT(first_name, ' ',last_name) AS 'Name',
sale.Revenue
FROM customers
JOIN
(SELECT 
orders.customer_id, SUM(order_items.quantity) AS 'Purchase Made',
ROUND(SUM((quantity*list_price)-discount),2) AS Revenue
FROM orders 
JOIN order_items
ON orders.order_id = order_items.order_id
GROUP BY 1
ORDER BY 1) AS sale
ON customers.customer_id = sale.customer_id
ORDER BY sale.Revenue DESC
LIMIT 50;

-- staff who made most sales

SELECT store_id,CONCAT(first_name, ' ',last_name) AS 'Name', Products_Sold
FROM staffs
JOIN 
(SELECT 
orders.staff_id, SUM(order_items.quantity) AS 'Products_Sold'
FROM orders
JOIN order_items
ON orders.order_id = order_items.order_id
GROUP BY 1) AS sale
ON staffs.staff_id = sale.staff_id;

-- shipping delays

SELECT 
CASE WHEN DATEDIFF(required_date,shipped_date) = 0 THEN 'No Delay' 
     WHEN DATEDIFF(required_date,shipped_date) THEN 'No Delay'
     ELSE 'Delay' END AS DELAY
FROM orders;

-- stores with most delays

SELECT 
store_id,
COUNT(CASE WHEN DATEDIFF(required_date,shipped_date) > 1 THEN order_id ELSE NULL END) AS DELAYS
FROM orders
GROUP BY 1

