CREATE DATABASE IF NOT EXISTS shop;
use shop;
-- То, что было сделано на уроках.
-- Домашнее задание к 4 уроку смотреть в нижней части файла!
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

/*
ДОМАШНЕЕ ЗАДАНИЕ
*/
-- Задание 1
-- 1. Подсчитайте средний возраст пользователей в таблице users.
-- SELECT name, TIMESTAMPDIFF(YEAR, birthday_at, NOW()) as age from users; /* Смотрим возрасты */
SELECT AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) as 'Средний возраст' from users;

-- Задание 2
-- 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
-- Следует учесть, что необходимы дни недели текущего года, а не года рождения.

-- Добавим еще пользователей с аналогичными датами, чтобы было, что группировать.
INSERT INTO users (name, birthday_at) VALUES
	('Ольга', '1987-11-12'),
    ('Олег', '1991-10-05'),
    ('Анатолий', '1975-05-20');
-- хотим, что-бы имена дней недели писались по русски
SET lc_time_names = 'ru_RU';
-- SELECT name, birthday_at from users; /* Смотрим какие там исходные даты в таблице */
-- Наш итоговый запрос, помним, что кол-во не вошедших дней (тут это вторник) равно нулю.
SELECT DATE_FORMAT(DATE_ADD(birthday_at, INTERVAL (YEAR(NOW()) - YEAR(birthday_at)) YEAR), '%W') as weekday, COUNT(*) as 'Количество' from users GROUP BY weekday ORDER BY DAYOFWEEK(DATE_ADD(birthday_at, INTERVAL (YEAR(NOW()) - YEAR(birthday_at)) YEAR));

-- Задание 3
-- 3. (по желанию) Подсчитайте произведение чисел в столбце таблицы.
SELECT ROUND(EXP(SUM(LOG(id)))) as 'Произведение id каталогов' FROM catalogs;