
-- Drop tables if they exist
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- Create Customers table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    country VARCHAR(50)
);

-- Create Products table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);

-- Create Orders table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    order_date DATE
);

-- Insert sample data into Customers
INSERT INTO customers (name, email, country) VALUES
('Amit Sharma', 'amit@example.com', 'India'),
('Sara Khan', 'sara@example.com', 'India'),
('John Doe', 'john@example.com', 'USA'),
('Emma Watson', 'emma@example.com', 'UK');

-- Insert sample data into Products
INSERT INTO products (product_name, category, price) VALUES
('Smartphone', 'Electronics', 700.00),
('Laptop', 'Electronics', 1200.00),
('Desk Chair', 'Furniture', 150.00),
('Water Bottle', 'Kitchen', 20.00);

-- Insert sample data into Orders
INSERT INTO orders (customer_id, product_id, quantity, order_date) VALUES
(1, 1, 1, '2024-04-01'),
(2, 2, 1, '2024-04-03'),
(1, 3, 2, '2024-04-10'),
(3, 4, 5, '2024-04-12'),
(4, 1, 1, '2024-04-15');

-- 1. Select query
SELECT * FROM customers;

-- 2. WHERE + ORDER BY
SELECT * FROM orders WHERE quantity > 1 ORDER BY order_date DESC;

-- 3. INNER JOIN
SELECT c.name, p.product_name, o.quantity, (p.price * o.quantity) AS total_price
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN products p ON o.product_id = p.product_id;

-- 4. Aggregate function: Total revenue per customer
SELECT c.name, SUM(p.price * o.quantity) AS total_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY c.name;

-- 5. Subquery: Customers who spent more than $1000
SELECT name FROM customers
WHERE customer_id IN (
    SELECT o.customer_id
    FROM orders o
    JOIN products p ON o.product_id = p.product_id
    GROUP BY o.customer_id
    HAVING SUM(p.price * o.quantity) > 1000
);

-- 6. Create a View for all electronics orders
CREATE VIEW electronics_orders AS
SELECT o.order_id, c.name, p.product_name, o.quantity, o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
WHERE p.category = 'Electronics';

-- 7. Index creation
CREATE INDEX idx_order_customer_id ON orders(customer_id);
