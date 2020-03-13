CREATE DATABASE IF NOT EXISTS shop;
use shop;
-- То, что было сделано на уроках.
-- Домашнее задание к 3 уроку смотреть в нижней части файла!
DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT 'Название раздела',
	UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет магазина';

INSERT IGNORE INTO catalogs VALUES
	(0, 'Процессоры'),
	(0, 'Мат.платы'),
	(0, 'Видеокарты'),
    (0, 'Жесткие диски'),
    (0, 'Оперативная память');

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

-- Заполняем Users (урок 3)
INSERT INTO users (name, birthday_at) VALUES
	('Геннадий', '1990-10-05'),
    ('Наталья', '1984-11-12'),
    ('Александр', '1985-05-20'),
    ('Сергей', '1988-02-14'),
    ('Иван', '1998-01-12'),
	('Мария', '2006-08-29');

/*
ДОМАШНЕЕ ЗАДАНИЕ
*/
-- Задание 1
-- Подготавливаем исходное состояние для задания
SET SQL_SAFE_UPDATES = 0; /* Отключаем защиту от случайных ошибок при массовом обновлении */
UPDATE users SET created_at = NULL, updated_at = NULL;
-- SELECT * FROM users; /* Смотрим промежуточный результат */

-- Обновляем на текущее время поля в строках, где created_at и updated_at были не заполнены..
UPDATE users SET created_at = NOW(), updated_at = NOW() WHERE created_at IS NULL && updated_at IS NULL;
SET SQL_SAFE_UPDATES = 1; /* Включаем защиту обратно */
-- SELECT * FROM users; /* Смотрим результат */

-- Задание 2
-- Подготавливаем исходное состояние для задания
ALTER TABLE users CHANGE COLUMN created_at created_at VARCHAR(64), CHANGE COLUMN updated_at updated_at VARCHAR(64);
SET SQL_SAFE_UPDATES = 0;
UPDATE users SET created_at = '20.10.2017 8:10', updated_at = '20.10.2017 13:10';
-- SELECT * FROM users; /* Смотрим промежуточный результат */

-- Меняем формат даты на необходимый, с сохранением данных (сперва данные, потом формат)
UPDATE users SET created_at = STR_TO_DATE(created_at,'%d.%m.%Y %H:%i'), updated_at = STR_TO_DATE(updated_at,'%d.%m.%Y %H:%i');
SET SQL_SAFE_UPDATES = 1;	/* Включаем защиту обратно */
ALTER TABLE users CHANGE COLUMN created_at created_at DATETIME, CHANGE COLUMN updated_at updated_at DATETIME;
-- SELECT * FROM users; /* Смотрим результат */

-- Задание 3
-- Подготавливаем исходное состояние для задания
TRUNCATE TABLE storehouses_products;
INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES
	(500, 1, 0),
    (501, 1, 2500),
    (502, 1, 0),
    (503, 1, 30),
    (504, 1, 500),
	(505, 1, 1);
-- select * from storehouses_products; -- /* Смотрим исходный вариант */

-- Селектим с сортировкой все варианты, где value больше 0 и прицепляем все, где value = 0
(SELECT * FROM storehouses_products WHERE value > 0 ORDER BY value LIMIT 0,18446744073709551615)
UNION SELECT * FROM storehouses_products WHERE value = 0;

-- задание 4
-- Условие поиска ('may', 'august') определено в правой части запроса
SELECT * FROM users WHERE date_format(birthday_at, '%M') IN ('may', 'august');

-- задание 5
SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY field(id, 5, 1, 2);