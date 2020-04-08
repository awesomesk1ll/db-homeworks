-- Инициализируем начальное состояние. Домашнее задание к 8 уроку смотрим в нижней части файла.
CREATE DATABASE IF NOT EXISTS shop;
USE shop;

DROP TABLE IF EXISTS products;
CREATE TABLE products (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT 'Название',
	description TEXT COMMENT 'Описание',
	price DECIMAL(11,2) COMMENT 'Цена',
	catalog_id INT UNSIGNED,
	created_at DATETIME COMMENT 'Дата и время создания' DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME COMMENT 'Дата и время обновления' DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	KEY index_of_catalog_id(catalog_id)
) COMMENT = 'Товарные позиции';
    
-- Домашнее задание к 8 уроку

-- Задание 1
-- 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие,
-- в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро",
-- с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер",
-- с 00:00 до 6:00 — "Доброй ночи".
DROP FUNCTION IF EXISTS hello;
DELIMITER //
CREATE FUNCTION hello() RETURNS VARCHAR(128) DETERMINISTIC
BEGIN
	DECLARE hours TINYINT DEFAULT HOUR(NOW());
	CASE 
		WHEN hours>=18 THEN RETURN 'Добрый вечер';
		WHEN hours>=12 THEN RETURN 'Добрый день';
		WHEN hours>=6 THEN RETURN 'Доброе утро';
		ELSE RETURN 'Доброе утро';
	END CASE;
END//
DELIMITER ;

SELECT HELLO() AS 'Приветствие'; -- Проверяем нашу новую функцию

-- Задание 2
-- 2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием.
-- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают 
-- неопределенное значение NULL неприемлема. Используя триггеры, добейтесь того, 
-- чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить обоим полям 
-- NULL-значение необходимо отменить операцию.
DROP TRIGGER IF EXISTS check_insert_products;
DROP TRIGGER IF EXISTS check_update_products;

DELIMITER //
CREATE TRIGGER check_insert_products BEFORE INSERT ON products FOR EACH ROW
BEGIN
	IF (NEW.name IS NULL && NEW.description IS NULL) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ошибка вставки: поля name и description равны NULL';
    END IF;
END//

CREATE TRIGGER check_update_products BEFORE UPDATE ON products FOR EACH ROW
BEGIN
	IF (NEW.name IS NULL && NEW.description IS NULL) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ошибка обновления: поля name и description равны NULL';
    END IF;
END//
DELIMITER ;

INSERT INTO products(name, description) VALUES
	('AMD FX-8320', 'Процессор AMD'),
	('AMD FX-8320E', 'Процессор AMD'),
	('Intel Core i3-8100', NULL),
	(NULL, 'Процессор Intel'),
	('ASUS ROG MAXIMUS X HERO', 'Z370, Socket 1151-v2, DDR4, ATX'),
	('Gigabyte H310M S2H', NULL),
	('MSI B250M GAMING PRO', NULL); -- Вставка работает.
    
SELECT * FROM products; -- Проверяем что последний запрос вставки не прошёл.

UPDATE products
	SET name = NULL, description = 'Материнская плата MSI B250M' -- Пробуем обнулить имя материнской платы, description которой равен NULL.
    WHERE id = 7; -- Всё ок, т.к одно поле вновь будет не NULL.

SELECT * FROM products; -- Проверяем что запросы выполнились как нужно.

-- Дальше будут варианты с ошибочными попытками вставки или обновления данных, для проверки их нужно раскомментировать

-- INSERT IGNORE INTO products(name, description) VALUES
-- ('AMD FX-8310', 'Процессор AMD'),
-- (NULL, NULL),
-- ('AMD FX-8330', 'Процессор AMD'); -- Весь запрос отклонён.

-- UPDATE IGNORE products
-- SET description = NULL -- Пробуем обнулить описание MSI B250M, name которой равно NULL.
-- WHERE id = 7; -- Запрос отклонён.
        
-- SELECT * FROM products; -- Смотрим, что последние два запроса не проходят.

-- Задание 3
-- 3. (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи.
-- Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел.
-- Вызов функции FIBONACCI(10) должен возвращать число 55.
DROP FUNCTION IF EXISTS FIBONACCI;
DELIMITER //
CREATE FUNCTION FIBONACCI(count INT) RETURNS BIGINT DETERMINISTIC
BEGIN
	DECLARE m BIGINT DEFAULT 0;
	DECLARE k BIGINT DEFAULT 1;
	DECLARE i INT DEFAULT 1;
	DECLARE tmp BIGINT;
	WHILE (i<=count) DO
		SET tmp=m+k, m=k, k=tmp, i=i+1;
	END WHILE;
    RETURN m;
END//
DELIMITER ;

-- Проверяем нашу новую функцию
SELECT FIBONACCI(10) AS '10-ое Фибоначчи', FIBONACCI(77) AS '77-ое Фибоначчи';
