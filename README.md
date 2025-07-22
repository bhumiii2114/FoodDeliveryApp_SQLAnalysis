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
-- SUM total_amount per customer
```

---

## 5. Delivery Success Rate

Calculates the delivery success percentage for each rider.

```sql
-- Ratio of 'delivered' statuses over total deliveries per rider
```

---

## 6. Order Value Analysis

Finds average order value of customers who have placed at least 3 orders.

```sql
-- Filters customers with COUNT >= 3
```

---

## 7. Undelivered Orders

Lists orders that were not delivered, along with the associated rider and customer details.

```sql
-- Filters delivery_status = 'not delivered'
```

---

## 8. Restaurant Revenue Rankings

Ranks all restaurants both overall and within each city based on total revenue generated.

```sql
-- Uses RANK() OVER for overall and partitioned city-wise ranking
```

---

## 9. Top Restaurant in Each City

Extracts the #1 revenue-generating restaurant per city.

```sql
-- Uses ROW_NUMBER() PARTITION BY city and filters city_rank = 1
```

---

## 10. Customer Churn Analysis

Identifies customers who placed orders in 2023 and 2024 but did **not** place any orders in 2025, including their last order date.

```sql
-- Filters customers who did not appear in 2025 order data
```

---

## 🛠️ Requirements

* SQL (PostgreSQL syntax preferred)
* Tables involved: `orders`, `customers`, `deliveries`, `riders`, `restraunts`

---

## 📌 Notes

* You can replace hardcoded values like `'Paul Vaughan'` with dynamic inputs or parameters.
* Ensure data types (especially `total_amount`, `order_time`) are appropriately cast if needed.

---

Let me know if you want a version in Markdown or `.md` file format.
