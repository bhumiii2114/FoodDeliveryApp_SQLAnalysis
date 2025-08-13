# 📊 Food Delivery Database Analysis – SQL Queries

This repository contains a collection of analytical SQL queries designed to extract key business insights from a food delivery platform's database. The dataset includes information on **customers**, **orders**, **restaurants**, **deliveries**, and **riders**.

---

## 📁 Table of Contents

1. [Top Dishes for a Customer](#1-top-dishes-for-a-customer)
2. [Most Popular Time Slots](#2-most-popular-time-slots)
3. [Loyal Customers](#3-loyal-customers)
4. [Top Spending Customers](#4-top-spending-customers)
5. [Delivery Success Rate](#5-delivery-success-rate)
6. [Order Value Analysis](#6-order-value-analysis)
7. [Undelivered Orders](#7-undelivered-orders)
8. [Restaurant Revenue Rankings](#8-restaurant-revenue-rankings)
9. [Top Restaurant in Each City](#9-top-restaurant-in-each-city)
10. [Customer Churn Analysis](#10-customer-churn-analysis)

---

## 1. Top Dishes for a Customer

Returns the top 5 most frequently ordered dishes by a specific customer (e.g., *Paul Vaughan*).

```sql
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
```

---

## 2. Most Popular Time Slots

Analyzes the distribution of order times and returns the top 5 hours with the highest order volumes.

```sql
SELECT 
    EXTRACT(HOUR FROM order_time::time) AS hour_of_day,
    COUNT(*) AS total_orders
FROM orders
GROUP BY hour_of_day
ORDER BY total_orders DESC
limit 5;
```

---

## 3. Loyal Customers

Identifies the top 10 customers based on the total number of orders placed.

```sql
SELECT 
    c.customer_id, 
    c.customer_name, 
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_orders DESC
LIMIT 10;
```

---

## 4. Top Spending Customers

Displays the top 3 customers who have spent the most, based on the total order amount.

```sql
SELECT 
    o.customer_id,
    c.customer_name,
    SUM(o.total_amount) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.customer_name
ORDER BY total_spent DESC
LIMIT 3;
```

---

## 5. Delivery Success Rate

Calculates the delivery success percentage for each rider.

```sql
SELECT 
    rider_id,
    COUNT(CASE WHEN 
	delivery_status = 'delivered' THEN 1 END)::float / COUNT(*) * 100 
	AS delivery_success_rate
FROM deliveries
GROUP BY rider_id
ORDER BY delivery_success_rate DESC;
```

---

## 6. Order Value Analysis

Finds average order value of customers who have placed at least 3 orders.

```sql
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
```

---

## 7. Undelivered Orders

Lists orders that were not delivered, along with the associated rider and customer details.

```sql
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
```

---

## 8. Restaurant Revenue Rankings

Ranks all restaurants both overall and within each city based on total revenue generated.

```sql
SELECT 
    r.restaurant_name,
    r.city,
    SUM(o.total_amount) AS total_revenue,
    RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS overall_rank,
    RANK() OVER (PARTITION BY r.city ORDER BY SUM(o.total_amount) DESC) AS city_rank
FROM orders o
JOIN restraunts r ON o.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_name, r.city;
```

---

## 9. Top Restaurant in Each City

Extracts the #1 revenue-generating restaurant per city.

```sql
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
```

---

## 10. Customer Churn Analysis

Identifies customers who placed orders in 2023 and 2024 but did **not** place any orders in 2025, including their last order date.

```sql
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
```

---

## 🛠️ Requirements

* SQL (PostgreSQL syntax used)
* Tables involved: `orders`, `customers`, `deliveries`, `riders`, `restraunts`

