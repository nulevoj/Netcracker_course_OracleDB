
-- Етап 4. DDL-тригера та DB-тригера

/*
	1. Створити таблицю для реєстрації наступних DDL-подій: тип події, 
	що спричинила запуск тригера; ім'я користувача; ім'я об'єкта БД. 
	Створити тригер реєстрації заданих подій створення об'єктів. 
	Подати тест-кейси перевірки роботи тригера.
*/

CREATE TABLE schema_track (
	username VARCHAR2(30),
	operation VARCHAR2(6),
	object VARCHAR2(30)
);

CREATE OR REPLACE TRIGGER schema_track_trig
	AFTER CREATE OR ALTER OR DROP ON SYECHYN.SCHEMA
BEGIN
	INSERT INTO schema_track (
			username,
			operation,
			object)
		VALUES (
			ORA_LOGIN_USER,
			ORA_SYSEVENT,
			ORA_DICT_OBJ_NAME);
END;

CREATE TABLE test (
	id INTEGER,
	text VARCHAR2(10)
);
ALTER TABLE test ADD text2 VARCHAR2(10);
ALTER TABLE test RENAME COLUMN text2 TO text3;
ALTER TABLE test DROP COLUMN text3;
DROP TABLE test;

SELECT * FROM schema_track;

ROLLBACK;
ALTER TRIGGER schema_track_trig DISABLE;

/*
	Table SCHEMA_TRACK created.
	Trigger SCHEMA_TRACK_TRIG compiled
	Table TEST created.
	Table TEST altered.
	Table TEST altered.
	Table TEST altered.
	Table TEST dropped.
	
	SELECT * FROM schema_track;
	USERNAME	OPERATION	OBJECT
	SYECHYN		ALTER		TEST
	SYECHYN		ALTER		TEST
	SYECHYN		DROP		TEST
	SYECHYN		CREATE		TEST
	SYECHYN		ALTER		TEST
*/

