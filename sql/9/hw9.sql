DROP DATABASE IF EXISTS shop;
CREATE DATABASE shop;
USE shop;
-- То, что было сделано на уроках.
-- Домашнее задание к 9 уроку смотреть в нижней части файла!
DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT 'Название раздела',
	UNIQUE unique_name(name(10)),
    created_at DATETIME COMMENT 'Дата и время создания' DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME COMMENT 'Дата и время обновления' DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Разделы интернет магазина';

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT 'Имя пользователя',
	birthday_at DATE COMMENT 'Дата рождения',
	created_at DATETIME COMMENT 'Дата и время создания' DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME COMMENT 'Дата и время обновления' DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

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

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
	id SERIAL PRIMARY KEY,
	user_id INT UNSIGNED,
	created_at DATETIME COMMENT 'Дата и время создания' DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME COMMENT 'Дата и время обновления' DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	key index_of_user_id(user_id)
) COMMENT = 'Заказы';

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
	id SERIAL PRIMARY KEY,
	order_id INT UNSIGNED,
	product_id INT UNSIGNED,
	total INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
	created_at DATETIME COMMENT 'Дата и время создания' DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME COMMENT 'Дата и время обновления' DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Состав заказа';

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
	id SERIAL PRIMARY KEY,
	user_id INT UNSIGNED,
	product_id INT UNSIGNED,
	discount FLOAT UNSIGNED COMMENT 'Величина скидки от 0.0 до 1.0',
	started_at DATETIME,
	finished_at DATETIME,
	created_at DATETIME COMMENT 'Дата и время создания' DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME COMMENT 'Дата и время обновления' DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	KEY index_of_user_id(user_id),
	KEY index_of_product_id(product_id)
) COMMENT = 'Скидки';

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT 'Название',
	created_at DATETIME COMMENT 'Дата и время создания' DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME COMMENT 'Дата и время обновления' DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Склады';

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
	id SERIAL PRIMARY KEY,
	storehouse_id INT UNSIGNED,
	product_id INT UNSIGNED,
	value INT UNSIGNED COMMENT 'Количество данного товара на складе',
	created_at DATETIME COMMENT 'Дата и время создания' DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME COMMENT 'Дата и время обновления' DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы товаров на складе';

/*
ДОМАШНЕЕ ЗАДАНИЕ
*/
-- Задание 1
-- 1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах 
-- users, catalogs и products в таблицу logs помещается время и дата создания записи, 
-- название таблицы, идентификатор первичного ключа и содержимое поля name.
DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	table_value_created_at DATETIME COMMENT 'Дата и время создания записи',
	table_name VARCHAR(64) COMMENT 'Имя логируемой таблицы',
	table_primary_key BIGINT UNSIGNED COMMENT 'Значение первичного ключа из таблицы',
	table_value_name VARCHAR(255) COMMENT 'Значение name из таблицы'
) ENGINE = archive COMMENT = 'Таблица с логами';

DROP TRIGGER IF EXISTS log_users;
DROP TRIGGER IF EXISTS log_catalogs;
DROP TRIGGER IF EXISTS log_products;
DELIMITER $$
CREATE TRIGGER log_users AFTER INSERT ON users FOR EACH ROW
BEGIN
	INSERT INTO logs(table_value_created_at, table_name, table_primary_key, table_value_name) 
	VALUES (NEW.created_at, 'users', NEW.id, NEW.name);
END$$

CREATE TRIGGER log_catalogs AFTER INSERT ON catalogs FOR EACH ROW
BEGIN
	INSERT INTO logs(table_value_created_at, table_name, table_primary_key, table_value_name) 
	VALUES (NEW.created_at, 'catalogs', NEW.id, NEW.name);
END$$

CREATE TRIGGER log_products AFTER INSERT ON products FOR EACH ROW
BEGIN
	INSERT INTO logs(table_value_created_at, table_name, table_primary_key, table_value_name) 
	VALUES (NEW.created_at, 'products', NEW.id, NEW.name);
END$$
DELIMITER ;

INSERT INTO users (name, birthday_at) VALUES
	('Геннадий', '1990-10-05'),
    ('Наталья', '1984-11-12'),
    ('Александр', '1985-05-20'),
    ('Сергей', '1988-02-14'),
    ('Иван', '1998-01-12'),
	('Мария', '2006-08-29');
    
INSERT IGNORE INTO catalogs(name) VALUES
	('Процессоры'),
	('Мат.платы'),
	('Видеокарты'),
    ('Жесткие диски'),
    ('Оперативная память');
    
INSERT INTO products (name, description, price, catalog_id) VALUES
	('AMD FX-8320', 'Процессор AMD', 7120, 1),
	('AMD FX-8320E', 'Процессор AMD', 4780, 1),
	('Intel Core i3-8100', 'Процессор Intel', 7890, 1),
	('Intel Core i5-7400', 'Процессор Intel', 12700, 1),
	('ASUS ROG MAXIMUS X HERO', 'Z370, Socket 1151-v2, DDR4, ATX', 19310, 2),
	('Gigabyte H310M S2H', 'H310, Socket 1151-V2, DDR4, mATX', 4790, 2),
	('MSI B250M GAMING PRO', 'B250, Socket 1151, DDR4, mATX', 5060, 2),
	('GIGABYTE GeForce GTX 1660', 'Видеокарта Nvidia (PCI-E 3.0)', 20840, 3),
	('MSI GeForce GTX 1050TI', 'Видеокарта Nvidia (PCI-E 3.0)', 13070, 3),
	('KINGSTON KVR26N19S8/8', 'Память DDR 4 (8GB)', 3590, 5),
	('KINGSTON KVR16LS11/4', 'Память DDR3L (4GB)', 2290, 5);
    
SELECT * FROM logs; -- смотрим наши логи

DROP TRIGGER log_users;
DROP TRIGGER log_catalogs;
DROP TRIGGER log_products;

-- Задание 2
-- 2. (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.
TRUNCATE users; -- Чистим таблицу users.

INSERT INTO users(name, birthday_at) SELECT CONCAT('Геннадий №', num), '1990-10-05' FROM
	(SELECT a.N + b.N * 100 + c.N * 10000 + 1 AS num FROM 
		(SELECT help_keyword_id AS N FROM mysql.help_keyword ORDER BY N LIMIT 100) AS a,
		(SELECT help_keyword_id AS N FROM mysql.help_keyword ORDER BY N LIMIT 100) AS b,
		(SELECT help_keyword_id AS N FROM mysql.help_keyword ORDER BY N LIMIT 100) AS c
	) AS million_rows; -- Добавим миллион Геннадиев.
    
SELECT * FROM users ORDER BY id DESC LIMIT 5; -- Смотрим последних 5 Геннадиев.