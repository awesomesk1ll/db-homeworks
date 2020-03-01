rem 1 задание в файле first_job.sql
mysql < first_job.sql

rem Создание дампа базы example
mysqldump --databases example > example_db_dump.sql

rem Далее я сделал ручками копию example_db_dump.sql 
rem в которой имя базы в двух местах заменил на sample
rem итоговый файл называется sample_db_import.sql

rem развертка базы sample
mysql < sample_db_import.sql

rem создание дампа таблицы `mysql`.`help_keyword` с лимитом 100 строк
mysqldump --databases mysql --tables help_keyword --where="1 limit 100" > help_keyword_dump.sql

rem создание дампа таблицы `mysql`.`help_keyword` с лимитом 100 строк по возрастанию ID
mysqldump --databases mysql --tables help_keyword --where="1 ORDER BY help_keyword_id limit 100" > help_keyword_ordered_dump.sql