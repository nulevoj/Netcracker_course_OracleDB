/*
	4.1 Для однієї з таблиць створити команду отримання значень всіх колонок 
	(явно перерахувати) за окремими рядками з урахуванням умови: 
	цілочисельне значення однієї з колонок 
	має бути більшим за якесь константне значення.
*/

SELECT 
    room_id,
    hostel_id,
    room_number,
    area,
    inspection_date,
    amount_of_windows,
    max_amount_of_students
    FROM room
    WHERE amount_of_windows > 2;


/*

	ROOM_ID		HOSTEL_ID	ROOM_NUMBER		AREA	INSPECTION_DATE		AMOUNT_OF_WINDOWS	MAX_AMOUNT_OF_STUDENTS
1	1			1			1				96		11-OCT-22			3					4

*/

/*
	4.2 Для однієї з таблиць створити команду отримання значень всіх колонок 
	(явно перерахувати) за окремими рядками з урахуванням умови: 
	символьне значення однієї з колонок 
	має співпадати з якимось константним значенням.
*/

SELECT 
    student_id,
    room_id,
    name,
    faculty
    FROM student
    WHERE faculty = 'Game Dev';

/*

	STUDENT_ID		ROOM_ID		NAME			FACULTY
1	1				1			Nikolay			Game Dev
2	2				1			Konstantin		Game Dev

*/

/*
	4.3 Для однієї з таблиць створити команду отримання значень всіх колонок 
	(явно перерахувати) за окремими рядками з урахуванням умови: 
	символьне значення однієї з колонок 
	повинно містити в першому та третьому знакомісті якісь надані вами символи.
*/

SELECT 
    student_id,
    room_id,
    name,
    faculty
    FROM student
    WHERE faculty LIKE 'D_s%';

/*

	STUDENT_ID		ROOM_ID		NAME		FACULTY
1	3				2			Oleg		Design
2	4				2			Kirill		Design	

*/

/*
	4.4 У завданні 1.2 було додано колонку типу date. 
	Створити команду отримання значень всіх колонок 
	(явно перерахувати) за окремими рядками з урахуванням умови: значення доданої 
	колонки містить невизначене значення.
*/

SELECT 
    student_id,
    room_id,
    name,
    faculty,
    date_of_birth
    FROM student
    WHERE date_of_birth IS NULL;


/*

	STUDENT_ID	ROOM_ID		NAME		FACULTY		DATE_OF_BIRTH
1	1			1			Nikolay		Game Dev	(null)
2	2			1			Konstantin	Game Dev	(null)
3	3			2			Oleg		Design		(null)

*/

/*
	4.5 Створити команду отримання значень всіх колонок 
	(явно перерахувати) за окремими рядками з урахуванням умови, 
	що поєднує умови з рішень завдань 4.1 та 4.2
*/

SELECT 
    room_id,
    hostel_id,
    room_number,
    area,
    inspection_date,
    amount_of_windows,
    max_amount_of_students
    FROM room
    WHERE area > 70
    AND amount_of_windows > 2;

/*

	ROOM_ID		HOSTEL_ID	ROOM_NUMBER		AREA	INSPECTION_DATE		AMOUNT_OF_WINDOWS	MAX_AMOUNT_OF_STUDENTS
1	1			1			1				96		11-OCT-22			3					4

*/

/*
	4.6 Створити команду отримання значень всіх колонок 
	(явно перерахувати) за окремими рядками з урахуванням умови, 
	що інвертує результат рішення 4.5
*/

SELECT 
    room_id,
    hostel_id,
    room_number,
    area,
    inspection_date,
    amount_of_windows,
    max_amount_of_students
    FROM room
    WHERE NOT area > 70
    AND NOT amount_of_windows > 2;

/*
	ROOM_ID		HOSTEL_ID	ROOM_NUMBER		AREA	INSPECTION_DATE		AMOUNT_OF_WINDOWS	MAX_AMOUNT_OF_STUDENTS
1	2			1			2				55		09-OCT-22			1					2

*/