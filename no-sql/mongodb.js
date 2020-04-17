// Задание 3.
// 3. Организуйте хранение категорий и товарных позиций учебной базы 
// данных shop в СУБД MongoDB.
//
// Для начала я создал базу (кластер) в монго атлас (в облаке)
// https://www.mongodb.com/cloud/atlas
// скачал mongo shell
// https://downloads.mongodb.org/win32/mongodb-shell-win32-x86_64-2012plus-4.2.5.zip
// подключился к базе с помощью выданной cli команды для mongo shell.
//
// Решение:

// Мы в системе, переключаемся на работу с базой shop
use shop
// Создаем индекс на поле name с флагом unique, что-бы было нельзя инсертить повторы.
db.catalogs.createIndex({"name": 1}, {unique: true})
// Вставляем данные:
db.catalogs.insertMany([
    {"name": "Процессоры"},
    {"name": "Мат.платы"},
    {"name": "Видеокарты"},
    {"name": "Жесткие диски"},
    {"name": "Оперативная память"}
])
// Смотрим данные
db.catalogs.find()
// MongoDB Enterprise test-shard-0:PRIMARY> db.catalogs.find()
// { "_id" : ObjectId("5e99b741de54d1ee68115d6f"), "name" : "Процессоры" }
// { "_id" : ObjectId("5e99b741de54d1ee68115d70"), "name" : "Мат.платы" }
// { "_id" : ObjectId("5e99b741de54d1ee68115d71"), "name" : "Видеокарты" }
// { "_id" : ObjectId("5e99b741de54d1ee68115d72"), "name" : "Жесткие диски" }
// { "_id" : ObjectId("5e99b741de54d1ee68115d73"), "name" : "Оперативная память" }

// Пробуем вставить еще один документ с повтором в имени
db.catalogs.insertOne({"name": "Мат.платы"})
// MongoDB Enterprise test-shard-0:PRIMARY> db.catalogs.insertOne({"name":"Мат.платы"})
// 2020-04-17T21:06:25.349+0700 E  QUERY    [js] WriteError({
//         "index" : 0,
//         "code" : 11000,
//         "errmsg" : "E11000 duplicate key error collection: shop.catalogs index: name_1 dup key: { name: \"Мат.платы\" }",
//         "op" : {
//                 "_id" : ObjectId("5e99b7e1de54d1ee68115d74"),
//                 "name" : "Мат.платы"
//         }
// })
// Поймали ошибку дубликации, значит всё работает как надо).

// Теперь создадим и сразу заполним коллекцию продуктов.
db.products.insertMany([
    {"name": "AMD FX-8320", "description": "Процессор AMD", "price": 7120, "type": "Процессоры", "created_at": new Date(), "updated_at": new Date()},
    {"name": "AMD FX-8320E","description": "Процессор AMD", "price": 4780, "type": "Процессоры", "created_at": new Date(), "updated_at": new Date()},
    {"name": "Intel Core i3-8100", "description": "Процессор Intel", "price": 7890, "type": "Процессоры", "created_at": new Date(), "updated_at": new Date()},
    {"name": "Intel Core i5-7400", "description": "Процессор Intel", "price": 12700, "type": "Процессоры", "created_at": new Date(), "updated_at": new Date()},
    {"name": "ASUS ROG MAXIMUS X HERO", "description": "Z370, Socket 1151-v2, DDR4, ATX", "price": 19310, "type": "Мат.платы", "created_at": new Date(), "updated_at": new Date()},
    {"name": "Gigabyte H310M S2H", "description": "H310, Socket 1151-V2, DDR4, mATX", "price": 4790, "type": "Мат.платы", "created_at": new Date(), "updated_at": new Date()},
    {"name": "MSI B250M GAMING PRO", "description": "B250, Socket 1151, DDR4, mATX", "price": 5060, "type": "Мат.платы", "created_at": new Date(), "updated_at": new Date()},
    {"name": "GIGABYTE GeForce GTX 1660", "description": "Видеокарта Nvidia (PCI-E 3.0)", "price": 20840, "type": "Видеокарты", "created_at": new Date(), "updated_at": new Date()},
    {"name": "MSI GeForce GTX 1050TI", "description": "Видеокарта Nvidia (PCI-E 3.0)", "price": 13070, "type": "Видеокарты", "created_at": new Date(), "updated_at": new Date()},
    {"name": "KINGSTON KVR26N19S8/8", "description": "Память DDR 4 (8GB)", "price": 3590, "type": "Оперативная память", "created_at": new Date(), "updated_at": new Date()},
    {"name": "KINGSTON KVR16LS11/4", "description": "Память DDR3L (4GB)", "price": 2290, "type": "Оперативная память", "created_at": new Date(), "updated_at": new Date()}
])

// Тогда для отображения объекта самой дешевой видеокарты:
db.products.find({"type": "Видеокарты"}).sort({price: 1}).limit(1)

// или стоимость процессора AMD FX-8320 со скидкой 10% (7120*0.9=6408):
db.products.find({"name": "AMD FX-8320"}).map(d => d.price*0.9)[0] //map возвращает массив