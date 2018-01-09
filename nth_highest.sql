-- How can we get the nth highest number of orders a single customer has?

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



-- We made a view of the number of orders each customer has:

CREATE VIEW customer_order_counts AS
SELECT customers.customer_id, first_name, count(orders.customer_id) AS order_count
FROM customers LEFT OUTER JOIN orders
ON (customers.customer_id = orders.customer_id)
GROUP BY customers.customer_id;

-- So for example, Nancy has 3 orders:

SELECT * FROM customer_order_counts ORDER BY RAND() LIMIT 1;

/*
    +-------------+------------+-------------+
    | customer_id | first_name | order_count |
    +-------------+------------+-------------+
    |        9118 | Nancy      |           3 |
    +-------------+------------+-------------+
*/


-- Answer
-- Let’s start by solving a simpler problem—how would we just get the highest number of orders?

-- Pretty trivial since we have a built-in function:

SELECT MAX(order_count) FROM customer_order_counts;
-- 1 row in set (1.89 sec)

-- Now can we adapt this to get the second highest number of orders?

-- Well, if we can get the highest order count, we can get "the highest order count that's not the highest order count":

SELECT MAX(order_count) FROM customer_order_counts WHERE order_count NOT IN (
SELECT MAX(order_count) FROM customer_order_counts);
-- 1 row in set (3.89 sec)

-- This works, but it’s pretty slow. Any ideas for a faster query?

-- We could also sort the order_counts. Then we don’t have to scan the whole table twice. We just jump down to the second row:

SELECT order_count FROM customer_order_counts ORDER BY order_count DESC LIMIT 1, 1;
-- 1 row in set (1.93 sec)

-- If LIMIT has one argument, that argument is the number of rows to return starting with the first row. With 2 arguments, the first argument is the row offset and the second argument is the number of rows to return. So in our query with “1, 1” we're saying "starting one row down from the top, give us one row."

-- Now, how do we get the nth highest order count?

-- Easy—we just change the row offset in our LIMIT clause:

SELECT order_count FROM customer_order_counts ORDER BY order_count DESC LIMIT N-1, 1;

