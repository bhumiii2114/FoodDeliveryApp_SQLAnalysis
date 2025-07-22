--1. Top n most frequently ordered dishes by a customer name
--need to join orders table for dish name and customers table for customer name
--group by on customer name,id and cnt dishes
SELECT 
    c.customer_id,
    c.customer_name,
    o.order_item AS dish,
    COUNT(*) AS total_orders
FROM orders AS o
JOIN customers AS c 
    ON c.customer_id = o.customer_id
WHERE c.customer_name = 'Paul Vaughan'
GROUP BY c.customer_id, c.customer_name, o.order_item
ORDER BY total_orders DESC
LIMIT 5;

--2. Most Popular time slot
SELECT 
    EXTRACT(HOUR FROM order_time::time) AS hour_of_day,
    COUNT(*) AS total_orders
FROM orders
GROUP BY hour_of_day
ORDER BY total_orders DESC
limit 5;

--3. Identify Loyal Customers
SELECT 
    c.customer_id, 
    c.customer_name, 
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_orders DESC
LIMIT 10;
--4. Top Spending Customers
SELECT 
    o.customer_id,
    c.customer_name,
    SUM(o.total_amount) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.customer_name
ORDER BY total_spent DESC
LIMIT 3;

--5. Delivery Success Rates of Riders
SELECT 
    rider_id,
    COUNT(CASE WHEN 
	delivery_status = 'delivered' THEN 1 END)::float / COUNT(*) * 100 
	AS delivery_success_rate
FROM deliveries
GROUP BY rider_id
ORDER BY delivery_success_rate DESC;

--6. Order Value Analysis
--Find avg order value of customers who places atleast 3 orders.
SELECT 
    o.customer_id,
    c.customer_name,
    COUNT(*) AS total_orders,
    ROUND(AVG(o.total_amount)::numeric, 2) AS avg_order_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.customer_name
HAVING COUNT(*) >= 3
ORDER BY avg_order_value DESC;

--7. Orders without delivery
--Orders that were placed but not delivered along with the name of rider assigned.
SELECT 
    o.order_id,
    c.customer_name,
    o.order_item,
    d.delivery_status,
    r.rider_name
FROM orders o
JOIN deliveries d ON o.order_id = d.order_id
JOIN customers c ON o.customer_id = c.customer_id
JOIN riders r ON d.rider_id = r.rider_id
WHERE d.delivery_status = 'not delivered';

--8. Restaurant Ranking
SELECT 
    r.restaurant_name,
    r.city,
    SUM(o.total_amount) AS total_revenue,
    RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS overall_rank,
    RANK() OVER (PARTITION BY r.city ORDER BY SUM(o.total_amount) DESC) AS city_rank
FROM orders o
JOIN restraunts r ON o.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_name, r.city;

--9. Rank 1 in each city
SELECT 
    restaurant_name,
    city,
    total_revenue
FROM (
    SELECT 
        r.restaurant_name,
        r.city,
        SUM(o.total_amount::int) AS total_revenue,
        ROW_NUMBER() OVER (PARTITION BY r.city ORDER BY SUM(o.total_amount) DESC) AS city_rank
    FROM orders o
    JOIN restraunts r ON o.restaurant_id = r.restaurant_id
    GROUP BY r.restaurant_name, r.city
) ranked
WHERE city_rank = 1;


--10.Customer Churn Analysis
--customers who placed an order in 2023 and 2024 but not in 2025 with last order date
SELECT 
    c.customer_id,
    c.customer_name,
    MAX(o.order_date) AS last_order_date
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE EXTRACT(YEAR FROM o.order_date) IN (2023, 2024)
  AND c.customer_id NOT IN (
        SELECT DISTINCT customer_id
        FROM orders
        WHERE EXTRACT(YEAR FROM order_date) = 2025
  )
GROUP BY c.customer_id, c.customer_name;


