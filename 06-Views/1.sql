
/*
	Використовується реляційна БД, створена та заповнена у лабораторних роботах No2-3.
	При створенні віртуальних таблиць використовувати довільні назви таблиць та колонок.
*/

/*
	1.1 Створити віртуальну таблицю, структура та вміст якої відповідає рішенню 
	завдання 4.2 з лабораторної роботи No3: для однієї з таблиць створити команду отримання значень 
	усіх колонок (явно перерахувати) за окремими рядками з урахуванням умови, в якій рядкове
	значення однієї з колонок має співпадати з якимось константним значенням. 
	Отримати вміст таблиці.
*/

CREATE OR REPLACE VIEW game_dev_students_list (
        id,
        room_id,
        name,
        faculty,
        date_of_birth
    ) AS
    SELECT 
        student_id,
        room_id,
        name,
        faculty,
        date_of_birth
        FROM student
        WHERE faculty = 'Game Dev';

SELECT * FROM game_dev_students_list;

/*
	ID	ROOM_ID		NAME		FACULTY		DATE_OF_BIRTH
1	1	1			Nikolay		Game Dev	(null)
2	2	1			Konstantin	Game Dev	(null)
*/

/*
	1.2 Виконати команду зміни значення колонки створеної віртуальної таблиці на значення, 
	яка входить в умову вибірки рядків із рішення попереднього завдання, 
	при цьому нове значення має відрізнятись від поточного.
*/

UPDATE game_dev_students_list
    SET date_of_birth = TO_DATE('09/07/2002', 'DD/MM/YYYY')
    WHERE id = 1;

SELECT * FROM game_dev_students_list;

/*
	ID	ROOM_ID		NAME		FACULTY		DATE_OF_BIRTH
1	1	1			Nikolay		Game Dev	09-JUL-02
2	2	1			Konstantin	Game Dev	
*/

/*
	1.3 Створити віртуальну таблицю, структура та вміст якої відповідає рішенню 
	завдання 3.2 з лабораторної роботи No4: для двох таблиць, пов'язаних через PK-колонку та FK-колонку, 
	створити команду отримання двох колонок першої та другої таблиць з використанням екві-сполучення таблиць. 
	Отримати вміст таблиці.
*/

CREATE OR REPLACE VIEW all_students_and_rooms (
        room_id,
        room_number,
        area,
        max_amount_of_students,
        student_id,
        name,
        faculty,
        date_of_birth
    ) AS
    SELECT
        room.room_id,
        room.room_number,
        room.area,
        room.max_amount_of_students,
        student.student_id,
        student.name,
        student.faculty,
        student.date_of_birth
        FROM room INNER JOIN student ON(student.room_id = room.room_id);

SELECT * FROM all_students_and_rooms;
/*
	ROOM_ID		ROOM_NUMBER		AREA	MAX_AMOUNT_OF_STUDENTS	STUDENT_ID	NAME		FACULTY				DATE_OF_BIRTH
1	1			1				96		4						1			Nikolay		Game Dev			09-JUL-02
2	1			1				96		4						2			Konstantin	Game Dev			(null)
3	3			1				45		2						5			Vasiliy		Cyber security		14-MAR-03
4	4			1				63		3						6			Vitaliy		Computer science	06-FEB-01
5	4			1				63		3						7			Oleg		Computer science	16-DEC-01
6	2			2				55		2						3			Oleg		Design				(null)
7	2			2				55		2						4			Kirill		Design				15-APR-02
*/

/*
	1.4 Виконати команду додавання нового рядка до однієї з таблиць, 
	що входить до запиту з попереднього завдання.
*/

INSERT INTO all_students_and_rooms (
        room_id,
        room_number,
        area,
        max_amount_of_students,
        student_id,
        name,
        faculty,
        date_of_birth
    )
    VALUES (
        room_sq.nextval,
        3,
        77,
        3,
        student_sq.nextval,
        'Eugene',
        'Cyber security',
        TO_DATE('01/06/2001', 'DD/MM/YYYY')
);

-- SQL Error: ORA-01779: cannot modify a column which maps to a non key-preserved table

