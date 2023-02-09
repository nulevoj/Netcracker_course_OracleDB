
-- Етап 2. Тригери складного контролю даних

/*
	1. Створити тригер для реалізації каскадного видалення рядків зі значеннями PK-колонки, 
	пов'язаних з FK-колонкою. Навести тест-кейс перевірки роботи тригера.
*/

CREATE OR REPLACE TRIGGER cascade_del_room
    AFTER DELETE ON room
    FOR EACH ROW
BEGIN
    DELETE FROM student WHERE student.room_id = :OLD.room_id;
    DELETE FROM technique WHERE technique.room_id = :OLD.room_id;
    DELETE FROM furniture WHERE furniture.room_id = :OLD.room_id;
END;

DELETE FROM room;
SELECT * FROM room;

ROLLBACK;

ALTER TRIGGER cascade_del_room DISABLE;

/*
	Trigger CASCADE_DEL_ROOM compiled
	5 rows deleted.
	Rollback complete.
*/

/*
	2. Створити тригер для реалізації предметно-орієнтованого контролю спроби 
	додавання значення FK-колонки, що не існує у PK-колонці. 
	Навести тест-кейс перевірки роботи тригера.
*/

CREATE OR REPLACE TRIGGER missing_pk
	BEFORE INSERT ON student
	FOR EACH ROW
DECLARE
	id room.room_id%TYPE;
BEGIN
	SELECT room_id INTO id FROM room
		WHERE room_id = :NEW.room_id;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		RAISE_APPLICATION_ERROR(
			-20551,
			'room_id #' || :NEW.room_id || ' not exists');
END;

INSERT INTO student(name, room_id) VALUES ('Anatoliy', 999);

ALTER TRIGGER missing_pk DISABLE;

/*
	Error starting at line : 1 in command -
	INSERT INTO student(name, room_id) VALUES ('Anatoliy', 999)
	Error report -
	ORA-20551: room_id #999 not exists
	ORA-06512: at "SYECHYN.MISSING_PK", line 8
	ORA-04088: error during execution of trigger 'SYECHYN.MISSING_PK'
*/

