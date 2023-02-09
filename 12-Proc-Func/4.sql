
-- Етап 4. Табличні функції

/*
	4.1. З урахуванням вашої предметної області створити табличну функцію, 
	що повертає значення будь-яких двох колонок будь-якої таблиці 
	з урахуванням значення однієї з колонок, що передається як параметр. 
	Показати приклад виклику функції.
*/

DROP TABLE student_short_list;
DROP TABLE student_short;
CREATE TYPE student_short AS OBJECT (
	student_id NUMBER(9),
	name VARCHAR(50),
	faculty VARCHAR(50)
);
CREATE TYPE student_short_list IS TABLE OF student_short;

CREATE OR REPLACE FUNCTION get_student_list(v_room_id IN INTEGER)
RETURN student_short_list
AS
	student_list student_short_list;
BEGIN
	SELECT student_short(student_id, name, faculty)
		BULK COLLECT INTO student_list
		FROM student
		WHERE room_id = v_room_id;
	RETURN student_list;
END;


SELECT * FROM TABLE(get_student_list(1));

/*
	STUDENT_ID		NAME			FACULTY
	1				Nikolay			Game Dev
	2				Konstantin		Game Dev
	3				Oleg			Game Dev
*/

/*
	4.2. Повторіть рішення попереднього завдання, 
	але з використанням конвеєрної табличної функції.
*/

CREATE OR REPLACE PACKAGE student_pac IS
	TYPE student_short IS RECORD (
		student_id NUMBER(9),
		name VARCHAR(50),
		faculty VARCHAR(50)
	);
	TYPE student_short_list IS TABLE OF student_short;
	
	FUNCTION get_student_list(v_room_id IN INTEGER)
		RETURN student_short_list PIPELINED;
END student_pac;


CREATE OR REPLACE PACKAGE BODY student_pac IS
	FUNCTION get_student_list(v_room_id IN INTEGER)
		RETURN student_short_list PIPELINED
	AS
	BEGIN
		FOR item IN (SELECT student_id, name, faculty
					FROM student
					WHERE room_id = v_room_id) LOOP
			PIPE ROW(item);
		END LOOP;
	END;
END student_pac;


SELECT * FROM TABLE(get_student_list(1));

/*
	STUDENT_ID		NAME			FACULTY
	1				Nikolay			Game Dev
	2				Konstantin		Game Dev
	3				Oleg			Game Dev
*/

