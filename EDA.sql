--Upload datasets
--go to Databases>FoodDeliveryApp>Schemas>public>tables>table_name
--right click and choose import/export, choose the csv file and set options accordingly
--for better debugging of errors use psql terminal commands
--\copy deliveries FROM 'C:\Users\bhumi\Downloads\delivery_data.csv' DELIMITER ',' CSV HEADER;
--EDA
select * from customers;
select * from riders;
select * from deliveries;
select * from orders;
select * from restraunts;

--check and handle null values
select count(*) from customers
where reg_date is null 
or customer_name is null;

select count(*) from riders
where sign_up is null;

--insert null values
INSERT INTO orders (order_id, customer_id, restaurant_id)
VALUES (10400, 1, 5);

select count(*) from orders
where total_amount is null;

select * from orders
where total_amount is null;

--delete the rows having some null values: Data Cleaning-Handling Missing Data
delete from orders
where total_amount is null;