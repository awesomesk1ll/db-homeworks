CREATE DATABASE IF NOT EXISTS shop;
USE shop;
-- То, что было сделано на уроках.
-- Домашнее задание к 6 уроку смотреть в нижней части файла!
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
-- 1. В базе данных shop и sample присутвуют одни и те же таблицы учебной базы данных.
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.
CREATE DATABASE IF NOT EXISTS sample;
DROP TABLE IF EXISTS sample.users;
CREATE TABLE sample.users LIKE shop.users; -- создаем пустую таблицу users

START TRANSACTION;
	INSERT INTO sample.users(id, name, birthday_at) SELECT id, name, birthday_at FROM shop.users WHERE shop.users.id = 1;
	DELETE FROM shop.users WHERE id = 1;
COMMIT;

SELECT * from sample.users; -- смотрим на таблицу sample.users
SELECT * from shop.users; -- смотрим на таблицу sample.users

-- вернём строчку обратно).
START TRANSACTION;
	INSERT INTO shop.users(id, name, birthday_at) SELECT id, name, birthday_at FROM sample.users WHERE sample.users.id = 1;
	DELETE FROM sample.users WHERE id = 1;
COMMIT;

SELECT * from sample.users; -- смотрим на таблицу sample.users
SELECT * from shop.users; -- смотрим на таблицу sample.users

-- Задание 2
-- 2. Создайте представление, которое выводит название (name) товарной позиции из таблицы products
-- и соответствующее название (name) каталога из таблицы catalogs.
-- Т.е. нужно вывести в представлении таблицу соответствий product.name и catalog.name.
CREATE OR REPLACE VIEW test AS SELECT p.name AS 'Имя товара', c.name AS 'Имя каталога' 
	FROM catalogs AS c JOIN PRODUCTS AS p
	WHERE c.id = p.catalog_id;

SELECT * FROM test; -- смотрим результат

-- Задание 3
-- 3. (по желанию) Пусть имеется таблица с календарным полем created_at. 
-- В ней размещены разряженые календарные записи за август 2018 года 
-- '2018-08-01', '2018-08-04', '2018-08-16' и 2018-08-17. 
-- Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1, 
-- если дата присутствует в исходном таблице и 0, если она отсутствует.

-- подготавливаем исходные данные
DROP TABLE IF EXISTS tbl3;
CREATE TABLE tbl3 (
	id SERIAL PRIMARY KEY,
	created_at DATETIME COMMENT 'Дата и время создания'
) COMMENT = 'Исходная таблица';
INSERT INTO tbl3(created_at) VALUES ('2018-08-01'), ('2018-08-04'), ('2018-08-16'), ('2018-08-17');
-- SELECT * FROM tbl3; -- смотрим, что там в таблице

-- Наш мега-запрос
SELECT days.day, IF(days.day IN (SELECT created_at FROM tbl3), 1, 0) AS 'соседние поля'
FROM 
	(SELECT DATE(ADDDATE('2018-08-01', INTERVAL @row := @row + 1 DAY)) AS day
		FROM mysql.help_category -- нужна ссылка на любую таблицу, где больше 30 строк
		JOIN (SELECT @row := -1) AS reset_row_value
		HAVING @row < DATEDIFF('2018-08-31', '2018-08-01')
	) AS days;
    
-- Задание 4
-- 4. (по желанию) Пусть имеется любая таблица с календарным полем created_at. 
-- Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.

-- подготовим данные для старта
TRUNCATE tbl3;
INSERT INTO tbl3(created_at)
	SELECT DATE(ADDDATE('2018-08-01', INTERVAL @row := @row + 1 DAY)) AS day
	FROM mysql.help_category -- нужна ссылка на любую таблицу, где больше 30 строк
	JOIN (SELECT @row := -1) AS reset_row_value
	HAVING @row < DATEDIFF('2018-08-31', '2018-08-01');
    
SELECT * FROM tbl3; -- глянем, что в таблице до удаления

SET SQL_SAFE_UPDATES = 0; /* Отключаем защиту от случайных ошибок при массовом обновлении */
-- Наш запрос
DELETE a FROM tbl3 AS a 
LEFT JOIN (SELECT created_at FROM tbl3 ORDER BY created_at DESC LIMIT 5) AS b
ON a.created_at = b.created_at -- соединяем рядом еще один столбик где в b.created_at будут только последних 5 значений
WHERE b.created_at IS NULL; -- и удаляем все строки где в b.created_at ничего не попало.

SET SQL_SAFE_UPDATES = 1;	/* Включаем защиту обратно */
SELECT * FROM tbl3; -- глянем, что в таблице после удаления