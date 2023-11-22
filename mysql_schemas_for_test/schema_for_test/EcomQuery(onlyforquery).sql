#Eg1

# NL： "显示一个特定客户的所有订单的详细情况，包括他们买了哪些产品，这些产品属于哪个类别，是哪个制造商生产的，以及这些产品的客户评价有多高。"
# 此查询旨在提供指定客户的订单详情。它包括以下内容：
#
# 客户的ID、名和姓。
# 他们的订单ID。
# 订单中每个产品的ID和型号。
# 产品的详细描述。
# 产品所属的类别及其描述。
# 产品的制造商。
# 关于这些产品的评价，包括评分和评价内容。

# 这个查询适用于分析特定客户的购买偏好和行为，同时提供了有关产品、类别和制造商的详细信息，以及客户对产品的评价。

SELECT 
    c.customers_id,
    c.customers_firstname,
    c.customers_lastname,
    o.orders_id,
    op.products_id,
    p.products_model,
    pd.products_description,
    cat.categories_id,
    cd.categories_name,
    m.manufacturers_name,
    r.reviews_rating,
    rd.reviews_text
FROM 
    customers c
    JOIN orders o ON c.customers_id = o.customers_id
    JOIN orders_products op ON o.orders_id = op.orders_id
    JOIN products p ON op.products_id = p.products_id
    JOIN products_description pd ON p.products_id = pd.products_id
    JOIN products_to_categories ptc ON p.products_id = ptc.products_id
    JOIN categories cat ON ptc.categories_id = cat.categories_id
    JOIN categories_description cd ON cat.categories_id = cd.categories_id
    JOIN manufacturers m ON p.manufacturers_id = m.manufacturers_id
    LEFT JOIN reviews r ON p.products_id = r.products_id
    LEFT JOIN reviews_description rd ON r.reviews_id = rd.reviews_id
WHERE 
    c.customers_id = $SOME_CUSTOMER_ID;  #1,2,3



# Eg2

# NL： "这个查询显示了不同产品类别和制造商的总订单数量和总销售量。它将按产品类别和制造商分组，为每个组合提供以下信息：
# 产品类别名称、制造商名称、产品型号、总订单数和总销售数量。此外，还会显示每个产品组合的订单状态。这个查询可以用来分析哪
# 些类别和制造商的产品最受欢迎，以及不同产品的销售表现如何。"

SELECT 
    cat.categories_name,
    m.manufacturers_name,
    p.products_model,
    COUNT(DISTINCT o.orders_id) AS total_orders,
    SUM(op.products_quantity) AS total_quantity_sold,
    os.orders_status_name
FROM 
    orders o
    JOIN orders_products op ON o.orders_id = op.orders_id
    JOIN products p ON op.products_id = p.products_id
    JOIN products_to_categories ptc ON p.products_id = ptc.products_id
    JOIN categories cat ON ptc.categories_id = cat.categories_id
    JOIN manufacturers m ON p.manufacturers_id = m.manufacturers_id
    JOIN orders_status os ON o.orders_status = os.orders_status_id
GROUP BY 
    cat.categories_name,
    m.manufacturers_name,
    p.products_model,
    os.orders_status_name
ORDER BY 
    total_quantity_sold DESC;



# test 
-- Insert customer information
INSERT INTO customers (customers_id, customers_firstname, customers_lastname, customers_dob, customers_email_address) VALUES 
(1, 'John', 'Doe', '2022-02-01 18:40:17', 'SRmlTguLvV@example.com'),
(2, 'Jane', 'Smith', '2021-06-22 01:58:39', 'cVLeHYCTPW@example.com'),
(3, 'Emily', 'Johnson', '2022-01-07 04:28:27', 'ZCXPacBAgi@example.com');

-- Insert order statuses
INSERT INTO orders_status (orders_status_id, orders_status_name) VALUES 
(1, 'Shipped'),
(2, 'Processing'),
(3, 'Cancelled');

-- Insert order information
INSERT INTO orders (orders_id, customers_id, orders_status) VALUES 
(100, 1, 1),
(101, 2, 2),
(102, 3, 3);

-- Insert manufacturer information
INSERT INTO manufacturers (manufacturers_id, manufacturers_name) VALUES 
(1, 'Manufacturer A'),
(2, 'Manufacturer B');

-- Insert products and descriptions
INSERT INTO products (products_id, products_model, manufacturers_id) VALUES 
(101, 'ModelA', 1),
(102, 'ModelB', 1),
(103, 'ModelC', 2);

INSERT INTO products_description (products_id, products_description) VALUES 
(101, 'Description of Product A'),
(102, 'Description of Product B'),
(103, 'Description of Product C');


-- Insert categories and descriptions
INSERT INTO categories (categories_id) VALUES 
(10),
(11),
(12);

INSERT INTO categories_description (categories_id, categories_name, categories_description) VALUES 
(10, 'Category A', 'Description for Category A'),
(11, 'Category B', 'Description for Category B'),
(12, 'Category C', 'Description for Category C');


-- Associate products with categories
INSERT INTO products_to_categories (products_id, categories_id) VALUES 
(101, 10),
(102, 11),
(103, 12);



-- Insert order products information
INSERT INTO orders_products (orders_id, products_id, products_quantity, products_prid) VALUES 
(100, 101, 2, 'PRID1'),
(101, 102, 1, 'PRID2'),
(102, 103, 3, 'PRID3');

-- Insert product reviews and descriptions
INSERT INTO reviews (reviews_id, products_id, reviews_rating) VALUES 
(1, 101, 5),
(2, 102, 4);
INSERT INTO reviews_description (reviews_id, reviews_text) VALUES 
(1, 'Excellent product'),
(2, 'Very good, but has some issues');

mysql> INSERT INTO reviews_description (reviews_id, reviews_text) VALUES 
    -> (1, 'Excellent product'),
    -> (2, 'Very good, but has some issues');
ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`Ecommerce`.`reviews_description`, CONSTRAINT `reviews_description_ibfk_2` FOREIGN KEY (`languages_id`) REFERENCES `languages` (`languages_id`))


# 请根据您数据库的实际结构对这些语句进行必要的调整。在测试第一个查询时，您可以使用1、2或3作为客户ID来替换$SOME_CUSTOMER_ID.
