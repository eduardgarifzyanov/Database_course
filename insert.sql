-- Добавление данных об клиентах --
INSERT INTO furniture_salon_database.customer (ClientName, PhoneNumber, Address)
VALUES
('Иван', '+79161234567', 'Москва, улица 1'),
('Анна', '+79161234568', 'Санкт-Петербург, улица 2'),
('Сергей', '+79161234569', 'Казань, улица 3'),
('Мария', '+79161234570', 'Екатеринбург, улица 4'),
('Ольга', '+79161234571', 'Новосибирск, улица 5'),
('Алексей', '+79161234572', 'Нижний Новгород, улица 6'),
('Елена', '+79161234573', 'Ростов-на-Дону, улица 7'),
('Дмитрий', '+79161234574', 'Владивосток, улица 8'),
('Наталия', '+79161234575', 'Красноярск, улица 9'),
('Владимир', '+79161234576', 'Воронеж, улица 10'),
('Татьяна', '+79161234577', 'Самара, улица 11'),
('Михаил', '+79161234578', 'Челябинск, улица 12'),
('Ирина', '+79161234579', 'Краснодар, улица 13'),
('Яков', '+79161234580', 'Омск, улица 14'),
('Елизавета', '+79161234581', 'Пермь, улица 15');

-- Добавление данных об заказах клиентов --
INSERT INTO furniture_salon_database.order_customer (ClientId, DateOfOrder, Status, ExistenceDelivery, ExistenceAssembling)
SELECT c.ClientId, '2023-01-01'::timestamp, 'В обработке', false, false 
FROM furniture_salon_database.customer c 
WHERE c.ClientId = 1
UNION ALL
SELECT c.ClientId, '2023-02-13'::timestamp, 'В обработке', true, true 
FROM furniture_salon_database.customer c 
WHERE c.ClientId = 2
UNION ALL
SELECT c.ClientId, '2023-03-04'::timestamp, 'Отменен', false, false 
FROM furniture_salon_database.customer c 
WHERE c.ClientId = 3
UNION ALL
SELECT c.ClientId, '2023-04-15'::timestamp, 'Готов к отправке', true, true 
FROM furniture_salon_database.customer c 
WHERE c.ClientId = 4
UNION ALL
SELECT c.ClientId, '2023-05-06'::timestamp, 'Завершен', true, true 
FROM furniture_salon_database.customer c 
WHERE c.ClientId = 5
UNION ALL
SELECT c.ClientId, '2023-06-17'::timestamp, 'В обработке', false, false 
FROM furniture_salon_database.customer c 
WHERE c.ClientId = 6
UNION ALL
SELECT c.ClientId, '2023-07-08'::timestamp, 'В ожидании доставки', true, true 
FROM furniture_salon_database.customer c 
WHERE c.ClientId = 7
UNION ALL
SELECT c.ClientId, '2023-08-19'::timestamp, 'Отменен', false, false 
FROM furniture_salon_database.customer c 
WHERE c.ClientId = 8
UNION ALL
SELECT c.ClientId, '2023-09-02'::timestamp, 'В обработке', true, true 
FROM furniture_salon_database.customer c 
WHERE c.ClientId = 9
UNION ALL
SELECT c.ClientId, '2023-10-14'::timestamp, 'Завершен', true, true 
FROM furniture_salon_database.customer c 
WHERE c.ClientId = 10
UNION ALL
SELECT c.ClientId, '2023-11-05'::timestamp, 'В обработке', true, true 
FROM furniture_salon_database.customer c 
WHERE c.ClientId = 11
UNION ALL
SELECT c.ClientId, '2023-12-16'::timestamp, 'В ожидании доставки', true, false 
FROM furniture_salon_database.customer c 
WHERE c.ClientId = 12
UNION ALL
SELECT c.ClientId, '2023-01-07'::timestamp, 'В обработке', true, true 
FROM furniture_salon_database.customer c 
WHERE c.ClientId = 13
UNION ALL
SELECT c.ClientId, '2023-02-18'::timestamp, 'В обработке', false, false 
FROM furniture_salon_database.customer c 
WHERE c.ClientId = 14
UNION ALL
SELECT c.ClientId, '2023-03-10'::timestamp, 'В обработке', true, true 
FROM furniture_salon_database.customer c 
WHERE c.ClientId = 15;

-- Добавление данных об сборке при условии, что в заказе в поле ExistenceAssembling стоит "true" --
INSERT INTO furniture_salon_database.assembling (OrderId, Price, DateOfStartAssembling, DateOfStopAssembling, Status)
SELECT oc.OrderId, 5000, oc.DateOfOrder + INTERVAL '30 day', oc.DateOfOrder + INTERVAL '31 day',  (SELECT CASE WHEN (NOW() > oc.DateOfOrder + INTERVAL '31 day') then 'Завершено' else 'В процессе' END)
FROM furniture_salon_database.order_customer oc
WHERE oc.ExistenceAssembling = true;

-- Добавление данных об доставке при условии, что в заказе в поле ExistenceDelivery стоит "true" --
INSERT INTO furniture_salon_database.delivery (OrderId, Price, DateOfStartDelivery, DateOfStopDelivery, Status)
SELECT oc.OrderId, 1000, oc.DateOfOrder + INTERVAL '30 day', oc.DateOfOrder + INTERVAL '30 day 5 hour', (SELECT CASE WHEN (NOW() > oc.DateOfOrder + INTERVAL '30 day 5 hour') then 'Завершено' else 'В процессе' END)
FROM furniture_salon_database.order_customer oc
WHERE oc.ExistenceDelivery = true;

-- Добавление данных об товарах --
INSERT INTO furniture_salon_database.product (ProductName, Price, Characteristic)
VALUES
('Диван', 10000, 'Трехместный, кожаный'),
('Кресло', 5000, 'Мягкое, обитое тканью'),
('Стол', 3000, 'Деревянный, обеденный'),
('Стул', 2000, 'Пластиковый, офисный'),
('Кровать', 7000, 'Двуспальная, деревянная'),
('Шкаф', 6000, 'Трехдверный, зеркальный'),
('Полка', 4000, 'Открытая, деревянная'),
('Тумба', 3000, 'Под телевизор, деревянная'),
('Комод', 2000, 'Четырехдверный, деревянный'),
('Зеркало', 1000, 'Настенное, в раме'),
('Лампа', 500, 'Настольная, светодиодная'),
('Картина', 1000, 'Абстракция, масляные краски'),
('Ковер', 3000, 'Большой, шерстяной'),
('Ваза', 2000, 'Высокая, стеклянная'),
('Часы', 1000, 'Настенные, механические');

-- Связующие данные между таблицами товаров и заказов клиентов --
INSERT INTO furniture_salon_database.link_order_customer_product (OrderId, ProductId, CountOfProducts)
VALUES
(1, 3, 1),
(1, 4, 4),
(1, 1, 1),
(2, 5, 1),
(2, 6, 1),
(3, 14, 1),
(4, 11, 3),
(5, 7, 6),
(5, 8, 4),
(5, 9, 2),
(6, 15, 3),
(6, 10, 2),
(7, 12, 10),
(8, 2, 5),
(8, 5, 2),
(8, 1, 3),
(8, 13, 5),
(9, 8, 1),
(10, 3, 2),
(11, 1, 1),
(12, 13, 20),
(13, 15, 2),
(14, 2, 3),
(14, 7, 15);

-- Добавление данных об фабриках --
INSERT INTO furniture_salon_database.manufacturer (Address, FactoryName)
VALUES
('123 Main Street, New York, NY 10001', 'ABC Furniture Company'),
('456 Broadway Avenue, Chicago, IL 60605', 'DEF Furniture Factory'),
('789 Oak Lane, Los Angeles, CA 90001', 'GHI Furniture Workshop'),
('101 Maple Road, Houston, TX 77001', 'JKL Furniture Maker'),
('202 Pine Boulevard, Philadelphia, PA 19101', 'MNO Furniture Shop'),
('303 Elm Street, San Francisco, CA 94101', 'PQR Furniture Studio'),
('404 Walnut Avenue, Washington, DC 20001', 'STU Furniture Design'),
('505 Ash Lane, Boston, MA 02101', 'VWX Furniture Production'),
('606 Cedar Road, Seattle, WA 98101', 'YZ Furniture Creations'),
('707 Spruce Street, Dallas, TX 75201', '123 Furniture Solutions'),
('808 Birch Avenue, Miami, FL 33101', '456 Furniture Concepts'),
('909 Cypress Street, Atlanta, GA 30301', '789 Furniture Innovations'),
('010 Oak Street, Phoenix, AZ 85001', '101 Furniture Improvements'),
('212 Cherry Lane, Denver, CO 80201', '202 Furniture Developments'),
('313 Maple Street, Portland, OR 97201', '303 Furniture Enhancements');

-- Добавление данных об заказах на фабрику --
INSERT INTO furniture_salon_database.order_manufacturer (ManufacturerId, ProductId, DateOfOrder, Status, CountOfProducts)
SELECT 1, locp.ProductId, '2023-02-14'::timestamp, 'Ожидание доставки', SUM(locp.CountOfProducts)
FROM furniture_salon_database.link_order_customer_product locp
WHERE locp.ProductId = 1
GROUP BY locp.ProductId
UNION ALL
SELECT 2, locp.ProductId, '2023-02-14'::timestamp, 'Ожидание доставки', SUM(locp.CountOfProducts)
FROM furniture_salon_database.link_order_customer_product locp
WHERE locp.ProductId = 2
GROUP BY locp.ProductId
UNION ALL
SELECT 3, locp.ProductId, '2023-02-14'::timestamp, 'Ожидание доставки', SUM(locp.CountOfProducts)
FROM furniture_salon_database.link_order_customer_product locp
WHERE locp.ProductId = 3
GROUP BY locp.ProductId
UNION ALL
SELECT 4, locp.ProductId, '2023-02-14'::timestamp, 'Ожидание доставки', SUM(locp.CountOfProducts)
FROM furniture_salon_database.link_order_customer_product locp
WHERE locp.ProductId = 4
GROUP BY locp.ProductId
UNION ALL
SELECT 5, locp.ProductId, '2023-02-14'::timestamp, 'Ожидание доставки', SUM(locp.CountOfProducts)
FROM furniture_salon_database.link_order_customer_product locp
WHERE locp.ProductId = 5
GROUP BY locp.ProductId
UNION ALL
SELECT 6, locp.ProductId, '2023-02-14'::timestamp, 'Ожидание доставки', SUM(locp.CountOfProducts)
FROM furniture_salon_database.link_order_customer_product locp
WHERE locp.ProductId = 6
GROUP BY locp.ProductId
UNION ALL
SELECT 7, locp.ProductId, '2023-02-14'::timestamp, 'Ожидание доставки', SUM(locp.CountOfProducts)
FROM furniture_salon_database.link_order_customer_product locp
WHERE locp.ProductId = 7
GROUP BY locp.ProductId
UNION ALL
SELECT 8, locp.ProductId, '2023-02-14'::timestamp, 'Ожидание доставки', SUM(locp.CountOfProducts)
FROM furniture_salon_database.link_order_customer_product locp
WHERE locp.ProductId = 8
GROUP BY locp.ProductId
UNION ALL
SELECT 9, locp.ProductId, '2023-02-14'::timestamp, 'Ожидание доставки', SUM(locp.CountOfProducts)
FROM furniture_salon_database.link_order_customer_product locp
WHERE locp.ProductId = 9
GROUP BY locp.ProductId
UNION ALL
SELECT 10, locp.ProductId, '2023-02-14'::timestamp, 'Ожидание доставки', SUM(locp.CountOfProducts)
FROM furniture_salon_database.link_order_customer_product locp
WHERE locp.ProductId = 10
GROUP BY locp.ProductId
UNION ALL
SELECT 1, locp.ProductId, '2023-02-14'::timestamp, 'Ожидание доставки', SUM(locp.CountOfProducts)
FROM furniture_salon_database.link_order_customer_product locp
WHERE locp.ProductId = 11
GROUP BY locp.ProductId
UNION ALL
SELECT 2, locp.ProductId, '2023-02-14'::timestamp, 'Ожидание доставки', SUM(locp.CountOfProducts)
FROM furniture_salon_database.link_order_customer_product locp
WHERE locp.ProductId = 12
GROUP BY locp.ProductId
UNION ALL
SELECT 3, locp.ProductId, '2023-02-14'::timestamp, 'Ожидание доставки', SUM(locp.CountOfProducts)
FROM furniture_salon_database.link_order_customer_product locp
WHERE locp.ProductId = 13
GROUP BY locp.ProductId
UNION ALL
SELECT 4, locp.ProductId, '2023-02-14'::timestamp, 'Ожидание доставки', SUM(locp.CountOfProducts)
FROM furniture_salon_database.link_order_customer_product locp
WHERE locp.ProductId = 14
GROUP BY locp.ProductId
UNION ALL
SELECT 5, locp.ProductId, '2023-02-14'::timestamp, 'Ожидание доставки', SUM(locp.CountOfProducts)
FROM furniture_salon_database.link_order_customer_product locp
WHERE locp.ProductId = 15
GROUP BY locp.ProductId

