-- Вывод списка клиентов --
SELECT * FROM furniture_salon_database.customer
ORDER BY clientid ASC;

-- Вывод всего каталога товаров --
SELECT * FROM furniture_salon_database.product
ORDER BY productid ASC;

-- Вывод списка всех фабрик --
SELECT * FROM furniture_salon_database.manufacturer
ORDER BY manufacturerid ASC;

-- Вывод списка заказов клиентов --
SELECT * FROM furniture_salon_database.order_customer
ORDER BY orderid ASC;

-- Вывод списка доставок --
SELECT * FROM furniture_salon_database.delivery
ORDER BY orderid ASC;

-- Вывод списка сборок --
SELECT * FROM furniture_salon_database.assembling
ORDER BY orderid ASC;

-- Вывод связи заказ клиента-товар --
SELECT * FROM furniture_salon_database.link_order_customer_product
ORDER BY orderid ASC;

-- Вывод списка заказов на фабрики --
SELECT * FROM furniture_salon_database.order_manufacturer
ORDER BY manufacturerid ASC;

-- Обновление статуса заказа клиента --
UPDATE furniture_salon_database.order_customer
SET Status = 'Статус'
WHERE orderid = 'уникальный идентификатор заказа';

-- Обновление статуса заказа на фабрику --
UPDATE furniture_salon_database.order_manufacturer
SET Status = 'Статус'
WHERE orderid = 'уникальный идентификатор заказа';

-- Обновление статуса сборки --
UPDATE furniture_salon_database.assembling
SET Status = 'Статус'
WHERE UniqueId = 'уникальный идентификатор заказа';

-- Обновление статуса доставки --
UPDATE furniture_salon_database.delivery
SET Status = 'Статус'
WHERE UniqueId = 'уникальный идентификатор заказа';

-- Удаление данных об клиенте --
DELETE FROM furniture_salon_database.сustomer
WHERE clientid = 'уникальный идентификатор заказа';

-- Очищение данных в какой-либо таблице --
DELETE FROM furniture_salon_database.customer;
DELETE FROM furniture_salon_database.order_customer;
DELETE FROM furniture_salon_database.assembling;
DELETE FROM furniture_salon_database.delivery;
DELETE FROM furniture_salon_database.product;
DELETE FROM furniture_salon_database.link_order_customer_product;
DELETE FROM furniture_salon_database.manufacturer;
DELETE FROM furniture_salon_database.order_manufacturer;


-- Вывод суммы заказа каждого покупателя --
SELECT locp.orderid, sum((SELECT p.price FROM furniture_salon_database.product p WHERE locp.productid = p.productid) * locp.CountOfProducts) as summary
FROM furniture_salon_database.link_order_customer_product locp
GROUP BY locp.orderid
ORDER BY summary DESC;

-- Вывод самого дорого заказа--
SELECT locp.orderid, sum((SELECT p.price FROM furniture_salon_database.product p WHERE locp.productid = p.productid) * locp.CountOfProducts) as summary
FROM furniture_salon_database.link_order_customer_product locp
GROUP BY locp.orderid
ORDER BY summary DESC
LIMIT 1;

-- Вывод списка "Звершенных" заказов клиентов-- 
SELECT *
FROM furniture_salon_database.order_customer o
WHERE o.status = 'Завершен';

-- Вывод самого дорого товара --
SELECT *
FROM furniture_salon_database.product p
ORDER BY p.price DESC
LIMIT 1;

-- Вывод заказов которым нужна доставка --
SELECT oc.orderid, oc.existencedelivery 
FROM furniture_salon_database.order_customer oc
WHERE oc.existencedelivery = true;

-- Вывод заказов которым нужна сборка --
SELECT oc.orderid, oc.existencedelivery 
FROM furniture_salon_database.order_customer oc
WHERE oc.existencedelivery = true;

-- Вывод товара, количество которого в заказах наибольшее --
SELECT p.ProductId, p.ProductName, (SELECT SUM(locp.CountOfProducts) FROM furniture_salon_database.link_order_customer_product locp WHERE p.productid = locp.productid) as sum_count
FROM furniture_salon_database.product p
GROUP BY p.productid
ORDER BY sum_count DESC
LIMIT 1;