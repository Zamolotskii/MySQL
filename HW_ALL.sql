-- ***_____________Lesson 1.0_______________***
   ***_____________Lesson 1.0_______________***
-- ***_____________Lesson 1.0_______________***

______________________________TASK_1
-- Задание: Установите СУБД MySQL на персональный компьютер.
MySQL установлен!

______________________________TASK_2
-- Задание: Создайте DB example, разместите в ней табл. users, сост из 2х столбцов: числового id и строкового name. 
CREATE DATABASE example
USE example
CREATE TABLE IF NOT EXISTS users(
	ID INT,
	Name VARCHAR);

______________________________TASK_3 
-- Задание: Создайте дамп DB example, разверните содержимое дампа в DB sample.
CREATE DATABASE sample;
\q
mysqldump -u root -p example > xxx.sql
******
mysql new < xxx.sql -uroot -p******

______________________________CHECK:
#mysql -u root -p
******

SHOW TADABASES;
USE sample;
SHOW TABLES FROM sample;


______________________________TASK_4
-- Задание. Создайте дамп единственной табл help_keyword DB mysql. 
-- Добейтесь, чтобы дамп содержал только первые 100 строк

mysqldump mysql --tables help_keyword --where='true limit 100' > test.sql
******


--***_____________Lesson 2.0_______________***
  ***_____________Lesson 2.0_______________***
--***_____________Lesson 2.0_______________***


______________________________TASK_1
-- Задание. Пусть в табл. catalogs DB shop в строке name могут находиться пустые строки и поля принимающие значения Null.
-- Напишите запрос, кот заменяет все поля на строку 'empty'
USE DATABASE shop
UPDATE
  cataligs
SET 
  name = 'empty'
WHERE
  name '' or 
  name is null;

______________________________TASK_2
-- Спроектируйте DB, кот могла бы хранить меди-файлы загружаемые пользователем (фотоб видеоб аудио)ю
-- Сами файлы будут храниться в файловом хранилище. База будет хранить пути к файлам,
-- названия, описания, ключевые слова, и принадлежность к юзеру.


DROP TABLE IF EXISTS users;
CREATE TABLE users (
id SERIAL PRIMARY KEY,
name VARCHAR(255) COMMENT 'Имя пользователя',
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Пользователи';
*
DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types (
id SERIAL PRIMARY KEY,
alias VARCHAR(255) COMMENT 'Псевдоним',
name VARCHAR(255) COMMENT 'Описание медиа-типа: изображение, аудио, видео',
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Типы медиафайлов';
*
INSERT INTO media_types VALUES
(NULL, 'image', 'Изображения'),
(NULL, 'audio', 'Аудио'),
(NULL, 'video', 'Видео');
*
DROP TABLE IF EXISTS medias;
CREATE TABLE medias (
id SERIAL PRIMARY KEY,
media_type_id INT,
user_id INT,
filename VARCHAR(255) COMMENT 'Название файла',
size INT COMMENT 'Размер файла',
metadata JSON COMMENT 'Метаинформация',
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
INDEX index_of_user_id(user_id),
INDEX index_of_media_type_id(media_type_id)
) COMMENT = 'Медиафайлы';


______________________________TASK_3
-- Задание. В учебной DB shop, присутствует табл. catalogs. Пусть в DB sample имеется табл cat, в которой
-- могут присутствовать строки с такими же первичными ключами. Напишите запрос, 
-- кот копирует данные из табл catalogs в cat, при этом для записей с конфликтующими первичными ключами,
-- в таб cat должна производиться замена значениями из таблицы catalogs 

INSERT INTO
  cat
SELECT * FROM shop.catalogs AS sc
  ON DUPLICATE KEY UPDATE name = sc.name;

--***_____________Lesson 3.0_______________***
  ***_____________Lesson 3.0_______________***
--***_____________Lesson 3.0_______________***

-- 1.
-- Задание. Пусть в таблице users поля created_at и updated_at оказались незаполненными. 
-- Заполните их текущими датой и временем.

UPDATE users SET created_at = NOW(), updated_at = NOW();


-- 2.
-- Задание.  Таблица users была неудачно спроектирована. 
-- Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате
-- "20.10.2017 8:10". Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.

 DROP TABLE IF EXISTS users_first;
CREATE TABLE users_first (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(16),
  updated_at VARCHAR(16)
) COMMENT = 'Неправильные покупатели';

INSERT INTO users_first (name, created_at, updated_at) VALUES
  ('Дмитрий', '05.11.1986 08:45', '05.11.1986 08:45'),
  ('Ольга', '06.11.1982 08:45', '06.11.1982 08:45'),
  ('Платон', '13.12.2013 16:20', '13.12.2013 16:20'),
  ('Мирон', '20.07.2016 20:11', '20.07.2016 20:11');


DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Правильные покупатели';

INSERT INTO
  users
SELECT
    NULL,
    name,
    birthday_at,
    STR_TO_DATE(created_at, "%d.%m.%Y %H:%i") AS created_at,
    STR_TO_DATE(updated_at, "%d.%m.%Y %H:%i") AS updated_at
FROM users_first;

DROP TABLE users_first;

/* 2_var */ ВТОРОЙ ВАРИАНТ РЕШЕНИЯ
/* 2_var */ ВТОРОЙ ВАРИАНТ РЕШЕНИЯ
UPDATE
	users
SET
	created_at = str_to_date(created_at, '%d.%m.%Y %h:%i'),
  updated_at = str_to_date(updated_at, '%d.%m.%Y %h:%i');

ALTER TABLE users MODIFY created_at DATETIME, MODIFY updated_at DATETIME;

/* 2_var */ ВТОРОЙ ВАРИАНТ РЕШЕНИЯ
/* 2_var */ ВТОРОЙ ВАРИАНТ РЕШЕНИЯ

____________________Практическое задание тема №4
--__________________Практическое задание тема №4
____________________Практическое задание тема №4


______________________________TASK_1
-- Задание. Подсчитайте средний возраст пользователей в таблице users.

SELECT
    AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) AS avg_age
FROM users;


______________________________TASK_2
-- Задание. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
-- Следует учесть, что необходимы дни недели текущего года, а не года рождения.

SELECT 
    DAYNAME(
		DATE_FORMAT(
			DATE_ADD(birthday_at, INTERVAL (YEAR(NOW()) - YEAR(birthday_at)) YEAR), '%Y-%m-%d'
		)
	) AS day_of_born,
    COUNT(*)
FROM users
GROUP BY day_of_born;


______________________________TASK_3
-- Задание. Подсчитайте произведение чисел в столбце таблицы

DROP TABLE IF EXISTS tabl;
CREATE TABLE tabl (
    value INT NOT NULL
);

INSERT INTO tabl VALUES
    (1), (2), (3), (4), (5);

SELECT ROUND(EXP(SUM(LN(value)))) FROM tabl;


--***_____________Lesson 5.0_______________***
  ***_____________Lesson 5.0_______________***
--***_____________Lesson 5.0_______________***

______________________________TASK_1
-- Задание. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

INSERT INTO orders
  (user_id)
VALUES
  (1), (3), (5), (3);

SELECT
    id, name
FROM
    users
WHERE
    id IN (
        SELECT DISTINCT user_id FROM orders
    );

SELECT DISTINCT
    users.id, users.name
FROM
    users JOIN orders on users.id = orders.user_id;


______________________________TASK_2
-- Задание. Выведите список товаров products и разделов catalogs, который соответствует товару.

SELECT
	p.id, p.name, p.description, p.price, c.name AS catalog_name, p.created_at, p.updated_at
FROM
	products AS p 
LEFT JOIN 
  catalogs AS c
ON
	p.catalog_id = c.id


______________________________TASK_3
-- Задание. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
-- Поля from, to и label содержат английские названия городов, поле name — русское. 
-- Выведите список рейсов flights с русскими названиями городов.
CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  `from` VARCHAR(20),
  `to` VARCHAR(20)
);

INSERT INTO flights
  (`from`, `to`)
VALUES
  ('moscow', 'omsk'),
  ('novgorod', 'kazan'),
  ('irkutsk', 'moscow'),
  ('omsk', 'irkutsk'),
  ('moscow', 'kazan');

CREATE TABLE cities (
    label VARCHAR(20),
    name VARCHAR(20)
);

INSERT INTO cities
  (label, name)
VALUES
  ('moscow', 'Москва'),
  ('irkutsk', 'Иркутск'),
  ('novgorod', 'Новгород'),
  ('kazan', 'Казань'),
  ('omsk', 'Омск');


SELECT
  f.id, c1.name, c2.name
FROM
	flights AS f
  LEFT JOIN cities AS c1 ON f.from = c1.label
  LEFT JOIN cities AS c2 ON f.to = c2.label
ORDER BY 
  f.id;


--***_____________Lesson 6.0_______________***
  ***_____________Lesson 6.0_______________***
--***_____________Lesson 6.0_______________***


______________________________TASK_1
-- Задание. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

START TRANSACTION; 

INSERT INTO sample.users
SELECT * FROM shop.users
WHERE id = 1;
DELETE FROM shop.users
WHERE id = 1

COMMIT;


______________________________TASK_2
-- Задание. Создайте представление, которое выводит название name товарной позиции из таблицы products 
-- и соответствующее название каталога name из таблицы catalogs.

CREATE OR REPLACE VIEW prod_ AS
SELECT
	p.name AS p_n,
  c.name AS c_n
FROM
	products AS p
JOIN
	catalogs AS c
ON 
  p.catalog_id = c.id;
SELECT * FROM prod_;

______________________________TASK_3
-- Задание. (по желанию) Пусть имеется таблица с календарным полем created_at. 
-- В ней размещены разряженые календ. записи за авг 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. 
-- Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1, 
-- если дата присутствует в исходном таблице и 0, если она отсутствует.

DROP TABLE IF EXISTS dates;
CREATE TABLE dates (date DATE);
INSERT INTO dates VALUES ('2018-08-01'), ('2018-08-04'), ('2018-08-16'), ('2018-08-17');

DROP TABLE IF EXISTS august;
CREATE TABLE august (days DATE);
INSERT INTO august VALUES ('2018-08-01'), ('2018-08-02'),
('2018-08-03'), ('2018-08-04'),('2018-08-05'), ('2018-08-06'),
('2018-08-07'), ('2018-08-08'), ('2018-08-09'), ('2018-08-10'),
('2018-08-11'), ('2018-08-12'), ('2018-08-13'), ('2018-08-14'),
('2018-08-15'), ('2018-08-16'), ('2018-08-17'), ('2018-08-18'),
('2018-08-19'), ('2018-08-20'), ('2018-08-21'), ('2018-08-22'),
('2018-08-23'), ('2018-08-24'), ('2018-08-25'), ('2018-08-26'),
('2018-08-27'), ('2018-08-28'), ('2018-08-29'), ('2018-08-30'),
('2018-08-31');

SELECT days, IF (days IN (SELECT * FROM dates), 1, 0) AS value FROM august;



______________________________TASK_4
-- Задание. (по желанию) Пусть имеется любая таблица с календарным полем created_at. 
-- Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.

DROP TABLE IF EXISTS day_;
CREATE TABLE day_ (date DATE);

INSERT INTO day_ 
VALUES 
  ('1167-03-01'), ('1318-04-04'), ('1444-03-11'), ('1666-06-06'), ('1703-05-27'), 
  ('1812-08-11'), ('1917-10-07'), ('1944-05-09'), ('1986-11-05'), ('2019-06-01');


DROP TABLE IF EXISTS tabl_temp;
CREATE TABLE TEMPORARY tabl_temp (date DATE);

INSERT INTO tabl_temp SELECT * FROM day_ ORDER BY date DESC LIMIT 5;

DELETE FROM day_ WHERE date NOT IN (SELECT * FROM tabl_temp);


--***_____________Lesson 7.0_______________***
  ***_____________Lesson 7.0_______________***
--***_____________Lesson 7.0_______________***


______________________________TASK_1
-- Задание. Создайте двух пользователей которые имеют доступ к базе данных shop. 
-- Первому пользователю shop_read должны быть доступны только запросы на чтение данных, 
-- второму пользователю shop — любые операции в пределах базы данных shop.
CREATE USER 'shop_read'@'localhost';
CREATE USER 'shop'@'localhost';

GRANT SELECT, SHOW VIEW ON shop.*
TO 'shop'@'localhost' IDENTIFIED BY '';

GRANT ALL ON shop.*
TO 'shop'@'localhost' IDENTIFIED BY '';


______________________________TASK_2 
-- Задание. (по желанию) Пусть имеется таблица accounts содержащая три столбца id, name, password, 
-- содержащие первичный ключ, имя пользователя и его пароль. 
-- Создайте представление username таблицы accounts, предоставляющий доступ к столбца id и name. 
-- Создайте пользователя user_read, который бы не имел доступа к таблице accounts, однако, 
-- мог бы извлекать записи из представления username.

CREATE TABLE accounts (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50),
  password VARCHAR(255)
);

INSERT INTO
  `accounts` (`id`, `name`, `password`)
VALUES
  ('1', 'Dima', 'qwerty'),
  ('2', 'Olga', '123456'),
  ('3', 'Platon', 'asdfgh'),
  ('4', 'Miron', 'zxcvbn');


CREATE VIEW username AS SELECT id, name FROM accounts;

CREATE USER 'user_read'@'localhost';

GRANT SELECT (id, name) ON shop.username
TO 'user_read'@'localhost';

--***_____________Lesson 8.0_______________***
  ***_____________Lesson 8.0_______________***
--***_____________Lesson 8.0_______________***

______________________________TASK_1
-- Задание. Создайте хранимую функцию hello(), которая будет возвращать приветствие,
-- в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать
-- фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день",
-- с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

DELIMITER //
DROP FUNCTION IF EXISTS hello//
CREATE FUNCTION hello()
RETURNS VARCHAR(20)
BEGIN
	DECLARE time_ INT;
    SET time_ = HOUR(NOW());
	CASE
		WHEN time_ >= 6 AND curHour < 12 THEN
			RETURN 'Доброе утро';
		WHEN time_ >= 12 AND curHour < 18 THEN
			RETURN 'Добрый день';
		WHEN time_ BETWEEN 18 AND 24 THEN
			RETURN 'Добрый вечер';
		ELSE
			RETURN 'Доброй ночи';
	END CASE;
END//
DELIMITER ;
SELECT hello()


______________________________TASK_2
-- Задание. В таблице products есть два текстовых поля: name с названием товара и
-- description с его описанием. Допустимо присутствие обоих полей или одно
-- из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
-- При попытке присвоить полям NULL-значение необходимо отменить операцию

DELIMITER //
DROP TRIGGER IF EXISTS check_null_value_insert//
CREATE TRIGGER check_null_value_insert BEFORE INSERT ON products
FOR EACH ROW
BEGIN
	IF NEW.name IS NULL AND NEW.description IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Incorret value in name or description fields';
	END IF;
END//

DROP TRIGGER IF EXISTS check_null_value_update//
CREATE TRIGGER check_null_value_update BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
	IF NEW.name IS NULL AND NEW.description IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Incorret value in name or description fields';
	END IF;
END//
DELIMITER ;


______________________________TASK_3
-- Задание. (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. 
-- Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. 
-- Вызов функции FIBONACCI(10) должен возвращать число 55.



--***_____________Lesson 9.0_______________***
  ***_____________Lesson 9.0_______________***
--***_____________Lesson 9.0_______________***

______________________________TASK_1
-- Задание. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, 
-- catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы,
-- идентификатор первичного ключа и содержимое поля name.

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    time DATETIME,
    table_name VARCHAR(15),
    id_pk BIGINT,
    name VARCHAR(20)
) ENGINE=Archive;

DELIMITER //
DROP TRIGGER IF EXISTS users_insert//
DROP TRIGGER IF EXISTS catalogs_insert//
DROP TRIGGER IF EXISTS products_insert//


CREATE TRIGGER users_insert AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs
	VALUES (DEFAULT, NOW(), 'users', NEW.id, NEW.name);
END//

CREATE TRIGGER catalogs_insert AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs
	VALUES (DEFAULT, NOW(), 'catalogs', NEW.id, NEW.name);
END//

CREATE TRIGGER products_insert AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs
	VALUES (DEFAULT, NOW(), 'products', NEW.id, NEW.name);
END//
DELIMITER ;

______________________________TASK_2
-- Задание. (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.

mysql> SELECT * FROM users;
+----+-------------+---------------------+---------------------+
| id | name        | created_at          | updated_at          |
+----+-------------+---------------------+---------------------+
| 1  | Dima        | 1986-11-05 08:45:00 | 1986-11-05 08:45:00 |
| 2  | Olga        | 1982-11-06 08:45:00 | 1982-11-06 08:45:00 |
| 3  | Platon      | 2013-12-13 16:20:00 | 2013-12-13 16:20:00 |
| 4  | Miron       | 2016-07-20 20:11:00 | 2016-07-20 20:11:00 |
+----+-------------+---------------------+---------------------+

DELIMITER //
DROP PROCEDURE IF EXISTS million//
CREATE PROCEDURE million()
BEGIN
	SET @w = 0;
    REPEAT
		INSERT INTO users
			VALUES (NULL, 'User_#', NOW(), NOW()),
            (NULL, 'User_#', NOW(), NOW()),
            (NULL, 'User_#', NOW(), NOW()),
            (NULL, 'User_#', NOW(), NOW()),
		SET @w = @w + 1;
	UNTIL @w > 250000
	END REPEAT;
END//
DELIMITER ;



--***_____________Lesson 10.0_______________***
  ***_____________Lesson 10.0_______________***
--***_____________Lesson 10.0_______________***

______________________________TASK_1
-- Задание. В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.

HMSET IP_addres '192.168.43.1' 0 '192.168.43.2' 0 '192.168.43.3' 0

HINCRBY IP_addres '192.168.43.1' 1
HINCRBY IP_addres '192.168.43.2' 1

HGETALL IP_addres

______________________________TASK_2
-- Задание.При помощи базы данных Redis решите задачу поиска имени пользователя
-- по электронному адресу и наоборот, поиск электронного адреса пользователя по его имени.

HMSET user 'dima' 'dima@email.com' 'olga' 'olga@email.com' 'platon' 'platon@email.com' 'miron' 'miron@email.com'
HMSET email 'dima@email.com' 'dima' 'olga@email.com' 'olga' 'platon@email.com' 'platon' 'miron@email.com' 'miron' 


______________________________TASK_3
-- Задание.Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.
db.shop.insert({
  'catalogs':[
    {'id': 1, 'name': 'Процессоры'},
    {'id': 2, 'name': 'Видеокарты'},
    {'id': 3, 'name': 'Жесткие диски'},
    {'id': 4, 'name': 'Оперативная память'}],
  'product':[
    {'name': 'Intel Core i3-8100', 'description': 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 'price': 7890.00, 'catalog_id': 1},
    {'name': 'Intel Core i3-8100', 'description': 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 'price': 7890.00, 'catalog_id': 1},
    {'name': 'Intel Core i5-7400', 'description': 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 'price': 12700.00, 'catalog_id': 1},
    {'name': 'AMD FX-8320E', 'description': 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 'price':4780.00, 'catalog_id': 1},
    {'name': 'AMD FX-8320', 'description': 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 'price': 7120.00, 'catalog_id': 1},
    {'name': 'ASUS ROG MAXIMUS X HERO', 'description': 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 'price': 19310.00, 'catalog_id': 2},
    {'name': 'Gigabyte H310M S2H', 'description': 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 'price': 4790.00, 'catalog_id': 2},
    {'name': 'MSI B250M GAMING PRO', 'description': 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 'price': 5060.00, 'catalog_id': 2}]
})

