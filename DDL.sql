-- Создание базы данных мебельного салона --
CREATE SCHEMA IF NOT EXISTS furniture_salon_database;

-- Создание таблицы клинтов --
CREATE TABLE IF NOT EXISTS furniture_salon_database.customer (
    ClientId    SERIAL          PRIMARY KEY,
    ClientName  VARCHAR(64)     NOT NULL,
    PhoneNumber VARCHAR(64)     NOT NULL,
    Address     VARCHAR(256)    NOT NULL
);

-- Создание таблицы заказов клинтов --
CREATE TABLE IF NOT EXISTS furniture_salon_database.order_customer (
    OrderId             SERIAL          PRIMARY KEY,
    ClientId            INTEGER         REFERENCES furniture_salon_database.customer(ClientId) ON DELETE CASCADE,
    DateOfOrder         TIMESTAMP       NOT NULL,
    Status              VARCHAR(200)    NOT NULL,
    ExistenceDelivery   BOOLEAN         NOT NULL,
    ExistenceAssembling BOOLEAN         NOT NULL
);

-- Создание таблицы сущности "сборка" --
CREATE TABLE IF NOT EXISTS furniture_salon_database.assembling (
    UniqueId                SERIAL          PRIMARY KEY,
    OrderId                 INTEGER         REFERENCES furniture_salon_database.order_customer(OrderId) ON DELETE CASCADE,
    Price                   INTEGER         NOT NULL,
    DateOfStartAssembling   TIMESTAMP       NOT NULL,
    DateOfStopAssembling    TIMESTAMP       NOT NULL,
    Status                  VARCHAR(200)    NOT NULL
);

-- Создание таблицы сущности "доставка" --
CREATE TABLE IF NOT EXISTS furniture_salon_database.delivery (
    UniqueId            SERIAL          PRIMARY KEY,
    OrderId             INTEGER         REFERENCES furniture_salon_database.order_customer(OrderId) ON DELETE CASCADE,
    Price               INTEGER         NOT NULL,
    DateOfDelivery      TIMESTAMP       NOT NULL,
    DateOfStopDelivery  TIMESTAMP       NOT NULL,
    Status              VARCHAR(200)    NOT NULL
);

-- Создание таблицы товаров --
CREATE TABLE IF NOT EXISTS furniture_salon_database.product (
    ProductId       SERIAL         PRIMARY KEY,
    ProductName     VARCHAR(256)    NOT NULL,
    Price           INTEGER         NOT NULL CHECK (Price > 0),
    Characteristic  VARCHAR(256)    NOT NULL
);

-- Создание таблицы-связки между заказом клиента и товарами --
CREATE TABLE IF NOT EXISTS furniture_salon_database.link_order_customer_product (
    UniqueId        SERIAL      PRIMARY KEY,
    OrderId         INTEGER     REFERENCES furniture_salon_database.order_customer(OrderId) ON DELETE CASCADE,
    ProductId       INTEGER     REFERENCES furniture_salon_database.product(ProductId) ON DELETE CASCADE,
    CountOfProducts INTEGER     NOT NULL CHECK (CountOfProducts > 0)
);

-- Создание таблицы склада --
CREATE TABLE IF NOT EXISTS furniture_salon_database.warehouse (
    UniqueId            SERIAL      PRIMARY KEY,
    ProductId           INTEGER     REFERENCES furniture_salon_database.product(ProductId) ON DELETE CASCADE,
    CountOfProducts     INTEGER     NOT NULL CHECK (CountOfProducts >= 0)
);

-- Создание таблицы фабрик --
CREATE TABLE IF NOT EXISTS furniture_salon_database.manufacturer (
    ManufacturerId  SERIAL          PRIMARY KEY,
    Address         VARCHAR(256)    NOT NULL,
    FactoryName     VARCHAR(256)    NOT NULL
);

-- Создание таблицы заказов на фабрику --
CREATE TABLE IF NOT EXISTS furniture_salon_database.order_manufacturer (
    OrderId             SERIAL          PRIMARY KEY,
    ManufacturerId      INTEGER         REFERENCES furniture_salon_database.manufacturer(ManufacturerId) ON DELETE CASCADE,
    ProductId           INTEGER         REFERENCES furniture_salon_database.product(ProductId) ON DELETE CASCADE,
    DateOfOrder         TIMESTAMP       NOT NULL,
    Status              VARCHAR(200)    NOT NULL,
    CountOfProducts     INTEGER         NOT NULL CHECK (CountOfProducts > 0)
);