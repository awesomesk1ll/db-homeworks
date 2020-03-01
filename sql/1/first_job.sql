-- создаем базу
CREATE SCHEMA `example`;
-- добавляем в базу таблицу
CREATE TABLE `example`.`users` (
  `id` INT NOT NULL,
  `name` CHAR(45) NOT NULL,
  PRIMARY KEY (`id`));