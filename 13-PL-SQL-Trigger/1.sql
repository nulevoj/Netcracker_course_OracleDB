
-- Етап 1. Прості інформуюче-доповнюючі та обмежуючі тригери

/*
	1. Створити інформуючий тригер для виведення повідомлення на екран 
	після додавання, зміни або видалення рядка з будь-якої таблиці Вашої бази даних 
	із зазначенням у повідомленні операції, на яку зреагував тригер. 
	Навести тест-кейс перевірки роботи тригера.
*/

CREATE OR REPLACE TRIGGER trig1
	AFTER INSERT OR UPDATE OR DELETE ON hostel
BEGIN
	IF INSERTING THEN
		DBMS_OUTPUT.PUT_LINE('Inserting into hostel');
	ELSIF UPDATING THEN
		DBMS_OUTPUT.PUT_LINE('Updating hostel');
	ELSIF DELETING THEN
		DBMS_OUTPUT.PUT_LINE('Deleting from hostel');
	END IF;
END;

INSERT INTO hostel (
		hostel_id,
		address,
		rating,
		amount_of_floors,
		amount_of_rooms)
	VALUES (
		hostel_sq.NEXTVAL,
		'Hummingbird Street, 4a',
		8.88,
		4,
		30);
UPDATE hostel
	SET rating = 7.77
	WHERE hostel_id = 1;
DELETE FROM hostel WHERE hostel_id = 24;

ROLLBACK;

ALTER TRIGGER trig1 DISABLE;

/*
	Inserting into hostel
	Updating hostel
	Deleting from hostel
*/

/*
	2. Повторити попереднє завдання лише під час роботи користувача, 
	ім'я якого збігається з вашим логіном. Навести тест-кейс перевірки роботи тригера.
*/

CREATE OR REPLACE TRIGGER trig2
	AFTER INSERT OR UPDATE OR DELETE ON hostel
	FOR EACH ROW
	WHEN (USER = 'SYECHYN')
BEGIN
	IF INSERTING THEN
		DBMS_OUTPUT.PUT_LINE('Inserting into hostel');
	ELSIF UPDATING THEN
		DBMS_OUTPUT.PUT_LINE('Updating hostel');
	ELSIF DELETING THEN
		DBMS_OUTPUT.PUT_LINE('Deleting from hostel');
	END IF;
END;

INSERT INTO hostel (
		hostel_id,
		address,
		rating,
		amount_of_floors,
		amount_of_rooms)
	VALUES (
		hostel_sq.NEXTVAL,
		'Hummingbird Street, 4a',
		8.88,
		4,
		30);
UPDATE hostel
	SET rating = 7.77
	WHERE hostel_id = 1;
DELETE FROM hostel WHERE hostel_id = 24;

ROLLBACK;

ALTER TRIGGER trig2 DISABLE;

/*
	Inserting into hostel
	Updating hostel
	Deleting from hostel
*/

