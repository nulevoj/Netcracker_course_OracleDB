/* 
Програмування активних БД на основі тригерів у мові PL/SQL.
Частина 4 - DDL-тригера та DB-тригера. 
Приклади створення
*/

SET LINESIZE 2000
SET PAGESIZE 60

/* Перехоплення DDL-подій - подія, яка виникає як
реакція на виконання операцій CREATE, ALTER, DROP

Під час обробки DDL-події доступні системні константи:
ORA_SYSEVENT – тип події, що викликала запуск тригера 
	(CREATE, ALTER, DROP);
ORA_LOGIN_USER – ім'я користувача;
ORA_DATABASE_NAME – ім'я БД;
ORA_CLIENT_IP_ADDRESS – IP-адреса клієнта;
ORA_DICT_OBJ_TYPE – тип об'єкта БД, 
	пов'язаного з DDL-інструкцією, 
	що викликала запуск тригера (наприклад, TABLE, INDEX);
ORA_DICT_OBJ_NAME – ім'я об'єкта БД
*/

/* Синтаксис створення тригера по DDL-події 

CREATE [OR REPLACE] TRIGGER ім'я_тригера
BEFORE|AFTER
ім'я_DDL_операції
ON ім'я_схеми.SCHEMA 
[WHEN(…)]
[DECLARE…]
BEGIN
 виконувані оператори
[EXCEPTION обробники винятків]
END;
*/

/* Приклад перехоплення DDL-подій */

-- Створити таблицю реєстрації DDL-подій
-- DROP TABLE who_created_object;
CREATE TABLE who_created_object (
	who_done_it VARCHAR2(30),
    when_created DATE,
    obj_name VARCHAR2(30),
    obj_type VARCHAR2(30)
);

-- Створити тригер реєстрації подій створення об'єктів
-- DROP TRIGGER track_created_objects;
CREATE OR REPLACE TRIGGER track_created_objects
	AFTER CREATE ON STUDENT.SCHEMA
BEGIN
	INSERT into who_created_object VALUES(
		ORA_LOGIN_USER, 
		SYSDATE, 
		ORA_DICT_OBJ_NAME, 
		ORA_DICT_OBJ_TYPE);
END;
/
SHOW ERRORS;

-- Тест-кейси перевірки роботи тригера
-- 1 Створити таблицю
-- DROP TABLE TEST3;
CREATE TABLE TEST3 ( 
	ID INTEGER, 
	NAME VARCHAR2(10)
);
-- 2 Перевірити таблицю реєстрації подій
SELECT * 
FROM who_created_object;

/* Перехоплення подій БД:
LOGON – під час запуску сеансу Oracle;
LOGOFF – при нормальному завершенні сеансу Oracle;
STARTUP – при відкритті БД;
SHUTDOWN – при нормальному закритті БД; 
SERVERERROR – у разі виникнення помилки Oracle.
*/

/* Приклад перехоплення подій БД */

-- Створити таблицю реєстрації подій
-- DROP TABLE database_audit;
CREATE TABLE database_audit (
	user_name varchar(20),
	logon_on_time date
);

-- Створити тригер реєстрації подій
-- DROP TRIGGER database_audit;
CREATE OR REPLACE TRIGGER database_audit
	AFTER LOGON ON DATABASE
BEGIN
	INSERT INTO database_audit VALUES(USER, SYSDATE);
END;
/
SHOW ERRORS;

-- Тест-кейси перевірки роботи тригера
-- 1 Вийти та повторно увійти користувачем

-- 2 Перевірити таблицю реєстрації подій
SELECT * 
FROM database_audit;


