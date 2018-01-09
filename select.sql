-- given the following schema:

-- CREATE TABLE cakes (
--     cake_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
--     flavor VARCHAR(100) NOT NULL
-- );

-- CREATE TABLE customers (
--     customer_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
--     first_name VARCHAR(100) NOT NULL,
--     last_name VARCHAR(100) NOT NULL,
--     phone VARCHAR(15),
--     street_address VARCHAR(255),
--     city VARCHAR(255),
--     zip_code VARCHAR(5),
--     referrer_id INT,
--     FOREIGN KEY (referrer_id) REFERENCES customers (customer_id)
-- );

-- CREATE TABLE orders (
--     order_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
--     cake_id INT NOT NULL,
--     customer_id INT,
--     pickup_date DATE NOT NULL,
--     FOREIGN KEY (cake_id) REFERENCES cakes (cake_id),
--     FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
-- );

-- Want to get set up with sample data? 
-- Here's how to get four cakes, a million customers, and a million orders:
-- curl -O https://s3-us-west-2.amazonaws.com/icpublic/bakery_schema_and_data.sql && mysql.server start && mysql -u root
-- source bakery_schema_and_data.sql;
-- mysql.server start && mysql -u root
-- use the bakery database:  USE BAKERY;

-- We want the order ID of every order in January and February, 2017. This is the query we've got so far:
SELECT order_id FROM orders WHERE DATEDIFF(orders.pickup_date, '2017-03-01') < 0;
-- 161314 rows in set (0.25 sec)


-- how could one improve the performance of this query?
ALTER TABLE orders ADD INDEX (pickup_date);
SELECT order_id FROM orders WHERE DATEDIFF(orders.pickup_date, '2017-03-01') < 0;
-- 161314 rows in set (0.25 sec)

-- didn't improve...why? functions evaluate on every row
-- Easy fix here—we can just compare the pickup date and March 1 directly:
SELECT order_id FROM orders WHERE orders.pickup_date < '2017-03-01';
-- 161314 rows in set (0.07 sec)

-- is there anything else 'wrong' with the select statement?
--    if there's data from before 2017 then the query will also include it, so we'd be
--    looking at data outside the required range.
--    How would we address that?
-- is there a way we could check how the statement might perform without actually running it?

