-- ============================================
-- TASK 7: Creating Views
-- SQL Developer Internship – Task 7
-- ============================================

-- RESET (avoids FK errors)
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;

SET FOREIGN_KEY_CHECKS = 1;


-- ============================================
-- 1. CREATE TABLES
-- ============================================

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Email VARCHAR(100),
    City VARCHAR(50)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(100),
    Price DECIMAL(10,2)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderDetails (
    DetailID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- ============================================
-- 2. INSERT SAMPLE DATA
-- ============================================

INSERT INTO Customers (Name, Email, City) VALUES
('Manasi', 'manasi@example.com', 'Pune'),
('Rohit', 'rohit@example.com', 'Mumbai'),
('Aditi', 'aditi@example.com', 'Delhi');

INSERT INTO Products (ProductName, Price) VALUES
('Laptop', 60000),
('Mobile', 20000),
('Mouse', 500);

INSERT INTO Orders (CustomerID, OrderDate) VALUES
(1, '2024-11-01'),
(2, '2024-11-05'),
(1, '2024-11-10');

INSERT INTO OrderDetails (OrderID, ProductID, Quantity) VALUES
(1, 1, 1),  
(1, 3, 2),  
(2, 2, 1),
(3, 1, 1);

-- ============================================
-- 3. CREATE VIEWS
-- ============================================

-- 3.1 Basic View (Simple)
CREATE VIEW customer_orders_view AS
SELECT 
    Customers.CustomerID,
    Customers.Name,
    Orders.OrderID,
    Orders.OrderDate
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID;

-- 3.2 Complex View (Join + Aggregation)
CREATE VIEW product_sales_view AS
SELECT 
    Products.ProductName,
    SUM(OrderDetails.Quantity) AS TotalSold
FROM Products
JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
GROUP BY Products.ProductName;

-- 3.3 View for Security (Hide Email)
CREATE VIEW customer_secure_view AS
SELECT 
    CustomerID,
    Name,
    City
FROM Customers;

-- 3.4 View with Condition
CREATE VIEW high_value_customers AS
SELECT 
    Customers.Name,
    SUM(Products.Price * OrderDetails.Quantity) AS TotalSpent
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Products ON OrderDetails.ProductID = Products.ProductID
GROUP BY Customers.CustomerID
HAVING TotalSpent > 50000;

-- ============================================
-- 4. USING THE VIEWS
-- ============================================

-- View 1: Customer Orders
SELECT * FROM customer_orders_view;

-- View 2: Product Sales Summary
SELECT * FROM product_sales_view;

-- View 3: Secure Customer View
SELECT * FROM customer_secure_view;

-- View 4: High Value Customers
SELECT * FROM high_value_customers;

-- ============================================
-- 5. UPDATE THROUGH A VIEW (Only possible for simple views)
-- ============================================

-- Example: Updating customer name through view
UPDATE customer_secure_view
SET Name = 'Mansi Updated'
WHERE CustomerID = 1;

-- ============================================
-- 6. DROPPING VIEWS
-- ============================================

DROP VIEW IF EXISTS customer_orders_view;
DROP VIEW IF EXISTS product_sales_view;
DROP VIEW IF EXISTS customer_secure_view;
DROP VIEW IF EXISTS high_value_customers;

-- END OF SCRIPT
