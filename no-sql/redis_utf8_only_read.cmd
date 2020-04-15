echo off
cls
echo Так как у меня windows, а redis существует только в рамках линкусовых систем,
echo я буду разворачивать сервер в виде контейнера для докера.
echo Для этого качаю, устанавливаю, запускаю докер:
echo https://hub.docker.com/editions/community/docker-ce-desktop-windows
echo Далее выполняю команды в командной строке (cmd.exe):
echo.
echo 1. Cкачиваем образ с redis в докер:
echo on
docker pull redis
@echo 2. Разворачиваем и запускаем образ с редисом:
docker run --name test-redis -d redis
@REM docker start test-redis
@echo 3. Открываем шелл/командную строку образа с редисом.
@echo Дальше необходимо писать команды вручную:
@echo redis-cli (для запуска консольного клиента для редиса)
@echo Далее пишу команды в клиент редиса:
@echo.
@echo Задание 1.
@echo В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.
@echo Решение:
@echo Для подсчёта посещений с определенных IP-адресов можно сделать хэштаблицу visits,
@echo где в качестве ключей полей хештаблицы будут указываться ip-адреса,
@echo а в качестве значений полей хештаблицы будет указываться количество посещений.
@echo При любом посещении на сайт мы передаем в редис команду:
@echo HINCRBY visits [айпи-адрес] 1 (например HINCRBY visits 192.168.1.1 1)
@echo в ответе сразу же получаем текущее количество посещений с этого адреса.
@echo Для того что-бы посмотреть все посещения со всех адресов:
@echo HGETALL visits (нечётные строки - айпи адреса, четные - количество посещений с них)
@echo Для того что-бы узнать количество посещений с определенного адреса:
@echo HGET visits 192.168.1.1
@echo.
@echo Задание 2.
@echo 2. При помощи базы данных Redis решите задачу поиска имени пользователя 
@echo по электронному адресу и наоброт, поиск электронного адреса пользователя 
@echo по его имени.
@echo Решение:
@echo Насколько я понял, редис не осуществляет поиск по значениям.
@echo Тогда для решения такой задачи можно сделать две хештаблицы,
@echo email_by_uname для хранения емейлов по нику пользователя,
@echo и uname_by_email хранения ников по адресу почты.
@echo Заполяем хештаблицы тестовыми данными:
@echo HMSET email_by_uname admin admin@geekbrains.ru aleksey aleksey@skhom.ru alisa alisa@example.com
@echo HMSET uname_by_email admin@geekbrains.ru admin aleksey@skhom.ru aleksey alisa@example.com alisa
@echo Тогда для того что бы получить почту пользователя с ником admin
@echo выполняем HGET email_by_uname admin
@echo а для того что бы узнать юзернейм пользователя с почтой aleksey@skhom.ru
@echo выполняем HGET uname_by_email aleksey@skhom.ru
@echo ==================================================================
@echo redis-cli (не забываем войти в редис-кли)
docker exec -it /test-redis /bin/bash
pause