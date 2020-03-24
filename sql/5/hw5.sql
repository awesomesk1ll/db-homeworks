CREATE DATABASE IF NOT EXISTS shop;
use shop;
-- То, что было сделано на уроках.
-- Домашнее задание к 5 уроку смотреть в нижней части файла!
DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT 'Название раздела',
	UNIQUE unique_name(name(10))
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

INSERT IGNORE INTO catalogs VALUES
	(0, 'Процессоры'),
	(0, 'Мат.платы'),
	(0, 'Видеокарты'),
    (0, 'Жесткие диски'),
    (0, 'Оперативная память');

INSERT INTO users (name, birthday_at) VALUES
	('Геннадий', '1990-10-05'),
    ('Наталья', '1984-11-12'),
    ('Александр', '1985-05-20'),
    ('Сергей', '1988-02-14'),
    ('Иван', '1998-01-12'),
	('Мария', '2006-08-29');

INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES
	(500, 1, 0),
    (501, 1, 2500),
    (502, 1, 0),
    (503, 1, 30),
    (504, 1, 500),
	(505, 1, 1);

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

INSERT INTO orders (user_id) VALUES	(2), (5), (4), (5);
/*
ДОМАШНЕЕ ЗАДАНИЕ
*/
-- Задание 1
-- 1. Составьте список пользователей users, которые осуществили хотя бы один заказ (orders) в интернет-магазине.
SELECT * FROM users WHERE id IN (SELECT user_id from orders);

-- Задание 2
-- 2. Выведите список товаров products и разделов catalogs, который соответствует товару. 
-- (на видео Симдянов Игорь так и объяснил. Вывести 3 столбика: id, name, и имя каталога)
SELECT 
	products.id,
    products.name,
    (SELECT catalogs.name FROM catalogs WHERE catalogs.id = products.catalog_id) AS 'Раздел catalogs'
FROM products;
/* Вариант 2, с использованием JOIN
SELECT p.id, p.name, c.name
FROM catalogs AS c
JOIN products AS p
WHERE c.id = p.catalog_id;
*/

-- Задание 3
-- 3. (по желанию) Есть таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
-- Поля from, to и label содержат английские названия городов, поле name — русское. 
-- Выведите список рейсов (flights) с русскими названиями городов.
DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
	id SERIAL PRIMARY KEY,
    `from` VARCHAR(128) COMMENT 'Откуда',
    `to` VARCHAR(128) COMMENT 'Куда'
) COMMENT = 'Список рейсов';

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
    label VARCHAR(128) COMMENT 'en',
    name VARCHAR(128) COMMENT 'ru'
) COMMENT = 'Города';

INSERT INTO cities (label, name) VALUES
	('Novosibirsk', 'Новосибирск'),
	('Kemerovo', 'Кемерово'),
	('Tomsk', 'Томск'),
	('Omsk', 'Омск'),
	('Krasnoyarsk', 'Красноярск'),
	('Irkutsk', 'Иркутск'),
	('Barnaul', 'Барнаул');
    
INSERT INTO flights (`from`, `to`) VALUES
	('Novosibirsk', 'Omsk'),
    ('Barnaul', 'Novosibirsk'),
    ('Tomsk', 'Krasnoyarsk'),
    ('Irkutsk', 'Kemerovo');
    
-- SELECT * FROM flights; /* смотрим что там во flights */

SELECT
	flights.id,
    (SELECT name FROM cities WHERE flights.`from` = cities.label) AS `from`,
    (SELECT name FROM cities WHERE flights.`to` = cities.label) AS `to`
FROM flights;
