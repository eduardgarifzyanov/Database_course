
-- Вывод всего каталога товаров --
SELECT * FROM furniture_salon_database.product
ORDER BY productid ASC;

-- Вывод списка всех фабрик --
SELECT * FROM furniture_salon_database.manufacturer
ORDER BY manufacturerid ASC;

-- Вывод списка клиентов --
SELECT * FROM furniture_salon_database.customer
ORDER BY clientid ASC;

-- Обновление статуса заказа клиента --
UPDATE furniture_salon_database.order_customer
SET Status = 'Выполнен'
WHERE orderid = 'уникальный идентификатор заказа';

-- Обновление статуса сборки --
UPDATE furniture_salon_database.assembling
SET Status = 'Завершена'
WHERE UniqueId = 'уникальный идентификатор заказа';

-- Обновление статуса доставки --
UPDATE furniture_salon_database.delivery
SET Status = 'Получена'
WHERE UniqueId = 'уникальный идентификатор заказа';

-- Удаление данных об клиенте --
DELETE FROM furniture_salon_database.сustomer
WHERE clientid = 'уникальный идентификатор заказа';

-- Удаление товара со склада --
DELETE FROM furniture_salon_database.warehouse
WHERE ProductId = 'уникальный идентификатор товара';

-- Проверка наличия товара на складе --
SELECT CASE WHEN w.CountOfProducts > 0 THEN 'true' ELSE 'false' END AS HasProducts
FROM furniture_salon_database.products p
JOIN furniture_salon_database.warehouse w ON p.ProductId = w.ProductId
WHERE p.ProductName = 'Название товара';

-- Добавление данных об сборке при условии, что в заказе в поле ExistenceAssembling стоит "true" --
INSERT INTO furniture_salon_database.assembling (OrderId, Price, DateOfStartAssembling, Status)
SELECT o.OrderId, NOW() AS DateOfStartAssembling, 5000 AS Price 'В процессе' AS Status
FROM furniture_salon_database.order_customer o
WHERE o.ExistenceAssembling = TRUE;

-- Добавление данных об доставке при условии, что в заказе в поле ExistenceDelivery стоит "true" --
INSERT INTO furniture_salon_database.delivery (OrderId, Price, DateOfStartDelivery, Status)
SELECT o.OrderId, NOW() AS DateOfStartDelivery, 5000 AS Price 'В процессе' AS Status
FROM furniture_salon_database.order_customer o
WHERE o.ExistenceAssembling = TRUE;