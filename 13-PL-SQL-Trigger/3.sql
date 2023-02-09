
-- Етап 3. Автоматичне оновлення даних

/*
	1. Розробити механізм журналізації DML-операцій, 
	що виконуються над таблицею вашої бази даних, враховуючи такі дії:
	– створити таблицю з ім'ям LOG_ім'я_таблиці. 
	Структура таблиці повинна включати: 
	ім'я користувача, тип операції, дата виконання операції, атрибути, що містять старі та нові значення.
	– створити тригер журналювання.
	Перевірити роботу тригера журналювання для операцій INSERT, UPDATE, DELETE.
*/
DROP TABLE log_student;
CREATE TABLE log_student (
	username CHAR(20),
	op_type CHAR(6),
	op_date DATE,
	new_student_id NUMBER,
	new_room_id NUMBER(5),
	new_name VARCHAR2(50),
	new_faculty VARCHAR2(50),
	new_date_of_birth DATE,
	new_email VARCHAR2(30),
	new_phone VARCHAR2(30),
	old_student_id NUMBER,
	old_room_id NUMBER(5),
	old_name VARCHAR2(50),
	old_faculty VARCHAR2(50),
	old_date_of_birth DATE,
	old_email VARCHAR2(30),
	old_phone VARCHAR2(30)
);

CREATE OR REPLACE TRIGGER log_student
	AFTER INSERT OR UPDATE OR DELETE ON student
	FOR EACH ROW
DECLARE
	op_type_ log_student.op_type%TYPE;
BEGIN
	IF INSERTING THEN op_type_ := 'INSERT';
	ELSIF UPDATING THEN op_type_ := 'UPDATE';
	ELSIF DELETING THEN op_type_ := 'DELETE';
	END IF;
	INSERT INTO log_student (
			username,
			op_type,
			op_date,
			new_student_id,
			new_room_id,
			new_name,
			new_faculty,
			new_date_of_birth,
			new_email,
			new_phone,
			old_student_id,
			old_room_id,
			old_name,
			old_faculty,
			old_date_of_birth,
			old_email,
			old_phone)
		VALUES (
			USER,
			op_type_,
			SYSDATE,
			:NEW.student_id,
			:NEW.room_id,
			:NEW.name,
			:NEW.faculty,
			:NEW.date_of_birth,
			:NEW.email,
			:NEW.phone,
			:OLD.student_id,
			:OLD.room_id,
			:OLD.name,
			:OLD.faculty,
			:OLD.date_of_birth,
			:OLD.email,
			:OLD.phone
	);
END;

INSERT INTO student (
		student_id,
		room_id,
		name,
		faculty,
		date_of_birth,
		email,
		phone)
	VALUES (
		student_sq.NEXTVAL,
		1,
		'Anatoliy',
		'Architecture',
		TO_DATE('27/04/2001', 'DD/MM/YYYY'),
		'tolik0@gmail.com',
		'+38(050)423-73-27'
	);
UPDATE student SET faculty = 'Game Dev' WHERE name = 'Anatoliy';
DELETE FROM student WHERE name = 'Anatoliy';
SELECT * FROM log_student;

ROLLBACK;
ALTER TRIGGER log_student DISABLE;

/*
	Table LOG_STUDENT created.
	Trigger LOG_STUDENT compiled
	1 row inserted.
	1 row updated.
	1 row deleted.
	
	SELECT * FROM log_student;

	USERNAME     OP_TYP OP_DATE   NEW_STUDENT_ID NEW_ROOM_ID    NEW_NAME       NEW_FACULTY          NEW_DATE_           NEW_EMAIL                NEW_PHONE     OLD_STUDENT_ID     OLD_ROOM_ID           OLD_NAME       OLD_FACULTY     OLD_DATE_            OLD_EMAIL            OLD_PHONE
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SYECHYN      INSERT 19-DEC-22            246           1    Anatoliy       Architecture         27-APR-01    tolik0@gmail.com        +38(050)423-73-27             (null)          (null)             (null)            (null)        (null)               (null)               (null)
	SYECHYN      UPDATE 19-DEC-22            246           1    Anatoliy           Game Dev         27-APR-01    tolik0@gmail.com        +38(050)423-73-27                246               1           Anatoliy      Architecture     27-APR-01     tolik0@gmail.com    +38(050)423-73-27
	SYECHYN      DELETE 19-DEC-22         (null)      (null)      (null)             (null)            (null)              (null)                   (null)                246               1           Anatoliy          Game Dev     27-APR-01     tolik0@gmail.com    +38(050)423-73-27

*/

/*
	2. Припустимо, що використовується СУБД до 12-ї версії, 
	яка не підтримує механізм DEFAULT SEQUENCE, 
	який дозволяє автоматично внести нове значення первинного ключа, 
	якщо воно не задано при операції внесення. 
	Для будь-якої колонки вашої бази даних створити тригер 
	з підтримкою механізму DEFAULT SEQUENCE. 
	Навести тест-кейс перевірки роботи тригера.
*/

CREATE OR REPLACE TRIGGER student_default_sequence
	BEFORE INSERT ON student
	FOR EACH ROW
BEGIN
	IF :NEW.student_id IS NULL THEN
		:NEW.student_id := student_sq.NEXTVAL;
	END IF;
END;

INSERT INTO student (
		room_id,
		name,
		faculty,
		date_of_birth,
		email,
		phone)
	VALUES (
		1,
		'Anatoliy',
		'Architecture',
		TO_DATE('27/04/2001', 'DD/MM/YYYY'),
		'tolik0@gmail.com',
		'+38(050)423-73-27'
	);
SELECT * FROM student WHERE name = 'Anatoliy';

ROLLBACK;
ALTER TRIGGER student_default_sequence DISABLE;

/*
	Trigger STUDENT_DEFAULT_SEQUENCE compiled
	1 row inserted.
	
	SELECT * FROM student WHERE name = 'Anatoliy';
	STUDENT_ID   ROOM_ID        NAME         FACULTY   DATE_OF_BIRTH               EMAIL                 PHONE
	       229         1    Anatoliy    Architecture       27-APR-01    tolik0@gmail.com     +38(050)423-73-27
	
	Rollback complete.
	Trigger STUDENT_DEFAULT_SEQUENCE altered.
*/

