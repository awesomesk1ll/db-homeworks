CREATE DATABASE IF NOT EXISTS shop;
use shop;
-- То, что было сделано на уроке.
-- Домашнее задание смотреть в нижней части файла!
DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT 'Название раздела' /* , */
	-- UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет магазина';

INSERT IGNORE INTO catalogs VALUES
	(0, 'Процессоры'),
	(0, 'Мат.платы'),
	(0, 'Видеокарты');

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
INSERT INTO catalogs VALUES
	(DEFAULT, NULL),
	(0, ''),
	(0, NULL),
	(0, NULL);
-- Условие на уникальность оставить можно только в случае если там одна такая строка!
-- Но не потому, что не получится добавить несколько строк со значением NULL в поле name
-- (так как одно неопределённое значение (NULL) не равно другому NULL),
-- а потому, что не получится обновить несколько строк на значение 'empty', будет дубликация.
-- Так как у меня строк содержащих NULL 3шт - убрал в SQL коде урока уникальность поля name.
-- А теперь заменим строки с id c 4 по 7 c NULL или '' на 'empty'
SET SQL_SAFE_UPDATES = 0; /* Отключаем защиту от случайных ошибок при массовом обновлении */
UPDATE catalogs SET	name = 'empty' WHERE name IS NULL OR name = '';
SET SQL_SAFE_UPDATES = 1; /* Включаем защиту обратно */
-- SELECT * FROM catalogs; /* Смотрим результат */

-- задание 2
CREATE DATABASE IF NOT EXISTS upload_base;
use upload_base;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT 'Имя'
) COMMENT = 'Пользователи';

DROP TABLE IF EXISTS media;
CREATE TABLE media (
	id SERIAL PRIMARY KEY,
    media_owner_id BIGINT UNSIGNED COMMENT 'id пользователя-владельца',
	user_given_name VARCHAR(255) COMMENT 'Пользовательское имя файла',
    user_given_desc VARCHAR(255) COMMENT 'Пользовательское описание файла',
    file_id VARCHAR(255) COMMENT 'Тип файла photo/video/audio',
    filename VARCHAR(255) COMMENT 'Относительный путь до файла',
    mime_type VARCHAR(60) COMMENT 'MIME тип данных',
    size INT UNSIGNED COMMENT 'Размер файла',
    FOREIGN KEY (media_owner_id) REFERENCES users (id) /* внешний ключ на владельца файла */
) COMMENT = 'Медиа';

DROP TABLE IF EXISTS photos;
CREATE TABLE photos (
	id SERIAL PRIMARY KEY,
    media_id BIGINT UNSIGNED COMMENT 'id media',
    size_height INT UNSIGNED COMMENT 'Высота картинки',
    size_width INT UNSIGNED COMMENT 'Ширина картинки',
    user_desc VARCHAR(255) COMMENT 'Описание картинки',
    FOREIGN KEY (media_id) REFERENCES media (id) /* внешний ключ на media id */
) COMMENT = 'Фотки';

DROP TABLE IF EXISTS videos;
CREATE TABLE videos (
	id SERIAL PRIMARY KEY,
    media_id BIGINT UNSIGNED COMMENT 'id media',
	duration TIME DEFAULT '00:00:00' COMMENT 'Продолжительность видео',
    user_desc VARCHAR(255) COMMENT 'Описание видео',
    FOREIGN KEY (media_id) REFERENCES media (id) /* внешний ключ на media id */
) COMMENT = 'Видосики';

DROP TABLE IF EXISTS audios;
CREATE TABLE audios (
	id SERIAL PRIMARY KEY,
    media_id BIGINT UNSIGNED COMMENT 'id media',
	duration TIME DEFAULT '00:00:00' COMMENT 'Продолжительность аудио',
    user_desc VARCHAR(255) COMMENT 'Описание аудио',
    lyrics TEXT COMMENT 'Субтитры/текст песни',
    FOREIGN KEY (media_id) REFERENCES media (id) /* внешний ключ на media id */
) COMMENT = 'Аудиофайлы';

SET FOREIGN_KEY_CHECKS = 1;
-- результат задания 2 в виде схемы http://s01.geekpic.net/di-LXO5S8.png

-- задание 3
-- подготовка базы sample
CREATE DATABASE IF NOT EXISTS sample;
use sample;

DROP TABLE IF EXISTS cat;
CREATE TABLE cat (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT 'Название раздела'
) COMMENT = 'Разделы интернет магазина';

INSERT IGNORE INTO cat VALUES (0, 'intel');

-- тот самый запрос на копирование с заменой primary key (запрос 3 задания)
REPLACE INTO cat SELECT * FROM `shop`.`catalogs`;

-- смотрим итог 3 задания
INSERT IGNORE INTO cat VALUES (0, 'Проверка, где оказался автоинкремент');
SELECT * FROM cat;