-- Инициализируем начальное состояние. Домашнее задание к 7 уроку смотрим в нижней части файла.
CREATE DATABASE IF NOT EXISTS shop;
USE shop;

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) COMMENT 'Название раздела',
    UNIQUE unique_name (name (10))
)  COMMENT='Разделы интернет магазина';

INSERT IGNORE INTO catalogs VALUES
	(0, 'Процессоры'),
	(0, 'Мат.платы'),
	(0, 'Видеокарты'),
    (0, 'Жесткие диски'),
    (0, 'Оперативная память');
    
-- Домашнее задание к 7 уроку

-- Задание 1
-- 1. Создайте двух пользователей которые имеют доступ к базе данных shop. 
-- Первому пользователю shop_read должны быть доступны только запросы на чтение данных, 
-- второму пользователю shop — любые операции в пределах базы данных shop.
DROP USER IF EXISTS 'shop_read', 'shop';
START TRANSACTION; -- Предполагаю, что лучше в данной ситуации использовать транзакции.
	CREATE USER 'shop_read'@'%' IDENTIFIED BY '1Q2W3e4r';
	GRANT SELECT ON `shop`.* TO 'shop_read'@'%';
COMMIT;
START TRANSACTION;
	CREATE USER 'shop'@'%' IDENTIFIED BY '1Q2W3e4r';
	GRANT ALL PRIVILEGES ON `shop`.* TO 'shop'@'%';
COMMIT;
SHOW GRANTS FOR 'shop_read'; -- смотрим права пользователя-читателя базы shop
SHOW GRANTS FOR 'shop'; -- cмотрим права полноценного пользователя базы shop

-- Задание 2
-- 2. (по желанию) Есть таблица (accounts), включающая в себя три столбца: id, name, password, 
-- которые содержат первичный ключ, имя пользователя и его пароль. 
-- Создайте представление username таблицы accounts, предоставляющее доступ к столбцам id и name. 
-- Создайте пользователя user_read, который бы не имел доступа к таблице accounts, 
-- однако мог извлекать записи из представления username.
DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) COMMENT 'Имя пользователя',
    password VARCHAR(255) COMMENT 'Пароль пользователя'
);

INSERT INTO accounts(name,password) VALUES 
	("William","EDJ24QXN"),
	("Kelly","KUE51MNP"),
	("Abraham","MSZ19WPD"),
	("Quinlan","LTS52AWX"),
	("Demetrius","LMO87RIB"),
	("Cairo","BIK31XQK"); -- заполняем пользователей с паролями

CREATE OR REPLACE VIEW username AS
    SELECT 
        id, name
    FROM
        accounts; -- создаем представление

DROP USER IF EXISTS 'user_read';
START TRANSACTION; -- Предполагаю, что лучше в данной ситуации использовать транзакции.
	CREATE USER 'user_read'@'%' IDENTIFIED BY '1Q2W3e4r';
	GRANT SELECT ON `shop`.`username` TO 'user_read'@'%'; -- даем доступ только на чтение представления
COMMIT;