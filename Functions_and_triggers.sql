----------------------------------------------------------------------------------------------------------
--Функция-триггер и сам триггер. Функция удаляет данные связанные с заказом, который мы хотим удалить из--
--таблицы order_customer. Триггер срабатывает при удалении заказа и вызывает данную функцию.            --
----------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION clean_order_info() RETURNS trigger
AS $$
DECLARE
        i int;
BEGIN
    FOR i IN SELECT locp.productid
              FROM furniture_salon_database.link_order_customer_product locp
              WHERE locp.orderid = OLD.orderid
    LOOP
        UPDATE furniture_salon_database.order_manufacturer
        SET CountOfProducts = CountOfProducts - (SELECT locp.CountOfProducts
                                             FROM furniture_salon_database.link_order_customer_product locp
                                             WHERE locp.orderid = OLD.orderid and locp.productid = i)
        WHERE ProductId = i;
    END LOOP;
    DELETE FROM furniture_salon_database.order_manufacturer
    WHERE CountOfProducts = 0;
    DELETE FROM furniture_salon_database.link_order_customer_product
    WHERE OrderId = OLD.orderid;
    DELETE FROM furniture_salon_database.assembling
    WHERE OrderId = OLD.orderid;
    DELETE FROM furniture_salon_database.delivery
    WHERE OrderId = OLD.orderid;
    RETURN OLD;
END;
$$ LANGUAGE 'plpgsql';


CREATE OR REPLACE TRIGGER clean_order_info 
    BEFORE DELETE ON furniture_salon_database.order_customer
    FOR EACH ROW
    EXECUTE FUNCTION clean_order_info();
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
--Функция-триггер и сам триггер. Функция обновляет данные в заказе на фабрику в зависимости от изменения--
--количества определенного товара в заказе клиента. Триггер срабатывает при изменении данных столбца    --
--countofproducts в таблице link_order_customer_product                                                 --
----------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION update_countofproducts_in_om() RETURNS trigger
AS $$  
    BEGIN
        UPDATE furniture_salon_database.order_manufacturer
        SET CountOfProducts = CountOfProducts - (OLD.CountOfProducts - NEW.CountOfProducts)
        WHERE productid = OLD.productid;
        DELETE FROM furniture_salon_database.order_manufacturer
        WHERE CountOfProducts = 0;
        RETURN NEW;
    END;
$$ LANGUAGE 'plpgsql';


CREATE OR REPLACE TRIGGER update_countofproducts_in_order
    BEFORE UPDATE OF CountOfProducts ON furniture_salon_database.link_order_customer_product
    FOR EACH ROW
    EXECUTE FUNCTION update_countofproducts_in_om();
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
--Функция-триггер и сам триггер. Функция удаляет данные об доставке. Триггер срабатывает при изменении  --
--поля ExistenceDelivery в таблице order_customer и вызывает функцию если оно == false                  --
----------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION cancel_delivery() RETURNS trigger
AS $$
    BEGIN
        DELETE FROM furniture_salon_database.delivery
        WHERE orderid = OLD.orderid;
        RETURN NEW;
    END;
$$ LANGUAGE 'plpgsql';


CREATE OR REPLACE TRIGGER delete_delivery
    BEFORE UPDATE OF ExistenceDelivery ON furniture_salon_database.order_customer 
    FOR EACH ROW
    WHEN (NEW.ExistenceDelivery = false)
    EXECUTE FUNCTION cancel_delivery();
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------



----------------------------------------------------------------------------------------------------------
--Функция-триггер и сам триггер. Функция удаляет данные об сборке. Триггер срабатывает при изменении  --
--поля ExistenceAssembling в таблице order_customer и вызывает функцию если оно == false                  --
----------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION cancel_assembling() RETURNS trigger
AS $$
    BEGIN
        DELETE FROM furniture_salon_database.assembling 
        WHERE orderid = OLD.orderid;
        RETURN NEW;
    END;
$$ LANGUAGE 'plpgsql';


CREATE OR REPLACE TRIGGER delete_assembling
    BEFORE UPDATE OF ExistenceAssembling ON furniture_salon_database.order_customer
    FOR EACH ROW 
    WHEN (NEW.ExistenceAssembling = false)
    EXECUTE FUNCTION cancel_assembling();
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------



----------------------------------------------------------------------------------------------------------
-- Удаление всех таблиц                                                                                 --
----------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE delete_all_tables()
AS $$
    BEGIN
        DROP TABLE IF EXISTS furniture_salon_database.assembling;
        DROP TABLE IF EXISTS furniture_salon_database.delivery;
        DROP TABLE IF EXISTS furniture_salon_database.link_order_customer_product;
        DROP TABLE IF EXISTS furniture_salon_database.order_manufacturer;
        DROP TABLE IF EXISTS furniture_salon_database.product;
        DROP TABLE IF EXISTS furniture_salon_database.order_customer;
        DROP TABLE IF EXISTS furniture_salon_database.customer;
        DROP TABLE IF EXISTS furniture_salon_database.manufacturer;
    END;
$$ LANGUAGE 'plpgsql';
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------



----------------------------------------------------------------------------------------------------------
-- Удаление всех функций и триггеров                                                                    --
----------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE delete_all_triggers_func()
AS $$
    BEGIN
        DROP TRIGGER IF EXISTS clean_order_info on furniture_salon_database.order_customer;
        DROP TRIGGER IF EXISTS update_countofproducts_in_order on furniture_salon_database.link_order_customer_product;
        DROP TRIGGER IF EXISTS delete_delivery on furniture_salon_database.order_customer;
        DROP TRIGGER IF EXISTS delete_assembling on furniture_salon_database.order_customer;
        DROP FUNCTION IF EXISTS clean_order_info();
        DROP FUNCTION IF EXISTS update_countofproducts_in_om();
        DROP FUNCTION IF EXISTS cancel_delivery();
        DROP FUNCTION IF EXISTS cancel_assembling();
   END;
$$ LANGUAGE 'plpgsql';
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
